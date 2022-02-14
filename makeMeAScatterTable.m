function scatterData = makeMeAScatterTable(varargin) ;

% save('/home/mark/matlab_temp_variables/scattscatt') ;
% ccc
% load('/home/mark/matlab_temp_variables/scattscatt') ;


if size(varargin,2) == 2
%% find max array
    data1 = varargin{1} ;
    data2 = varargin{2} ;
    maxSize = max(max(size(data1,2), max(size(data2,2))));

    %% make nan matrix
    dataMat = nan(maxSize,2) ;

    %% fill the nan
    dataMat(1:size(data1,2),1) = data1 ;
    dataMat(1:size(data2,2),2) = data2 ;

end

if size(varargin,2) == 3
%% find max array
    data1 = varargin{1} ;
    data2 = varargin{2} ;
    data3 = varargin{3} ;
    maxSize = max([max(size(data1,2)), max(size(data2,2)), max(size(data3,2))]);

    %% make nan matrix
    dataMat = nan(maxSize,2) ;

    %% fill the nan
    dataMat(1:size(data1,2),1) = data1 ;
    dataMat(1:size(data2,2),2) = data2 ;
    dataMat(1:size(data3,2),3) = data3 ;

end

scatterData = dataMat ;
scatterData(scatterData==0) = NaN ;