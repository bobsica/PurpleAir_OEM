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

ehgfs(1) = springX.e(2);
ehgfs(2) = summerX.e(2);
ehgfs(3) = fallX.e(2);
ehgfs(4) = winterX.e(2);
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
ehgfm = [janX.e(2) febX.e(2) marX.e(2) aprX.e(2) mayX.e(2) junX.e(2) julX.e(2) nan sepX.e(2) octX.e(2) novX.e(2) decX.e(2)];
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



