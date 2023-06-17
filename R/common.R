col_size <- function(cols) {
  cols |>
    # Escape pipe so stringr does not confuse it with OR operator
    stringr::str_count(pattern = "\\|") |> 
    # One extra to accommodate the split
    max() + 1 
}

space_split_to_vec <- function(str) {
  unlist(stringr::str_split(str, pattern = "\\s+"))
}