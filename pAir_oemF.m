function pAir_oemF(witch,RHpAirErr,iplt)
% pAir_oem
% Optimal Estimation Method applied to PurpleAir calibration
% with a physical model from Malings et al
%
% PA = (PM/f) + c
% where f = 1 + k(a/(1-a))
% and a = RH / e^(-b/TDp)
% our retrieved x(1) is c and x(2) is k
% data is PM, RH, T
% b is known constants

% Jill had for summer 664:1387
% go = 664; stop = 1387; 
% test: go = 25; stop = 49;


if witch == 13
    go = 1; stop = 2207; period = 'Hourly_spring'; titl = 'Spring Hourly';
elseif witch  == 14
    go = 1; stop = 1696; period = 'Hourly_summer'; titl = 'Summer Hourly';
elseif witch  == 15
    go = 1; stop = 1754; period = 'Hourly_fall'; titl = 'Autumn Hourly';
elseif witch  == 16
    go = 1; stop = 2120; period = 'Hourly_winter'; titl = 'Winter Hourly';
elseif witch  == 1
    go = 730; stop = 1460; period = 'Hourly_winter'; titl = 'January Hourly';% January
elseif witch  == 2
    go = 1461; stop = 2120; period = 'Hourly_winter'; titl = 'February Hourly';% February
elseif witch  == 3
    go = 1; stop = 743; period = 'Hourly_spring'; titl = 'March Hourly'; %March
elseif witch  == 4
    go = 744; stop = 1463; period = 'Hourly_spring'; titl = 'April Hourly'; %April
elseif witch  == 5
    go = 1464; stop = 2207; period = 'Hourly_spring'; titl = 'May Hourly';% May
elseif witch  == 6
    go = 1; stop = 663; period = 'Hourly_summer'; titl = 'June Hourly';% June; skip point 664, is Nan
elseif witch  == 7
    go = 665; stop = 1388; period = 'Hourly_summer'; titl = 'July Hourly';% July
elseif witch  == 8
    'barf' % no august
    return
elseif witch  == 9
    go = 1; stop = 303; period = 'Hourly_fall'; titl = 'September Hourly';% September
elseif witch  == 10
    go = 304; stop = 1043; period = 'Hourly_fall'; titl = 'October Hourly';% October
elseif witch  == 11
    go = 1044; stop = 1754; period = 'Hourly_fall'; titl = 'November Hourly';% November
elseif witch  == 12
    go = 1; stop = 729; period = 'Hourly_winter'; titl = 'December Hourly';% December
elseif witch  == 21
    go = 247; stop = 336; period = 'Daily'; titl = 'Daily Winter'; % 336 Winter; subtract one from start/stop
elseif witch  == 22
    go = 1; stop = 92; period = 'Daily'; titl = 'Daily Spring'; %spring
elseif witch  == 23
    go = 93; stop = 171; period = 'Daily'; titl = 'Daily Summer'; %summer
elseif witch  == 24
    go = 172; stop = 246; period = 'Daily'; titl = 'Daily Autumn'; %fall
else
    'no data read'
    return
end

%go = 665; stop = 1594; period = 'Hourly_summer' % July 1594 is august jump
%go = 1595; stop = 1696; period = 'Hourly_summer' % July 1594 is august jump
%go = 1316; stop = 1388; period = 'Hourly_summer' % July 1594 is august jump

% get data from excel file
% averaged_date"2" means the new sheet with June and July daily averages
[ii,t,r] = xlsread('./Example/averaged_data2.xlsx',period);
%[ii,t,r] = xlsread('./Example/averaged_data.xlsx',period);

% Y, data structure for 'measurement vector'. This is the ministry data
% because that is an example of output from the forward model
% variance calculated below

% 2nd index, RHS was 2, 3, 4, 6
if witch > 20
%    hrs = ii(go:stop,2); % hours
    min_avgs = ii(go:stop,2);  % ministry PM2.5 data
    pm_avgs = ii(go:stop,3);  % purpleair PM2.5 data
    rh_avgs = ii(go:stop,4);  % purpleair RH data
    T_avgs = ii(go:stop,6);  % purpleair T data; column 6 if F, 7 is Kelvin
    min_sd = ii(go:stop,7);
