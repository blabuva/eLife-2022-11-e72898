function finalTextTrace = makeMeATraceAReallyNiceTrace(allTheData, metaData, experiment, ratID, totalSWDcount)

% save('/home/mark/matlab_temp_variables/gthePlth')
% ccc
% load('/home/mark/matlab_temp_variables/gthePlth')

%%

%% get the traces
textFilePath = strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/FINAL_PLETH_ABFS_TO_SCORE/LoPass_4/', ...
    metaData.fileInfo.outputFileName, '.txt') ;
textTraces = importdata(textFilePath) ;  

%% get fields
if ~isempty(allTheData.(experiment).(ratID).SWDsPerCondition)
    conditionFields = fieldnames(allTheData.(experiment).(ratID).SWDsPerCondition) ;
else
    conditionFields = [] ;
end

%% get SWDs per condition

SWDtrace = zeros(size(textTraces,1), 1) ;
%% make time column
timeC = make_time_column(200, length(SWDtrace), 'rate') ;

%% add SWDs to trace
for iCondition = 1:length(conditionFields)
    currentSWDs = allTheData.(experiment).(ratID).SWDsPerCondition.(conditionFields{iCondition}).table ;
    for iSWDs = 1:size(currentSWDs,1)
        startIDX = find(timeC >= currentSWDs.SWD_Start(iSWDs),1) ;
        endIDX =  find(timeC >= currentSWDs.SWD_End(iSWDs),1) ;
        SWDtrace(startIDX:endIDX) = 1*iCondition ;
    end
end

%% add condition  trace
conditionTrace = zeros(size(textTraces,1),1) ;
conditionStarts = allTheData.(experiment).(ratID).condition.starts ;

for iCondition = 1:length(conditionStarts)-1
    conditionIDX1 = find(timeC >= conditionStarts(iCondition),1) ;
    conditionIDX2 = find(timeC >= conditionStarts(iCondition+1),1) ;
    conditionTrace(conditionIDX1:conditionIDX2) = iCondition ;
end

if exist('conditionIDX2', 'var') == 1
    conditionTrace(conditionIDX2:end) = iCondition + 1 ;
end

%% make plampable text file
finalTextTrace = [textTraces, SWDtrace, conditionTrace] ;
numChans = num2str(size(finalTextTrace,2)) ;
dumpPath = strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/FINAL_PLETH_ABFS_TO_SCORE/WITH_SCORED_CHANNELS/', ...
    ratID, '__', numChans, '_chans', '__', num2str(totalSWDcount), '_SWDs', '.txt') ;
dlmwrite(dumpPath, finalTextTrace) ;








