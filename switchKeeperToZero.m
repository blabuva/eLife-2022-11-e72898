function binnedAlignedSWDs = switchKeeperToZero(binnedAlignedSWDs, experimentsMAT) 


for iExperiment = 1:length(experimentsMAT)
   rats = fieldnames(binnedAlignedSWDs.(experimentsMAT{iExperiment})) ;     
   for iRat = 1:length(rats)
        if strcmp(binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}), 'noSWDs') == 0
            conditions = fieldnames(binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat})) ;
            for iCondition = 1:length(conditions)
                binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}).(conditions{iCondition}).keeper = 0 ;
            end
            clear conditions ;       
        end
   end
   clear rats ; 
end
