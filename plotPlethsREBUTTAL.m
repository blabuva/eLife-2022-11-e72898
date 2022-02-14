% function comboed = plotPleths(uniqueConditions, comboed) 

% save('/home/mark/matlab_temp_variables/plotPLETHS') ;
ccc
load('/home/mark/matlab_temp_variables/plotPLETHS') ;

stackedColors = makeMeSomeStackedColors() ;


for iUnique = 2 %1:length(uniqueConditions)
    
    disp(strcat(num2str(iUnique),'of',num2str(length(uniqueConditions)))) 

    %% SWD stacked histo
    subplot(4,6,[1,2,7,8,13,14])
     h1 = bar(comboed.(uniqueConditions{iUnique}).bins', 'stacked') ;
     for iBar = 1:length(h1)
        set(h1(iBar), 'FaceColor', stackedColors(iBar,:)) ;
     end
        
    hold on
    plot([5.5, 5.5], [0, max(sum(comboed.(uniqueConditions{iUnique}).bins,1))+1], 'r:', 'linewidth', 2) 
    title(uniqueConditions{iUnique}, 'interpreter', 'none')
    ylim([0 30]);
    ylabel('# SWSs', 'fontsize', 14)  
        
    %% SWD Chev 
    subplot(4,6,[3,4,9,10,15,16])
        controlSum = mean(comboed.(uniqueConditions{iUnique}).bins(:,1:5),2) ;
        manipSum = mean(comboed.(uniqueConditions{iUnique}).bins(:,6:10),2) ;
        
        for iChev = 1:length(controlSum)
            face = plot([1, 2], [controlSum(iChev), manipSum(iChev)], 'o-', 'markersize', 8, 'linewidth', 2);             
            face.MarkerFaceColor = stackedColors(iChev,:) ;
            face.MarkerEdgeColor = stackedColors(iChev,:) ;
            face.Color = stackedColors(iChev,:) ;
             hold on 
        end
        
        [x,pValTtest] = ttest(controlSum, manipSum) ;
        title(sprintf('p = %.5f', pValTtest)) ; clear pValTtest ;
        
        axis([0.5 2.5 0 max([controlSum; manipSum])+0.2])
        ylabel('# SWSs', 'fontsize', 14) 
        
    %% Resp Traces
    subplot(4,6,[19,20])
        resps = comboed.(uniqueConditions{iUnique}).resps ;
        timeC = (make_time_column(200, length(resps), 'rate')/60)-15 ;
        halfTimeC = length(timeC)/2 ;
        close all
        for iResp = 1:size(resps,1)
%            if iResp < 6
%                spNum = 1 ;
%            else
%                spNum = 2 ;
%            end
           subplot(size(resps,1)/2,2, iResp)
            plot(timeC, resps(iResp,:), 'Color',  stackedColors(iResp,:), 'linewidth', 2) 
            axis([-15 15 -inf inf])
            
           respMeans(iResp,1) = nanmean(resps(iResp,1:halfTimeC)) ;
           respMeans(iResp,2) = nanmean(resps(iResp,halfTimeC:end)) ;
%            hold on
        end
        
        plot([0,0], [0,max(max(resps))], 'r:') ;
        axis([-15 15 0 inf])
        xticks([-15:5:15])
        
        ylabel('Resp (Hz)', 'fontsize', 14) 
        
 %% make confplot for resp rate   
 subplot(4,6,[21, 22])  
     resps = comboed.(uniqueConditions{iUnique}).resps ;
    meanResps = nanmean(resps,1) ;
    stdResps = nanstd(resps,1) ;
    timeC = (make_time_column(200, length(resps), 'rate')/60)-15 ;
    halfTimeC = length(timeC)/2 ;     

    smoothVal = 50 ;
    meanRespsReduce = smooth(decimate(meanResps, 100), smoothVal) ;
    stdRespsReduce = smooth(decimate(stdResps, 100),smoothVal) ;
    timeCreduce = decimate(timeC, 100) ;

    xconf = [timeCreduce; timeCreduce(end:-1:1)] ;
    yconf = [[meanRespsReduce+stdRespsReduce]', [meanRespsReduce(end:-1:1)-stdRespsReduce(end:-1:1)]']'; 

    fill(xconf, yconf, rgb('salmon'))
    hold on        
    plot(timeCreduce, meanRespsReduce ,'k') ;


    plot([0,0], [min(meanRespsReduce),max(meanRespsReduce)], 'r:') ;
    axis([-15 15 -inf inf])
    xticks([-15:5:15])

    ylabel('Resp (Hz)', 'fontsize', 14)           
        
        
     
    %% Resp Chev    
    subplot(4,6,[5,6,11,12,17,18])
     
        for iChev = 1:size(respMeans,1)
            face = plot([1, 2], [respMeans(iChev,1), respMeans(iChev,2)], 'o-', 'markersize', 8, 'linewidth', 2);             
            face.MarkerFaceColor = stackedColors(iChev,:) ;
            face.MarkerEdgeColor = stackedColors(iChev,:) ;
            face.Color = stackedColors(iChev,:) ;
             hold on 
        end
        axis([0.5 2.5 min(min(respMeans))-0.1 max(max(respMeans))+0.1])
        ylabel('Resp (Hz)', 'fontsize', 14) 
        
        [x,pValTtest] = ttest(respMeans(:,1), respMeans(:,2)) ;
        title(sprintf('p = %.5f', pValTtest)) ; clear pValTtest ;
    
    %% legend    
    subplot(4,6,[23, 24])
        for iChev = 1:length(controlSum)
            face = plot([1, 2], [-2, -2], 'o-', 'markersize', 8, 'linewidth', 2) ;
            face.MarkerFaceColor = stackedColors(iChev,:) ;
            face.MarkerEdgeColor = stackedColors(iChev,:) ;
            face.Color = stackedColors(iChev,:) ;
            hold on 
        end
          
        theLeg = comboed.(uniqueConditions{iUnique}).rats ;
        legend(theLeg, 'interpreter', 'none', 'location', 'northeast')
        axis([0.5 2.5 0 max([controlSum; manipSum])+1])       
        set(gca,'Color', 'none', 'XColor', 'none', 'YColor', 'none')
       
        
    set(gcf, 'units', 'normalized', 'position', [0.01 0.1 0.3 0.8])    
    
    make_my_figure_fit_HW(10, 20) ;
        
    print(strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/elHistos/WITH_RESP/', uniqueConditions{iUnique}), '-dpng')     
    print(strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/elHistos/WITH_RESP/', uniqueConditions{iUnique}), '-depsc', '-painters')  
    
    print(strcat('/media/katieX/Hyperventilation_Project/Pleth_Paper2021/figures/plethSWDrespEPS/', uniqueConditions{iUnique}), '-dpng')     
    print(strcat('/media/katieX/Hyperventilation_Project/Pleth_Paper2021/figures/plethSWDrespEPS/', uniqueConditions{iUnique}), '-depsc', '-painters')  
    
%     close all
    

    

%%
    
    chevNums(:,1) = controlSum ;
    chevNums(:,2) = manipSum ;
    
    swdDurations = comboed.(uniqueConditions{iUnique}).swdDurations ;
    swdFreqs = comboed.(uniqueConditions{iUnique}).swdFreqs ;
    
    chevTable = array2table([chevNums, respMeans, swdDurations, swdFreqs], 'VariableNames', {'ControlSWD', 'ManipulationSWD', 'ControlResp', 'ManipulationResp', 'ControlSWD_duration', 'ManipSWD_duration', 'ControlSWD_Freq', 'ManipSWD_Freq'}, 'RowNames', theLeg) ;
    
%     comboed.(uniqueConditions{iUnique}).stats.SWDcount.pVal_RANKSUM = ranksum(chevNums(:,1), chevNums(:,2)) ;
%     [x, comboed.(uniqueConditions{iUnique}).stats.SWDcount.pVal_tTest] = ttest(chevNums(:,1), chevNums(:,2)) ;
%     [comboed.(uniqueConditions{iUnique}).stats.SWDcount.normalityTest.normal, comboed.(uniqueConditions{iUnique}).stats.SWDcount.normalityTest.pVals] = test_normality({chevNums(:,1), chevNums(:,2)}) ;
    
    
    comboed.(uniqueConditions{iUnique}).stats.SWDcount.meanSE.control(1,1:2) = [nanmean(chevNums(:,1)), nanstd(chevNums(:,1))/(sqrt(size(chevNums,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.SWDcount.meanSE.manip(1,1:2) = [nanmean(chevNums(:,2)), nanstd(chevNums(:,2))/(sqrt(size(chevNums,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.SWDcount.sampleSize = size(chevNums,1) ;
    
%     comboed.(uniqueConditions{iUnique}).stats.resp.pVal_RANKSUM = ranksum(respMeans(:,1), respMeans(:,2)) ;
%     [x, comboed.(uniqueConditions{iUnique}).stats.resp.pVal_tTest] = ttest(respMeans(:,1), respMeans(:,2)) ;    
%     [comboed.(uniqueConditions{iUnique}).stats.resp.normalityTest.normal, comboed.(uniqueConditions{iUnique}).stats.resp.normalityTest.normal] = test_normality({respMeans(:,1), respMeans(:,2)}) ;
    
    comboed.(uniqueConditions{iUnique}).stats.resp.meanSE.control(1,1:2) = [nanmean(respMeans(:,1)), nanstd(respMeans(:,1))/(sqrt(size(respMeans,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.resp.meanSE.manip(1,1:2) = [nanmean(respMeans(:,2)), nanstd(respMeans(:,2))/(sqrt(size(respMeans,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.resp.sampleSize = size(respMeans,1) ;
    
    comboed.(uniqueConditions{iUnique}).stats.SWDduration.meanSE.control = [nanmean(swdDurations(:,1)), nanstd(swdDurations(:,1))/(sqrt(size(swdDurations,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.SWDduration.meanSE.manip = [nanmean(swdDurations(:,2)), nanstd(swdDurations(:,2))/(sqrt(size(swdDurations,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.SWDduration.sampleSize = size(swdDurations,1) ;
    comboed.(uniqueConditions{iUnique}).stats.SWDduration.pVal.rankSum = ranksum(swdDurations(:,1), swdDurations(:,2)) ;
    [h, comboed.(uniqueConditions{iUnique}).stats.SWDduration.pVal.tTestPaired] = ttest(swdDurations(:,1), swdDurations(:,2)) ;
    
    [comboed.(uniqueConditions{iUnique}).stats.SWDduration.normalityTest.normal, ...
        comboed.(uniqueConditions{iUnique}).stats.SWDduration.normalityTest.pTable]= test_normality(swdDurations) ;
    
    comboed.(uniqueConditions{iUnique}).stats.SWDfreq.meanSE.control = [nanmean(swdFreqs(:,1)), nanstd(swdFreqs(:,1))/(sqrt(size(swdFreqs,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.SWDfreq.meanSE.manip = [nanmean(swdFreqs(:,2)), nanstd(swdFreqs(:,2))/(sqrt(size(swdFreqs,1)))] ;   
    comboed.(uniqueConditions{iUnique}).stats.SWDduration.sampleSize = size(swdFreqs,1) ;
    comboed.(uniqueConditions{iUnique}).stats.SWDfreq.pVal.rankSum = ranksum(swdFreqs(:,1), swdFreqs(:,2)) ;
    [h, comboed.(uniqueConditions{iUnique}).stats.SWDfreq.pVal.tTestPaired] = ttest(swdFreqs(:,1), swdFreqs(:,2)) ;   
    
    [comboed.(uniqueConditions{iUnique}).stats.SWDfreq.normalityTest.normal, ...
        comboed.(uniqueConditions{iUnique}).stats.SWDfreq.normalityTest.pTable]= test_normality(swdFreqs) ;
    
    comboed.(uniqueConditions{iUnique}).chevTable = chevTable ;     
        
    clear controlSum manipSum theLeg chevNums chevTable respMeans swdDurations swdFreqs h
    close all

end

