##' Calculate confidence intervals for a simple proportion
##' 
##' Currently only able to do 95\% confidence intervals. It would not be tricky to 
##' extend this function to allow other intervals.
##' 
##' @param x The numerator in a percentage calculation.
##' @param n The denominator in a percentage calculation. 
##' 
##' @return A named numeric vector with the lower confidence interval, 
##' point estimate and upper confidence interval.
##' ##' @seealso 
##' \code{\link{ci.mean}}, 
##' \code{\link{ci.poisson}}, 
##' \code{\link{ci.standardised.rate}}
##' @author dwhiting@@nhs.net david.whiting@@publichealth.me.uk
##' @keywords stats
##' @examples 
##' ci.proportion(3, 20) 
##' 
##' @export

ci.proportion <- function(x, n){
  p <- x / n
  q <- 1 - p
  ci <- 1.96 * sqrt((p * q) / n)
  p.lower <- p - ci
  p.upper <- p + ci
  c(lower.CI = p.lower,
    p = p,
    upper.CI = p.upper)
}

