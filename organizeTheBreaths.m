%% clear all
ccc
warning('off', 'all') ;

%% path to master excel file
xlFile = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/Pleth_Experiments_Master_KAS.xlsx' ;

%% read excel file
excelData = readtable(xlFile) ;
numTableRows = size(excelData,1) ;

%% make empty structure to build upon
allTheData = [] ;

%% loopsy through excel file
for iRow = 1:size(excelData,1)
   theMessage = strcat(num2str(100*iRow/numTableRows),'% Done') ;
   disp(theMessage)
   currentRow = excelData(iRow,:) ;
   if strcmp(currentRow.Analyze_Y_N_, 'Y') == 1
       metaData = getRelevantPlethFileInfo(currentRow) ;
       allTheData = gatherAllThePlethData(allTheData, metaData) ;
   end
end

%% create file timestamp
theTime = strrep(strrep(datestr(datetime(now,'ConvertFrom','datenum')), ' ', '__'), ':', '_') ;

%% save allTheData
pathName = strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/FINAL_PLETH_ABFS_TO_SCORE/allTheData_pleth_LoPass_4', theTime)  ;
save(pathName, 'allTheData') ;








