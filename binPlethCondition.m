function [binned] = binPlethConditiont(theCounts, ratInfo, maxFlankTime, binSize, binnedAlignedSWDs, binFolder) 
% 

% 
% save('/home/mark/matlab_temp_variables/BINPLOT2s') ;
% ccc
% load('/home/mark/matlab_temp_variables/BINPLOT2s') ;

%% turn off warning
warning('off', 'all') ;

%% suppress figure display
set(0,'DefaultFigureVisible','off') ;

%% display progress
disp2 = sprintf('\t\t%s', ratInfo.condition) ;
disp(disp2)

%% define dump folder
dumpFolder = strcat(binFolder, ratInfo.ratID, '/') ;
mkdir(dumpFolder) ;

%% define dumpFile
dumpFile = strcat(dumpFolder, ratInfo.condition) ;

%% grab the data
plethTraces = theCounts.alignedTraces.resp ;
allTraces = theCounts.alignedTraces.all.traces ;

%% grab the SWD starts
swdStartsAll = theCounts.SWDtable.SWD_Starts__alignedTime_min ;

%% only grab those SWDs within flank time
swdStarts = swdStartsAll(find(swdStartsAll >= -maxFlankTime & swdStartsAll <= maxFlankTime)) ;

%% get the durations and frequencies of relevant SWDs...SWDs within the flanks, split in the two conditions
relevantSWDs = theCounts.SWDtable(find(swdStartsAll >= -maxFlankTime & swdStartsAll <= maxFlankTime), :) ;
if isempty(relevantSWDs) == 0 
    controlCondition = relevantSWDs.Condition{1} ;
    allControlIDX = find(strcmp(controlCondition, relevantSWDs.Condition)) ;
    allManipConditionIDX = allControlIDX(end)+1 : size(relevantSWDs,1) ;
    % durations:
    binned.swdProps.durations.mean = [mean(cell2mat(relevantSWDs.TrueDuration(allControlIDX))), mean(cell2mat(relevantSWDs.TrueDuration(allManipConditionIDX)))] ;
    binned.swdProps.durations.stdev = [std(cell2mat(relevantSWDs.TrueDuration(allControlIDX))), std(cell2mat(relevantSWDs.TrueDuration(allManipConditionIDX)))] ;
    % frequencies
    binned.swdProps.freq.mean = [mean(cell2mat(relevantSWDs.MajorFFTfreq(allControlIDX))), mean(cell2mat(relevantSWDs.TrueDuration(allManipConditionIDX)))] ;
    binned.swdProps.freq.stdev = [std(cell2mat(relevantSWDs.MajorFFTfreq(allControlIDX))), std(cell2mat(relevantSWDs.TrueDuration(allManipConditionIDX)))] ;
else
    binned.swdProps.durations.mean = [nan, nan] ;
    binned.swdProps.durations.stdev = [nan, nan] ;
    % frequencies
    binned.swdProps.freq.mean = [nan, nan] ;
    binned.swdProps.freq.stdev = [nan, nan] ;
end
% uniqueConditions = unique(relevantSWDs.Condition) ;
% for iUniqueCondition = 1:size(uniqueConditions, 1)
%     conditionIDX = find(strcmp(uniqueConditions{iUniqueCondition}, relevantSWDs.Condition)) ;
%     binned.swdProps.(uniqueConditions{iUniqueCondition}).durations = relevantSWDs.TrueDuration(conditionIDX) ;
%     binned.swdProps.(uniqueConditions{iUniqueCondition}).freqs = relevantSWDs.MajorFFTfreq(conditionIDX) ;
%     clear conditionIDX
% end

%% make bin edges
OneSideEdges = [0:binSize:maxFlankTime] ;
theEdges = [-(fliplr(OneSideEdges)), OneSideEdges(2:end)] ;

subplot(4,1,1:2)
        %% make histogram
        h = histogram(swdStarts, theEdges, 'FaceColor', 'r') ;
        hold on

        %% add info to histogram
        plot([0 0], [0 max(h.Values)+1], 'k--', 'linewidth', 2)
        axis([-inf inf 0 max(h.Values)+1])
        title(ratInfo.condition, 'Interpreter', 'none')
        ylabel('# of SWDs')
        uniqueConditions = unique(theCounts.SWDtable.Condition, 'stable') ;
        text(min(theEdges)+1, max(h.Values)+0.5, uniqueConditions{1}, 'Interpreter', 'none')
        text(1, max(h.Values)+0.5, uniqueConditions{2}, 'Interpreter', 'none')

        %% gather the bin data
        binned.Values = h.Values ;
        binned.Edges = h.BinEdges ;
        binned.binSize = h.BinWidth ;
subplot(4,1,3)
        if ~isempty(plethTraces.traces)
            noNanPleth = plethTraces.traces(:,1) ;
            noNanPleth(noNanPleth==-5) = NaN;
            timeZeroIDX = find(plethTraces.timeC.aligned >= 0,1) ;
            plot(plethTraces.timeC.aligned, noNanPleth)
            
            binned.pleth.fft.timeC = plethTraces.timeC.aligned ;
            binned.pleth.fft.respRate = noNanPleth ;
            
            hold on
            plot([min(plethTraces.timeC.aligned), max(plethTraces.timeC.aligned)], [nanmean(noNanPleth(1:timeZeroIDX)), nanmean(noNanPleth(1:timeZeroIDX))], 'r:')     
            plot([0 0], [0, max(plethTraces.traces(:,1))],  'k--', 'linewidth', 2)
            axis([min(plethTraces.timeC.aligned), max(plethTraces.timeC.aligned), 0, inf])
            ylabel('Rate (Hz)')
            title('Resp Rate According to FFT')
            clear noNanPleth
        end
        
subplot(4,1,4)
        if ~isempty(plethTraces.traces)
            noNanPleth = plethTraces.traces(:,2) ;
            noNanPleth(noNanPleth==-5) = NaN;
            plot(plethTraces.timeC.aligned, plethTraces.traces(:,2))  
            hold on
            plot([min(plethTraces.timeC.aligned), max(plethTraces.timeC.aligned)], [nanmean(noNanPleth(1:timeZeroIDX)), nanmean(noNanPleth(1:timeZeroIDX))], 'r:')     
            plot([0 0], [0, max(plethTraces.traces(:,1))],  'k--', 'linewidth', 2)
            axis([min(plethTraces.timeC.aligned), max(plethTraces.timeC.aligned), 0, inf])
            ylabel('Rate (Hz)')
            title('Resp Rate According to Peak-to-Peak')
        end
        
 %% make aligned txt file for pClamp
numChans = num2str(size(allTraces,2)) ;
dlmwrite(strcat(dumpFolder, ratInfo.condition,'_textFile__', numChans, 'chans__conditionStart_', num2str(theCounts.conditionStart), '.txt'), allTraces) ;

    
%% save plot
% print(dumpFile, '-dpng')
close all

set(0,'DefaultFigureVisible','on')







