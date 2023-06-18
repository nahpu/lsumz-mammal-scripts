source(here::here("R", "common.R"))

gonads <- c("testisPos", "testisSize", "ovaryOpening", "mammaeCondition", "mammaeFormula")

clean_collname <- function(df) {
  df |> 
    dplyr::rename(collectorLastName = cataloger) |>
    dplyr::rename(species = specificEpithet) |>
    dplyr::rename(state = stateProvince) |>
    dplyr::rename(prepType = preparation) |>
    tidyr::unite("locality", municipality:specificLocality, sep = ", ", remove = FALSE) |>
    tidyr::separate_wider_delim(prepType, delim = "|", names = prepType.colnames,  too_few = "align_start") |>
    tidyr::separate_wider_delim(coordinates, delim = "|", names = coordinates.colnames,  too_few = "align_start") |>
    tidyr::unite("remarks", gonads, sep = ", ", remove = FALSE, na.rm = TRUE)
}

tissue_list <- c("Brain", "Liver", "Lung", "Heart", "Muscle", "Kidney", "Mammary", "Spleen", "Tongue")

# Nahpu first and second column is tissueID and barcodeID
# LSUMZ mammals does not use this records
# We can ignore it here.
# We match column names for the matching specify columns.
prep_types.nahpu_cols <- c(
  "PrepType", 
  "Count",
  "Preservation", 
  "additionalTreatment",
  "dateTaken",
  "timeTaken",
  "museumPermanent",
  "museumLoan",
  "remark"
  )

split_prepType <- function(cols) {
  index <- stringr::str_extract(cols, pattern = "\\d+")
  coll_names <- paste0(prep_types.nahpu_cols, index)
  prepType <- paste0("PrepType", index)
  tissueType <- paste0("TissueType", index)
  preservation <- paste0("Preservation", index)
  count <- paste0("Count", index)
  preparedDate <- paste0("PreparedDate", index)
  storageLocation <- paste0("StorageLocation", index)
  initial_cols <- c("specimenUUID", tissueType, preparedDate, storageLocation)
  lsumz_cols <- c("specimenUUID", prepType, tissueType, preservation, count, preparedDate, storageLocation)
  cleaned.df |> 
    dplyr::mutate("PreparedDate{index}" := preparationDate ) |>
    dplyr::mutate("StorageLocation{index}" := '') |>
    dplyr::mutate("TissueType{index}" := '') |>
    dplyr::select(cols, all_of(initial_cols)) |> 
    tidyr::separate_wider_delim(cols, delim = ";", names = coll_names, too_few = "align_start", too_many = "merge") |>
    # Remove MZB tissues
    dplyr::mutate(across(everything(), ~stringr::str_remove(.x, pattern = "museumPermanent: MZB"))) |>
    ## Nahpu label the specimen part data for easy reading
    ## We remove it here for specify input
    dplyr::mutate(across(everything(), ~stringr::str_remove(.x, pattern = "(\\w+:\\s)"))) |>
    dplyr::mutate("TissueType{index}" := ifelse(is.na(!!sym(tissueType)) | !!sym(prepType) %in% tissue_list, !!sym(prepType), "")) |>
    dplyr::mutate("PrepType{index}" := ifelse(!!sym(prepType) %in% tissue_list, "Tissue" , !!sym(prepType))) |>
    dplyr::select(all_of(lsumz_cols))
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
