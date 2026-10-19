\name{example_bio215}
\alias{example_bio215}
\title{Load three complete example observations}
\description{Provides the same three example feature rows distributed with the BIO215 Shiny application, drawn from the fixed internal test split.}
\usage{example_bio215()}
\value{A data.frame with three rows and 30 numeric columns with original, unmodified Kaggle column names. No diagnosis or patient identifier is included.}
\details{Data provenance: Wolberg, Mangasarian and Street, Wisconsin Diagnostic dataset, UCI, DOI 10.24432/C5DW2B; Kaggle mirror by uciml. Data are distributed under CC BY 4.0. The model was not fitted using these three observations.}
\examples{x <- example_bio215()
dim(x)
predict_bio215(x)}
\seealso{\code{\link{predict_bio215}}}
