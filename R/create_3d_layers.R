#' Add 3D regression surface to a plot_ly plot.
#'
#' This function adds a 3 dimensional regression surface to a plotly plot.
#'
#' Additional plotly layers such as add_markers() can
#' be added to the plotly plot, but be aware that many plotly layers inherit the data from the prior layer.
#' As such, a function such as add_markers may not work as intended if called after add_3d_surface.
#'
#' The surface can be built from either an lm or glm. For glms, testing has been primarily focused on
#' binomial and Gamma families.
#'
#' @param p A plotly object.
#' @param model An lm or glm with exactly two x variables
#' @param data An optional dataframe to be used to create the regression surface. By default, this will be the data used by the inherited plotly object.
#' @param ci An optional logical. Defaults to TRUE, showing the confidence intervals of the predicted effects.
#' @param surfacecolor A color recognized by plotly. Used within the colorscale parameter in add_trace. Defaults to 'blue'.
#' @param surfacecolor_ci A color recognized by plotly. Used within the colorscale parameter in add_trace. Defaults to 'grey'.
#' @param opacity Sets the opacity of the surface. Defaults to 0.5.
#' @inheritParams plotly::plot_ly
#'
#' @return A plotly object with the regression surface added to the plot.
#' @export
#'
#' @examples
#' library(plotly)
#' mymodel <- lm(length ~ isFemale_num + isMale_num, data = hair_data)
#' p1 <- plot_ly(data = hair_data,
#'               x = ~isFemale_num,
#'               y = ~isMale_num,
#'               z = ~length )
#' add_3d_surface(p1, model = mymodel, data = hair_data)
add_3d_surface <- function(p, model, data = NULL, ci = T,
                           surfacecolor = "blue", surfacecolor_ci = "grey",
                           opacity = 0.5, ...){
  data <- data %||% plotly::plotly_data(p, id = names(p$x$visdat)[1])
  coefficients <- create_named_coeffs(model= model)
  #could pass coefficients through surface_data, but keeping it here makes the function more flexible
  surface_data <- create_surface_data(data, model)

  p <- plotly::add_trace(p, data = surface_data,
                      x = surface_data[,coefficients["x1"]],
                      y = surface_data[,coefficients["x2"]],
                      z = surface_data[,coefficients["y"]],
                      type ='mesh3d',
                      intensity = surface_data[,coefficients["y"]],
                      colorscale = list(c(0,surfacecolor),
                                        c(1, surfacecolor)),
                      opacity = opacity, showscale = F,
                      legendgroup = 'regression.surface',
                      name = "Predicted regression surface")
  if(ci){
    p <- p %>%
      plotly::add_trace(data = surface_data,
                        x = surface_data[,coefficients["x1"]],
                        y = surface_data[,coefficients["x2"]],
                        z = surface_data[,"upperCI"],
                        type ='mesh3d',
                        intensity = surface_data[,"upperCI"],
                        colorscale = list(c(0,surfacecolor_ci),
                                          c(1, surfacecolor_ci)),
                        opacity = opacity, showscale = F,
                        legendgroup = 'regression.surface', showlegend = F,
                        name = "Lower 95% CI") %>%
      plotly::add_trace(data = surface_data,
                        x = surface_data[,coefficients["x1"]],
                        y = surface_data[,coefficients["x2"]],
                        z = surface_data[,"lowerCI"],
                        type ='mesh3d',
                        intensity = surface_data[,"lowerCI"],
                        colorscale = list(c(0,surfacecolor_ci),  # color = doesn't work
                                          c(1, surfacecolor_ci)),
                        opacity = opacity, showscale = F,
                        legendgroup = 'regression.surface', showlegend = F,
                        name = "Upper 95% CI")
  }
  p
}

