function fixedConditionFields = fieldMakerPleth(theConditions) ;

% % save('/home/mark/matlab_temp_variables/fdd')
% ccc
% load('/home/mark/matlab_temp_variables/fdd')

for iCondition = 1:length(theConditions)
    fix1 = strrep(theConditions{iCondition}, ' ', '_') ;
    fix2 = strrep(fix1, '%', 'pct') ;
    fixedConditionFields{iCondition,1} = fix2 ;
    clear fix1 fix2
end

%% find unique conditions
uniqueConditions = unique(fixedConditionFields) ;

%% create letters
letters = upper(char(97:122)) ;
%%
for iUniques = 1:length(uniqueConditions) 
    jumper = 1;
    for iCondition = 1:length(fixedConditionFields)
        if strcmp(fixedConditionFields{iCondition}, uniqueConditions{iUniques}) == 1 
            fixedConditionFields{iCondition} = strcat(fixedConditionFields{iCondition}, '_', letters(jumper)) ;            
            jumper = jumper + 1;        
        end
    end 
end
    


