function SWDs = retrofitSWDAfterAdam(SWDsTemp) 


% save('/home/mark/matlab_temp_variables/retroAdam')
% ccc
% load('/home/mark/matlab_temp_variables/retroAdam')

%% find unique channels
uniqueChannels = unique(SWDsTemp.Signal) ;

%% grab cursor timestamp of just the first channel (sufficient as other channel timestamps are equivalent)
chan1rows = SWDsTemp(strcmp(SWDsTemp.Signal, uniqueChannels{1}), :) ;

%%
SWDs.startTime = chan1rows.Time1_ms_/1000 ;
SWDs.endTime = chan1rows.Time2_ms_/1000 ;

%%
