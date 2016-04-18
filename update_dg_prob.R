#' @title Update diagnostic probability based on the result of a test
#' @descriptin Given a pre-test probability and a likelihood ratio from an independent diagnostic test, calculate the post-test probability of the diagnosis.
#' @param pretest_prob The probability that the individual has the diagnosis prior to the test.
#' @param LR The (positive) likelihood ratio of the diagnosis given the result on the test.
#' @return The probability that the individual has the diagnosis after the test, or the post-test odds.
#' @reference https://en.wikipedia.org/wiki/Likelihood_ratios_in_diagnostic_testing
update_dg_prob <- function(pretest_prob, LR){

  pretest_odds = pretest_prob / (1 - pretest_prob)
  posttest_odds = pretest_odds * LR
  posttest_prob = posttest_odds / (1 + posttest_odds)

  return(posttest_prob)

}

update_dg_prob(0.4, 5)
update_dg_prob(0.9, 0.01)
update_dg_prob(0.5, 2.5)
