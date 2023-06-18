source(here::here("R", "common.R"))

gonads <- c("testisPos", "testisSize", "ovaryOpening", "mammaeCondition", "mammaeFormula")

clean_collname <- function(df) {
  df |> 
    dplyr::rename(collectorLastName = cataloger) |>
    dplyr::rename(species = specificEpithet) |>
    dplyr::rename(state = stateProvince) |>
    dplyr::rename(prepType = preparation) |>
    dplyr::mutate(fieldNumber = stringr::str_extract(fieldID, pattern = "\\d+")) |>
    tidyr::unite("locality", municipality:specificLocality, sep = ", ", remove = FALSE) |>
    tidyr::separate_wider_delim(prepType, delim = "|", names = prepType.colnames,  too_few = "align_start") |>
    tidyr::separate_wider_delim(coordinates, delim = "|", names = coordinates.colnames,  too_few = "align_start") |>
    tidyr::unite("remarks", gonads, sep = ", ", remove = FALSE, na.rm = TRUE)
}

prep_types.lsumz_cols <- "PrepType PreparedDate Count TissueType Preservation	StorageLocation Notes"

tissue_list <- c("Brain", "Liver", "Lung", "Heart", "Muscle", "Kidney", "Mammary", "Spleen", "Tongue")

prep_types.nahpu_cols <- "PrepType Count Preservation	TissueType StorageLocation PreparedDate Notes"

nahpu.allCols <- space_split_to_vec(prep_types.nahpu_cols)

prepType.allCols <- space_split_to_vec(prep_types.lsumz_cols)

split_prepType <- function(cols) {
  index <- stringr::str_extract(cols, pattern = "\\d+")
  coll_names <- paste0(nahpu.allCols, index)
  count <- paste0("Count", index)
  prepType <- paste0("PrepType", index)
  tissueType <- paste0("TissueType", index)
  cleaned.df |> 
    dplyr::select("specimenUUID", cols) |>
    tidyr::separate_wider_delim(cols, delim = ";", names = coll_names, too_few = "align_start", too_many = "merge") |>
    dplyr::select("specimenUUID", !starts_with("Notes")) |>
    dplyr::mutate("TissueType{index}" := ifelse(is.na(!!sym(tissueType)) & !!sym(prepType) %in% tissue_list, !!sym(prepType), "")) |>
    dplyr::mutate("PrepType{index}" := ifelse(!!sym(prepType) %in% tissue_list, "Tissue" , !!sym(prepType)))
}

nahpu_coord.cols <- c("name", "lat/long", "elevation", "MaxErrorDistance", "datum", "gps", "notes")

split_coordinate <- function(cols) {
  coll_names <- paste0(nahpu_coord.cols, ".", cols)
  latlong_cols <- paste0(c("Latitude", "Longitude"), ".", cols)
  cleaned.df |>
    dplyr::select("specimenUUID", cols) |>
    tidyr::separate_wider_delim(cols, delim = ";", names = coll_names, too_few = "align_start", too_many = "merge") |>
    tidyr::separate_wider_delim(3, delim = ",", names = latlong_cols, too_few = "align_start", too_many = "merge") |>
    tidyr::separate_wider_regex(5, c(elevationTemp = "\\d+", unitTemp = "\\w+")) |>
    dplyr::rename("Elevation.{cols}" := elevationTemp) |>
    dplyr::rename("ElevationUnit.{cols}" := unitTemp)
}
