function fixed = blankifyRespTrace(trace, startIDX, endIDX)



%% replace cursored region with -5
fixed = trace ;
fixed(startIDX:endIDX) = -5;