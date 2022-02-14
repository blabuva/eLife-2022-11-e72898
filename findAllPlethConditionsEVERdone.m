function allConditions = findAllPlethConditionsEVERdone(experimentsMAT, aggregated) 

% save('/home/mark/matlab_temp_variables/allyall'
% ccc 
% load('/home/mark/matlab_temp_variables/allyall'


iJumper = 1; 
for iExperiment = 1:length(experimentsMAT)
    conditions = fieldnames(aggregated.(experimentsMAT{iExperiment})) ;
    for iCondition = 1:length(conditions)
       allConditions{iJumper,1} = conditions{iCondition} ; 
       iJumper = iJumper + 1 ;        
    end
    clear conditions
end