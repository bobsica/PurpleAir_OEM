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

go = 1; stop = 1696; period = 'Hourly_summer';
%go = 1; stop = 2207; period = 'Hourly_spring';
%go = 1; stop = 1754; period = 'Hourly_fall';
%go = 1; stop = 2120; period = 'Hourly_winter';

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
    if j == 519
        kkk = k;
    end
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
x_a = [1.5;0.5];
x_var = [0.5*x_a(1)^2,0.5*x_a(2)^2]; %was 0.5
S_a = diag(x_var);

S_ainv = [];
Seinv = [];
[X,R] = oem(O,Q,R,@pAirmakeJ_physical,S_a,Se,S_ainv,Seinv,x_a,Y.Y);
X.x

% apply forward model to get corrected purpleair data
exponent = Q.RH.*exp(-Q.b./(T_avgs*Q.Dp));
pm_corrected = X.x(1) + pm_avgs ./ (1 + X.x(2)*exponent./(1 - exponent));

save(period,'-struct','X')
