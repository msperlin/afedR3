format_date <- function(x) {

  x <- as.Date(x)
  x.formatted <- format(x, '%d/%m/%Y')

  return(x.formatted)
}


replace_str_file <- function(f.in, f.out, str.id, str.replace) {

  txt.out <- stringr::str_c(
    readr::read_lines(f.in),
    collapse = '\n'
    )

  for (i.str in seq(str.id)) {
    txt.out <- stringr::str_replace(txt.out,
                           pattern = stringr::fixed(str.id[i.str]),
                           replacement = str.replace[i.str])

  }

  cat(txt.out, file = f.out)

  return(invisible(TRUE))

}

print.pretty.df <- function(my.print.df) {
  #my.align <- paste0('|l|', paste0(rep('l', ncol(my.print.df)-1), collapse = '|'), '|'  )
  #knitr::kable(my.print.df, row.names = F, format = 'html', align = my.align,digits = 2, format.args = list(decimal = ',') )

  knitr::kable(my.print.df, row.names = F,
               format.args = list(decimal.mark = ',',
                                  digits =5))
  #my.print.df %>%
  #kbl(centering = FALSE, booktabs = TRUE)

}



#' Check exams answers
#'
#' @param answers_in Char vector
#'
#' @return TRUE or FALSE
#' @export
#'
#' @examples
#' check_answers(1:5)
check_answers <- function(answers_in) {

  n_answers <- 5
  if (length(answers_in) != n_answers) {
    stop('Found question with less or more than 5 answers..')
  }

  n_unique <- dplyr::n_distinct(answers_in)
  if (n_unique != n_answers) {
    stop('Found question with less or more than 5 UNIQUE answers..')
  }

  flag <- any(stringr::str_trim(answers_in) == '')
  if (flag) {
    stop('Found question with empty answer..')
  }

  if (is.numeric(answers_in)) {
    flag <- any(!is.finite(answers_in))

    if (flag) {
      stop('Found numeric question with non finite number..')
    }

  }

  return(invisible(TRUE))

}

#' Generate random vectors for answers
#'
#' This function generates random vectors with first element equal to 1 and rest
#' equal to proportions. It is mostly used for building alternatives in numerical questions:
#' solution*afedR_gen_rnd_vec().
#'
#' @return A vector
#' @export
#' @import stats
#'
#' @examples
#' print(afedR_gen_rnd_vec())
gen_rnd_vec <- function(){
  rnd.vec.1 <- c(1, seq(runif(1,0.1,0.2), runif(1,0.7,0.8), length.out = 4))
  rnd.vec.2 <- c(1, seq(runif(1,1.1,1.2), runif(1,1.7, 1.8), length.out = 4))
  rnd.vec.3 <- c(1, seq(runif(1,0.25,0.5),runif(1,0.6,0.8), length.out = 2),
                 seq(runif(1,1.2,2), length.out = 2))

  rnd.l <- list(rnd.vec.1, rnd.vec.2, rnd.vec.3)
  rnd.vec <- sample(rnd.l,1)[[1]]
  return(rnd.vec)
}


decimal_places <- function(x) {
  if (abs(x - round(x)) > .Machine$double.eps^0.5) {
    nchar(strsplit(sub('0+$', '', as.character(x)), ".", fixed = TRUE)[[1]][[2]])
  } else {
    return(0)
  }
}

#' Creates random answers
#'
#' @param solution The solution
#' @param candidates Candidates (opcional)
#' @param is_cash Where solution is cash
#'
#' @return Char vector with randomized answers
#' @export
#'
#' @examples
#' make_random_answers(10)
make_random_answers <- function(solution,
                                candidates = NA,
                                is_cash = FALSE) {
  if (!any(is.na(candidates))) {
    candidates <- unique(candidates)
    candidates <- candidates[candidates != solution]

    if (length(candidates) < 4) {
      stop('Candidate vector is lower than 4!')
    }

    my_answers <- c(solution,
                    sample(candidates, 4))
  } else {
    # check if is numeric
    if (class(solution) %in% c('numeric', 'integer')) {
      # find number of decimais
      n_decimals <- decimal_places(solution)

      if (n_decimals ==0) {
        my_answers <- floor(solution*gen_rnd_vec())
      } else {

        if (n_decimals > 4) n_decimals <- 4

        my_answers <- prettyNum(solution*gen_rnd_vec())
      }

      if (is_cash) {
        my_answers <- format_cash(
          as.numeric(my_answers),
          type_cash = 'USD')
      }

    }

  }

  return(my_answers)
}

#' Creates text for random questions
#'
#' @param text1 tibble 1
#' @param text2 tibble 2
#' @param text3 tibble 3
#'
#' @return A list
#' @export
#'
#' @examples
#'
#' tibble1 <- dplyr::tibble(text = c("ABC1", "ABC2", "ABC3"), sol =  c(TRUE, FALSE, TRUE))
#' tibble2 <- dplyr::tibble(text = c("ABC1", "ABC2", "ABC3"), sol = c(TRUE, FALSE, TRUE))
#' tibble3 <- dplyr::tibble(text = c("ABC1", "ABC2", "ABC3"), sol = c(TRUE, FALSE, TRUE))
#' build_answers_text(tibble1, tibble2, tibble3)
build_answers_text <- function(text1,
                               text2,
                               text3) {

  answer <- NULL

  text1_chosen <- text1[sample(1:nrow(text1), 1), ]
  text2_chosen <- text2[sample(1:nrow(text2), 1), ]
  text3_chosen <- text3[sample(1:nrow(text3), 1), ]

  right_answer <- paste0(c(text1_chosen$sol,
                           text2_chosen$sol,
                           text3_chosen$sol), collapse = ', ')

  other_answers <- tidyr::expand_grid(col1 = c('TRUE', 'FALSE'),
                                      col2 = c('TRUE', 'FALSE'),
                                      col3 = c('TRUE', 'FALSE')) |>
    dplyr::mutate(answer = glue::glue('{col1}, {col2}, {col3}') ) |>
    dplyr::filter(answer != right_answer)

  my_answers <- c(right_answer,
                  sample(other_answers$answer, 4))

  return(list(my_answers = my_answers,
              texts = c(text1_chosen$text,
                        text2_chosen$text,
                        text3_chosen$text)))

}
