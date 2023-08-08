## Duy Nguyen
## DataScience@SMU
## High-performance Computing - Summer, 2023

library(tseries)
library(smooth)
library(vars)
library(forecast)
library(tswge)
library(nnfor)

## Change your desired forecasting horizon as needed
horizon=18

## Change your desired ticker symbol as needed
which_ticker = 'AAPL'
#'META' 'AMZN' 'AAPL' 'NFLX' 'GOOGL'

#######################################################################################

read_data<-function(){
  
  ##change which_ticker for different ticker symbols
  df = read.csv("df_for_R.csv")
  df <- df[,-1]
  
  return(df)
  
}

#######################################################################################

pinpoint_multi_df<-function(df, which_ticker){
  
  # Pinpoint dataframe into the chosen ticker symbol
  df = df[df$TICKER == which_ticker,]
  #n_years = 4
  
  OPEN = df$OPEN
  #OPEN = OPEN[(length(OPEN)-(n_years*365)):length(OPEN)]
  
  HIGH = df$HIGH
  #HIGH = HIGH[(length(HIGH)-(n_years*365)):length(HIGH)]
  
  LOW = df$LOW
  #LOW = LOW[(length(LOW)-(n_years*365)):length(LOW)]
  
  ADJ_CLOSE = df$ADJ_CLOSE
  #ADJ_CLOSE = ADJ_CLOSE[(length(ADJ_CLOSE)-(n_years*365)):length(ADJ_CLOSE)]
  
  VOLUME = df$VOLUME
  #VOLUME = VOLUME[(length(VOLUME)-(n_years*365)):length(VOLUME)]
  
  return(list('OPEN'=OPEN,
              'HIGH'=HIGH,
              'LOW'=LOW,
              'ADJ_CLOSE'=ADJ_CLOSE,
              'VOLUME'=VOLUME))
}

#######################################################################################

fit_mlp<-function(variables, horizon){
  
  set.seed(12345)
  small_df_xreg = data.frame(OPEN = ts(variables$OPEN[1:(length(variables$OPEN)-horizon)]),
                             HIGH = ts(variables$HIGH[1:(length(variables$HIGH)-horizon)]),
                             LOW = ts(variables$LOW[1:(length(variables$LOW)-horizon)]),
                             VOLUME = ts(variables$VOLUME[1:(length(variables$VOLUME)-horizon)])
  )
  df_xreg = data.frame(OPEN = ts(variables$OPEN),
                       HIGH = ts(variables$HIGH),
                       LOW = ts(variables$LOW),
                       VOLUME = ts(variables$VOLUME)
  )
  temp_mlp_fit = mlp(ts(variables$ADJ_CLOSE[1:(length(variables$ADJ_CLOSE)-horizon)]),
                     reps=5, comb="median",
                     xreg=small_df_xreg,
                     difforder=NULL,
                     allow.det.season=TRUE,
                     sel.lag=TRUE)
  foreholder = forecast(temp_mlp_fit, h=horizon, xreg=df_xreg)$mean
  # temp_foreholder = {}
  # foreholder = {}
  # for(x in 1:3) {
  #   temp_mlp_fit = mlp(ts(variables$ADJ_CLOSE[1:(length(variables$ADJ_CLOSE)-horizon)]), 
  #                      reps=5, comb="median", 
  #                      xreg=small_df_xreg,
  #                      difforder=NULL,
  #                      allow.det.season=TRUE,
  #                      sel.lag=TRUE)
  #   temp_foreholder[[x]] = forecast(temp_mlp_fit, h=horizon, xreg=df_xreg)$mean
  # }
  # for(x in 1:horizon) {
  #   foreholder[x] = mean(c(temp_foreholder[[1]][x], 
  #                          temp_foreholder[[2]][x], 
  #                          temp_foreholder[[3]][x]
  #   ))
  # }
  
  return(foreholder)
}

#######################################################################################

## Read in Alpha Vantage API data of FAANG
df<-read_data()

## Pinpoint data to only ticker matching 2nd parameter (currently AAPL)
variables<-pinpoint_multi_df(df, which_ticker)

## Perform MLP
fore.MLP = fit_mlp(variables, horizon)
