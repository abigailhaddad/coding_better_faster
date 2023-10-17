# function
one_plus_one <- function() {
  1 + 1
}

# test
library(testthat)
test_that("one_plus_one() equals 2", {
  expect_equal(one_plus_one(), 2)
})
