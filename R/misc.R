#' Coerce tibble to data frame
#'
#' Commented out the message as unnecessary. Could get rid of this function.
#'
#' @param tibble A tibble
#'
#' @return A data frame.
#' @export
tibble_to_dataframe <- function(tibble){
  # message("Coercing tibble into a data frame.")
  as.data.frame(tibble)
}
