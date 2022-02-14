function fixNoisyBreaths(metaData, finalTextTrace, ratID)
% 
% save('/home/mark/matlab_temp_variables/noisyBreaths') 
% ccc
% load('/home/mark/matlab_temp_variables/noisyBreaths')

%% make time column (assuming 200Hz sampling frequency)
timeC = make_time_column(200, size(finalTextTrace,1), 'rate')*1000 ; % in milliseconds

%% load ATF file
noisyCursors = readtable(metaData.plethNoiseATF, 'FileType', 'text') ;

%% grab relevant resp traces. Location depends on if original recording contained 1 or 2 corticals
if size(finalTextTrace,2) == 8
    respTrace = finalTextTrace(:,3) ;
    freqTrace = finalTextTrace(:,4) ;
    perTrace = finalTextTrace(:,5) ;
elseif size(finalTextTrace,2) == 9
    respTrace = finalTextTrace(:,4) ;
    freqTrace = finalTextTrace(:,5) ;
    perTrace = finalTextTrace(:,6) ;
end

%% loop to chop out noise
for iNoise = 1:size(noisyCursors,1)
    startMS = noisyCursors.Time1_ms_(iNoise) ;
    endMS = noisyCursors.Time2_ms_(iNoise) ;
    startIDX = find(timeC >=startMS, 1) ;
    endIDX = find(timeC >=endMS, 1) ;
    respTrace(startIDX:endIDX) =  -10;
    freqTrace(startIDX:endIDX) = -0.5 ;
    perTrace(startIDX:endIDX) = -0.5 ;
end

%% reorganize finalTextTrace
if size(finalTextTrace,2) == 8
    fixedTextTrace = finalTextTrace(:,1:3) ;
    fixedTextTrace(:,4) = respTrace ;
    fixedTextTrace(:,5) = freqTrace ;
    fixedTextTrace(:,6) = perTrace ;
    fixedTextTrace(:,7:9) = finalTextTrace(:,6:8) ;
    theChannelNames = {'Cortex 1', 'EMG', 'Resp Orig', 'RespNoNoiz', 'Resp Freq', 'Resp Per', 'O2', 'SWDs', 'Condition'} ;
elseif size(finalTextTrace,2) == 9
    fixedTextTrace = finalTextTrace(:,1:4) ;
    fixedTextTrace(:,5) = respTrace ;
    fixedTextTrace(:,6) = freqTrace ;
    fixedTextTrace(:,7) = perTrace ;
    fixedTextTrace(:,8:10) = finalTextTrace(:,7:9) ;
    theChannelNames = {'Cortex 1', 'Cortex 2', 'EMG', 'Resp Original', 'Resp DeNoised', 'Resp Freq', 'Resp Period', 'O2', 'SWDs', 'Condition'} ;
end

%% write data
sampFreq = 200 ; % in Hz
dumpPath = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/FINAL_PLETH_ABFS_MARK_FIXED_RESP/' ;
fileName = ratID ;

dumpPath = strcat(dumpPath, ratID, '.txt') ;
dlmwrite(dumpPath, finalTextTrace) ;

% write_data_atf(fixedTextTrace, 'SignalNames', theChannelNames, 'FileName', ratID, 'OutFolder', dumpPath, ...
%     'SamplingIntervalSeconds', 1/sampFreq) ;

    
    
