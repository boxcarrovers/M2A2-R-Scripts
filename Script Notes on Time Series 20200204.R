# NOTES ON TIME SERIES ANALYSIS
# FEBRUARY 4, 2020

# This uses some code extracts and examples from R IN ACTION  CH.15

sales <- c(18,33,41,7,34,36,24,25,24,21,25,20,22,31,40,29,25,21,22,54,21,25,26,35)
# create time series object
tsales <- ts(sales, start = c(2003,1), frequency =12)
plot(tsales)
start(tsales)
end(tsales)
frequency(tsales)
# window command can be used to create a subset of the time series observations
jmrecent <- window(tsales, start =c(2004,1), end =c(2004,12))


# after plotting, typically first step is to capture general/longer term trends
# that can often be done by plotting and seeing some moving averages.
# which can smooth things out and reveal/highlight these trends. (if they indeed exist.)
# picking the right number of periods to incorp into moving average is a judgment 
# typically pick an odd number - to grab observations before and after

# moving average function (ma) is from forecast library.. can be used
library(forecast)
salesma3 <- plot(ma(tsales,3), main = 'SMA = 3') 

# Most Common Way of Looking At Time Series Is To Think Of Following:
#  Yt = Trendt + Seasonalt + Irregulart
# in other words, base function + LT trend + seasonality factor + normal error/noise

