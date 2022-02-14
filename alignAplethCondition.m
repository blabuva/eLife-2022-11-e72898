function binned = alignAplethCondition(currentRow, alignedSWDs, maxFlankTime, binSize, figDump) 
% 

% 
% save('/home/mark/matlab_temp_variables/BINPLOT2s') ;
% ccc
% load('/home/mark/matlab_temp_variables/BINPLOT2s') ;

% maxFlankTime = 10 ;

%% grab the data

% plethTraces = alignedSWDs.(currentRow.Experiment{1}).(currentRow.Rat{1}).(currentRow.Condition{1}).alignedTraces.resp ;


if ~isempty(alignedSWDs.(currentRow.Experiment{1}).(currentRow.Rat{1}))
    dataTable = alignedSWDs.(currentRow.Experiment{1}).(currentRow.Rat{1}).(currentRow.Condition{1}).SWDtable ;
    plethTraces = alignedSWDs.(currentRow.Experiment{1}).(currentRow.Rat{1}).(currentRow.Condition{1}).alignedTraces.resp ;
    allTraces = alignedSWDs.(currentRow.Experiment{1}).(currentRow.Rat{1}).(currentRow.Condition{1}).alignedTraces.all.traces ;
    conditionStart = alignedSWDs.(currentRow.Experiment{1}).(currentRow.Rat{1}).(currentRow.Condition{1}).conditionStart ;
    
    %% grab the SWD starts
    swdStartsAll = dataTable.SWD_Starts__alignedTime_min ;

    %% only grab those SWDs within flank time
    swdStarts = swdStartsAll(find(swdStartsAll >= -maxFlankTime & swdStartsAll <= maxFlankTime)) ;

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
        title({currentRow.Experiment{1}; currentRow.Rat{1}; currentRow.Condition{1}}, 'Interpreter', 'none')
        ylabel('# of SWDs')
        uniqueConditions = unique(dataTable.Condition, 'stable') ;
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
%     dlmwrite(strcat(figDump, currentRow.Condition{1},'_textFile__', numChans, 'chans__conditionStart_', '.txt'), allTraces) ;
    dlmwrite(strcat(figDump, currentRow.Condition{1},'_textFile__', numChans, 'chans__conditionStart_', num2str(conditionStart), '.txt'), allTraces) ;
else
    subplot(4,1,1:4)
        plot(0,0)
        title({currentRow.Experiment{1}; currentRow.Rat{1}; 'No SWDs'}, 'Interpreter', 'none')
        binned.Values = 0 ;
        binned.Edges = 0 ;
        binned.binSize = 0 ;
        binned.pleth.fft.timeC = 0 ;
        binned.pleth.fft.respRate = 0 ;
        currentRow.Condition = {'NoSWDs'} ;
end
    
%% save plot
print(strcat(figDump, currentRow.Condition{1}), '-dpng')
close all









