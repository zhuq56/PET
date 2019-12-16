% 20 Nov edit by EQZ

%% FAO56 Penman-Monteith
function [ETo]=ET_foa56(clim,alt,lat)
%climate variables
    rain=clim(:,2);
    tmax=clim(:,3);
    tmin=clim(:,4);
    temp=(tmax+tmin)./2;
    rad=clim(:,5);
    windten=clim(:,6); %wind from BARRA at 10m height [m s-1]
    doy=datenum2doy(clim(:,1));
%calculate the wind down to 2 meters by EQZ using FAO56 pp.56
    z = 10; % height of wind measurement
    wind = (windten * 4.87)./log(67.8 * z-5.64);
%     xy=size(clim);
%     if xy(2)==11;
%         wind=clim(:,11);
%         wind=wind-5;
%         i=find(wind<0.5);
%         wind(i)=0.5;
%     hum=clim(:,8);
%     else
%     wind=0.5;
%     hum=NaN;
%     end
%ETo reference evapotranspiration [mm day-1],
%G soil heat flux density [MJ m-2 day-1],
G=0;%note_assumptuion that soil heat flux is very small under opasture canopy at daily time step.
%wind wind speed at 2 m height [m s-1],
%es saturation vapour pressure [kPa],
Eomin=0.6108.*exp((17.27.*tmin)./(tmin+237.3));  % celsius to kelvin temperature, zero oC = 273.15 K
Eomax=0.6108.*exp((17.27.*tmax)./(tmax+237.3));
es=(Eomin+Eomax)./2;
%ea actual vapour pressure [kPa],
if isnan(hum)==1
   ea=Eomin;
else
ea=hum./100.*((Eomax+Eomin)./2);
end
%es - ea saturation vapour pressure deficit [kPa],
%S-slope vapour pressure curve [kPa °C-1],
S=(4098.*(0.6108.*exp((17.3.*temp)./(temp+237.1))))./(temp+237.3).^2;
% y-psychrometric constant [kPa °C-1].
P = 101.3*((293 -(0.0065)*alt)/293)^5.26;
y= 0.665*10^-3*(P); 
%Rn net radiation at the crop surface [MJ m-2 day-1],
%calculation of Ra (needed for clear sky radiation)
gsc=0.0820;
dr=1+0.033.*cos((2.*pi./365).*doy);
latr=pi/18*lat;
dec=0.409.*sin(((2.*pi./365).*doy)-1.39);
ws=acos(-tan(latr).*tan(dec));
Ra=24.*60./pi.*gsc.*dr.*(ws.*-(sin(latr).*sin(dec))+-(cos(latr).*cos(dec)).*sin(ws));%note I have put the negaves in!!
% calculation of long wave radiation (Rnl)
tempk=temp+273.16; %(temperature in degrees kelvin)
sc=4.9030e-009; %steffan-boltzmann constant
Rso=(0.75+2.0000e-005).*Ra;% clear sky radiation
Rnl=sc.*tempk.*(0.34-0.14.*sqrt(ea)).*(1.35.*(rad./Rso)-0.35); %long wave
Rn= ((1-0.23)*rad)-Rnl;

%FAO 56 equationequation
%ETo=(0.408*S.*(rad-G)+y.*(900./temp).*wind.*(es-ea))./(S+y.*(1+0.3.*wind));
ETo=(0.408*S.*(Rn-G)+y.*(900./(temp+273)).*wind.*(es-ea))./(S+y.*(1+0.3.*wind));
%EToCO2=(0.408*S.*(Rn-G)+y.*(900./(temp+273)).*wind.*(es-ea))./{S+y.*[1+wind.*(0.34+ 0.00024*(CO2-300))]};

ETo=real(ETo);

%% HS PET
 load /data/mounts/s01161-dpi-drought-isc/research/Data/Optimisation/spatial_parameters_v7
    param=cat(3,x1,x2,x3,x4-0.7,x4+0.7,x5,x6,x7); 
    clear x*
    x=[0.0023;17.8;0.5]; %(evaporation model parameters)    

%Run the simulation
disp(' *******running dpi-agrimod**********')

% Nov 10 2019 ETo as follows was Hargreavea-Samani temperature-based model rather than Priestley-Taylor - EQZ fixed 

for n=1:length(run)
    p=find(awap_date==run(n));
    ss=s.swat(:,:,p-1);gg=g.GI(:,:,p-1);
    disp(datestr(awap_date(p)))
    ETo= x(1).*(((tx.tmax(:,:,p)+tm.tmin(:,:,p))./2) + x(2)).*(tx.tmax(:,:,p) - tm.tmin(:,:,p)).^x(3).*rr.rad(:,:,p); %PET, Hargreaves-Samani model
    [pg.pgr(:,:,p),s.swat(:,:,p),g.GI(:,:,p)]= growest2_grid(r.rain(:,:,p),tx.tmax(:,:,p),tm.tmin(:,:,p),real(ETo),rr.rad(:,:,p),param,ss,gg,rad_mean(:,:,doy(p)));
end

%% Priestly-Taylor PET.
si=13;
load E:\soil_water_balance\sm_obs\sites_update\soil_agents
load (['E:\soil_water_balance\sm_obs\sites_update\' num2str(agents(si,1)) '_smobs']);
load (['E:\soil_water_balance\sm_obs\sites_update\aws_climate\' num2str(agents(si,1)) '_ews']);
data=ews_clim;
temp=(data(:,3)+data(:,4))./2
rad=data(:,5)

alt=200;
a=1.26;%empirical constant
L=1.46;%latent heat of evaporation (2.5*10^6 j/mm^-1)
A=(4098.*(0.6108.*exp((17.27.*temp)./(temp+237.3))))./(temp+237.3).^2;%slope of the vapour pressure-temperatute curve
P = 101.3*((293 -(0.0065)*alt)/293)^5.26;
y= 0.665*10^-3*(P);    %psychometric constant (~PaC^-1)
G=0;

PET=a.*A./(A+y).*rad-G;

plot(PET)

[ETo]=ET_foa56(data,alt)

%% Blaney & Criddle PET
kp = ;
Ta= ;
ETO_bc = kp * (0.46*Ta + 8.13);