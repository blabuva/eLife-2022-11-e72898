function respRatesPeaks = respRateBasedOnPlethPeaks(winBreath, winTimeC, respRatesPeaks)

% save('/home/mark/matlab_temp_variables/respPeaks')
% ccc
% load('/home/mark/matlab_temp_variables/respPeaks')


%% invert the breath window and filter it using movmean
negWinBreath = -winBreath ;
filtBreath = movmean(negWinBreath, 20) ;

%% find max/min of negChunk
minBreath = min(filtBreath) ;
maxBreath = max(filtBreath) ;
thresh = mean([minBreath, maxBreath]) ;
threshBreath = filtBreath ;
threshBreath(find(filtBreath<thresh),1) = 0 ;

%% find peaks
[amps, idxs] = findpeaks(threshBreath) ; 
ampBreathPeaks = negWinBreath(idxs) ;
timeBreathPeaks = winTimeC(idxs) ;

%% get mean resp rate
respRate = ones(length(winBreath),1) * nanmean(diff(timeBreathPeaks)) ;
respRatesPeaks.timeSeries.period.windows = [respRatesPeaks.timeSeries.period.windows; respRate] ;
respRatesPeaks.timeSeries.period.breathTimes = [respRatesPeaks.timeSeries.period.breathTimes; timeBreathPeaks] ;

%% plot, if you want
plotIt = 0 ;
if plotIt == 1 
    subplot(2,1,1)
        plot(winTimeC, winBreath)

    subplot(2,1,2)
        plot(winTimeC, negWinBreath)
        hold on
        plot(winTimeC, ones(length(winTimeC))*thresh, 'r-')
        plot(timeBreathPeaks, ampBreathPeaks, 'ro')
        plot(winTimeC, filtBreath, 'c-')

    set(gcf, 'units', 'normalized', 'position', [0.7 0.3 0.2 0.4]) ;
end