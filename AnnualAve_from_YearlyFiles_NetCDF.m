%{
    Author: Bahareh Kamranzad
    Date: June 28, 2024
    Description: This MATLAB script is designed to Calculate annual averages of 'msl','sst','i10fg' (Mean Sea Level, Sea Surface Temperature and Wind Gust, respectively, downloaded from ECMWF ERA5 product) in a domain. Input files should be yearly NetCDFs.
    Copyright (c) 2024, Bahareh Kamranzad. All rights reserved.
%}

clc
clear
MinLong= -12; % Western boundary longitude
MaxLong= 3; % Eastern boundary longitude
MinLat= 49; % Southern boundary latitude
MaxLat= 61.5; % Northern boundary latitude
TemporalResolution=1;  % Temporal resolution in hours

% Calculate the number of time steps per day
TimeStepPerDay=24/TemporalResolution;

% Define time period for analysis
StartYear=2014;
EndYear=2023;
PER=10; % number of years considered for calculations of annual mean

% Calculate the number of years and periods
NumberofYears=EndYear-StartYear+1;
periods=NumberofYears/PER;

Domain='Domain';

parameters={'msl','sst','i10fg'};

% Define spatial resolution
ResX=0.25; % resolution in x-direction
ResY=0.25; % resolution in y-direction
NCOL=(MaxLong-MinLong)/ResX+1; %number of columns
NROW=(MaxLat-MinLat)/ResY+1; %number of row

% Loop through each parameter
for paramIdx=2:2 % for parameters (PAR) listed above > for instance, k=2 does the calculations for "sst".
parameter=parameters{paramIdx};

% Loop through each period
for periodIdx=1:periods    
       startYear=StartYear+(periodIdx-1)*PER;
       endYear=startYear+PER-1;
       F=zeros(NCOL,NROW);

% Loop through each year in the current period
for yr=1:PER
 % Read data from NetCDF file
VAR=ncread([Domain, '_Wind_',num2str(yr+startYear-1),'.nc'],parameter);   
VAR(VAR==-0.900E+01)=0;
[longitude,latitude, time] = size(VAR);
E=zeros(longitude,latitude);

 % Loop through each time step
 for T=1:time
              E=E+VAR(:,:,t);
 end 


F=F+E;
end

% Calculate annual average
AVE=F/(TimeStepPerDay*PER*365);
AVE=AVE';

% Write the results to a file
dlmwrite([Domain,'_',parameter,'_AVE_Annual_from',num2str(startYear),' to ',num2str(endYear),'.dat'], AVE, 'delimiter','\t');

end
end

