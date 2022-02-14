function SWDsThatSpanCenter = SWDCenterSpan(condition1name, condition2name, condition1starts, condition2starts, ...
                                            condition1ends, condition2ends, centerPoint)
                                        
                                        
% save('/home/mark/matlab_temp_variables/theCenters')
% ccc
% load('/home/mark/matlab_temp_variables/theCenters')


%%
SWDsTimes_mat(:,1) = [condition1starts; condition2starts] ;
SWDsTimes_mat(:,2) = [condition1ends; condition2ends] ;
SWDsTimes_mat(:,3) = SWDsTimes_mat(:,1) - centerPoint ;
SWDsTimes_mat(:,4) = SWDsTimes_mat(:,2) - centerPoint ;
SWDsTimes_mat(:,5) = SWDsTimes_mat(:,3)/60 ;
SWDsTimes_mat(:,6) = SWDsTimes_mat(:,4)/60 ;


%% convert into table
SWDsTimes = array2table(SWDsTimes_mat, 'VariableNames', {...
    'SWD_Starts__realTime_sec',...
    'SWD_Ends__realTime_sec', ...
    'SWD_Starts__alignedTime_sec', ...
    'SWD_Ends__alignedTime_sec', ...
    'SWD_Starts__alignedTime_min', ...
    'SWD_Ends__alignedTime_min'}) ;

%% get condition names so that they can be appended to the table
for iCondition = 1:length(condition1starts)+length(condition2starts)
    if ~isempty(find([1:length(condition1starts)] == iCondition))
        allConditions{iCondition,1} = condition1name;
    else
        allConditions{iCondition,1} = condition2name;
    end
end
% convert into table
conditionNames = array2table(allConditions, 'VariableNames', {'Condition'}) ;

%% concat the two tables
SWDsThatSpanCenter = [conditionNames, SWDsTimes] ;
