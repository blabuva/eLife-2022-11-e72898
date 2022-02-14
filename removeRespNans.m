function deNaned = removeRespNans(trace)

%%
deNaned = trace ;

%%
anyNans = find(isnan(trace) ==1) ;

%%
deNaned(anyNans) = -1 ; 
