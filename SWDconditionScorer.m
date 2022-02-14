function SWDconditionScorer(allTheData, maxFlankTime, binSize)


%% get experiment (field) names
experiments = fieldnames(allTheData) ;

%% skip if aligned already saved...
skip =0
if skip == 0
    %% make big looper to align all conditions/experiments to condition changes
    for iExperiment = 1:length(experiments) 
        rats = fieldnames(allTheData.(experiments{iExperiment})) ;
        for iRat = 1:length(rats)
             disp(rats{iRat})                
             [plethTraces, traces] = getRatsPlethTraces(rats{iRat}) ;
             
           
             
             alignedSWDs.(experiments{iExperiment}).(rats{iRat}) ...         
                 = alignTheSWDsToCondition(allTheData.(experiments{iExperiment}).(rats{iRat}).SWDsPerCondition, plethTraces, traces, maxFlankTime) ;

             clear plethTraces traces
        end
        clear rats
    end
%% save aligned traces
    save('/media/markX/Katie/alignTheSWDsToCondition', 'alignedSWDs') ;   
end


%% load aligned traces
load('/media/markX/Katie/alignTheSWDsToCondition') ;

%% create file timestamp
theTime = strrep(strrep(datestr(datetime(now,'ConvertFrom','datenum')), ' ', '__'), ':', '_') ;

%%
dumpPath = strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/AlignedPlethHistos/LoPass_4/', theTime, '/');
binnedAlignedSWDs = [] ;
experiments = fieldnames(alignedSWDs) ;

for iExperiment = 1:length(experiments)
    disp(experiments{iExperiment})
    binFolder = strcat(dumpPath, 'BinSize_', num2str(binSize),'min__','Flank_',num2str(maxFlankTime),'min/', experiments{iExperiment}, '/') ;
    rats = fieldnames(alignedSWDs.(experiments{iExperiment})) ;
    for iRat = 1:length(rats)
        disp(sprintf('\t %s',rats{iRat}))
        if ~isempty(alignedSWDs.(experiments{iExperiment}).(rats{iRat}))
            conditions = fieldnames(alignedSWDs.(experiments{iExperiment}).(rats{iRat})) ;
            for iCondition = 1:length(conditions)            
                theCounts = alignedSWDs.(experiments{iExperiment}).(rats{iRat}).(conditions{iCondition}) ;
                ratInfo.experiment = experiments{iExperiment} ;
                ratInfo.ratID = rats{iRat} ;
                ratInfo.condition = conditions{iCondition} ;
                binnedAlignedSWDs.(experiments{iExperiment}).(rats{iRat}).(conditions{iCondition}) = ...
                    binPlethCondition(theCounts, ratInfo, maxFlankTime, binSize, binnedAlignedSWDs, binFolder) ;
                clear theCounts ratInfo ;
            end
        else
            binnedAlignedSWDs.(experiments{iExperiment}).(rats{iRat}) = 'noSWDs' ;
            mkdir(strcat(binFolder, rats{iRat})) ;
        end
        clear conditions ;
    end
    clear rats binFolder ;
end



%% save binned mat file
dumpPath = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/AlignedPlethHistos/LoPass_4/';

save(strcat(dumpPath, theTime, '/BinSize_', num2str(binSize),'min__','Flank_',num2str(maxFlankTime),'min/binnedAlignedSWDs_',...
    'BinSize_', num2str(binSize),'min__','Flank_', num2str(maxFlankTime),'__', theTime), 'binnedAlignedSWDs') ;


