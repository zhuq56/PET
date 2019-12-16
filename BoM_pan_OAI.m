% plotting accumulated annual evaporation of (0)63254 Orange OAI

source_dir = 'C:\Users\zhuq\Documents\02Evapo\001OAI\SILO';
cd (source_dir); 

% ss1 = sheetnames('2019averagenew1124.xlsx'); %load sheets name including (0)63254 Orange OAI.

subplot(1,2,1);

%for i = 1:length(ss1)
    %subplot(5,6,i);
%A = xlsread('2019averagenew1124.xlsx',26,'B2:H400');
A = xlsread('063254_1208.xlsx',3,'B2:H400');

%    display(i);
%     value = 0;

    for yy = 1:1:7
        for j = 1:1:366
            if (j==1)
                AccEvapor.result(j,yy) = A(j,yy);
            else
            AccEvapor.result(j,yy) = AccEvapor.result(j-1,yy)+ A(j,yy);
            end
        end
    end
     
y13 = AccEvapor.result(:,1);
y14 = AccEvapor.result(:,2);
y15 = AccEvapor.result(:,3);    
y16 = AccEvapor.result(:,4);    
y17 = AccEvapor.result(:,5);
y18 = AccEvapor.result(:,6);
y19 = AccEvapor.result(:,7);
            
plot(y13,':','DisplayName','2013','color',[0.6 0.6 0.6]);
hold on;
plot(y14,':','DisplayName','2014','color',[0.6 0.6 0.6]);
plot(y15,':','DisplayName','2015','color',[0.6 0.6 0.6]);
plot(y16,':','DisplayName','2016','color',[0.6 0.6 0.6]);
plot(y17,':','DisplayName','2017','color',[0.6 0.6 0.6]);
plot(y18,'DisplayName','2018');
plot(y19,'DisplayName','2019');
% plot(y20,'DisplayName','Aver',[0.6 0.6 0.6]);
hold off;

    datetick('x','mmmyy');
%     grid on;
    lgd = legend;
%     lgd.NumColumns = 2;
    set(gca,'xtick',15:31:366,...
    'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
xlim ([0 366]);
ylim ([0 2000]);
ylabel('Evaporation (mm)') % y-axis label
title('063254 Orange OAI');

%% plot shade 2013-2019

subplot(1,2,2);
B = xlsread('shadeOAI.xlsx',1,'A1:K400');

%%
% We can calculate the daily range across all years, and plot these bounds
% along with the mean

y19 = B(:,8);

dy = B(:,1);
evamin = B(:,9);
evamax = B(:,10);
evamean = B(:,11);
bnd = [evamean - evamin, evamax - evamean];

cla;
boundedline(dy, evamean, bnd);
hold on;
% plot(y18,'DisplayName','2018');
plot(y19,'DisplayName','2019','color',[0.9100 0.4100 0.1700]);
hold off;  

    datetick('x','mmmyy');
%     grid on;
    lgd = legend;
%     lgd.NumColumns = 2;
    set(gca,'xtick',15:31:366,...
    'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
xlim ([0 366]);
ylim ([0 2000]);
ylabel('Evaporation (mm)') % y-axis label
title('063254 Orange OAI');

% fig = gcf;
% fig.PaperPositionMode = 'auto';
% print('shadeOAI','-dpng','-r300');

    
