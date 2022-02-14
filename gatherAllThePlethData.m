function allTheData = gatherAllThePlethData(allTheData, metaData) 

% save('/home/mark/matlab_temp_variables/gthePlth')
% ccc
% load('/home/mark/matlab_temp_variables/gthePlth')

%% load text files to get pleth trace
textFilePath = strcat('/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/FINAL_PLETH_ABFS_TO_SCORE/LoPass_4/', ...
    metaData.fileInfo.outputFileName, '.txt') ;
textTraces = importdata(textFilePath) ;  
if size(textTraces,2) == 8
    pleths.breaths = textTraces(:,3) ;
    pleths.respRate = textTraces(:,4) ;
elseif size(textTraces,2) == 9 ;
    pleths.breaths = textTraces(:,4) ;
    pleths.respRate = textTraces(:,5) ;
end
pleths.timeC = make_time_column(200, size(textTraces,1), 'rate') ;
clear textTraces textFilePath
    

%% get SWD info
SWDfileATF = strcat(metaData.SWDinfo.atfFilePath{1}, metaData.SWDinfo.atfFile{1},'.atf') ;
SWDfileExcel = strcat(metaData.SWDinfo.atfFilePath{1}, metaData.SWDinfo.atfFile{1},'.xlsx') ;
if isfile(SWDfileATF)   
    SWDs = readtable(SWDfileATF, 'FileType', 'text') ;
    if strcmp(SWDs{1,1}{1}(1:4), 'File') ;
        SWDs = [] ;
    end
elseif isfile(SWDfileExcel)
    SWDs = readtable(SWDfileExcel) ;
end

%% laser info
lasers = getManipulationInfo(metaData.laserInfo) ;

%% gas info
gas = getManipulationInfo(metaData.gasInfo) ;

%% define which manipulation info to use (fyi: if both included, then gas & laser info are identical) 
if ~isempty(lasers)
    theManip = lasers ;
else
    theManip = gas ;
end

%% fix rat ID so that it can be used as a structure field
ratID = strcat('rat_',metaData.fileInfo.outputFileName) ;
ratID = strrep(ratID, '-', '_') ;
ratID = strrep(ratID, '#', '_') ;
ratID = strrep(ratID, ' ', '') ;

%% divey up SWDs according to  condition
[allTheData.(metaData.experiment.experiment{1}).(ratID).SWDsPerCondition, ...
   allTheData.(metaData.experiment.experiment{1}).(ratID).condition.names, ...
   allTheData.(metaData.experiment.experiment{1}).(ratID).condition.starts, ...
   totalSWDcount] = SWDsPerPlethCondition(SWDs, theManip) ;

%% tack on the pleths
allTheData.(metaData.experiment.experiment{1}).(ratID).pleths = pleths ;
    
%% add metaData to the rat info
allTheData.(metaData.experiment.experiment{1}).(ratID).metaData = metaData ;  

%% add traces for pClampable file
finalTextTrace = makeMeATraceAReallyNiceTrace(allTheData, metaData, metaData.experiment.experiment{1}, ratID, totalSWDcount) ;







