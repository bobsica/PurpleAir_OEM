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

%go = 1; stop = 2207; period = 'Hourly_spring'
%go = 1; stop = 1696; period = 'Hourly_summer'
%go = 1; stop = 1754; period = 'Hourly_fall'
%go = 1; stop = 2120; period = 'Hourly_winter'

%go = 730; stop = 1460; period = 'Hourly_winter' % January
%go = 1461; stop = 2120; period = 'Hourly_winter' % February
%go = 1; stop = 743; period = 'Hourly_spring' % March
%go = 744; stop = 1463; period = 'Hourly_spring' % April
%go = 1464; stop = 2207; period = 'Hourly_spring' % May
%go = 1; stop = 663; period = 'Hourly_summer' % June; skip point 664, is Nan
%go = 665; stop = 1388; period = 'Hourly_summer' % July
% no august
%go = 1; stop = 303; period = 'Hourly_fall' % September
%go = 304; stop = 1043; period = 'Hourly_fall' % October
%go = 1044; stop = 1754; period = 'Hourly_fall' % November
go = 1; stop = 729; period = 'Hourly_winter' % December

%go = 665; stop = 1594; period = 'Hourly_summer' % July 1594 is august jump
%go = 1595; stop = 1696; period = 'Hourly_summer' % July 1594 is august jump
%go = 1316; stop = 1388; period = 'Hourly_summer' % July 1594 is august jump

% get data from excel file
[ii,t,r] = xlsread('./Example/averaged_data.xlsx',period);

% 2nd index, RHS was 2, 3, 4, 6
hrs = ii(go:stop,2); % hours
min_avgs = ii(go:stop,3);  % ministry PM2.5 data
pm_avgs = ii(go:stop,4);  % purpleair PM2.5 data
rh_avgs = ii(go:stop,5);  % purpleair RH data
T_avgs = ii(go:stop,7);  % purpleair T data; column 6 if F, 7 is Kelvin

%set R, retrieval structure
R = [];
R.jq = {};
R.ji = {};
iter = 0;

% O, input structure
O = defOreal;

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

% Y, data structure for 'measurement vector'. This is the ministry data
% because that is an example of output from the forward model
Y.Y = min_avgs;
% covariance matrix. ministry sensor has 5% accuracy, plus added 0.5 since
% integer rounding
%Y.Yvar = (0.5 + 0.05*min_avgs).^2;
Y.Yvar = min_std.^2 + (0.05*min_avgs).^2; % Bob modified with min SD above

Se = diag(Y.Yvar);

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
X.x

% RH contribution to HGF error
expo = Q.RH.*exp(-Q.b./(Q.T*Q.Dp));
K_RH = (expo./Q.RH) .* (Q.Y-(2+X.x(2))./(1-expo.*(1+X.x(2)).^2));
%S_RH = (0.05.*Q.RH).^2; % 5% error
%RHvar = X.G(2,:)*K_RH*S_RH*K_RH'*X.G(2,:)';
S_RH = (0.5).^2
RHvar = X.G(2,:)*K_RH*S_RH*K_RH'*X.G(2,:)';
RHerr = sqrt(RHvar);
%RHerrMean = sqrt((sum(1./RHvar)).^-1);

% apply forward model to get corrected purpleair data
exponent = Q.RH.*exp(-Q.b./(T_avgs*Q.Dp));
pm_corrected = X.x(1) + pm_avgs ./ (1 + X.x(2)*exponent./(1 - exponent));

% fit check
%'Uncorrected'
[slp,sigmaslp,regAvg]=fitline0(pm_avgs,min_avgs);
%'Corrected'
[slpc,sigmaslpc,regCorr]=fitline0(pm_corrected,min_avgs);
X.slp = slp;
X.sigmaslp = sigmaslp;
X.regAvg = regAvg;
X.slpc = slpc;
X.sigmaslpc = sigmaslpc;
X.regCorr = regCorr;
X.RHerr = RHerr;

%springX = X;
%save('Hourly_spring.mat','springX')
%summerX = X;
%save('Hourly_summer.mat','summerX')
%fallX = X;
%save('Hourly_fall.mat','fallX')
%winterX = X;
%save('Hourly_winter.mat','winterX')

%janX = X;
%save('January.mat','janX')
%febX = X;
%save('February.mat','febX')
%marX = X;
%save('March.mat','marX')
%aprX = X;
%save('April.mat','aprX')
%mayX = X;
%save('May.mat','mayX')
%junX = X;
%save('June.mat','junX')
%julX = X;
%save('July.mat','julX')
%augX = X;
%save('August.mat','augX')
%sepX = X;
%save('September.mat','sepX')
%octX = X;
%save('October.mat','octX')
%novX = X;
%save('November.mat','novX')
decX = X;
save('December.mat','decX')