% covariance matrix. ministry sensor has 5% accuracy, plus added 0.5 since
% integer rounding
    Y.Y = min_avgs;
%    Y.Yvar = (0.5*ones(size(min_avgs))).^2;
%    Y.Yvar = (0.5 + 0.05*min_avgs).^2;
    Y.Yvar = (0.5 + min_sd).^2;
else
    hrs = ii(go:stop,2); % hours
    min_avgs = ii(go:stop,3);  % ministry PM2.5 data
    pm_avgs = ii(go:stop,4);  % purpleair PM2.5 data
    rh_avgs = ii(go:stop,5);  % purpleair RH data
    T_avgs = ii(go:stop,7);  % purpleair T data; column 6 if F, 7 is Kelvin
% ministry SD (Bob)
    [rows,col] = size(ii(go:stop,3));
    min_std = size(rows);
    numinSD = size(rows);
    minH(1) = min_avgs(1);
    jj = 0;
    k = 0;
    for j = 2:rows
        if hrs(j-1) < hrs(j)
            k = k + 1;
            minH(k) = min_avgs(j);
        else %if
            numinSD(j-length(minH):j) = k;
            minSTD = std(minH);
            min_std(j-length(minH):j) = minSTD;
            minH = [];
            k = 0;
        end
    end
    % on exit, fix first value, write out last group and transpose vector
    min_std(1) = min_std(2);
    numinSD(j-length(minH):j) = k;
    minSTD = std(minH);
    min_std(j-length(minH):j) = minSTD;
    min_std = min_std';
    numinSD = numinSD';
