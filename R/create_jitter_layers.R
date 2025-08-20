#' Jitter scattercloud points
#'
#' The jitter trace is a scatter trace with the mode of markers.
#'
#' It adds a small amount of random variation to the location of each point, and is a useful way of handling overplotting caused by discreteness.
#' It is based on ggplot's geom_jitter.
#' New attributes in this function are: x_jitter, y_jitter, z_jitter.
#' If these attributes are misspelled, plot_ly will generate a warning message listing all valid attributes.
#' Since regress3d is an add on to plotly, this list of valid attributes does not include the attributes created in this function.
#'
#' @param p a plotly object
#' @param x the x variable
#' @param y the y variable
#' @param z the z variable
#' @param data a data frame (optional)
#' @param x_jitter,y_jitter,z_jitter Amount of vertical, horizontal, and depth jitter. The jitter is added in both positive and negative directions, so the total spread is twice the value specified here.
#'    If omitted, defaults to 40% of the resolution of the data: this means the jitter values will occupy 80% of the implied bins.
#' @param ... Arguments (i.e., attributes) passed along to the trace type. See schema() for a list of acceptable attributes for a given trace type (by going to traces -> type -> attributes). Note that attributes provided at this level may override other arguments (e.g. plot_ly(x = 1:10, y = 1:10, color = I("red"), marker = list(color = "blue"))).
#'
#' @return a plotly object
#' @export
#'
#' @examples
#' library(plotly)
#' p <- plot_ly( data = hair_data,
#'               x = ~isFemale_num,
#'               y = ~isMale_num,
#'               z = ~length) %>%
#'      add_jitter( x_jitter = 0, z_jitter = 0, color = ~gender,
#'                 colors = c("pink", "skyblue", "purple"))
add_jitter <- function(p, x = NULL, y = NULL, z = NULL, data = NULL,
                       x_jitter = NULL, y_jitter = NULL, z_jitter =NULL,  ...){
  #note to fix: scatter3d objects don't have these attributes: jitter_y jitter_z. But the list of valid attributes doesn't include my new x_jitter attributes.
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
#' Used by add_jitter()
#'
#' @param data The data frame with the x, y, and z variables.
#' @param varname The name of the variable to add jitter to.
#' @param jitter_val The amount of jitter to add. If it is NULL (default value), then the function calculates 40% of the range of the data.
#'
#' @return A dataframe containing one jittered column.
#' @noRd
jitter_40pct <- function(data, varname, jitter_val =NULL){
  jitter_val <- jitter_val %||% 0.4* (max(data[ , varname], na.rm=T) - min(data[ , varname], na.rm=T))
  jitter_var <- data[ , varname] + runif(length(data[ , varname]),
                                         min = -jitter_val/2, max = jitter_val/2 )
  jitter_var
}
