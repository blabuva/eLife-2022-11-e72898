%%
ccc 

%% path and file to mat file
pathName = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/AlignedPlethHistos/BinSize_2min__Flank_10min/'; 
fileName = 'binnedAlignedSWDs_BinSize_2min__Flank_10' ;

%% load mat file
load(strcat(pathName, fileName)) ;

%% experiments
experiments = fieldnames(binnedAlignedSWDs) ;

%%
for iExperiment = 1:length(experiments)
   rats = fieldnames(binnedAlignedSWDs.(experiments{iExperiment})) ; 
   for iRat = 1:length(rats)
%         condition = 
       
       
   end
   clear rats 
    
end