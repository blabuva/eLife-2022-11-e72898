function comboed = comboTheLikePleths(uniqueConditions, experimentsMAT, aggregated) 

% save('/home/mark/matlab_temp_variables/comboCombos')
% ccc
% load('/home/mark/matlab_temp_variables/comboCombos')


for iUnique = 1:length(uniqueConditions)
    iJumper = 1 ;
    theBinsCombined = [] ;
    theAnimalsCombined = [] ;
    theDursCombined = [] ;
    theFreqsCombined = [] ;

%     uniqueConditions(iUnique)
    for iExperiment = 1:length(experimentsMAT)
        clc
        disp(sprintf('unique condition: %s', uniqueConditions{iUnique})) 
        disp(sprintf('experiment: %s', experimentsMAT{iExperiment}))
        conditions = fieldnames(aggregated.(experimentsMAT{iExperiment})) ;
        for iCondition = 1:length(conditions)
            disp(sprintf('condition: %s', conditions{iCondition}))
            if strcmp(uniqueConditions{iUnique}, conditions{iCondition}) == 1;
                x=1 ;
%                 comboed.(uniqueConditions{iUnique}).bins{iJumper,:} = aggregated.(experimentsMAT{iExperiment}).(uniqueConditions{iUnique}).bins ;
                
                theBinsCombined = [theBinsCombined; aggregated.(experimentsMAT{iExperiment}).(uniqueConditions{iUnique}).bins] ;
                theRespsCombined{iJumper} = aggregated.(experimentsMAT{iExperiment}).(uniqueConditions{iUnique}).resps ;
                
                theDursCombined = [theDursCombined; aggregated.(experimentsMAT{iExperiment}).(uniqueConditions{iUnique}).swdDurations] ;
                theFreqsCombined  = [theFreqsCombined; aggregated.(experimentsMAT{iExperiment}).(uniqueConditions{iUnique}).swdFreqs] ;
%                 theRespsCombined = {theRespsCombined; aggregated.(experimentsMAT{iExperiment}).(uniqueConditions{iUnique}).resps} ;
                                
                animalTemp1 = fieldnames(aggregated.(experimentsMAT{iExperiment}).(uniqueConditions{iUnique})) ;
                animalTemp2 = animalTemp1(find(strcmp('bins', animalTemp1)==0)) ;
                animalTemp3 = animalTemp2(find(strcmp('resps', animalTemp2) == 0)) ;
                animalTemp4 = animalTemp3(find(strcmp('swdDurations', animalTemp3) ==0 )) ;
                animalTemp5 = animalTemp4(find(strcmp('swdFreqs', animalTemp4) == 0)) ;
                                
                theAnimalsCombined = [theAnimalsCombined; animalTemp5] ;
                comboed.(uniqueConditions{iUnique}).experiments{iJumper,1} = experimentsMAT{iExperiment} ;
                comboed.(uniqueConditions{iUnique}).allData{iJumper,1} = aggregated.(experimentsMAT{iExperiment}).(uniqueConditions{iUnique}) ;
                iJumper = iJumper + 1;
                clear animalTemp1 animalTemp2 animalTemp3 animalTemp4 animalTemp5
            end
        end
        clear conditions
    end
    comboed.(uniqueConditions{iUnique}).bins = theBinsCombined ;
    comboed.(uniqueConditions{iUnique}).rats = theAnimalsCombined ;
    comboed.(uniqueConditions{iUnique}).swdDurations = theDursCombined ;
    comboed.(uniqueConditions{iUnique}).swdFreqs = theFreqsCombined ;
    
    % make nan array for combining the resps
    for iResps = 1:length(theRespsCombined)
        allLengthsMax(iResps,1) = cellfun(@length, theRespsCombined(iResps));  
        numArrays(iResps,1) = size(theRespsCombined{iResps},1);         
    end
    
    nanRespArray = NaN(sum(numArrays), max(allLengthsMax)) ;
    iJumper = 1 ;
    for iResps = 1:length(theRespsCombined)
        currentResp = theRespsCombined{iResps} ;
        for iCurrent = 1:width(currentResp)
            nanRespArray(iJumper,1:length(currentResp)) = currentResp(iCurrent,:) ;
            iJumper = iJumper + 1 ;
        end
       clear currentResp
    end
    
    comboed.(uniqueConditions{iUnique}).resps = nanRespArray ;
    clear theRespsCombined nanRespArray numArrays allLengthsMax theDursCombined theFreqsCombined
end