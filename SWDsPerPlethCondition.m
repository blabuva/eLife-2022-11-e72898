function [SWDsPerCondition, theConditions, conditionStarts, totalSWDcount] = SWDsPerPlethCondition(SWDs, manipulation)

% save('/home/mark/matlab_temp_variables/gthePlth')
% ccc
% load('/home/mark/matlab_temp_variables/gthePlth')

%% bypass if no SWDs found
if ~isempty(SWDs)
    %% Do if SWDs are found:
    %% find start times of different conditions
    % NOTE: some of the tables pulled in nans, making the deterimination of
    % condition start times difficult (Mark filtered nans out).
    % Also, manipulation start time is (annoyingly) sometimes called
    % "RealStartTime", and other times called "RealTimeStart".
    
    %% retrofit excel-based SWD info storage to ATF-based (had to do this after Adam)
    SWDsTemp = SWDs ;
    clear SWDs
    SWDs = retrofitSWDAfterAdam(SWDsTemp) ;
    

    if sum(strcmp("RealStartTime_s_", manipulation.Properties.VariableNames)) > 0
        theConditions = manipulation.condition(~isnan(manipulation.RealStartTime_s_)) ;
        conditionStarts = manipulation.RealStartTime_s_(~isnan(manipulation.RealStartTime_s_)) ;
        fixedConditionFields = fieldMakerPleth(theConditions(~isnan(manipulation.RealStartTime_s_))) ;
        conditionDurations= manipulation.duration_s_(~isnan(manipulation.RealStartTime_s_)) ;     
    else
        theConditions = manipulation.condition(~isnan(manipulation.RealTimeStart_s_)) ;
        conditionStarts = manipulation.RealTimeStart_s_(~isnan(manipulation.RealTimeStart_s_))  ;
        fixedConditionFields = fieldMakerPleth(theConditions(~isnan(manipulation.RealTimeStart_s_))) ;
        conditionDurations= manipulation.duration_s_(~isnan(manipulation.RealTimeStart_s_)) ;  
    end

totalSWDcount = 0 ;
    %% loopsie loop for finding SWDs within each condition
    for iCondition = 1:length(theConditions)
        if iCondition == length(theConditions)% ccc
            theStart = conditionStarts(iCondition) ;
            allSWDsWithinCurrentCondition(:,1) = SWDs.startTime(find(SWDs.endTime>=theStart)) ; 
            allSWDsWithinCurrentCondition(:,2) = SWDs.endTime(find(SWDs.endTime>=theStart)) ;
            allSWDsWithinCurrentCondition(:,3) = allSWDsWithinCurrentCondition(:,2) - allSWDsWithinCurrentCondition(:,1) ;
            SWDsPerCondition.(fixedConditionFields{iCondition}).table = array2table(allSWDsWithinCurrentCondition, ...
                'VariableNames', {'SWD_Start', 'SWD_End', 'SWD_Duration'});
            SWDsPerCondition.(fixedConditionFields{iCondition}).table.StartCondition = NaN(length(allSWDsWithinCurrentCondition(:,1)),1) ;
            SWDsPerCondition.(fixedConditionFields{iCondition}).table.EndCondition = NaN(length(allSWDsWithinCurrentCondition(:,1)),1) ;
            SWDsPerCondition.(fixedConditionFields{iCondition}).table.StartCondition(1) = theStart ;
            
            %% tack on respRates
%             startSnippetIDX = find(pleths.timeC >= theStart) ;
%             endSnippetIDX = find(pleths.timeC >= theEnd) ;
%             SWDsPerCondition.(fixedConditionFields{iCondition}).pleths.breaths = pleths.breaths(startSnippetIDX:end) ;
%             SWDsPerCondition.(fixedConditionFields{iCondition}).pleths.respRate = pleths.respRate(startSnippetIDX:end) ;
%             SWDsPerCondition.(fixedConditionFields{iCondition}).pleths.timeC = pleths.timeC(startSnippetIDX:end) ;            
            
            
        else
            theStart = conditionStarts(iCondition) ;
            theEnd = conditionStarts(iCondition+1) ;
            allSWDsWithinCurrentCondition(:,1) = SWDs.startTime(find(SWDs.endTime>=theStart & SWDs.endTime<=theEnd)) ; 
            allSWDsWithinCurrentCondition(:,2) = SWDs.endTime(find(SWDs.endTime>=theStart & SWDs.endTime<=theEnd)) ;
            allSWDsWithinCurrentCondition(:,3) = allSWDsWithinCurrentCondition(:,2) - allSWDsWithinCurrentCondition(:,1) ;
            SWDsPerCondition.(fixedConditionFields{iCondition}).table = array2table(allSWDsWithinCurrentCondition, ...
                'VariableNames', {'SWD_Start', 'SWD_End', 'SWD_Duration'});
            SWDsPerCondition.(fixedConditionFields{iCondition}).table.StartCondition = NaN(length(allSWDsWithinCurrentCondition(:,1)),1) ;
            SWDsPerCondition.(fixedConditionFields{iCondition}).table.EndCondition = NaN(length(allSWDsWithinCurrentCondition(:,1)),1) ;
            SWDsPerCondition.(fixedConditionFields{iCondition}).table.StartCondition(1) = theStart ;
            SWDsPerCondition.(fixedConditionFields{iCondition}).table.EndCondition(1) = theEnd ;
            
            %% tack on respRates
%             startSnippetIDX = find(pleths.timeC >= theStart) ;
%             endSnippetIDX = find(pleths.timeC >= theEnd) ;
%             SWDsPerCondition.(fixedConditionFields{iCondition}).pleths.breaths = pleths.breaths(startSnippetIDX:endSnippetIDX) ;
%             SWDsPerCondition.(fixedConditionFields{iCondition}).pleths.respRate = pleths.respRate(startSnippetIDX:endSnippetIDX) ;
%             SWDsPerCondition.(fixedConditionFields{iCondition}).pleths.timeC = pleths.timeC(startSnippetIDX:endSnippetIDX) ;
           
            
        end
        totalSWDcount = totalSWDcount+length(allSWDsWithinCurrentCondition(:,1)) ;
        clear x allSWDsWithinCurrentCondition
    end
else
    SWDsPerCondition = [] ;
    theConditions = [] ;
    conditionStarts = [] ;
    totalSWDcount = [] ;
end