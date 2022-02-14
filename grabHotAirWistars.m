function [WistarAir] = grabHotAirWistars(Data_path,filename);

% save('/home/katie/matlab_temp_variables/stuff');
% ccc
% load('/home/katie/matlab_temp_variables/stuff');
%% Grab Data

[Normnum, Normtxt, Normraw] = xlsread(strcat(Data_path,filename),'Normoxia');
[Hypnum, Hyptxt, Hypraw] = xlsread(strcat(Data_path,filename),'Hypoxia');
% [HypCO2num, HypCO2txt, HypCO2raw] = xlsread(strcat(Data_path,filename),'HypoxiaCO2');
% [CO2num,CO2txt, CO2raw] = xlsread(strcat(Data_path,filename),'Hypercapnia');
% [LaserBeforenum,LaserBeforetxt,LaserBeforeraw] = xlsread(strcat(Data_path,filename),'Laser_Before');
% [LaserAfternum,LaserAftertxt,LaserAfterraw] = xlsread(strcat(Data_path,filename),'Laser_After');
% [LaserCO2num, LaserCO2txt, LaserCO2raw] = xlsread(strcat(Data_path,filename),'LaserCO2');
% [Saline150num, Saline150txt, Saline150raw] = xlsread(strcat(Data_path,filename),'Saline150mgkg');
% [Metformin150num, Metformin150txt, Metformin150raw] = xlsread(strcat(Data_path,filename),'Metformin150mgkg');
% [Saline200num, Saline200txt, Saline200raw] = xlsread(strcat(Data_path,filename),'Saline200mgkg');
% [Metformin200num, Metformin200txt, Metformin200raw] = xlsread(strcat(Data_path,filename),'Metformin200mgkg');

%% Get Field Data

Condition = {'Norm' 'Hyp'} ;
Values = {'pH' 'PCO2' 'PO2' 'HCO3' 'BE' 'TCO2' 'O2sat' 'Lactate'}; 
numbers = { Normnum, Hypnum} ;

for iName = 1:size(Condition,2)
    for iValue = 1:size(Values,2)
    WistarAir.(Condition{iName}).(Values{iValue}) = numbers{iName}(iValue,:) ;
    end
end

%% Take Delta PCO2

% for j = 1:size(WAGAir.Norm.PCO2,2)
% WAGAir.DeltaPCO2(1,j) = abs(WAGAir.Hyp.PCO2(1,j)-WAGAir.Norm.PCO2(1,j)) ;   
% WAGAir.DeltaPCO2_PercentChange(1,j) = (WAGAir.Hyp.PCO2(1,j)-WAGAir.Norm.PCO2(1,j))/WAGAir.Norm.PCO2(1,j)*100 ;
% end

%% Add WAG Names
for k = 2:size(Normraw,2)
    RATName{k-1} = Normraw{1,k}(1:end-8) ;
end

WistarAir.Names = RATName;

