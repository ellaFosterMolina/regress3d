## Resubmission

This is a resubmission. In this version I have:

-   Changed all T and F logicals to TRUE and FALSE.
-   There are no citations for this package.
-   Edited the internal function create_glm_adjustment() on lines 194, 197, 199 in R/create_plot_data.R to use a t distribution instead of normal.

## R CMD check results

0 errors \| 0 warnings \| 1 note

-   This is a new release.
-   The submitted size is 1.5 MB without any vignettes. The vast bulk of this size is "regression-rotating.gif", which is called in README.md and stored in man/figures. It is 1.38 MB and demonstrates the core functionality of this package. I have compressed it as much as possible without losing too much definition.
