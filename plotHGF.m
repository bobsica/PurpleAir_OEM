function plotHGF(RHpAirErr)
% plot HGF
%clear all; close all

load Hourly_spring;
load Hourly_summer;
load Hourly_fall;
load Hourly_winter;

hgfs(1) = springX.x(2);
hgfs(2) = summerX.x(2);
hgfs(3) = fallX.x(2);
hgfs(4) = winterX.x(2);

HGFs(1) = springX.HGF;
HGFs(2) = summerX.HGF;
HGFs(3) = fallX.HGF;
HGFs(4) = winterX.HGF;

ehgfso(1) = springX.eo(2);
ehgfso(2) = summerX.eo(2);
ehgfso(3) = fallX.eo(2);
ehgfso(4) = winterX.eo(2);
ehgfsRH(1) = springX.RHerr;
ehgfsRH(2) = summerX.RHerr;
ehgfsRH(3) = fallX.RHerr;
ehgfsRH(4) = winterX.RHerr;
ehgfs = sqrt(ehgfso.^2 + ehgfsRH.^2);

xs = [1 2 3 4];
%'hgfs mean/sd'
mms = mean(hgfs)
sss = std(hgfs)

figure
h = errorbar(xs,hgfs,ehgfso,"ro:");
hold on
hh = errorbar(xs,hgfs,ehgfsRH,"bo:");
axis([0.5 4.5 0.2 0.6])
xlabel Season
ylabel 'Hygroscopic Growth Factor'
xticks([1:1:4])
xticklabels({'Spring','Summer','Fall','Winter'})
supersizeme(1.2)
h.MarkerSize = 12;
h.MarkerFaceColor = 'red';
if RHpAirErr == .025
    title('2.5% Relative Humidity Uncertainty');
    saveas(gcf,'season2d5percent.pdf')
else
    title('1% Relative Humidity Uncertainty');
    saveas(gcf,'season1percent.pdf')
end

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
HGFm = [janX.HGF febX.HGF marX.HGF aprX.HGF mayX.HGF junX.HGF julX.HGF nan sepX.HGF octX.HGF novX.HGF decX.HGF];

xm = [1:1:12];
%'hgfm mean/sd'
mm = mean(hgfm(~isnan(hgfm)))
ss = std(hgfm(~isnan(hgfm)))

figure
h = errorbar(xm,hgfm,ehgfmo,"ro:");
hold on
hh = errorbar(xm,hgfm,ehgfmRH,"bo:");
axis([0.5 12.5 0.2 0.6])
xlabel Month
ylabel 'Hygroscopic Growth Factor'
xticks([1:1:12])
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
supersizeme(1.2)
h.MarkerSize = 12;
h.MarkerFaceColor = 'red';
if RHpAirErr == .025
    title('2.5% Relative Humidity Uncertainty');
    saveas(gcf,'monthly2d5percent.pdf')
else
    title('1% Relative Humidity Uncertainty');
    saveas(gcf,'monthly1percent.pdf')
end

% decX.eo
% decX.RHerr
% sqrt(decX.eo.^2 + decX.RHerr.^2)

figure
plot(xm,HGFm)

