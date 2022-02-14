function manipInfo = getManipulationInfo(metaStuff)


%%
if ~isempty(metaStuff.excelFile{1})
    fileCSV = strcat(metaStuff.excelFilePath{1}, metaStuff.excelFile{1},'.csv') ;
    fileExcel = strcat(metaStuff.excelFilePath{1}, metaStuff.excelFile{1},'.xlsx') ;
    
    if isfile(fileCSV)   
        manipInfo = readtable(fileCSV) ;
    elseif isfile(fileExcel)
        manipInfo = readtable(fileExcel) ;
    end
    
else
    manipInfo = [] ;
end