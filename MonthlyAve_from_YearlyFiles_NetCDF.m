%{
    Author: Bahareh Kamranzad
    Date: February 16, 2024
    Description: This MATLAB script is designed to Calculate monthly averages in a domain. Input files should be yearly NetCDFs.
    Copyright (c) 2024, Bahareh Kamranzad. All rights reserved.
%}

clc
clear
MinLong= 10; % Western longitude
MaxLong= 20; % Eastern longitude
ResX=0.5; % resolution in x-direction
NCOL=(MaxLong-MinLong)/ResX+1; %number of columns
MinLat= -10; % Southern latitude
MaxLat= 0; % Northern latitude
ResY=0.5; % resolution in y-direction
NROW=(MaxLat-MinLat)/ResY+1; %number of rows
TemporalResolution=1;
TimeStepPerDay=24/TemporalResolution;
StartYear=2015;
EndYear=2020;
NumberofYears=EndYear-StartYear+1;
PAR={'swh','mwp'}; % Add parameters here
directory='D:\Wave\';
for k=1:2
parameter=PAR{k};
DaY=[31 28 31 30 31 30 31 31 30 31 30 30];
e=0;   
for month=1:12
    G=zeros(NCOL,NROW);    
for yr=1:1:NumberofYears
    E=zeros(NCOL,NROW);
    VAR=ncread([directory, 'Wave_',num2str(yr+StartYear-1),'.nc'],parameter); % change filename
    [longitude,latitude, time] = size(VAR);
    for T=1+e*TimeStepPerDay:(e+DaY(month))*TimeStepPerDay
              D=zeros(NCOL,NROW);
                D(1:NCOL,1:NROW)=VAR(:,:,T);
                E=D+E;
    end                
        G=G+E;
end     
AVE=G/(DaY(month)*TimeStepPerDay*NumberofYears);
AVE=AVE';
dlmwrite([parameter,'_AVE_month-',num2str(month),'.dat'], AVE, 'delimiter','\t');
e=e+DaY(month);
end
end


