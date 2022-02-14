function [channelFields] = getSPIKE2fields(metaData, plethData)

% save('/home/mark/matlab_temp_variables/fieelds') ;
% ccc 
% load('/home/mark/matlab_temp_variables/fieelds') ;


%% pleth Fields
plethFieldsTemp = fieldnames(plethData) ;

%% you may have to re-align the spike2 fields:
plethFields{1,1} = plethFieldsTemp{1} ; 
plethFields{2,1} = plethFieldsTemp{2} ; 
plethFields{3,1} = plethFieldsTemp{4} ; 
plethFields{4,1} = plethFieldsTemp{5} ; 
plethFields{5,1} = plethFieldsTemp{9} ; 

for iFields = 1:length(plethFields)
    % pleth field:
    if ~isempty(strfind(plethFields{iFields}, metaData.channels.respiration))
        channelFields.plethField = plethFields{iFields} ;
    end
    
    % cortex 1 field
    if ~isempty(strfind(plethFields{iFields}, metaData.channels.cortex1))
        ctx{1} = plethFields{iFields} ;
    end
    
    % cortex 2 field
    if ~isempty(strfind(plethFields{iFields}, metaData.channels.cortex2))
        ctx{2} = plethFields{iFields} ;
    end
    
    % EMG field
    if ~isempty(strfind(plethFields{iFields}, metaData.channels.emg))
        channelFields.emgfield = plethFields{iFields} ;
    end
    
    % O2 field
    if ~isempty(strfind(plethFields{iFields}, 'O2'))
        channelFields.O2field = plethFields{iFields} ;
    end
    
%     % CO2 field
%     if ~isempty(strfind(plethFields{iFields}, 'CO2'))
%         channelFields.CO2field = plethFields{iFields} ;
%     end    
    
%     % CO2 field
%     if ~isempty(strfind(plethFields{iFields}, 'Keyboard'))
%         channelFields.KeyBoardField = plethFields{iFields} ;
%     end  
    
end

channelFields.CTXfield = ctx(~cellfun('isempty', ctx'));

