function popBinned = aggTheYs(binnedAlignedSWDs, experimentsMAT) 

% save('/home/mark/matlab_temp_variables/aggyagg') ;
% ccc
% load('/home/mark/matlab_temp_variables/aggyagg');

buggy = 1 ;
for iExperiment = 1:length(experimentsMAT)
   rats = fieldnames(binnedAlignedSWDs.(experimentsMAT{iExperiment})) ;     
   for iRat = 1:length(rats)
        if strcmp(binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}), 'noSWDs') == 0
            conditions = fieldnames(binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat})) ;
            for iCondition = 1:length(conditions)
                mainConditions{iCondition,1} = conditions{iCondition}(1:end-2) ;
            end
            
            uniqueMainConditions = unique(mainConditions) ;
               
            for iMainCondition = 1:length(uniqueMainConditions)
                    iJumper = 1 ;
                    for iCondition = 1:length(conditions) 
                        if strcmp(uniqueMainConditions{iMainCondition}, conditions{iCondition}(1:end-2)) == 1 
                            
                             if binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}).(conditions{iCondition}).keeper == 1 
                                 if isfield(binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}).(conditions{iCondition}), 'Values')
                                     if buggy ~= 12 && buggy ~=19 && buggy ~=25 && buggy ~=29 && buggy ~=35
%                                         x=1  ; 
                                     
                                     popBinned.(experimentsMAT{iExperiment}).(rats{iRat}).(uniqueMainConditions{iMainCondition}).individualBins(iJumper,:) = binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}).(conditions{iCondition}).Values ;
                                     popBinned.(experimentsMAT{iExperiment}).(rats{iRat}).(uniqueMainConditions{iMainCondition}).conditionsIncluded{iJumper,1} = conditions{iCondition} ;
                                     popBinned.(experimentsMAT{iExperiment}).(rats{iRat}).(uniqueMainConditions{iMainCondition}).resp.FFT{iJumper,1} = binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}).(conditions{iCondition}).pleth.fft.respRate ;
                                     popBinned.(experimentsMAT{iExperiment}).(rats{iRat}).(uniqueMainConditions{iMainCondition}).resp.timeC{iJumper,1} = binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}).(conditions{iCondition}).pleth.fft.timeC ;
                                     popBinned.(experimentsMAT{iExperiment}).(rats{iRat}).(uniqueMainConditions{iMainCondition}).SWDduration(iJumper,:) = binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}).(conditions{iCondition}).swdProps.durations.mean ;
                                     popBinned.(experimentsMAT{iExperiment}).(rats{iRat}).(uniqueMainConditions{iMainCondition}).SWDfreq(iJumper,:) = binnedAlignedSWDs.(experimentsMAT{iExperiment}).(rats{iRat}).(conditions{iCondition}).swdProps.freq.mean ;
                                     
                                     end
                                     iJumper = iJumper + 1;
                                     buggy = buggy +1 ;
                                 end
                            end              
                        end
                    end
            end               
        end
        clear conditions allBins uniqueMainConditions;  
   end
   clear rats ; 
end