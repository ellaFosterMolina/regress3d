test_that("plot data is from initial plotly call", {
  mymodel <- lm(r_shift ~ median_income16 * any_college, data = county_data, weight = pop_estimate16)
  p_nosurface <- plot_ly( data = county_data,
                          x = ~median_income16,
                          y = ~any_college,
                          z = ~test_that) %>%
    add_markers(size = 1, color = I('black'))%>%
    add_marginals(model = mymodel)

  p_surface <- plot_ly( data = county_data,
                        x = ~median_income16,
                        y = ~any_college,
                        z = ~test_that) %>%
    add_markers(size = 1, color = I('black')) %>%
    add_3d_surface(model = mymodel)

  data_surface <- plotly::plotly_data(p_surface, id = names(p_surface$x$visdat)[1])
  data_nosurface <- plotly::plotly_data(p_nosurface, id = names(p_nosurface$x$visdat)[1])

  length_diff <- dim(as.data.frame(setdiff(data_surface, data_nosurface)))[1]

  expect_equal(length_diff, 0)

})
