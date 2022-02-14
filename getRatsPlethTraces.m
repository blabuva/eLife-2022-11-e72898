function [plethTraces, traces] = getRatsPlethTraces(rat) 

% save('/home/mark/matlab_temp_variables/ratsBreath')
% ccc
% load('/home/mark/matlab_temp_variables/ratsBreath')

%% list files with pleth channels
folderPN = '/media/katieX/Hyperventilation_Project/EEG_Pleth_experiments/FINAL_PLETH_ABFS_TO_SCORE/WITH_SCORED_CHANNELS/';
filesToCheck = dir(strcat(folderPN, '*.txt'));

%% get filenames
x = 0 ;
for iFile = 1:size(filesToCheck,1)
   currentFile = filesToCheck(iFile).name ;
   theUnderscores = strfind(currentFile,'__') ;
%    theUnderscores = [10,11,25]

   if length(theUnderscores) == 2
        realUnderscores = theUnderscores ;
   else
        theDiffs = diff(theUnderscores) ;
        if theDiffs(1) > theDiffs(2)
            realUnderscores = theUnderscores(1:2) ;
        else
            realUnderscores = theUnderscores(2:end) ;
        end
   end
   
   theName = currentFile(1:realUnderscores(1)-1) ;
   theChans = currentFile(realUnderscores(1)+2:realUnderscores(2)-1) ;
   
   if strcmp(theName, rat) == 1
      if strcmp(theChans, '10_chans') == 1
          traces = load(strcat(folderPN, currentFile)) ;
          plethTraces.traces = traces(:,[4,6]) ;
          plethTraces.timeC = make_time_column(200, size(traces,1), 'rate') ;
      elseif strcmp(theChans, '11_chans') == 1
          traces = load(strcat(folderPN, currentFile)) ;         
          
          plethTraces.traces = traces(:,[5,7]) ;
          plethTraces.timeC = make_time_column(200, size(traces,1), 'rate') ;
      end
   end
end