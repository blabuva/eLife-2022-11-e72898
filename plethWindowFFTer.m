function respRates = plethWindowFFTer(timeC, breaths, sampF, windows)

%%
% save('/home/mark/matlab_temp_variables/fft')
% ccc
% load('/home/mark/matlab_temp_variables/fft')

%%
freqTimeSeries = zeros(find(timeC>=windows(end),1),1) ;
perTimeSeries = zeros(find(timeC>=windows(end),1),1) ;
timeCseries = zeros(find(timeC>=windows(end),1),1) ;


%%
% breathsFilt = zof_mark_high(breaths, 0.1, 1, 1/sampF) ;

breathsFilt = zof_mark_band(breaths, 0.1, 4, 1, 1/sampF) ;

for iWin = 1:length(windows)-1
    winStart = windows(iWin) ;
    winEnd = windows(iWin+1) ;
    
%     if winStart >= 4000
%         x=1
%     end
    
    idxStart = find(timeC >= winStart,1);
    idxEnd = find(timeC >= winEnd,1) ;
    
    breathChunk = breathsFilt(idxStart:idxEnd, 1) ;
    timeChunk = timeC(idxStart: idxEnd, 1) ;
    
    majorFrequency = fftBreath(breathChunk, timeChunk, sampF) ;
    majorPeriod = 1/majorFrequency ;
    
    timeCseries(idxStart:idxEnd, 1) = timeChunk;
    freqTimeSeries(idxStart:idxEnd, 1) = ones(length(timeChunk),1)*majorFrequency ;
    perTimeSeries(idxStart:idxEnd, 1) = ones(length(timeChunk),1)*majorPeriod ;
    
    respRates.values.primaryFrequencies(iWin) = majorFrequency ;
    respRates.values.periods(iWin) = majorPeriod ;
    
    clear winStart winEnd idxStart idxEnd breathChunk timeChunk majorFrequency majorPerid
end

%% make plottable (step-like function) frequency/period readout for plotting
finalFreqs = zeros(length(timeC),1) ;
finalFreqs(1:length(freqTimeSeries),1) = freqTimeSeries ;

%% find number of points in a window
pointsWin = find(timeC >= (windows(2)-windows(1)),1 ) ;

%% number of windows in a minute
winMin = 60/(windows(2)-windows(1)) ;

%% number of windows in 30 sec
winThirty = 30/(windows(2)-windows(1)) ;

%% smooth frequencies to a minute
smoothFinalFreqs = smooth(finalFreqs, pointsWin*winThirty) ;

%% append freq and period to respRates
respRates.timeSeries.freq = smoothFinalFreqs ;
respRates.timeSeries.period = 1/smoothFinalFreqs ;







