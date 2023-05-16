% plot HGF
clear all; close all

load Hourly_spring;
load Hourly_summer;
load Hourly_fall;
load Hourly_winter;

hgfs(1) = springX.x(2);
hgfs(2) = summerX.x(2);
hgfs(3) = fallX.x(2);
hgfs(4) = winterX.x(2);

ehgfso(1) = springX.eo(2);
ehgfso(2) = summerX.eo(2);
ehgfso(3) = fallX.eo(2);
ehgfso(4) = winterX.eo(2);
ehgfsRH(1) = springX.RH(2);
ehgfsRH(2) = summerX.RH(2);
ehgfsRH(3) = fallX.RH(2);
ehgfsRH(4) = winterX.RH(2);
ehgfs = sqrt(ehgfso.^2 + ehgfsRH.^2);

xs = [1 2 3 4];
'hgfs mean/sd'
mean(hgfs)
std(hgfs)

figure
errorbar(xs,hgfs,ehgfs,"ro:")
axis([0.5 4.5 0.38 0.48])
xlabel Season
ylabel 'Hygroscopic Growth Factor'
xticks([1:1:4])
xticklabels({'Spring','Summer','Fall','Winter'})
supersizeme(1.2)

load December.mat
load November.mat
load October.mat
load September.mat
load July.mat
load June.mat
load May.mat
load April.mat
load March.mat
load February.mat
load January.mat

hgfm = [janX.x(2) febX.x(2) marX.x(2) aprX.x(2) mayX.x(2) junX.x(2) julX.x(2) nan sepX.x(2) octX.x(2) novX.x(2) decX.x(2)];
ehgfmo = [janX.eo(2) febX.eo(2) marX.eo(2) aprX.eo(2) mayX.eo(2) junX.eo(2) julX.eo(2) nan sepX.eo(2) octX.eo(2) novX.eo(2) decX.eo(2)];
ehgfmRH = [janX.RHerr febX.RHerr marX.RHerr aprX.RHerr mayX.RHerr junX.RHerr julX.RHerr nan sepX.RHerr octX.RHerr novX.RHerr decX.RHerr];
ehgfm = sqrt(ehgfmo.^2 + ehgfmRH.^2);

xm = [1:1:12];
'hgfm mean/sd'
mean(hgfm(~isnan(hgfm)))
std(hgfm(~isnan(hgfm)))
%mean(hgfm)
%std(hgfm)

figure
h = errorbar(xm,hgfm,ehgfm,"ro:");
axis([0.5 12.5 0.2 0.55])
xlabel Month
ylabel 'Hygroscopic Growth Factor'
xticks([1:1:12])
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
supersizeme(1.2)

decX.eo
decX.RHerr
sqrt(decX.eo.^2 + decX.RHerr.^2)

