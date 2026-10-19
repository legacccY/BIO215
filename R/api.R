.bio215_model <- local({
  value <- NULL
  function() {
    if (is.null(value)) value <<- readRDS(system.file("extdata", "model.rds", package = "BIO215", mustWork = TRUE))
    value
  }
})

predict_bio215 <- function(newdata, type = c("class", "probability")) {
  type <- match.arg(type)
  result <- predict_rows(.bio215_model(), newdata)
  if (type == "probability") result$probability_M
  else factor(result$prediction, levels = c("Benign", "Malignant"))
}

example_bio215 <- function() {
  utils::read.csv(system.file("extdata", "example_input.csv", package = "BIO215", mustWork = TRUE), check.names = FALSE)
}

explain_bio215 <- function(newdata) {
  explain_rows(.bio215_model(), newdata)
}
