function [aligned] = alignRespToConditionStart(traces, timeCsec, conditionStart, maxFlankTime)

% save('/home/mark/matlab_temp_variables/SWDalignTraces')
% ccc
% load('/home/mark/matlab_temp_variables/SWDalignTraces')

% maxFlankTime = 10 ;

%% subtract condition start from timeCsec
timeCsecAligned = timeCsec - conditionStart ;

%% convert aligned timeC into mins
timeCmin = timeCsecAligned/60 ;

%% find index of left flank start
leftFlankIDX = find(timeCmin >= -maxFlankTime, 1) ;

%% find index of left flank start
if ~isempty(find(timeCmin >= maxFlankTime, 1)) 
    rightFlankIDX = find(timeCmin >= maxFlankTime, 1) ;
else
    rightFlankIDX = length(timeCmin) ;
end

%% validate flank IDXs
(leftFlankIDX+rightFlankIDX)/2 ;
find(timeCsec >= conditionStart,1) ;

%% aligned traces = left to right flank IDX
aligned.traces = traces(leftFlankIDX:rightFlankIDX, :) ;

aligned.timeC.aligned = timeCmin(leftFlankIDX:rightFlankIDX, 1) ;
aligned.timeC.real = timeCsec(leftFlankIDX:rightFlankIDX, 1) ;
