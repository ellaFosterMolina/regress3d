test_that("x values in surface data do not exceed range of original data", {
  # this is for when line directions are calculated from rotations
  # create more tests for x_vals from create_marginals, and eventually create_directional_x_vars
  mymodel <- lm(r_shift ~ median_income16 * any_college, data = county_data, weight = pop_estimate16)
  coeff_names <- create_named_coeffs(mymodel)
  range_x1 <- c(min(county_data[ , coeff_names["x1"]], na.rm=T), max(county_data[ , coeff_names["x1"]], na.rm=T))
  range_x2 <- c(min(county_data[ , coeff_names["x2"]], na.rm=T), max(county_data[ , coeff_names["x2"]], na.rm=T))

  surface_data <- create_surface_data(county_data, mymodel)
  range_x1_vals <- c(min(surface_data[ , coeff_names["x1"]], na.rm=T), max(surface_data[ , coeff_names["x1"]], na.rm=T))
  range_x2_vals <- c(min(surface_data[ , coeff_names["x2"]], na.rm=T), max(surface_data[ , coeff_names["x2"]], na.rm=T))

  difference_must_be_0 <- length(setdiff(range_x1, range_x1_vals) ) +length(setdiff(range_x2, range_x2_vals))
  expect_true(difference_must_be_0 ==0)

})
