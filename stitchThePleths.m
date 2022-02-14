%%
ccc

%% for  final resubmission:
pn1 = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/AlignedPlethHistos/LoPass_4/12-Dec-2021__15_45_22/BinSize_3min__Flank_15min/'; ;
fn1 = 'binnedAlignedSWDs_BinSize_3min__Flank_15__12-Dec-2021__15_45_22_B.mat' ;

load(strcat(pn1, fn1));

%% load in excel file
xlPN = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/conditionKeepers_KAS.xlsx' ;
xlKeepers = plethXLkeepers(xlPN) ;

%% get field names from both mat file and excel file
experimentsXL = fieldnames(xlKeepers) ;
experimentsMAT = fieldnames(binnedAlignedSWDs) ;

%% make default keeper = N (0)
binnedAlignedSWDs = switchKeeperToZero(binnedAlignedSWDs, experimentsMAT) ;

%% switch keeper = Y (1) for those designated as such on XL sheet
binnedAlignedSWDs = switchSomeKeepersToOne(binnedAlignedSWDs, xlKeepers, experimentsXL) ;

%% just keep what's needed
keep binnedAlignedSWDs experimentsMAT

%% aggregate the Y keepers
popBinned = aggTheYs(binnedAlignedSWDs, experimentsMAT) ;

%% just keep what's needed
keep binnedAlignedSWDs experimentsMAT popBinned 

%% aggregateLikes
aggregated = experimentAGGA(experimentsMAT, popBinned) ;

%% find all conditions ever
allConditions = findAllPlethConditionsEVERdone(experimentsMAT, aggregated) ;

%% all uniques
uniqueConditions = unique(allConditions) ;

%% combine all like conditions
comboed = comboTheLikePleths(uniqueConditions, experimentsMAT, aggregated) ;

%% make the plots
comboed = plotPleths(uniqueConditions, comboed) ;
allPlethHistoData.allUniqueConditions = comboed ;

%% do the hypox/hypoxHyperCap
clear comboed
comboed = aggregated.Hypoxia_Hypoxia_CO2 ;
uniqueConditions = fieldnames(aggregated.Hypoxia_Hypoxia_CO2) ;
comboed = plotPlethsHyPox(uniqueConditions, comboed) ;

allPlethHistoData.hypoxHypercap = comboed ;

%% save data
save('/media/katieX/Hyperventilation_Project/Pleth_Paper2021/allPlethHistoData_2021-07-29', 'allPlethHistoData') ;   







