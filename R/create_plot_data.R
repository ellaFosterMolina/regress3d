#' Create named character vector attaching coefficient names to standardized names
#'
#' @param model A glm with exactly two x variables
#'
#' @return A named character vector attaching coefficient names to standardized names (e.g. x1, x2, y)
#' @noRd
#'
#' @examples
#' mymodel <- lm(length ~ isFemale_num + isMale_num, data = hair_data)
#' coefficients <- create_named_coeffs(model= mymodel)
create_named_coeffs <- function(model){
  coeff_names <- names(model$model)

  # check if model has 2 x variables, also allow for a weighted regression
  model_has_3_coeffs_no_weights <- length(coeff_names)== 3 & !"(weights)" %in% coeff_names
  model_has_3_coeffs_w_weights <- length(coeff_names)== 4 &  "(weights)" %in% coeff_names

  if(model_has_3_coeffs_no_weights){
    names(coeff_names)  <- c("y", "x1","x2")
  }else if(model_has_3_coeffs_w_weights){
    coeff_names[4] <- as.character(model$call$weights) #name of weights column
    names(coeff_names)  <- c("y", "x1","x2", "weights")
  }else{
    stop("Model must have exactly two x variables.", call. = FALSE)
  }
  coeff_names
}

#' Create matrix of x variables for regression surface
#'
#' @param data A data frame or a tibble (check it works with a tibble)
#' @param model A glm with exactly two x variables
#' @param coefficient_names A named character vector that attaches coefficient
#'         names to standardized names (e.g. x1, x2, y)
#'
#' @return A data frame of x values that span the minimum to maximum values of both x variables
#' @noRd
create_surface_x_vars <- function(data, model, coefficient_names){
  # if(is_tibble(data)) data <- tibble_to_dataframe(tibble = data)
  x1_seq = rep(seq(min(data[ ,coefficient_names["x1"]  ], na.rm =T),
                   max(data[ ,coefficient_names["x1"]  ], na.rm =T),
                   length.out=30), each =30)
  x2_min = min(data[ ,coefficient_names["x2"]  ], na.rm =T)
  x2_max = max(data[ ,coefficient_names["x2"]  ], na.rm =T)
  x2_seq = seq(x2_min, x2_max, length.out = 30)
  if( "weights" %in% names(coefficient_names) ){
    weights <- mean(data[, coefficient_names["weights"]], na.rm=T) #mean of weights variable, could pass to create_constant_value()
    xvars_for_prediction <- data.frame(x1_seq, x2_seq, weights) #had direction.name=NA , direction.std=NA in original function
  } else {
    xvars_for_prediction <- data.frame(x1_seq, x2_seq) #had direction.name=NA , direction.std=NA in original function
  }

  xvars_for_prediction
}

#' Create a constant value
#'
#' @param constant_value The desired constant value for the marginal effect.
#'        It can take the value "mean", "median", "min", "max", or a numeric value
#' @param data The data frame being used for the regression.
#' @param coefficients A named character vector where the names are the c("y","x1","x2")
#'         and the values are the variable names associated with each element in the named vector.
#' @param x_thats_constant The variable used to create the constant value.
#'
#' @return A numeric value corresponding to the constant value desired (e.g. the mean, median, etc)
#' @noRd
create_constant_value <- function(constant_value, data, coefficients, x_thats_constant){
  if(constant_value == "mean"){
    constant_value <- mean(data[ ,coefficients[x_thats_constant]  ], na.rm =T)
  }else if(constant_value == "median"){
    constant_value <- median(data[ ,coefficients[x_thats_constant]  ], na.rm =T)
  }else if(constant_value == "min"){
    constant_value <- min(data[ ,coefficients[x_thats_constant]  ], na.rm =T)
  }else if(constant_value == "max"){
    constant_value <- max(data[ ,coefficients[x_thats_constant]  ], na.rm =T)
  }else{
    constant_value <- as.numeric(constant_value)
  }
  constant_value
}

