\name{predict_bio215}
\alias{predict_bio215}
\title{Predict breast tumor classes with the fixed BIO215 model}
\description{Applies the same trained ridge logistic model as the Shiny application. It never refits or downloads a model. For educational use only.}
\usage{predict_bio215(newdata, type = c("class", "probability"))}
\arguments{
\item{newdata}{A data.frame with 1 to 1000 rows and all 30 finite numeric Wisconsin Diagnostic feature columns, with their original Kaggle names. See the example CSV returned by \code{example_bio215()}. Column order is arbitrary. Extra columns are ignored. Missing columns, duplicate names, NA, NaN, Inf, nonnumeric features and empty inputs cause an informative error.}
\item{type}{Character string. Default \code{"class"} returns classified outcomes; \code{"probability"} returns the estimated malignant probability.}
}
\value{For \code{type = "class"}, a factor of length nrow(newdata), with levels \code{"Benign"} and \code{"Malignant"}. For \code{type = "probability"}, a numeric vector of the same length in [0,1]. A probability greater than or equal to 0.5 maps to Malignant. Row order is preserved.}
\details{The fixed seed-123 split has 454 training and 115 internal test observations. Candidate selection used training-only stratified five-fold cross-validation repeated three times. The selected ridge model uses all 30 features, alpha = 0 and lambda = 0.01. Standardization is learned from training data. Test results are internal and the split had already been inspected during feasibility work. Probabilities are not clinically calibrated. The complete feature names and scales are preserved in the supplied example; use \code{check.names = FALSE} when reading CSV files because concave-points column names contain spaces.}
\examples{
x <- example_bio215()
predict_bio215(x)
predict_bio215(x, type = "probability")
stopifnot(identical(predict_bio215(x), predict_bio215(x[, rev(names(x))])))
}
\seealso{\code{\link{example_bio215}}, \code{\link{explain_bio215}}}
\references{Wolberg, Mangasarian and Street. Breast Cancer Wisconsin (Diagnostic). UCI Machine Learning Repository. \doi{10.24432/C5DW2B}.}
