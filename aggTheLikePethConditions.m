function ALL_BINNED = aggTheLikePethConditions(currentExperiment) 

% save('/home/mark/matlab_temp_variables/aggs') ;
% ccc
% load('/home/mark/matlab_temp_variables/aggs') ;

%%
rats = fieldnames(currentExperiment) ;

%% collect all condition names
con = 1;
for iRat = 1:length(rats)
   conditions = fieldnames(currentExperiment.(rats{iRat})) ;
   for iCondition = 1:length(conditions)
        allConditions{con,1} = conditions{iCondition} ;
        con = con + 1;
   end
end

%% find uniques
uniqueCondition = unique(allConditions) ;

%% agg
for iUnique = 1:length(uniqueCondition)
    iJumper = 1 ;
    for iRat = 1:length(rats)
       conditions =  fieldnames(currentExperiment.(rats{iRat})) ;
       for iCondition = 1:length(conditions)
          if strcmp(uniqueCondition{iUnique}, conditions{iCondition}) == 1
              ALL_BINNED.(uniqueCondition{iUnique}).bins(iJumper,:) = mean(currentExperiment.(rats{iRat}).(conditions{iCondition}).individualBins,1) ;
              ALL_BINNED.(uniqueCondition{iUnique}).(rats{iRat}).conditions = currentExperiment.(rats{iRat}).(conditions{iCondition}).conditionsIncluded ;
                
              
              ALL_BINNED.(uniqueCondition{iUnique}).swdDurations(iJumper,:) = nanmean(currentExperiment.(rats{iRat}).(conditions{iCondition}).SWDduration, 1) ;
              ALL_BINNED.(uniqueCondition{iUnique}).swdFreqs(iJumper,:) = nanmean(currentExperiment.(rats{iRat}).(conditions{iCondition}).SWDfreq, 1) ;
              
              theResps = currentExperiment.(rats{iRat}).(conditions{iCondition}).resp.FFT ;
              
              
              if length(theResps) > 1 
                 for iResps = 1:length(theResps)
                     if iResps ==1
                        allLengths = cellfun(@length, theResps);
                        respArray = NaN(length(theResps), max(allLengths));  
                        respArray(1,1:length(theResps{1})) = theResps{1} ;
                     else
                        respArray(iResps,1:length(theResps{iResps})) = theResps{iResps} ;
                     end
                 end
                 ALL_BINNED.(uniqueCondition{iUnique}).resps(iJumper,:) = mean(respArray,1) ;
              else
                 ALL_BINNED.(uniqueCondition{iUnique}).resps(iJumper,:) = theResps{1} ; 
              end
              
              iJumper = iJumper + 1;
          end
       end
    end
end