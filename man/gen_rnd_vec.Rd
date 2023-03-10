% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exams_webex_fcts.R
\name{gen_rnd_vec}
\alias{gen_rnd_vec}
\title{Generate random vectors for answers}
\usage{
gen_rnd_vec()
}
\value{
A vector
}
\description{
This function generates random vectors with first element equal to 1 and rest
equal to proportions. It is mostly used for building alternatives in numerical questions:
solution*afedR_gen_rnd_vec().
}
\examples{
print(afedR_gen_rnd_vec())
}
