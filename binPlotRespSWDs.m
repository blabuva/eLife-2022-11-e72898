function binnedAlignedSWDs = binPlotRespSWDs(xlFile, alignedSWDs, maxFlankTime, binSize, binnedAlignedSWDs)
% 
% save('/home/mark/matlab_temp_variables/BINPLOTs') ;
% ccc
% load('/home/mark/matlab_temp_variables/BINPLOTs') ;
% keep xlFile alignedSWDs maxFlankTime binSize binnedAlignedSWDs
% close all
% clc


%% dump Path
dumpPath = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/AlignedPlethHistos/LoPass_4/';
binFolder = strcat(dumpPath, 'BinSize_', num2str(binSize),'min__','Flank_',num2str(maxFlankTime),'min/', xlFile.Experiment{1}, '/') ;

%% find unique rats
uniqueRats = unique(xlFile.Rat, 'stable') ;

%% loop through unique rats
for iUniqueRat = 1:length(uniqueRats)
   theRat = uniqueRats{iUniqueRat} ; 
   figDump = strcat(binFolder, theRat, '/') ;
   mkdir(figDump) ;
   for iTableRow = 1:size(xlFile,1)
       currentRow = xlFile(iTableRow, :) ;
%        theRat = 'rat_27e2a_20200707' ;
%        if strcmp(currentRow.Rat, theRat) == 1
           if strcmp(currentRow.Condition{1},'NoSWDs')==0
                binnedAlignedSWDs.(currentRow.Experiment{1}).(currentRow.Rat{1}).(currentRow.Condition{1}) = alignAplethCondition(currentRow, alignedSWDs, maxFlankTime, binSize, figDump) ;
           else
                binnedAlignedSWDs.(currentRow.Experiment{1}).(currentRow.Rat{1}) = alignAplethCondition(currentRow, alignedSWDs, maxFlankTime, binSize, figDump) ; 
           end
%        end
       clear currentRow
   end
end