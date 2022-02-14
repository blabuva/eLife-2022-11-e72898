function theFreq = fftBreath(data, time, sampF) 

% save('/home/mark/matlab_temp_variables/fftBreath') ;
% ccc ;
% load('/home/mark/matlab_temp_variables/fftBreath') ;


%% find major freq based on the average of the first two peaks returned by an FFT

%% smooth breaths
% dataSmooth = smooth(data, 50) ;
% plot(dataSmooth)



[f,mx,maxF,powmaxF] = markFFT(data,sampF) ;


% plot(data)
% hold on
% plot(dataHipass, 'r')


%% eliminate peak at 0
minFreqIDX = find(f >= 0.15,1) ;
% mx(1:minFreqIDX) = 0 ;

%% eliminate peaks greater than 20 Hz
maxFreqIDX = find(f >= 20, 1) ;
mx(maxFreqIDX:end) = 0 ;

%% run find peaks once to get peak values
[maxes1, idxes1] = findpeaks(mx) ;

%% find amplitude in between 0 and max peak for (prominence) thresholding
promThresh = max(maxes1)/4 ;

%% run find peaks a second time to threshold
% [maxes2, idxes2] = findpeaks(mx, 'threshold', middleMX) ;
[maxes2, idxes2] = findpeaks(mx, 'minpeakprominence', promThresh) ;

%% dominant freq based on first peak
try 
    theFreq = f(idxes2(1)) ;
catch
    theFreq = 0 ;
end



%% plot, if necessary
plotThePlot = 0;
if plotThePlot == 1
    plot(f,mx)
    hold on
    plot([0 100], [promThresh promThresh], 'r:')
    axis([0 5 0 inf])
end












