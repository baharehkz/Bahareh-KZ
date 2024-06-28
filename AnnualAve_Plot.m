%{
    Author: Bahareh Kamranzad
    Date: June 28, 2024
    Description: This MATLAB script is designed to plot annual averages of parameters in a domain. Input files should be yearly NetCDFs.
    Copyright (c) 2024, Bahareh Kamranzad. All rights reserved.
%}

clc
clear

% Define domain boundaries and temporal resolution
MinLong= -12; % Western boundary longitude
MaxLong= 3; % Eastern boundary longitude
MinLat= 49; % Southern boundary latitude
MaxLat= 61.5; % Northern boundary latitude
TemporalResolution=1;

% Calculate the number of time steps per day
TimeStepPerDay=24/TemporalResolution;

% Define time period for analysis
StartYear=1943;
EndYear=2022;
PER=10; % number of years considered for calculations of annual mean


% Calculate the number of years and periods
NumberofYears=EndYear-StartYear+1;
periods=NumberofYears/PER;

Domain='Domain';


ResX=0.25; % Resolution in x-direction (longitude)
ResY=0.25; % Resolution in y-direction (latitude)
NCOL=(MaxLong-MinLong)/ResX+1; % Number of columns
NROW=(MaxLat-MinLat)/ResY+1; % Number of rows

% Define parameters and their properties
parameters = {'msl', 'sst', 'i10fg'};
parametersLong = {'Mean Sea Level Pressure', 'Sea Surface Temperature', 'Wind Gust'};
units = {' (m)', ' (°C)', ' (m/s)'};

lower_limit = [0, 8.5, 0]; % Lower limits for plotting
upper_limit = [4, 14.5, 80]; % Upper limits for plotting


% Loop through each parameter
for paramIdx = 2:2
    parameter = parameters{paramIdx};
    unit = units{paramIdx};

% Loop through each period

for periodIdx = 1:periods
        startYear = StartYear + (periodIdx - 1) * PER;
        endYear = startYear + PER - 1;

% Load the data file
C=load([Domain,'_',parameter,'_AVE_Annual_from',num2str(StartYear),' to ',num2str(EndYear),'.dat']);

 if parameter=='sst'
                    C=C-273.15; % Convert Kelvin to Celsius if parameter is 'sst'
 end


% Plotting the data

x=MinLong:ResX:MaxLong;
y=MaxLat:-ResY:MinLat;
colormap jet
n=pcolor(x,y,C);
set(n,'EdgeColor', 'none');
h=colorbar;
h.FontSize = 16;
h.FontName = 'Times New Roman';
set(gca,'fontsize',16)
set(gca,'fontname','Times New Roman')
caxis([lower_limit(paramIdx), upper_limit(paramIdx)]);

% Saving plots in .emf (high quality) format
saveas(n,[Domain,'_',parameter,'_AVE_Annual_from',num2str(StartYear),' to ',num2str(EndYear),'.emf'])

% Set the title
title([' Annual mean ',parameters{paramIdx},unit,num2str(StartYear), ' to ', num2str(EndYear)]) 

% Saving plots in .png (lower quality)
saveas(n,[Domain,'_',parameter,'_AVE_Annual_from',num2str(StartYear),' to ',num2str(EndYear),'.png'])
end
end
