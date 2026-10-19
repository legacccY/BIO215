validate_rows <- function(bundle, input) {
  if (!is.data.frame(input)) stop("Input must be a data.frame.")
  if (anyDuplicated(names(input))) stop("Column names must be unique. Remove duplicate columns.")
  missing <- setdiff(bundle$feature_names, names(input))
  if (length(missing)) stop("Missing columns: ", paste(missing, collapse = ", "))
  x <- input[, bundle$feature_names, drop = FALSE]
  if (!nrow(x)) stop("No input rows.")
  if (nrow(x) > 1000L) stop("Please upload at most 1000 rows.")
  if (!all(vapply(x, is.numeric, logical(1)))) stop("All feature columns must be numeric.")
  if (any(!is.finite(as.matrix(x)))) stop("Inputs must contain only finite numbers.")
  x
}

predict_probability <- function(bundle, input) {
  x <- validate_rows(bundle, input)
  active <- if (is.null(bundle$active_features)) bundle$feature_names else bundle$active_features
  x <- x[, active, drop = FALSE]
  kind <- if (is.null(bundle$kind)) "rf" else bundle$kind
  probability <- switch(kind,
    rf = stats::predict(bundle$model, newdata = x, type = "prob")[, "M"],
    ridge = as.numeric(stats::predict(bundle$model, newx = as.matrix(x),
      s = bundle$lambda, type = "response")),
    svm = attr(stats::predict(bundle$model, newdata = x, probability = TRUE), "probabilities")[, "M"],
    stop("Unsupported model type."))
  if (any(!is.finite(probability)) || any(probability < 0 | probability > 1)) stop("Invalid model probabilities.")
  unname(probability)
}

predict_rows <- function(bundle, input) {
  probability <- predict_probability(bundle, input)
  data.frame(row = seq_along(probability),
    prediction = ifelse(probability >= 0.5, "Malignant", "Benign"),
    probability_M = probability)
}

explain_rows <- function(bundle, input) {
  x <- validate_rows(bundle, input)
  if (!identical(bundle$kind, "ridge")) stop("Exact log-odds SHAP requires the selected ridge model.")
  coefficients <- as.matrix(stats::coef(bundle$model, s = bundle$lambda))[, 1]
  active <- bundle$active_features
  values <- sweep(sweep(as.matrix(x[, active, drop = FALSE]), 2,
    bundle$training_mean[active], "-"), 2, coefficients[active], "*")
  baseline <- unname(coefficients[1] + sum(coefficients[active] * bundle$training_mean[active]))
  list(values = values, baseline = baseline,
    probability_M = stats::plogis(baseline + rowSums(values)), scale = "log-odds")
}
