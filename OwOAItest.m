cd('C:\Users\zhuq\Documents\02Evapo\001OAI')

%% Save climate data from Office of Water OAI AWS to mat file named as OW_OAI_AWS1.mat

%A = xlsread('2019averagenew1124.xlsx',26,'B2:H400');
A = xlsread('Atmos41\Owhourly\421198.xlsx',1,'A2:J31000');

% % dd = str2num(A(:,1)); %date
% % Windshr = A(:,3);%Average wind Speed (m/s)
% % GRadhr = A(:,4); %Solar Radiation - Global (watts/Square Metre)
% % Temphr = A(:,5);%Air Temperature celsius degree (oC)
% % RHumhr = A(:,6);%Relative Humidity (Percent)
% % 
% % data1=[dd Windshr GRadhr Temphr RHumhr];
% % 
% % save OAI_OW_hourly1 data1 
% % 
% % load('OAI_OW_hourly1.mat');
% % whos Temphr;
% % G = findgroups(dd);
% % Tmin = splitapply(@min,Temphr,G);
% % Tmax = splitapply(@max,Temphr,G);
% % plot(Tmin, Tmax);

dd = A(:,1);
mm = A(:,2);
yy = A(:,3);
hh = A(:,4);
Windshr = A(:,7);%Average wind Speed (m/s)
GRadhr = A(:,8); %Solar Radiation - Global (watts/Square Metre)
Temphr = A(:,9);%Air Temperature celsius degree (oC)
RHumhr = A(:,10);%Relative Humidity (Percent)

data1=[dd mm yy hh Windshr GRadhr Temphr RHumhr];

save OAI_OW_hourly data1 

load('OAI_OW_hourly.mat');
whos Temphr;
G = findgroups(dd,mm,yy);
Tmin = splitapply(@min,Temphr,G);%aggregate to daily min Temperature
Tmax = splitapply(@max,Temphr,G);%aggregate to daily max Temperature

plot(Tmin);
hold on;
plot(Tmax);

% data2 = [Tmin Tmax T RG]; %save as cube for PET_HS algorism 
% save OAI_OW_HS

% [b, ~, n] = unique(yourArray(:,3) , 'first');
% firstColumn  = accumarray(n , yourArray(;,1) , size(b) , @(x) max(x));
% secondColumn = accumarray(n , yourArray(;,2) , size(b) , @(x) min(x));
% outputArray  = cat(2 , firstColumn , secondColumn , b);

% % [num,txt,raw]=xlsread('Atmos41\OoW_421198_1607_191118.xlsx');
% % VarNames=txt(3,2:2:30);
% % v2=matlab.lang.makeValidName(VarNames,'ReplacementStyle','delete');
% % 
% % time=datetime(txt(5:end,1),'inputformat','dd/MM/yyyy','timezone','Australia/Sydney');
% % time.TimeZone='UTC';
% % 
% % data=raw(5:end,2:2:14);
% % data=cell2mat(data);
% % 
% % OWdata=(data);
% % save OW_OAI_AWS3 OWdata

% %% load Climate observations from Office of Water AWS at Orange OAI from 30 Jun 2018 to 18 Nov 2019.  
% 
% clim='C:/Users/zhuq/Documents/02Evapo/02Atmos41/';
% owd=matfile([clim 'OW_OAI_AWS1.mat'],'writable',true);
% size(owd,'OWdata')