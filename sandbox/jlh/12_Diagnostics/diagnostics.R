library(argoFloats)
library(oce)
qf <- function(x) {
    100 * (1 - sum(4 == x[[paste0(variable, 'Flag')]]) / length(x[[paste0(variable, 'Flag')]]))
}
meanf <- function(x) {
    mean(x[[variable, na.rm=TRUE]])
}
if (!exists("bai")) {
    bai <- getIndex(file='bgc')
    F5901462 <- subset(bai, ID='5901462') # Follow 5901462 float
    profiles <- getProfiles(F5901462)
    argos <- readProfiles(profiles, handleFlags=FALSE) 
}
time <- oce::numberAsPOSIXct(unlist(lapply(argos[['profile']], function(x) x[['time']])))
variables <- c('oxygen', 'salinity', 'temperature')
for (variable in variables) {
    q <- unlist(lapply(argos[['profile']], qf))
    m <- unlist(lapply(argos[['profile']], meanf))
    par(mfrow=c(2,1), mar=c(2.5,2.5,1,1))
    if (any(is.finite(q))) {
        oce.plot.ts(time,q, ylab=paste(variable, "% Good"), drawTimeRange = FALSE)
        abline(h=50, col='red', lty='dashed')
        oce.plot.ts(time, m, ylab=paste(variable, "Mean"), type='l', col='grey', drawTimeRange = FALSE)
        points(time, m, col=ifelse(q < 50, 'red', 'black'), pch=20, cex=0.75)
    } else {
        plot(0:1, 0:1, xlab="", ylab='', type="n", axes=FALSE)
        box()
        text(0, 0.5, paste(' No', variable, 'flags available'), pos=4)
        plot(0:1, 0:1, xlab="", ylab='', type="n", axes=FALSE)
        box()
        text(0, 0.5, paste(' No', variable, 'flags available'), pos=4)
    }
}
