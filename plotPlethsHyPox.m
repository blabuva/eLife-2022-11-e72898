% function comboed = plotPlethsHyPox(uniqueConditions, comboed) 

% save('/home/mark/matlab_temp_variables/PLOTHYP')
ccc
load('/home/mark/matlab_temp_variables/PLOTHYP')

stackedColors = makeMeSomeStackedColors() ;

%% %%%%%%%%%%%%%%%%%
for iUnique = 1 
    animalTemp1 = fieldnames(comboed.(uniqueConditions{iUnique})) ;
    animalTemp2 = animalTemp1(find(strcmp('bins', animalTemp1)==0)) ;
    animalTemp3 = animalTemp2(find(strcmp('swdDurations', animalTemp2)==0)) ;
    animalTemp4 = animalTemp3(find(strcmp('swdFreqs', animalTemp3)==0)) ;
    
    rats = animalTemp4(find(strcmp('resps', animalTemp4)==0)) ;
    
    % plot SWD histograms: 
    subplot(4,12,[1,2,13,14,25,26])
        h1 = bar(comboed.(uniqueConditions{iUnique}).bins', 'stacked') ;
        for iBar = 1:length(h1)
            set(h1(iBar), 'FaceColor', stackedColors(iBar,:)) ;
        end
        
        hold on
        plot([5.5, 5.5], [0, max(sum(comboed.(uniqueConditions{iUnique}).bins,1))+1], 'r:', 'linewidth', 2) 
        ylim([0 30]);
        title(uniqueConditions{iUnique}, 'interpreter', 'none')
     
     % plot SWD chevs:
     subplot(4,12,[3,4,15,16,27,28])
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
        axis([0.5 2.5 0 2.5])
    
    % plot legend (only, but in it's own subplot):
    subplot(4,12,[41,42])
        for iChev = 1:length(controlSum)
            face = plot([1, 2], [-2, -2], 'o-', 'markersize', 8, 'linewidth', 2) ;
            face.MarkerFaceColor = stackedColors(iChev,:) ;
            face.MarkerEdgeColor = stackedColors(iChev,:) ;
            face.Color = stackedColors(iChev,:) ;
            hold on 
        end
        theLeg = rats ;
        legend(theLeg, 'interpreter', 'none', 'location', 'northeast')
        axis([0.5 2.5 0 max([controlSum; manipSum])+1])       
        set(gca,'Color', 'none', 'XColor', 'none', 'YColor', 'none')
        
    % Resp Traces
    subplot(4,12,[37, 38])
        resps = comboed.(uniqueConditions{iUnique}).resps ;
        timeC = (make_time_column(200, length(resps), 'rate')/60)-15 ;
        halfTimeC = length(timeC)/2 ;
        for iResp = 1:size(resps,1)
           plot(timeC, resps(iResp,:), 'Color',  stackedColors(iResp,:), 'linewidth', 2) 
           respMeans(iResp,1) = nanmean(resps(iResp,1:halfTimeC)) ;
           respMeans(iResp,2) = nanmean(resps(iResp,halfTimeC:end)) ;
           hold on
        end
        plot([0,0], [0,max(max(resps))], 'r:') ;
        axis([-15 15 0 inf])
        xticks([-15:5:15])
        
        ylabel('Resp (Hz)', 'fontsize', 14) 
        
        
        
    % Mean Resp Traces
    subplot(4,12,[39, 40])
        meanRespTrace = nanmean(resps,1) ;
        stdevRespTrace = nanstd(resps,1) ;
        
        smoothVal = 50 ;
        meanRespsReduce = smooth(decimate(meanRespTrace, 100), smoothVal) ;
        stdRespsReduce = smooth(decimate(stdevRespTrace, 100),smoothVal) ;
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
        
        
        
        
    % Resp Chevs    
    subplot(4,12,[5,6,17,18, 29, 30])
     
        for iChev = 1:size(respMeans,1)
            face = plot([1, 2], [respMeans(iChev,1), respMeans(iChev,2)], 'o-', 'markersize', 8, 'linewidth', 2);             
            face.MarkerFaceColor = stackedColors(iChev,:) ;
            face.MarkerEdgeColor = stackedColors(iChev,:) ;
            face.Color = stackedColors(iChev,:) ;
             hold on 
        end
        axis([0.5 2.5 0.8 2.4])
        ylabel('Resp (Hz)', 'fontsize', 14) 
        
        [x,pValTtest] = ttest(respMeans(:,1), respMeans(:,2)) ;
        title(sprintf('p = %.5f', pValTtest)) ; clear pValTtest ;
        
end

    chevNums(:,1) = controlSum ;
    chevNums(:,2) = manipSum ;
    chevTable = array2table(chevNums, 'VariableNames', {'Control', 'Manipulation'}, 'RowNames', theLeg) ;
    respTable = array2table(respMeans, 'VariableNames', {'Control', 'Manipulation'}, 'RowNames', theLeg) ;
    
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
    
    
    comboed.(uniqueConditions{iUnique}).hypox_chevTable = chevTable ; 
    comboed.(uniqueConditions{iUnique}).resp_chevTable = respTable ; 
    
clear animalTemp1 rats controlSum manipSum chevNums chevTable meanRespTrace stdevRespTrace meanRespsReduce stdRespsReduce timeCreduce xConf yConf

%% %%%%%%%%%%%%%%%%%%%%%%
for iUnique = 2 
    animalTemp1 = fieldnames(comboed.(uniqueConditions{iUnique})) ;
    animalTemp2 = animalTemp1(find(strcmp('bins', animalTemp1)==0)) ;
    animalTemp3 = animalTemp2(find(strcmp('swdDurations', animalTemp2)==0)) ;
    animalTemp4 = animalTemp3(find(strcmp('swdFreqs', animalTemp3)==0)) ;
    
    rats = animalTemp4(find(strcmp('resps', animalTemp4)==0)) ;
    
    
    
    % plot SWD histos
    subplot(4,12,[7,8,19,20,31,32])
        h2 = bar(comboed.(uniqueConditions{iUnique}).bins', 'stacked') ;
        for iBar = 1:length(h1)
            set(h2(iBar), 'FaceColor', stackedColors(iBar,:)) ;
        end
        
        hold on
        plot([5.5, 5.5], [0, max(sum(comboed.(uniqueConditions{iUnique}).bins,1))+1], 'r:', 'linewidth', 2) 
        ylim([0 30]);
        title(uniqueConditions{iUnique}, 'interpreter', 'none')
    
    % plot SWD chevs
    subplot(4,12,[9,10,21,22,33,34])
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
        axis([0.5 2.5 0 2.5])
     
    % plot the legend (just the legend)
    subplot(4,12,[47, 48])
        for iChev = 1:length(controlSum)
            face = plot([1, 2], [-2, -2], 'o-', 'markersize', 8, 'linewidth', 2);
            face.MarkerFaceColor = stackedColors(iChev,:) ;
            face.MarkerEdgeColor = stackedColors(iChev,:) ;
            face.Color = stackedColors(iChev,:) ;
            hold on 
        end
        theLeg = rats ;
        legend(theLeg, 'interpreter', 'none', 'location', 'northeast')
        axis([0.5 2.5 0 max([controlSum; manipSum])+1])       
        set(gca,'Color', 'none', 'XColor', 'none', 'YColor', 'none')
        
        
    % Resp Traces
    subplot(4,12,[43, 44])
        resps = comboed.(uniqueConditions{iUnique}).resps ;
        timeC = (make_time_column(200, length(resps), 'rate')/60)-15 ;
        halfTimeC = length(timeC)/2 ;
        for iResp = 1:size(resps,1)
           plot(timeC, resps(iResp,:), 'Color',  stackedColors(iResp,:), 'linewidth', 2) 
           respMeans(iResp,1) = nanmean(resps(iResp,1:halfTimeC)) ;
           respMeans(iResp,2) = nanmean(resps(iResp,halfTimeC:end)) ;
           hold on
        end
        plot([0,0], [0,max(max(resps))], 'r:') ;
        axis([-15 15 0 inf])
        xticks([-15:5:15])
        
        ylabel('Resp (Hz)', 'fontsize', 14) 
        
        
        
% Mean Resp Traces
    subplot(4,12,[45, 46])
        meanRespTrace = nanmean(resps,1) ;
        stdevRespTrace = nanstd(resps,1) ;
        
        smoothVal = 50 ;
        meanRespsReduce = smooth(decimate(meanRespTrace, 100), smoothVal) ;
        stdRespsReduce = smooth(decimate(stdevRespTrace, 100),smoothVal) ;
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
        
        
        
        
        
        
        
        
    % Resp Chevs    
    subplot(4,12,[11,12,23,24,35,36])
     
        for iChev = 1:size(respMeans,1)
            face = plot([1, 2], [respMeans(iChev,1), respMeans(iChev,2)], 'o-', 'markersize', 8, 'linewidth', 2);             
            face.MarkerFaceColor = stackedColors(iChev,:) ;
            face.MarkerEdgeColor = stackedColors(iChev,:) ;
            face.Color = stackedColors(iChev,:) ;
             hold on 
        end
        axis([0.5 2.5 0.8 2.4])
        ylabel('Resp (Hz)', 'fontsize', 14) 
        
        [x,pValTtest] = ttest(respMeans(:,1), respMeans(:,2)) ;
        title(sprintf('p = %.5f', pValTtest)) ; clear pValTtest ;   
        
        
        
        
        
    chevNums(:,1) = controlSum ;
    chevNums(:,2) = manipSum ;
    chevTable = array2table(chevNums, 'VariableNames', {'Control', 'Manipulation'}, 'RowNames', theLeg) ;
    respTable = array2table(respMeans, 'VariableNames', {'Control', 'Manipulation'}, 'RowNames', theLeg) ;
    
%     comboed.(uniqueConditions{iUnique}).stats.SWDcount.pVal_RANKSUM = ranksum(chevNums(:,1), chevNums(:,2)) ;
%     [x, comboed.(uniqueConditions{iUnique}).stats.SWDcount.pVal_tTest] = ttest(chevNums(:,1), chevNums(:,2)) ;
%     [comboed.(uniqueConditions{iUnique}).stats.SWDcount.normalityTest.normal, comboed.(uniqueConditions{iUnique}).stats.SWDcount.normalityTest.pVals] = test_normality({chevNums(:,1), chevNums(:,2)}) ;
    
    comboed.(uniqueConditions{iUnique}).stats.SWDcount.meanSE.control(1,1:2) = [nanmean(chevNums(:,1)), nanstd(chevNums(:,1))/(sqrt(size(chevNums,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.SWDcount.meanSE.manip(1,1:2) = [nanmean(chevNums(:,2)), nanstd(chevNums(:,2))/(sqrt(size(chevNums,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.SWDcount.sampleSize = size(chevNums,1) ;
%     
%     comboed.(uniqueConditions{iUnique}).stats.resp.pVal_RANKSUM = ranksum(respMeans(:,1), respMeans(:,2)) ;
%     [x, comboed.(uniqueConditions{iUnique}).stats.resp.pVal_tTest] = ttest(respMeans(:,1), respMeans(:,2)) ;    
%     [comboed.(uniqueConditions{iUnique}).stats.resp.normalityTest.normal, comboed.(uniqueConditions{iUnique}).stats.resp.normalityTest.normal] = test_normality({respMeans(:,1), respMeans(:,2)}) ;
    
    comboed.(uniqueConditions{iUnique}).stats.resp.meanSE.control(1,1:2) = [nanmean(respMeans(:,1)), nanstd(respMeans(:,1))/(sqrt(size(respMeans,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.resp.meanSE.manip(1,1:2) = [nanmean(respMeans(:,2)), nanstd(respMeans(:,2))/(sqrt(size(respMeans,1)))] ;
    comboed.(uniqueConditions{iUnique}).stats.resp.sampleSize = size(respMeans,1) ;
    
    
    
    
    
    
    comboed.(uniqueConditions{iUnique}).hypoxHyper_chevTable = chevTable ; 
    comboed.(uniqueConditions{iUnique}).resp_chevTable = respTable ; 
        
        clear animalTemp1 rats controlSum manipSum;
end
        
        

    set(gcf, 'units', 'normalized', 'position', [0.4 0.3 0.3 0.4])    
    
    make_my_figure_fit_HW(10, 20) ;
        
    print(strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/elHistos/WITH_RESP/', uniqueConditions{iUnique},'__both'), '-dpng')     
    print(strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/elHistos/WITH_RESP/', uniqueConditions{iUnique},'__both'), '-depsc', '-painters')     
    
    print(strcat('/media/katieX/Hyperventilation_Project/Pleth_Paper2021/figures/plethSWDrespEPS/', uniqueConditions{iUnique},'__both'), '-dpng')     
    print(strcat('/media/katieX/Hyperventilation_Project/Pleth_Paper2021/figures/plethSWDrespEPS/', uniqueConditions{iUnique},'__both'), '-depsc', '-painters')  
        
        
        
    clear controlSum manipSum theLeg
%     close all


%% stats for hypoxia SWD durations:
comboed.hypoxia_10pct.stats.SWDduration.meanSE.control = [mean(comboed.hypoxia_10pct.swdDurations(:,1)), std(comboed.hypoxia_10pct.swdDurations(:,1))/(sqrt(size(comboed.hypoxia_10pct.swdDurations,1)))] ;
comboed.hypoxia_10pct.stats.SWDduration.meanSE.manip = [mean(comboed.hypoxia_10pct.swdDurations(:,2)), std(comboed.hypoxia_10pct.swdDurations(:,2))/(sqrt(size(comboed.hypoxia_10pct.swdDurations,1)))] ;

comboed.hypoxia_10pct.stats.SWDduration.sampleSize = size(comboed.hypoxia_10pct.swdDurations,1) ;
comboed.hypoxia_10pct.stats.SWDduration.pVal.rankSum = ranksum(comboed.hypoxia_10pct.swdDurations(:,1), comboed.hypoxia_10pct.swdDurations(:,2)) ;
[h, comboed.hypoxia_10pct.stats.SWDduration.pVal.tTestPaired] = ttest(comboed.hypoxia_10pct.swdDurations(:,1), comboed.hypoxia_10pct.swdDurations(:,2)) ;

[comboed.hypoxia_10pct.stats.SWDduration.normalityTest.normal, ...
    comboed.hypoxia_10pct.stats.SWDduration.normalityTest.pTable]= test_normality(comboed.hypoxia_10pct.swdDurations) ;
    

%% stats for hypoxia SWD frequencies:
comboed.hypoxia_10pct.stats.SWDfreq.meanSE.control = [mean(comboed.hypoxia_10pct.swdFreqs(:,1)), std(comboed.hypoxia_10pct.swdFreqs(:,1))/(sqrt(size(comboed.hypoxia_10pct.swdFreqs,1)))] ;
comboed.hypoxia_10pct.stats.SWDfreq.meanSE.manip = [mean(comboed.hypoxia_10pct.swdFreqs(:,2)), std(comboed.hypoxia_10pct.swdFreqs(:,2))/(sqrt(size(comboed.hypoxia_10pct.swdFreqs,1)))] ;

comboed.hypoxia_10pct.stats.SWDfreq.sampleSize = size(comboed.hypoxia_10pct.swdFreqs,1) ;
comboed.hypoxia_10pct.stats.SWDfreq.pVal.rankSum = ranksum(comboed.hypoxia_10pct.swdFreqs(:,1), comboed.hypoxia_10pct.swdFreqs(:,2)) ;
[h, comboed.hypoxia_10pct.stats.SWDfreq.pVal.tTestPaired] = ttest(comboed.hypoxia_10pct.swdFreqs(:,1), comboed.hypoxia_10pct.swdFreqs(:,2)) ;

[comboed.hypoxia_10pct.stats.SWDfreq.normalityTest.normal, ...
    comboed.hypoxia_10pct.stats.SWDfreq.normalityTest.pTable]= test_normality(comboed.hypoxia_10pct.swdFreqs) ;


%% stats for hypoxia-hypercap SWD durations:
comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDduration.meanSE.control = [mean(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations(:,1)), std(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations(:,1))/(sqrt(size(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations,1)))] ;
comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDduration.meanSE.manip = [mean(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations(:,2)), std(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations(:,2))/(sqrt(size(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations,1)))] ;

comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDduration.sampleSize = size(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations,1) ;
comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDduration.pVal.rankSum = ranksum(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations(:,1), comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations(:,2)) ;
[h, comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDduration.pVal.tTestPaired] = ttest(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations(:,1), comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations(:,2)) ;

[comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDduration.normalityTest.normal, ...
    comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDduration.normalityTest.pTable]= test_normality(comboed.hypoxic_10pct_hypercapnia_5pct.swdDurations) ;
    

%% stats for hypoxia-hypercap SWD frequencies:
comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDfreq.meanSE.control = [mean(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs(:,1)), std(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs(:,1))/(sqrt(size(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs,1)))] ;
comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDfreq.meanSE.manip = [mean(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs(:,2)), std(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs(:,2))/(sqrt(size(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs,1)))] ;

comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDfreq.sampleSize = size(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs,1) ;
comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDfreq.pVal.rankSum = ranksum(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs(:,1), comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs(:,2)) ;
[h, comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDfreq.pVal.tTestPaired] = ttest(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs(:,1), comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs(:,2)) ;

[comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDfreq.normalityTest.normal, ...
    comboed.hypoxic_10pct_hypercapnia_5pct.stats.SWDfreq.normalityTest.pTable]= test_normality(comboed.hypoxic_10pct_hypercapnia_5pct.swdFreqs) ;

