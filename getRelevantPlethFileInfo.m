function metaData = getRelevantPlethFileInfo(currentRow)

%%
metaData.rat.ID = currentRow.Rat ;
metaData.rat.strain = currentRow.Strain ;
metaData.rat.sex = currentRow.Sex ;
metaData.rat.age = currentRow.Age ;

metaData.experiment.experimenter = currentRow.Experimenter ;
metaData.experiment.experiment = currentRow.Experiment ;

metaData.fileInfo.matFile = currentRow.MATFileName ;
metaData.fileInfo.matFilePath = currentRow.ExperimentMATFilePath ;

metaData.SWDinfo.atfFile = currentRow.SWDATFFileName ;
metaData.SWDinfo.atfFilePath = currentRow.SWDsATFPath ;

metaData.laserInfo.excelFile = currentRow.LaserFile ;
metaData.laserInfo.excelFilePath = currentRow.LaserFilePath ;

metaData.gasInfo.excelFile = currentRow.GasFile ;
metaData.gasInfo.excelFilePath = currentRow.GasFilePath ;


metaData.channels.cortex1 = currentRow.Cortex1Name ;
metaData.channels.cortex2 = currentRow.Cortex2Name ;
metaData.channels.emg = currentRow.EMGName ;
metaData.channels.respiration = currentRow.PlethName ;

metaData.plethNoiseATF = strcat(currentRow.PlethFilePath{1}, currentRow.ScoredPlethFile{1}, '.atf') ;

%%
outFile = cell2str(currentRow.MATFileName) ;
ratName = cell2str(currentRow.Rat) ;
metaData.fileInfo.outputFileName = strcat(ratName(3:end-3), '_', outFile(3:10)) ;