function alignedSWDs = alignTheSWDsToCondition(SWDsPerCondition, plethTraces, traces, maxFlankTime) 

% save('/home/mark/matlab_temp_variables/SWDalign')
% ccc
% load('/home/mark/matlab_temp_variables/SWDalign')

%% get conditions
if ~isempty(SWDsPerCondition)
    conditions = fieldnames(SWDsPerCondition) ;

    %% grab condition starts
    for iCondition = 1:length(conditions)
       conditionStarts(iCondition,:) = [SWDsPerCondition.(conditions{iCondition}).table.StartCondition(1), SWDsPerCondition.(conditions{iCondition}).table.EndCondition(1)] ; 
    end

    %% find commonalities between end of 1 condition and beginning of next condition
    for iCondition = 1:length(conditions)-1
        if conditionStarts(iCondition,2) == conditionStarts(iCondition+1, 1)
            theCenters{iCondition,1} = [iCondition, iCondition+1] ;
            theCenters{iCondition,2} = conditionStarts(iCondition,2) ;
        end
    end

    %% combine SWDs from the two conditions that span a condition start
    for iCenter = 1:size(theCenters,1)
        alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable...,
                 = SWDCenterSpan(conditions{theCenters{iCenter,1}(1)}, ...
                                 conditions{theCenters{iCenter,1}(2)}, ...    
                                 SWDsPerCondition.(conditions{theCenters{iCenter,1}(1)}).table.SWD_Start, ...
                                 SWDsPerCondition.(conditions{theCenters{iCenter,1}(2)}).table.SWD_Start, ...
                                 SWDsPerCondition.(conditions{theCenters{iCenter,1}(1)}).table.SWD_End, ...
                                 SWDsPerCondition.(conditions{theCenters{iCenter,1}(2)}).table.SWD_End, ...
                                 theCenters{iCenter,2}) ;
        alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).alignedTraces.resp = alignRespToConditionStart(plethTraces.traces, plethTraces.timeC, theCenters{iCenter,2}, maxFlankTime) ;
        alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).alignedTraces.all = alignRespToConditionStart(traces, plethTraces.timeC, theCenters{iCenter,2}, maxFlankTime) ;
        alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).conditionStart = theCenters{iCenter,2} ;
        
        timeC = plethTraces.timeC ;
        
        for iSWD = 1:length(alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.Condition)
            startSWD_IDX = find(timeC >= alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.SWD_Starts__realTime_sec(iSWD), 1) ;
            endSWD_IDX = find(timeC >= alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.SWD_Ends__realTime_sec(iSWD), 1) ;
            
            if startSWD_IDX ~= endSWD_IDX
                theSWD = traces(startSWD_IDX:endSWD_IDX, 1) ;
                try
                    theNoise = rms(traces(startSWD_IDX-400:startSWD_IDX,1)) ;
                catch
                    theNoise = rms(traces(endSWD_IDX:endSWD_IDX+400,1)) ;
                end
                SWDtimeC = (0:0.005:(length(theSWD)-1)/200)' ;
                [durationSWDsec, startSWD, endSWD, threshold] = durThatSWD(SWDtimeC, theSWD, theNoise) ;
                fftSWD = fftThatFu(theSWD) ;

                % plot FFT for spot checking
                plotFFT = 0 ;
                if plotFFT == 1
                    subplot(2,1,1)
                        plot(SWDtimeC, theSWD, 'k')
                        axis([0, max(timeSWD),-inf, inf])
                    subplot(2,1,2)            
                        plot(fftSWD.mark.fSpec(1:30), fftSWD.mark.Pyy(1:30), 'k')
                end

                lessThan10Hz = fftSWD.adam.top3freqs(find(fftSWD.adam.top3freqs <=10)) ;% find value closest to 10 Hz (sometimes the first val from adams function is spuriou
                [val, idx] = min(abs(lessThan10Hz - 10)) ;
                minVal = lessThan10Hz(idx) ;
                alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.MajorFFTfreq(iSWD) = {minVal}; 
                alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.TrueDuration(iSWD) = {durationSWDsec} ;
                alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.TrueStartStop(iSWD) = {[startSWD, endSWD]} ;
                alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.timeVStheSWD(iSWD) = {[SWDtimeC, theSWD]} ;
            else
                alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.MajorFFTfreq(iSWD) = {'na'}; 
                alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.TrueDuration(iSWD) = {'na'} ;
                alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.TrueStartStop(iSWD) = {'na'} ;
                alignedSWDs.(conditions{theCenters{iCenter,1}(2)}).SWDtable.timeVStheSWD(iSWD) = {'na'} ;
            end
          
            clear SWDtimeC theSWD fftSWD theNoise startSWD_IDX endSWD_IDX durationSWDsec minVal idx
        end
    end
%%
else
    alignedSWDs = [] ;
end


