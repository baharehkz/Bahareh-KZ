clc
clear

MinLat= -12;
% south latitude

MaxLat= 3;
% north latitude

MinLong= 49;
% west longitude

MaxLong= 61.5;
% east longitude

ResX=0.5;
% resolution in x-direction


ResY=0.5;
% resolution in y-direction

TemporalResolution=1;
Domain='Asia';
VARShort={'swh','mwp', };
VARLong={'Significant height of combined wind waves and swell', 'mean wave period', };
UNIT={' (m)',' (s)'};
% maxlimit=[33, 13, 18, 18 ];

for year=2010:2014
    for k=1:2 % k is the parameter to be read from .nc file in each loop
        Variable=VARShort{k};   
        VAR=ncread([Domain,'_Wave_',num2str(year),'.nc'],Variable);
        % in NC files, the long and lats are transposed.
        [longitude,latitude, time] = size(VAR);

        for t=1:time
        A=zeros(latitude,longitude);

        for i= 1:longitude
            for j=1:latitude
                B=A(i,j);
                
                    B(t,1)=VAR(i,j,t);
                end
                A(j,i)=max(max(B));
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
        set(gca,'fontsize',22)
        set(gca,'fontname','Times New Roman')
        caxis([0 maxlimit(k)]);
        
        title([VARLong{k},' (m), ',num2str(year)]) 
        saveas(n,[Domain,'_', Variable,'_',num2str(ResX),' deg_',num2str(TemporalResolution),' hourly_',num2str(year),'_MAX.png'])

        dlmwrite([Domain,'_', Variable,'_',num2str(ResX),' deg_',num2str(TemporalResolution),' hourly_',num2str(year),'_MAX.dat'], A, 'delimiter','\t');
             
    end
end