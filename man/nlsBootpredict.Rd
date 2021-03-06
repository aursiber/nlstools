\name{nlsBootpredict}
\alias{nlsBootpredict}
%- Also NEED an '\alias' for EACH other topic documented here.

\title{Prediction from Bootstrap resampling }

\description{
Computation of confidence intervals on predictions from Bootstrap resampling 
}

\usage{
nlsBootpredict(nlsBoot, newdata, 
                interval = c("confidence", "prediction")) 
}

%- maybe also 'usage' for other objects documented here.

\arguments{
    \item{nlsBoot}{ An object of class 'nlsBoot'. }
    \item{newdata}{ A data frame in which to look for values of independent variables 
    for the predictions.If omitted, the data used for fitting are used.}
    \item{interval}{ Type of interval to compute, "confidence", or "prediction".}
}

\details{
    \code{nlsBootpredict} produces confidence intervals on predicted values 
that can be obtaine using \code{\link{predict.nls}} for values of the
independent variable(s) defined in the data frame newdata. Non-parametric bootstrapping is used (results of \code{nlsBoot}). 
For confidence intervals the bootstrap sample of predictions is simply computed
from the bootstrap sample of estimations of the model parameters, by evaluating
the mean value of the model on each new data. For prediction intervals, 
to take into account the residual errors, a residual error sampled
in the mean centered residuals is added to each mean predicted
value. In both cases, bootstrap predictions are summarized by the median and 95 percent confidence intervals (50, 2.5, and 97.5 percentiles of the bootstrapped values).   
}

\value{ 
    \code{\link{nlsBoot}} returns a matrix of predictions with three columns 
    respectively corresponding to the 50, 2.5 and 97.5 percentiles of bootstrap predictions.
}

\seealso{
    See \code{\link{nlsBoot}} and \code{\link{predict.nls}}.
}

\references{
Huet S, Bouvier A, Poursat M-A, Jolivet E (2003) Statistical tools for nonlinear regression: a practical guide with S-PLUS and R examples. Springer, Berlin, Heidelberg, New York.
}

\author{ 
Florent Baty \email{florent.baty@gmail.com}\cr
Marie-Laure Delignette-Muller \email{ml.delignette@vetagro-sup.fr}
}

%\note{  }

\examples{
formulaExp <- as.formula(VO2 ~ (t <= 5.883) * VO2res + (t > 5.883) * 
                            (VO2res + (VO2peak - VO2res) * 
                               (1 - exp(-(t - 5.883) / mu))))
O2K.nls1 <- nls(formulaExp, start = list(VO2res = 400, VO2peak = 1600, 
                                         mu = 1), data = O2K)
niter <- 200
### To reach stable prediction intervals use far greater niter (>> 1000)
O2K.boot1 <- nlsBoot(O2K.nls1, niter = niter)
newdata <- data.frame(t = seq(0, 12, length.out = 50))
(pred.clim <- nlsBootpredict(O2K.boot1, newdata = newdata, interval = "confidence"))
(pred.plim <- nlsBootpredict(O2K.boot1, newdata = newdata, interval = "prediction"))

plotfit(O2K.nls1, smooth = TRUE, ylim = c(200, 1800))
lines(newdata$t, pred.clim[, 2], pch = 19, col = "red")
lines(newdata$t, pred.clim[, 3], pch = 19, col = "red")
lines(newdata$t, pred.plim[, 2], pch = 19, col = "blue")
lines(newdata$t, pred.plim[, 3], pch = 19, col = "blue")

### An example without giving newdata
(pred.plim <- nlsBootpredict(O2K.boot1, interval = "prediction"))

plotfit(O2K.nls1, smooth = FALSE, ylim = c(200, 1800))
points(O2K$t, pred.plim[, 1], pch = 19, col = "blue")
segments(O2K$t, pred.plim[, 2], O2K$t, pred.plim[, 3], col = "blue")

  }

\keyword{ nonlinear }% at least one, from doc/KEYWORDS
