load('April.mat')
%load('August.mat')
load('December.mat')
load('February.mat')
load('January.mat')
load('July.mat')
load('June.mat')
load('March.mat')
load('May.mat')
load('November.mat')
load('October.mat')
load('September.mat')

figure
startDate = datenum('02-01-2021');
endDate = datenum('03-31-2022');
xData = linspace(startDate,endDate,12);

hgmon = [marX.x(2),aprX.x(2),mayX.x(2),junX.x(2),julX.x(2),-9999,sepX.x(2),octX.x(2),novX.x(2),decX.x(2),janX.x(2),febX.x(2)];
hgmonSD = [marX.e(2),aprX.e(2),mayX.e(2),junX.e(2),julX.e(2),0.1,sepX.e(2),octX.e(2),novX.e(2),decX.e(2),janX.e(2),febX.e(2)];
errorbar(xData,hgmon,hgmonSD,':o','MarkerSize', 10, 'MarkerFaceColor','b', 'CapSize', 18)
ax = gca;
ax.XTick = xData;
datetick('x','mmm','keepticks')
xlim([738178 738621])
ylim([.2 .55])
xlabel('Monthly Average 2021-22')
ylabel('Aerosol Hygroscopicity Parameter')

hgmon(6) = NaN;
hgmonSD(6) = NaN;
mean(hgmon,'omitnan')
std(hgmon,'omitnan')

figure
const = [marX.x(1),aprX.x(1),mayX.x(1),junX.x(1),julX.x(1),-9999,sepX.x(1),octX.x(1),novX.x(1),decX.x(1),janX.x(1),febX.x(1)];
constSD = [marX.e(1),aprX.e(1),mayX.e(1),junX.e(1),julX.e(1),0.1,sepX.e(1),octX.e(1),novX.e(1),decX.e(1),janX.e(1),febX.e(1)];
errorbar(xData,const,constSD,':d','MarkerSize', 10, 'MarkerFaceColor','b', 'CapSize', 18)
ax = gca;
ax.XTick = xData;
datetick('x','mmm','keepticks')
xlim([738178 738621])
ylim([0 3.5])
xlabel('Monthly Average 2021-22')
ylabel('Offset')

const(6) = NaN;
constSD(6) = NaN;
mean(const,'omitnan')
std(const,'omitnan')

% original 2.17 +/- 0.76, 0.49 +/- 0.13
