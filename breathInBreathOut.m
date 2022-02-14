% function breathInBreathOut(metaData, winSize)

%%
% save('/home/mark/matlab_temp_variables/brether') 
ccc
load('/home/mark/matlab_temp_variables/brether') 

%% ccc
plethData = load(strcat(metaData.fileInfo.matFilePath{1}, metaData.fileInfo.matFile{1})) ;
% plethData = load(strcat(metaData.fileInfo.matFilePath{1}, 'ORIGINAL_20200724T174054_000.mat')) ;

%% define size of sliding window (in seconds) to calculate respiration rate 
% winSize = 10 ;

%% gather the right SPIKE2 channels
[channelFields] = getSPIKE2fields(metaData, plethData) ;

%% gather data from fields
try 
    breaths = plethData.(channelFields.plethField).values ;

    if size(channelFields.CTXfield,2) == 1 
        CTX1 = plethData.(channelFields.CTXfield{1}).values ;
    else
        CTX1 = plethData.(channelFields.CTXfield{1}).values ;
        CTX2 = plethData.(channelFields.CTXfield{2}).values ;
    end
    EMG = plethData.(channelFields.emgfield).values ;
    O2 = plethData.(channelFields.O2field).values ;
catch
    breaths = plethData.(channelFields.plethField) ;
    CTX1 = plethData.(channelFields.CTXfield{1}) ;
    CTX2 = plethData.(channelFields.CTXfield{2}) ;
    EMG = plethData.(channelFields.emgfield) ;
    O2 = zeros(length(EMG),1) ;
end
%% si (not in data file)
sampF = 200 ;
timeC = make_time_column(sampF, length(breaths), 'rate') ;

%% calculate start/end of all windows in recording
windows = [0:winSize:max(timeC)] ;

%% calculate rates per window using FFT
respRatesFFT = plethWindowFFTer(timeC, breaths, sampF, windows) ;

%% calculate rates per window using peakDetection
respRatesPeaks = plethWindowPeaker(timeC, breaths, windows) ;

%% fix noisy breaths (according to scored ATF file)
[respRatesFFT, respRatesPeaks] = fixNoisyBreathsNumberTwo(metaData, timeC, respRatesFFT, respRatesPeaks) ;

%% find max time point of freq/per time series
maxTimeIDX = length(timeC) ;

%% make clampfit-loadable text file
if exist('CTX2', 'var') == 1
    finalDataArray = makePlethPclampData(breaths, CTX1, CTX2, EMG, O2, respRatesFFT, respRatesPeaks, maxTimeIDX) ;
else
    finalDataArray = makePlethPclampData(breaths, CTX1, EMG, O2, respRatesFFT, respRatesPeaks, maxTimeIDX) ;
end

%% write file
dumpPath = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/FINAL_PLETH_ABFS_TO_SCORE/LoPass_4/' ;
dumpFile = strcat(dumpPath, metaData.fileInfo.outputFileName, '.txt') ;
dlmwrite(dumpFile, finalDataArray) ;

