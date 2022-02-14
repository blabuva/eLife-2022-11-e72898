function [respRatesFFT, respRatesPeaks] = fixNoisyBreathsNumberTwo(metaData, timeC, respRatesFFT, respRatesPeaks)

% save('/home/mark/matlab_temp_variables/respPeaks2')
% ccc
% load('/home/mark/matlab_temp_variables/respPeaks2')

%% make time column (assuming 200Hz sampling frequency)
timeCms = timeC*1000 ; % in milliseconds

%% load ATF file
noisyCursors = readtable(metaData.plethNoiseATF, 'FileType', 'text') ;

%% manageableify variables
fftPer = respRatesFFT.timeSeries.period ;
fftFreq = respRatesFFT.timeSeries.freq ;
peakPer = respRatesPeaks.timeSeries.period.finalWindowPeriod ;
peakFreq = respRatesPeaks.timeSeries.freq.finalWindowPeriod ;

%% remove any nans
fftPer = removeRespNans(fftPer) ;
fftFreq = removeRespNans(fftFreq) ;
peakPer = removeRespNans(peakPer) ;
peakFreq = removeRespNans(peakFreq) ;

%% loop to chop out noise
for iNoise = 1:size(noisyCursors,1)
    startMS = noisyCursors.Time1_ms_(iNoise) ;
    endMS = noisyCursors.Time2_ms_(iNoise) ;
    startIDX = find(timeCms >=startMS, 1) ;
    endIDX = find(timeCms >=endMS, 1) ;
    fftPer(startIDX:endIDX) = -5;
    fftFreq(startIDX:endIDX) = -5;    
    peakPer(startIDX:endIDX) = -5;    
    peakFreq(startIDX:endIDX) = -5; 
end

%% add neNoised traces to respective resp structures
respRatesFFT.fixed.period = fftPer ;
respRatesFFT.fixed.frequency = fftFreq ;
respRatesPeaks.fixed.period = peakPer ;
respRatesPeaks.fixed.frequency = peakFreq ;





