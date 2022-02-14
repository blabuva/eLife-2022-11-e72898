function respRatesPeaks = plethWindowPeaker(timeC, breaths, windows)

% save('/home/mark/matlab_temp_variables/respPeaks2')
% ccc
% load('/home/mark/matlab_temp_variables/respPeaks2')

%% create an empty vector that will eventually hold resp rates
respRatesPeaks.timeSeries.period.windows = [] ;
respRatesPeaks.timeSeries.period.breathTimes = [] ;

%% for loop to grab windows of pleth data (according to windows variable)
for iWin = 1:length(windows)-1
    chunk.IDX.start = find(timeC>=windows(iWin),1) ;
    chunk.IDX.end = find(timeC>=windows(iWin+1),1) ;
    respRatesPeaks = respRateBasedOnPlethPeaks(breaths(chunk.IDX.start:chunk.IDX.end), ...
        timeC(chunk.IDX.start:chunk.IDX.end), respRatesPeaks) ;
end

%% make respRatesPeaks.window same length as breaths
finalRespPeriod = zeros(length(breaths), 1) ;
finalRespPeriod(1:length(respRatesPeaks.timeSeries.period.windows)) = respRatesPeaks.timeSeries.period.windows ;
respRatesPeaks.timeSeries.period.finalWindowPeriod = finalRespPeriod ;

%% tack on Freqs (and deal with Nans)
finalRespFreq = (1./finalRespPeriod) ;
respRatesPeaks.timeSeries.freq.finalWindowPeriod = finalRespFreq ;
