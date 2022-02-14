%%
ccc

%%
xlPN = '/media/katieX/Hyperventilation_Project/Pleth_Paper2021/WAG_isocapnia2.xlsx' ;

%%
xlData = readtable(xlPN) ;

%% load some data
data = readtable(sprintf('%s%s', xlData.Path{1}, xlData.x7{1})) ;

%% 
plot (data.X, data.Y, 'ro')