#' Create a data frame of x variables to plot the marginal effect
#'
#' @param data A data frame or a tibble
#' @param model A glm with exactly two x variables
#' @param marginal_of_x1 A logical. If true, then the data frame represents the marginal effect of x1.
#'        If false, the marginal effect of x2.
#' @param constant_value A string or number indicating which constant value to use for
#'         the variable that remains constant. The string can take on "mean", "median", "min", or "max". Alternately, a numeric value may be specified.
#'
#' @return A data frame of x values that span the minimum to maximum values
#'       of the marginal effect, holding the other x variable constant
#' @noRd
create_marginal_x_vars <- function(data, model, marginal_of_x1,
                                   constant_value = "mean"){
  if(marginal_of_x1){
    x_that_changes <- "x1"
    x_thats_constant <- "x2"
  }else{
    x_that_changes <- "x2"
    x_thats_constant <- "x1"
  }
  coefficients <- create_named_coeffs(model)
  x_seq = seq(min(data[ ,coefficients[x_that_changes]  ], na.rm =T),
              max(data[ ,coefficients[x_that_changes]  ], na.rm =T),
              length.out=10)
  constant_num  <- create_constant_value(constant_value = constant_value, data = data,
                                         coefficients = coefficients,
                                         x_thats_constant = x_thats_constant)
  x_constant = rep(constant_num, each =10)  #rep 10
  if(marginal_of_x1){
    xvars_for_prediction <- data.frame(x_seq, x_constant)
  }else{
    xvars_for_prediction <- data.frame(x_constant, x_seq)
  }

  if( "weights" %in% names(coefficients) ){
    mean_weight <- mean(data[, coefficients["weights"]], na.rm=T) #mean of weights variable, could pass to create_constant_value()
    xvars_for_prediction$weights <- mean_weight
  }
  xvars_for_prediction
}

#' Create predicted y values from a data frame of x values
#'
#' @param x_vals A data frame  or tibble with exactly two columns.
#'      The first column has x1 values and the second column has x2 values.
#'      These will form a curve or line if plotted in the regression surface.
#'       The column names do not matter.
#' @param model A glm with exactly two x variables
#' @param coefficient_names A named character vector that attaches coefficient names
#'      to standardized names (x1, x2, y)
#'
#' @return A data frame with x values and their corresponding predicted y values,
#'      as well as 95% confidence intervals
#' @export
#'
#' @examples
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
#'                                                                  x1= "median_income16",
#'                                                                  x2= "any_college") )
create_y_estimates <- function(x_vals, model, coefficient_names){
  x_vals <- x_vals %>%
    tibble::rowid_to_column("rownum")
  var.names <- unname(coefficient_names[-1])
  names(x_vals) <- c("rownum", var.names)
  if("glm" %in% class(model)){
    predicteddata <- create_glm_adjustment(x_vals, model)
  }else if("lm" %in% class(model)){
    predicteddata <- broom::augment(model, newdata = x_vals, interval = "confidence") #returns a tibble
  }else{
    stop("Model must be in the lm or glm families.")
  }
  names(predicteddata) <- c("rownum", var.names, coefficient_names["y"], "lowerCI", "upperCI" )
  as.data.frame(predicteddata) #plot_ly wasn't accepting a tibble
}

#' Create predicted and confidence interval values from a glm model.
#'
#' Used by `create_y_estimates()` when the model is a glm.
#' This has been tested on the binomial family, but may work for all glms.
#' Uses the inverse link function to generate both predicted values and confidence intervals for the range of x values.
#'
#' @param x_vals A data frame or tibble with x values.
#' @param model A glm with exactly two x variables
#'
#' @return A data frame or tibble with x values and their corresponding predicted y values.
#'        This is an intermediary function.
#'        create_y_estimates generates the appropriate column names and data structure.
#' @noRd
create_glm_adjustment <- function(x_vals, model){
  inverse_link <- stats::family(model)$linkinv
  predicted_glm_data <- dplyr::bind_cols(x_vals,
                                         tibble::as_tibble(stats::predict(model, newdata = x_vals,
                                                                          type = "link", se.fit = T) [1:2]))
  names(predicted_glm_data) <- c(names(x_vals), 'fit_link','se_link')

  predicted_glm_data <- predicted_glm_data %>%
    dplyr::mutate(fit_response = inverse_link(.data$fit_link),
                  lowerCI = inverse_link(.data$fit_link-(stats::qnorm(.975)*.data$se_link)),  # should this be t values?
                  upperCI = inverse_link(.data$fit_link+(stats::qnorm(.975)*.data$se_link)) ) %>%
    dplyr::select(-.data$fit_link, -.data$se_link)

  predicted_glm_data
}

#' Create data frame used to plot a surface of predicted y values
#'
#' @param data A data frame being used to create the regression model
#' @param model A glm with exactly two x variables
#'
#' @return A data frame with a matrix of x values, predicted y values and predicted confidence intervals for each pair of x values
#' @export
#'
#' @examples
#' mymodel <- lm(length ~ isFemale_num + isMale_num,
#'               data = hair_data)
#' surface_data <- create_surface_data(data = hair_data,
#'                                     model = mymodel)
create_surface_data <- function(data, model){
  coefficients <- create_named_coeffs(model)
  x_vals <- create_surface_x_vars(data =data, model = model, coefficient_names = coefficients)
  predicteddata <- create_y_estimates(x_vals, model, coefficient_names = coefficients)
  predicteddata
}
