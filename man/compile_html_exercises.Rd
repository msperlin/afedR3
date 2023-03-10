% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exams_fcts_html.R
\name{compile_html_exercises}
\alias{compile_html_exercises}
\title{Compiles exercises from book afedR}
\usage{
compile_html_exercises(
  students_names,
  students_ids = paste0("Exam ", 1:length(students_names)),
  class_name = "Sample class",
  exercise_name = paste0("Sample Exercise"),
  links_in_html = dplyr::tibble(text = "Analyzing Financial and Economic Data with R",
    url = "https://www.msperlin.com/afedr"),
  chapters_to_include = 1:3,
  solution = FALSE,
  dir_out = "html exams",
  language = "en"
)
}
\arguments{
\item{students_names}{Names of students (a vector)}

\item{students_ids}{Ids of students (a vector)}

\item{class_name}{The name of the class}

\item{exercise_name}{The name of the exercises}

\item{links_in_html}{A dataframe with links to be added in the html page. This can
be anything that helps the students. The dataframe must have two columns: "text" with the text to
appear in the html and "url" with the actual link (see default options for details).}

\item{chapters_to_include}{Chapter to include in exercise (1-13)}

\item{solution}{flag (TRUE/FALSE) for whether printing solutions or not}

\item{dir_out}{Folder to copy exercise html files}

\item{language}{Selection of language ("en" only so far)}
}
\value{
TRUE, if sucessfull
}
\description{
This function uses the \link{exams} package to create exercises in the html or pdf format with
random selections. This means that each student will receive a different version of the same
exercise. All exercise files are taken from book "Analysing Financial and Economic Data with R".
}
\examples{
\dontrun{
afedR_build_exam(students_names = 'George', chapters_to_include = 2,
                 dir_out = tempdir())
 }
}
