function binnedAlignedSWDs = switchSomeKeepersToOne(binnedAlignedSWDs, xlKeepers, experimentsXL) ;

for iExperiment = 1:length(experimentsXL)
   xlTable = xlKeepers.(experimentsXL{iExperiment}) ;
   for iRow = 1:size(xlTable,1)
       currentRow = xlKeepers.(experimentsXL{iExperiment})(iRow,:) ;
       if strcmp('Y', currentRow.Keep_Y_N_) == 1
           currentExperiment = currentRow.Experiment{1} ;
           currentRat = currentRow.Rat{1} ;
           currentCondition = currentRow.Condition{1} ;
           if strcmp(binnedAlignedSWDs.(currentExperiment).(currentRat), 'noSWDs') == 0
               binnedAlignedSWDs.(currentExperiment).(currentRat).(currentCondition).keeper = 1; 
           end
       end
       clear currentRow
   end
   clear xlTable
end