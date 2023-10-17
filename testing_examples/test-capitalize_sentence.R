test_that("capitalize_sentence function works", {
  expect_equal(capitalize_sentence("hello world"), "Hello World")
  expect_equal(capitalize_sentence("this is a test"), "This Is A Test")
})

