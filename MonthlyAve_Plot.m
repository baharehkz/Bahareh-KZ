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
MaxLat= 10; % Northern latitude
ResY=0.5; % resolution in y-direction
NROW=(MaxLat-MinLat)/ResY+1; %number of rows
TemporalResolution=1;
TimeStepPerDay=24/TemporalResolution;
StartYear=2015;
EndYear=2020;
PAR={'swh','mwp','Wave Power'};
UNIT={' (m)',' (s)',' (kW/m)'};
lower_limit=[0 0 0];
upper_limit=[5 14 160];
% specify the limits for each parameter. 
Months=12;
for k=1:3
parameter=PAR{k};
unit=UNIT{k}; 
images=cell(Months,1);
for m=1:Months
C=load([parameter,'_AVE_month-',num2str(m),'.dat']);

%plotting the files for each year
x=MinLong:ResX:MaxLong;
y=MaxLat:-ResY:MinLat;
colormap jet
n=pcolor(x,y,C);
set(n,'EdgeColor', 'none');
h=colorbar;
h.FontSize = 16;
h.FontName = 'Times New Roman';
set(gca,'fontsize',12)
set(gca,'fontname','Times New Roman')
caxis([lower_limit(k) upper_limit(k)])

%saving plots in .emf (high quality) format
saveas(n,[parameter,'_AVE_month-',num2str(m),'.emf'])

%saving plots in .png (lower quality)
title([' monthly mean ',parameter,unit,'-month ',num2str(m)]) 
saveas(n,[parameter,'_AVE_month-',num2str(m),'.png'])
end
end
