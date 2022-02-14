function finalDataArray = makePlethPclampData(varargin)
% 
% save('/home/mark/matlab_temp_variables/fieelds') ;
% ccc
% load('/home/mark/matlab_temp_variables/fieelds') ;

%%
maxTimeIDX = varargin{end} ;

if nargin == 7    
    for iVar = 1:4
        lengths(iVar) = length(varargin{iVar}) ;
    end
    maxTimeIDX = min(lengths) ;
    
    
% (breaths, CTX1, EMG, O2, respRates, maxTimeIDX) ;
    finalDataArray(:,1) = varargin{2}(1:maxTimeIDX) ; % CTX 1
    finalDataArray(:,2) = varargin{3}(1:maxTimeIDX) ; % EMG
    finalDataArray(:,3) = varargin{1}(1:maxTimeIDX) ; % breaths
    finalDataArray(:,4) = varargin{5}.fixed.frequency(1:maxTimeIDX) ; % resp frequency according to FFT
    finalDataArray(:,5) = varargin{5}.fixed.period(1:maxTimeIDX) ; % resp period according to FFT
    finalDataArray(:,6) = varargin{6}.fixed.frequency(1:maxTimeIDX)  ; % resp frequency according to peak detection
    finalDataArray(:,7) = varargin{6}.fixed.period(1:maxTimeIDX) ; % resp period according to peak detection
    finalDataArray(:,8) = varargin{4}(1:maxTimeIDX) ; % O2
end

if nargin == 8
    for iVar = 1:5
        lengths(iVar) = length(varargin{iVar}) ;
    end
    maxTimeIDX = min(lengths) ;
        
% (breaths, CTX1, CTX2, EMG, O2, respRates, maxTimeIDX) ;
    finalDataArray(:,1) = varargin{2}(1:maxTimeIDX) ; % CTX 1
    finalDataArray(:,2) = varargin{3}(1:maxTimeIDX) ; % CTX 2
    finalDataArray(:,3) = varargin{4}(1:maxTimeIDX) ; % EMG
    finalDataArray(:,4) = varargin{1}(1:maxTimeIDX) ; % breaths
    finalDataArray(:,5) = varargin{6}.fixed.frequency(1:maxTimeIDX) ; % resp frequency according to FFT
    finalDataArray(:,6) = varargin{6}.fixed.period(1:maxTimeIDX) ; % resp period according to FFT
    finalDataArray(:,7) = varargin{7}.fixed.frequency(1:maxTimeIDX)  ; % resp frequency according to peak detection
    finalDataArray(:,8) = varargin{7}.fixed.period(1:maxTimeIDX) ; % resp period according to peak detection
    finalDataArray(:,9) = varargin{5}(1:maxTimeIDX) ; % O2
end
