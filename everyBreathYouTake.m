%% clear all
ccc

%% path to master excel file
xlFile = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/Pleth_Experiments_Master_KAS.xlsx' ;

%% read excel file
excelData = readtable(xlFile) ;

%% loopsy through excel file
for iRow = 1:size(excelData,1)
   disp(strcat(num2str(100*iRow/size(excelData,1)), '% Done'))
   currentRow = excelData(iRow,:) ;
   if strcmp(currentRow.Analyze_Y_N_, 'Y') == 1
       metaData = getRelevantPlethFileInfo(currentRow) ;
       winSize = 10 ; % size of window (sec) to calculate sliding resp FFT
       breathInBreathOut(metaData, winSize) ;
   end    
end

% organizeTheBreaths
