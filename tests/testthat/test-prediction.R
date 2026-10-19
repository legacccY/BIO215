test_that("default output contains classes and preserves rows and column reordering", {
  x <- example_bio215()
  classes <- predict_bio215(x)
  expect_s3_class(classes, "factor")
  expect_length(classes, 3)
  expect_identical(levels(classes), c("Benign", "Malignant"))
  expect_identical(classes, predict_bio215(x[, rev(names(x))]))
  p <- predict_bio215(x, "probability")
  expect_equal(as.character(classes), ifelse(p >= 0.5, "Malignant", "Benign"))
  x$ignored <- "extra column"
  expect_identical(p, predict_bio215(x, "probability"))
})
test_that("invalid inputs fail before model prediction", {
  x <- example_bio215()
  expect_error(predict_bio215(as.matrix(x)), "data.frame")
  expect_error(predict_bio215(x[, -1]), "Missing columns")
  expect_error(predict_bio215(x[0, ]), "No input rows")
  expect_error(predict_bio215(x[rep(1, 1001), ]), "at most 1000")
  z <- x; names(z)[2] <- names(z)[1]
  expect_error(predict_bio215(z), "unique")
  for (value in c(NA_real_, NaN, Inf, -Inf)) {
    z <- x; z[1, 1] <- value
    expect_error(predict_bio215(z), "finite")
  }
  z <- x; z[[1]] <- as.character(z[[1]])
  expect_error(predict_bio215(z), "numeric")
  expect_error(predict_bio215(x, "invalid"))
})
test_that("exact SHAP reconstructs all held-out predictions", {
  x <- utils::read.csv(system.file("extdata", "test_features.csv", package = "BIO215"), check.names = FALSE)
  expected <- utils::read.csv(system.file("extdata", "test_predictions.csv", package = "BIO215"))
  p <- predict_bio215(x, "probability")
  expect_length(p, 115)
  expect_equal(p, expected$probability_M, tolerance = 1e-12)
  expect_equal(as.character(predict_bio215(x)), ifelse(expected$predicted == "M", "Malignant", "Benign"))
  shap <- explain_bio215(x)
  expect_equal(dim(shap$values), c(115L, 30L))
  expect_equal(shap$scale, "log-odds")
  expect_equal(shap$probability_M, p, tolerance = 1e-12)
})
