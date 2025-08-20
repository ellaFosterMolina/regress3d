#' Jitter scattercloud points
#'
#' Add a jitter to a scatter trace with the mode of markers.
#'
#' This adds a small amount of random variation to the location of each point, and
#' is a useful way of handling overplotting caused by discreteness.
#' It is based on ggplot's `ggplot2::geom_jitter()`.
#'
#' The arguments `x_jitter`, `y_jitter`, `z_jitter` are not from plotly's syntax.
#' If these arguments are misspelled, plot_ly will generate a warning message listing all valid
#' arguments, but note that plotly uses the term attributes instead of arguments.
#' Since regress3d is an add on to plotly, this list of valid attributes does not
#' include the attributes/arguments created in this function.
#'
#' @param p a plotly object
#' @param x,y,z an optional x, y, and/or z variable.
#'      Defaults to the data inherited from the plotly object p.
#' @param data an optional data frame.
#'      Defaults to the data inherited from the plotly object p.
#' @param x_jitter,y_jitter,z_jitter Amount of vertical, horizontal, and depth jitter. The jitter is added in both positive and negative directions, so the total spread is twice the value specified here.
#'    If omitted, defaults to 40% of the spread in the data, so the jitter values will occupy 80% of the implied bins.
#' @inheritParams plotly::plot_ly
#'
#' @return a plotly object
#' @export
#'
#' @examples
#' library(plotly)
#' plot_ly( data = hair_data,
#'               x = ~isFemale_num,
#'               y = ~isMale_num,
#'               z = ~length) %>%
#'      add_jitter( x_jitter = 0, z_jitter = 0, color = ~gender,
#'                 colors = c("pink", "skyblue", "purple"))
add_jitter <- function(p, x = NULL, y = NULL, z = NULL, data = NULL,
                       x_jitter = NULL, y_jitter = NULL, z_jitter =NULL,  ...){
  data <- tibble_to_dataframe(data %||% plotly::plotly_data(p))
  xvar <- strsplit(deparse(x %||% p$x$attrs[[1]][["x"]]), "~")[[1]][2]
  yvar <- strsplit(deparse(y %||% p$x$attrs[[1]][["y"]]), "~")[[1]][2]
  zvar <- strsplit(deparse(z %||% p$x$attrs[[1]][["z"]]), "~")[[1]][2]
  jitterdata <- data.frame(jitter_x = jitter_40pct(data, xvar, x_jitter),
                           jitter_y= jitter_40pct(data, yvar, y_jitter),
                           jitter_z= jitter_40pct(data, zvar, z_jitter) )
  p <- plotly::add_markers(p,
                           x = jitterdata$jitter_x,
                           y = jitterdata$jitter_y,
                           z = jitterdata$jitter_z, ...)
  p
}

#' Create jittered data
#'
#' Used by `add_jitter()`
#'
#' @param data The data frame with the x, y, and z variables.
#' @param varname The name of the variable to add jitter to.
#' @param jitter_val The amount of jitter to add. If it is NULL (default value),
#'        then the function calculates 40% of the range of the data.
#'
#' @return A dataframe containing one jittered column.
#' @noRd
jitter_40pct <- function(data, varname, jitter_val =NULL){
  jitter_val <- jitter_val %||% 0.4* (max(data[ , varname], na.rm=T) - min(data[ , varname], na.rm=T))
  jitter_var <- data[ , varname] + runif(length(data[ , varname]),
                                         min = -jitter_val/2, max = jitter_val/2 )
  jitter_var
}
