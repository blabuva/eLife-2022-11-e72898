function xlKeepers = plethXLkeepers(xlPN) ;

xlKeepers.Opto_NmX = readtable(xlPN, 'sheet', 'Opto_NmX') ;
xlKeepers.Opto_Hyper = readtable(xlPN, 'sheet', 'Opto_Hyper') ;
xlKeepers.Opto_NmX_Hyper = readtable(xlPN, 'sheet', 'Opto_NmX_Hyper') ;
xlKeepers.Hypoxia = readtable(xlPN, 'sheet', 'Hypoxia') ;
xlKeepers.Hypoxia_Hypoxia_CO2 = readtable(xlPN, 'sheet', 'Hypoxia_Hypoxia_CO2') ;
xlKeepers.Hypercapnia = readtable(xlPN, 'sheet', 'Hypercapnia') ;