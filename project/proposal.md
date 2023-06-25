# Project Proposal

1. Data Source: The time series data from the M3 forecasting competition.
2. Analysis Workflow: 
- Data Preprocessing:
  - Read in json data files hosted on github. There are 4 types of files (or time series types) "monthly", "yearly", "quarterly", and "other". I will be focusing in only "monthly" for now since there are 1428 realizations that are needed to apply LSTM for.
  - The json files will already have 2 columns "start", the start year-month-day of the time series, and "target", the observed values of the time series. Preprocessing will convert all "target" values into numeric, then it will extract the series features necessary for building a forecasting model, specifically p, d, q, s, series length, year, month, min target, and max target.
  - Most of these features are created to cater for statistical methods like ARIMA and exponential smoothing, which are already fully developed. This project is spawned because the fact that LSTM, a deep learning neural network, requires a lot more computing power than a local personal computer.
- Time Series Analysis: 
  - Cochrane Orcutt will be used to solve first order autocorrelation problems, where a p-value <= 0.05 means that a certain realization contains trend which is problematic to applying an LSTM network.
  - And once a realization is detected with this problem, the "target" values are applied an ARIMA transformation, or rather lag 1 differencing, where a wandering component is added to stabilize the realization and make it have constant mean and variance. Non-constant mean and variance is problematic to applying an LSTM network.
  - **WIP** *Scaling the "target" values to [-1,1] to cater to the default tanh activation function of LSTM.*
  - Apply the LSTM network and tune it using sMAPE (symmetric Mean Absolute Percentage Error) as a baseline.
  - **WIP** *Invert the scaling*, and invert the ARIMA transformation (lag 1 differencing).
- High-performance Computing:
  - Since the network takes longer times on local computers, SLURM will be used to manage workloads on Southern Methodist University's M3 HPC cluster and send batch jobs that contains only 50 or 100 realizations each which will be run in parallel. Logs and outputs will from the jobs will be sent to my email.
- Possible Performance Optimization Targets:
  - This is where tuning the LSTM and doing the necessary steps prior to tuning are crucial in minimizing the execution times of the jobs.
  - LSTM has 6 parameters that can easily be manipulated, however a slight change to a few of them can increase the runtime exponentially.
  - Additionally, the forecasting process in general takes your desired amount of years, months, or days to forecast out in the future, and looks into the entire realization as a whole minus that amount of time, in order to generate the forecasts on top of the old observed values of the time series. This amount is called horizons. The longer the horizons, the more computing power required. On other notes, this ties back to using sMAPE to evaluate the fitness of the tuned LSTM network, where the horizons are evaluated against the old observed values.