% end Bob code (except for using the newly computed SDEV below
    Y.Y = min_avgs;
    Y.Yvar = min_std.^2 + (0.05*min_avgs).^2; % Bob modified with min SD above
end %if 

% code for missing June/July averages
if witch == 6 || witch == 7
check = diff(ii(go:stop,2));
buff(1) = ii(go,4);
mm = 0;
nn = 2;
kk = 0;
for jj = go+1:stop
    kk = kk + 1;
    if check(kk) > 0 
        buff(nn) = ii(jj,4);
        nn = nn + 1;
    else
        mm = mm + 1;
        pav(mm) = mean(buff);
        pavsd(mm) = std(buff);
        buff = zeros(size(buff(nn-1)));
        nn = 1;
    end %if
end
mm = mm + 1;
pav(mm) = mean(buff);
pavsd(mm) = std(buff);
end %if

Se = diag(Y.Yvar);

%set R, retrieval structure
R = [];
R.jq = {};
R.ji = {};
iter = 0;

% O, input structure
O = defOreal;

% Q, Forward model structure. This is the purpleair pm2.5 and RH data
% because that is what is used as data in our forward model
Q.Y = pm_avgs;
Q.RH = (rh_avgs / 100)+0.21;
Q.T = T_avgs;
sigma = 0.072; % water surface tension N/m
M = 0.018; % water molecular weight kg/mol
rho = 1000; % water density kg/m3
Rgas = 8.314; % ideal gas constant J/mol K
Q.b = 4*sigma*M/(rho*Rgas);
Q.Dp = 0.0000002; % particle diameter m

n = 2; % retrieving i, k

% set a priori coefficients
%x_a = [2.5;0.25]; % ; for column vector
%x_sd = [2.5,0.1*x_a(2)];
% above 2.5 +/- 2.5 is from Malings et al; HGF from Ceurelly et al.

% below is after re-running set with above
x_a = [1.9;0.25];
x_sd = [0.66,0.1*x_a(2)];

%x_var = [0.001*x_a(1)^2,0.5.*x_a(2)^2]; %was 0.5; , for row vector..
%x_a = [1.5;0.5]; %2.2
%x_var = [0.76.^2,0.1.^2];
x_var = x_sd.^2;
S_a = diag(x_var);

S_ainv = [];
Seinv = [];
[X,R] = oem(O,Q,R,@pAirmakeJ_physical,S_a,Se,S_ainv,Seinv,x_a,Y.Y);
%X.x

% RH contribution to HGF error
dEdH = exp(-Q.b./(Q.T*Q.Dp));
dycdE = (X.x(2).*Q.Y) ./ (1-Q.RH.*(1-X.x(2))).^2;
K_RH = dEdH .* dycdE;
S_RH = (RHpAirErr).^2;
RHvar = X.G(2,:)*K_RH*S_RH*K_RH'*X.G(2,:)';
RHerr = sqrt(RHvar);

% apply forward model to get corrected purpleair data
expo = Q.RH .* exp(-Q.b./(Q.T.*Q.Dp));
expom = mean(Q.RH) .* exp(-Q.b./(mean(Q.T).*Q.Dp));
pm_corrected = X.x(1) + pm_avgs ./ (1 + X.x(2)*expo./(1 - expo));
HGF = 1 + X.x(2).*(expom./(1-expom));

% fit check
%'Uncorrected'
%[slp,sigmaslp,regAvg]=fitline0(pm_avgs,min_avgs);
[slp,sigmaslp,regAvg]=fitline0(min_avgs,pm_avgs);
%'Corrected'
%[slpc,sigmaslpc,regCorr]=fitline0(pm_corrected,min_avgs);
[slpc,sigmaslpc,regCorr]=fitline0(min_avgs,pm_corrected);
X.slp = slp;
X.sigmaslp = sigmaslp;
X.regAvg = regAvg;
X.slpc = slpc;
X.sigmaslpc = sigmaslpc;
X.regCorr = regCorr;
X.RHerr = RHerr;
X.HGF = HGF;

% regression method
% this is finally correct as of 2 Apr 2024
parms = [pm_avgs,rh_avgs];
mdl = fitlm(parms,min_avgs);
coeffs = table2array(mdl.Coefficients(1:3,1));
statFit = coeffs(2).*pm_avgs + coeffs(3).*rh_avgs + coeffs(1); 
X.coeffs = coeffs;
X.mdl = mdl;
% figure;
% hh = plotAdjustedResponse(mdl,'x1'); % adjusted fit of model using only
% pm_avgs (x1), not RH (x2)
% hhh = hh(1);
% xFit = hhh.XData;
% yFit = hhh.YData;
%close(gcf)

nloop = length(pm_corrected);
ntest = length(Y.Y);
if nloop == ntest
    mae = sum(abs(pm_corrected-Y.Y))./nloop;
    maeStat = sum(abs(statFit-Y.Y))./nloop;
    bias = sum(pm_corrected-Y.Y)./nloop;
    biasStat = sum(statFit-Y.Y)./nloop;
    rms = rmse(pm_corrected,Y.Y);
    rmsStat = rmse(statFit,Y.Y);
    X.mae = mae;
    X.maeStat = maeStat;
    X.bias = bias;
    X.biasStat = biasStat;
    X.rms = rms;
    X.rmsStat = rmsStat;
else
    'number of pAir samples and ministry not equal'
    'no data written'
    return
end %if

if iplt == 1
    grayColor = [.4 .4 .4]; % larger number ligher gray
    H1 = figure;
    plot(min_avgs,pm_avgs,'LineStyle','none','Marker','x','Color',grayColor);
    hold on
    plot(min_avgs,pm_corrected,'ro')
    plot(min_avgs,statFit,'bx')
    pmax = max(pm_avgs);
    pmax = ceil(pmax/10)*10; % round up to near 5; use 10 for 10
%    'daily plot scaling is'
    pmax = 60;
    plot([0 pmax],[0 pmax],'k')
    axis([0 pmax 0 pmax])
    xlabel(['Ministry PM2.5 ','$(\mu g/m^3)$'],'interpreter','latex')
    ylabel(['Purple Air PM2.5 ','$(\mu g/m^3)$'],'interpreter','latex')
    legend('Raw pAir','OEM pAir','MLR pAir');
    title(titl)
    set(gca,'Box','on');
% plots coded by RH
    plttab = table(min_avgs,pm_avgs,pm_corrected,rh_avgs);
    H2 = figure;
    scat = scatter(plttab,'min_avgs','pm_corrected','filled','ColorVariable','rh_avgs');
    scat.SizeData = 50; % size of dots NOT RH scaling
    hold on
%    plot(min_avgs,pm_avgs,'x','Color',grayColor)
    pmax = max(pm_corrected); % max(pm_avgs)
    pmax = ceil(pmax/10)*10; % round up to near 5; use 10 for 10
%    'hourly plot scaling is'
    pmax = 45;
    plot([0 pmax],[0 pmax],'k')
    axis([0 pmax 0 pmax])
    ccc = colorbar;
    ccc.Label.Interpreter = 'latex'; %keeps all fonts the same
    ccc.Label.String = 'Relative Humidity (\%)';
    colormap(jet)
    xlabel(['Ministry PM2.5 ','$(\mu g/m^3)$'],'interpreter','latex')
    ylabel(['Purple Air PM2.5 ','$(\mu g/m^3)$'],'interpreter','latex')
    title(titl)
    set(gca,'Box','on');
end %if

if witch  == 13
    springX = X;
    save('Hourly_spring.mat','springX')
    savefig(H1,'hourly-spring.fig')
    savefig(H2,'hourly-spring-RH.fig')
elseif witch  == 14
    summerX = X;
    save('Hourly_summer.mat','summerX')
    savefig(H1,'hourly-summer.fig')
    savefig(H2,'hourly-summer-RH.fig')
elseif witch  == 15
    fallX = X;
    save('Hourly_fall.mat','fallX')
    savefig(H1,'hourly-fall.fig')
    savefig(H2,'hourly-fall-RH.fig')
elseif witch  == 16
    winterX = X;
    save('Hourly_winter.mat','winterX')
    savefig(H1,'hourly-winter.fig')
    savefig(H2,'hourly-winter-RH.fig')
elseif witch  == 1
    janX = X;
    save('January.mat','janX')
    savefig(H1,'January.fig')
    savefig(H2,'January-RH.fig')
elseif witch  == 2
    febX = X;
    save('February.mat','febX')
    savefig(H1,'February.fig')
    savefig(H2,'February-RH.fig')
elseif witch  == 3
    marX = X;
    save('March.mat','marX')
    savefig(H1,'March.fig')
    savefig(H2,'March-RH.fig')
elseif witch  == 4
    aprX = X;
    save('April.mat','aprX')
    savefig(H1,'April.fig')
    savefig(H2,'April-RH.fig')
elseif witch  == 5
    mayX = X;
    save('May.mat','mayX')
    savefig(H1,'May.fig')
    savefig(H2,'May-RH.fig')
elseif witch  == 6
    junX = X;
    save('June.mat','junX')
    save('pAVGjune.mat','pav','pavsd')
    savefig(H1,'June.fig')
    savefig(H2,'June-RH.fig')
elseif witch  == 7
    julX = X;
    save('July.mat','julX')
    save('pAVGjuly.mat','pav','pavsd')
    savefig(H1,'July.fig')
    savefig(H2,'July-RH.fig')
elseif witch  == 8
    augX = X;
    save('August.mat','augX')
    savefig(H1,'August.fig')
    savefig(H2,'August-RH.fig')
elseif witch  == 9
    sepX = X;
    save('September.mat','sepX')
    savefig(H1,'September.fig')
    savefig(H2,'September-RH.fig')
elseif witch  == 10
    octX = X;
    save('October.mat','octX')
    savefig(H1,'October.fig')
    savefig(H2,'October-RH.fig')
elseif witch  == 11
    novX = X;
    save('November.mat','novX')
    savefig(H1,'November.fig')
    savefig(H2,'November-RH.fig')
elseif witch  == 12
    decX = X;
    save('December.mat','decX')
    savefig(H1,'December.fig')
    savefig(H2,'December-RH.fig')
elseif witch  == 21
    winDX = X;
    save('daily-winter.mat','winDX')
    savefig(H1,'daily-winter.fig')
    savefig(H2,'daily-winter-RH.fig')
elseif witch  == 22
    sprDX = X;
    save('daily-spring.mat','sprDX')
    savefig(H1,'daily-spring.fig')
    savefig(H2,'daily-spring-RH.fig')
elseif witch  == 23
    sumDX = X;
    save('daily-summer.mat','sumDX')
    savefig(H1,'daily-summer.fig')
    savefig(H2,'daily-summer-RH.fig')
elseif witch  == 24
    fallDX = X;
    save('daily-fall.mat','fallDX')
    savefig(H1,'daily-fall.fig')
    savefig(H2,'daily-fall-RH.fig')
end
return


