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
TemporalResolution=1; % temporal resolution in hour
TimeStepPerDay=24/TemporalResolution;
StartYear=2015;
EndYear=2020;
NumberofYears=EndYear-StartYear+1;
directory='D:\Wave\';
VARShort={'swh','mwp', }; % Add parameters here
VARLong={'Significant height of combined wind waves and swell', 'mean wave period', };
maxlimit=[18, 18 ]; % Define maximum limit for each parameter
for year=StartYear:EndYear
    for k=1:1 % k is the parameter to be read from .nc file in each loop
        Variable=VARShort{k};   
        VAR=ncread([directory,'Wave_',num2str(year),'.nc'],Variable); % change filename
        [longitude,latitude, time] = size(VAR);         
        A=zeros(NROW,NCOL);
        for i= 1:NROW
            for j=1:NCOL  
                B=zeros(time,1);  
                  for t=1:time
                    B(t,1)=VAR(j,i,t);                    
                end
                A(i,j)=max(max(B));
            end
        end
        A(A==-999)=NaN;
        x=MinLong:ResX:MaxLong;
        y=MaxLat:-ResY:MinLat;
        shading interp;
        set(gca, 'Color', [0.7 0.7 0.7]);
        colormap jet
        n=pcolor(x,y,A);
        set(n,'EdgeColor', 'none');
        colorbar;
        h.FontSize = 22;
        h.FontName = 'Times New Roman';
        set(gca,'fontsize',16)
        set(gca,'fontname','Times New Roman')
        caxis([0 maxlimit(k)]);        
        title([VARLong{k},' (m), ',num2str(year)]) 
        saveas(n,[Domain,'_', Variable,'_',num2str(ResX),' deg_',num2str(TemporalResolution),' hourly_',num2str(year),'_MAX.png'])
        dlmwrite([Domain,'_', Variable,'_',num2str(ResX),' deg_',num2str(TemporalResolution),' hourly_',num2str(year),'_MAX.dat'], A, 'delimiter','\t');  
    end
end