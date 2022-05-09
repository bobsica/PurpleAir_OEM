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

% get data from excel file
[i,t,r] = xlsread('Example\averaged_data.xlsx','Hourly_summer');
min_avgs = i(664:1387,2);  % ministry PM2.5 data
pm_avgs = i(664:1387,3);  % purpleair PM2.5 data
rh_avgs = i(664:1387,4);  % purpleair RH data
T_avgs = i(664:1387,6);  % purpleair T data

%set R, retrieval structure
R = [];
R.jq = {};
R.ji = {};
iter = 0;

% O, input structure
O = defOreal;

% Y, data structure for 'measurement vector'. This is the ministry data
% because that is an example of output from the forward model
Y.Y = min_avgs;
% covariance matrix. ministry sensor has 5% accuracy, plus added 0.5 since
% integer rounding
Y.Yvar = (0.5 + 0.05*min_avgs).^2;
Se = diag(Y.Yvar);

% Q, Forward model structure. This is the purpleair pm2.5 and RH data
% because that is what is used as data in our forward model
Q.Y = pm_avgs;
Q.RH = (rh_avgs / 100)+0.21;
Q.T = T_avgs;
sigma = 0.072; % water surface tension N/m
M = 0.018; % water molecular weight kg/mol
rho = 1000; % water density kg/m3
r = 8.314; % ideal gas constant J/mol K
Q.b = 4*sigma*M/(rho*r);
Q.Dp = 0.0000002; % particle diameter m

n = 2; % retrieving i, k

% set a priori coefficients
x_a = [1.5;0.5];
x_var = [0.5*x_a(1)^2,0.5*x_a(2)^2];
S_a = diag(x_var);

S_ainv = [];
Seinv = [];
[X,R] = oem(O,Q,R,@pAirmakeJ_physical,S_a,Se,S_ainv,Seinv,x_a,Y.Y);
X.x
X.e;
