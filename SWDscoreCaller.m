%%
ccc

%% load mat file
matFileToLoad = 'allTheData_pleth_LoPass_406-Nov-2020__18_14_47.mat' ;
load(strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/FINAL_PLETH_ABFS_TO_SCORE/', matFileToLoad)) ;

%% run 1
maxFlankTime = 15 ; % in min
binSize = 3 ; % in min
SWDconditionScorer(allTheData, maxFlankTime, binSize) ;

