clc
clear
MinLong= -12; % Western longitude
MaxLong= 3; % Eastern longitude
ResX=0.5; % resolution in x-direction
NCOL=(MaxLong-MinLong)/ResX+1; %number of columns
MinLat= 49; % Southern latitude
MaxLat= 61.5; % Northern latitude
ResY=0.5; % resolution in y-direction
NROW=(MaxLat-MinLat)/ResY+1; %number of rows
TemporalResolution=1;
TimeStepPerDay=24/TemporalResolution;
StartYear=2015;
EndYear=2020;
NumberofYears=EndYear-StartYear+1;
Domain='UK';
PAR={'swh','mwp'};
UNIT={' (m)',' (s)'};
directory='D:\UK\Wave\';
for k=1:2
parameter=PAR{k};
DaY=[31 28 31 30 31 30 31 31 30 31 30 30];
e=0;   
for month=1:12
    G=zeros(NCOL,NROW);    
for yr=1:1:NumberofYears
    E=zeros(NCOL,NROW);
    VAR=ncread([directory,'UK_Wave_',num2str(yr+StartYear-1),'.nc'],parameter);  
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


