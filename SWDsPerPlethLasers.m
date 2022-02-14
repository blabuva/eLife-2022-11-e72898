function SWDsPerCondition = SWDsPerPlethLasers(SWDs, lasers)

%% get number of conditions
theConditions = lasers.condition ;

%% create condition field names
fixedConditionFields = fieldMakerPleth(theConditions) ;

%% find start times of different conditions
if sum(strcmp("RealStartTime_s_", lasers.Properties.VariableNames)) > 0
    conditionStarts = lasers.RealStartTime_s_ ; 
else
    conditionStarts = lasers.RealTimeStart_s_ ;
end

conditionDurations= lasers.duration_s_ ;

%% loopsie loop for finding SWDs within each condition
for iCondition = 1:length(theConditions)
    if iCondition == length(theConditions)
        theStart = conditionStarts(iCondition) ;
        for iSWD = 1:size(SWDs,1)
                allSWDsWithinCurrentCondition(:,1) = SWDs.startTime(find(SWDs.endTime>=theStart)) ; 
                allSWDsWithinCurrentCondition(:,2) = SWDs.endTime(find(SWDs.endTime>=theStart)) ;
                allSWDsWithinCurrentCondition(:,3) = allSWDsWithinCurrentCondition(:,2) - allSWDsWithinCurrentCondition(:,1) ;
                SWDsPerCondition.(fixedConditionFields{iCondition}) = array2table(allSWDsWithinCurrentCondition, ...
                    'VariableNames', {'SWD Start', 'SWD End', 'SWD Duration'});
        end
    else
        theStart = conditionStarts(iCondition) ;
        theEnd = conditionStarts(iCondition+1) ;
            for iSWD = 1:size(SWDs,1)
                allSWDsWithinCurrentCondition(:,1) = SWDs.startTime(find(SWDs.endTime>=theStart & SWDs.endTime<=theEnd)) ; 
                allSWDsWithinCurrentCondition(:,2) = SWDs.endTime(find(SWDs.endTime>=theStart & SWDs.endTime<=theEnd)) ;
                allSWDsWithinCurrentCondition(:,3) = allSWDsWithinCurrentCondition(:,2) - allSWDsWithinCurrentCondition(:,1) ;
                SWDsPerCondition.(fixedConditionFields{iCondition}) = array2table(allSWDsWithinCurrentCondition, ...
                    'VariableNames', {'SWD Start', 'SWD End', 'SWD Duration'});
            end
    end
    clear x allSWDsWithinCurrentCondition
end