#' Add 3d marginal effects to a plot_ly plot
#'
#' Additional plotly layers such as add_markers() can
#' be added to the plotly plot, but be aware that many plotly layers inherit the data from the prior layer.
#' As such, a function such as add_markers may not work as intended if called after add_marginals().
#'
#' @param p A plotly object
#' @param model A lm or glm with exactly two x variables
#' @param data An optional dataframe to be used to create the regression surface. By default, this will be the data used by the inherited plotly object.
#' @param ci A logical. Defaults to TRUE, showing the confidence intervals of the predicted effects.
#' @param x1_constant_val,x2_constant_val A string or numeric value indicating which constant value to
#'     set for x1 or x2 when the marginal effect of x2 is plotted.
#'     Defaults to the mean value. The string can take on "mean", "median", "min", or "max".
#'     Alternately, a numeric value may be specified.
#' @param x1_color The color to be used for the line(s) depicting the marginal effect of x1. Defaults to "darkorange".
#' @param x2_color The color to be used for the line(s) depicting the marginal effect of x2. Defaults to "crimson".
#' @param x1_direction_name The hover text for the plotted line(s). Defaults to "Predicted marginal effect of x1".
#' @param x2_direction_name The hover text for the plotted line(s). Defaults to "Predicted marginal effect of x2".
#' @param omit_x1,omit_x2 An optional logical. Defaults to FALSE. If set to TRUE, the marginal effect for that variable will not be included.
#'
#' @return A plotly object with the predicted marginal effects added to the plot.
#' @export
#'
#' @examples
#' library(plotly)
#' mymodel <- lm(r_shift ~ median_income16 + any_college,
#'               data = county_data, weight = pop_estimate16)
#' plot_ly( data = county_data,
#'          x = ~median_income16,
#'          y = ~any_college,
#'          z = ~r_shift) %>%
#'   add_marginals(model = mymodel)
add_marginals <- function(p, model, data =NULL, ci = T,
                          x1_constant_val = "mean", x2_constant_val = "mean",
                          x1_color = "darkorange", x2_color = "crimson",
                          x1_direction_name = "Predicted marginal effect of x1",
                          x2_direction_name = "Predicted marginal effect of x2",
                          omit_x1 =F, omit_x2 = F){
  data <- data %||% plotly::plotly_data(p, id = names(p$x$visdat)[1])
  if(is_tibble(data)) data <- tibble_to_dataframe(tibble = data)
  coefficients <- create_named_coeffs(model)

  if(!omit_x1){
    marginal_x1_vars <- create_marginal_x_vars(data, model = model, marginal_of_x1 = T,
                                               constant_value = x2_constant_val)
    predicted_marginal_x1_data <- create_y_estimates(x_vals = marginal_x1_vars,
                                                     model = model, coefficient_names = coefficients )

    p <- add_direction(p, model, predicted_marginal_x1_data, direction_name = x1_direction_name,
                       linecolor = x1_color, ci)
  }

  if(!omit_x2){
    marginal_x2_vars <- create_marginal_x_vars(data, model= model, marginal_of_x1 = F,
                                               constant_value = x1_constant_val)
    predicted_marginal_x2_data <- create_y_estimates(x_vals = marginal_x2_vars,
                                                     model = model, coefficient_names = coefficients )

    p <- add_direction(p, model, predicted_marginal_x2_data, direction_name = x2_direction_name,
                       linecolor = x2_color, ci)
  }
  p
}


#' A flexible function to add a line of predicted effects to the plotly surface with optional confidence intervals.
#'
#' Primarily used by functions such as add_3d_surface or add_marginals.
#' If user defines "direction_data" appropriately, any line can be shown.
#'
#' @param p A plotly object
#' @param model A glm with exactly two x variables
#' @param direction_data A data frame with a column of x1 values,
#'      a column of x2 values, predicted y values and optional predicted
#'      confidence interval for each pair of x values.
#'      The variable names are c("rownum", actual x1 variable name, actual x2 variable name,
#'      actual y variable name, "lowerCI", "upperCI").
#' @param direction_name The hover text for the plotted line(s). Defaults to "User defined line".
#' @param linecolor The color for the plotted line. Defaults to "black".
#' @param ci An optional logical. Defaults to TRUE, showing the confidence intervals of the predicted effects.
#'
#' @return A plotly object
#' @export
#'
#' @examples
#' library(plotly)
#' mymodel <- lm(r_shift ~ median_income16 + any_college, data = county_data)
#' xvars <- data.frame(x1 = seq(min(county_data$median_income16, na.rm=TRUE),
#'                              max(county_data$median_income16, na.rm=TRUE),
#'                               length.out=10),
#'                     x2 = seq(min(county_data$any_college, na.rm=TRUE),
#'                              max(county_data$any_college, na.rm=TRUE),
#'                              length.out=10))
#'
#' predicted_xvars_data <- create_y_estimates(x_vals = xvars,
#'                                            model = mymodel,
#'                                            coefficient_names = c(y = "r_shift",
#'                                            x1= "median_income16", x2= "any_college") )
#' plot_ly( data = county_data,
#'          x = ~median_income16,
#'          y = ~any_college,
#'          z = ~r_shift) %>%
#'   add_markers(size = ~pop_estimate16, color = I('black')) %>%
#'   add_3d_surface(model = mymodel)%>%
#'   add_direction(model = mymodel, direction_data = predicted_xvars_data)
#'
add_direction <- function(p, model, direction_data, direction_name = "User defined line", linecolor = "black", ci = T){
  coefficients <- create_named_coeffs(model)
  direction_names <- data.frame(zvals = c(coefficients["y"], "upperCI", "lowerCI"),
                                trace_names = c(direction_name, "upper 95% CI", "lower 95% CI"),
                                linewidth = c(6,3,3), legendVal = c(T,F,F),
                                opacity = c(1,.6,.6))

  num_lines_to_draw <- 1
  if(ci) num_lines_to_draw <- 3   # create three lines if confidence intervals should be plotted
  group_rand_num <- runif(n =1)  # makes the prediction & CIs group together

  for(i in 1:num_lines_to_draw){  # loop through direction_names to get CIs if ci == T
    p<- p %>% add_trace( data = direction_data,
                         x = direction_data[,coefficients["x1"]],
                         y = direction_data[,coefficients["x2"]],
                         z = direction_data[,direction_names$zvals[i]], #coefficients["y"], "upperCI", "lowerCI"
                         type="scatter3d", mode='lines' , opacity = direction_names$opacity[i],
                         line = list( width = direction_names$linewidth[i], color = linecolor),
                         legendgroup = group_rand_num, showlegend = direction_names$legendVal[i],
                         name = direction_names$trace_names[i])
  }
  p
}
