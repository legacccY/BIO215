\name{explain_bio215}
\alias{explain_bio215}
\title{Explain predictions with exact log-odds SHAP values}
\description{Computes exact interventional SHAP values for the selected linear log-odds model using training-only feature means.}
\usage{explain_bio215(newdata)}
\arguments{\item{newdata}{A data.frame satisfying the same requirements as \code{predict_bio215()}.}}
\value{A list with \code{values} (n by 30 matrix of feature contributions), \code{baseline} (training-mean model log-odds), \code{probability_M} (n reconstructed probabilities), and \code{scale} (the string \code{"log-odds"}).}
\details{Each value is coefficient times (feature value minus training feature mean). Baseline plus the row sum reconstructs the linear predictor; plogis of that sum reconstructs P(M). This explains log-odds, not probability contributions. Marginal replacement ignores feature correlations; these SHAP values do not establish biological causation. The Shiny Analysis tab separately displays Monte Carlo SHAP on the probability scale. Do not compare the numeric sizes across these two scales.}
\examples{x <- example_bio215()
s <- explain_bio215(x)
stopifnot(max(abs(plogis(s$baseline + rowSums(s$values)) -
  predict_bio215(x, "probability"))) < 1e-12)}
\seealso{\code{\link{predict_bio215}}}
