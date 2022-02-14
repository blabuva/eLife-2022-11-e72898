function stackedColors = makeMeSomeStackedColors() 

%%
rgbColors{1} = 'Black' ;
rgbColors{2} = 'Red' ;
rgbColors{3} = 'Gold' ;
rgbColors{4} = 'Green' ;
rgbColors{5} = 'Blue' ;
rgbColors{6} = 'Purple' ;
rgbColors{7} = 'DimGray' ;
rgbColors{8} = 'DarkRed' ;
rgbColors{9} = 'Cyan' ;
rgbColors{10} = 'Magenta' ;
rgbColors{11} = 'SteelBlue' ;
rgbColors{12} = 'LawnGreen' ;
rgbColors{13} = 'Silver' ;
rgbColors{14} = 'Crimson' ;
rgbColors{15} = 'DarkCyan' ;
rgbColors{16} = 'Navy' ;
rgbColors{17} = 'Indigo' ;
rgbColors{18} = 'AntiqueWhite' ;
rgbColors{19} = 'DeepPink' ;
rgbColors{20} = 'Maroon' ;
rgbColors{21} = 'DarkOliveGreen' ;
rgbColors{22} = 'LawnGreen' ;
rgbColors{23} = 'Tomato' ;

%%
for iColor = 1:length(rgbColors)
   stackedColors(iColor,:) = rgb(rgbColors{iColor}) ;
end

