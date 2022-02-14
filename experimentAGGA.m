function aggregated = experimentAGGA(experimentsMAT, popBinned)

for iExperiment = 1:length(experimentsMAT)
    currentExperiment = popBinned.(experimentsMAT{iExperiment}) ;
    aggregated.(experimentsMAT{iExperiment}) = aggTheLikePethConditions(currentExperiment) ;
end