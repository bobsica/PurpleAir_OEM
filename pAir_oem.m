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
[ii,t,r] = xlsread('./Example/averaged_data.xlsx','Hourly_summer');
% for summer 664:1387
go = 664; stop = 1387;
% 2nd index, RHS was 2, 3, 4, 6
min_avgs = ii(go:stop,3);  % ministry PM2.5 data
pm_avgs = ii(go:stop,4);  % purpleair PM2.5 data
rh_avgs = ii(go:stop,5);  % purpleair RH data
T_avgs = ii(go:stop,6);  % purpleair T data

%set R, retrieval structure
R = [];
R.jq = {};
R.ji = {};
iter = 0;

% O, input structure
O = defOreal;

% ministry SD
[rows,col] = size(ii);

%you want to loop while ii(2) < 24; each time it rolls over do a new SD

for j = 2:rows
    k = 1;
    if j == 2
        minH(1) = pm_avgs(1);
        k = 2;
    end %if
    while ii(j-1) < ii(j)
        minH(k) = pm_avgs(j);
        k = k + 1;
    else
        minSTD() = std(minH);
        need this std for all of them in group!
    end %while
end







    tMinH(2) = mean(tMinT.Var3(i));
    tMinH(3) = mean(tMinT.Var4(i));
    tMinH(4) = mean(tMinT.Var5(i));
    tMinH(5) = mean(tMinT.Var6(i));
    tMinH(6) = mean(tMinT.Var7(i));
    tMinH(7) = mean(tMinT.Var8(i));
    tMinH(8) = mean(tMinT.Var9(i));
    tMinH(9) = mean(tMinT.Var10(i));
    tMinH(10) = mean(tMinT.Var11(i));
    tMinH(11) = mean(tMinT.Var12(i));
    tMinH(12) = mean(tMinT.Var13(i));
    tMinH(13) = mean(tMinT.Var14(i));
    tMinH(14) = mean(tMinT.Var15(i));
    tMinH(15) = mean(tMinT.Var16(i));
    tMinH(16) = mean(tMinT.Var17(i));
    tMinH(17) = mean(tMinT.Var18(i));
    tMinH(18) = mean(tMinT.Var19(i));
    tMinH(19) = mean(tMinT.Var20(i));
    tMinH(20) = mean(tMinT.Var21(i));
    tMinH(21) = mean(tMinT.Var22(i));
    tMinH(22) = mean(tMinT.Var23(i));
    tMinH(23) = mean(tMinT.Var24(i));
    tMinH(24) = mean(tMinT.Var25(i));
    
    tMinT.Var26(i) = mean(tMinH);
    tMinT.Var27(i) = std(tMinH);
end
tMinSD = tMinT.Var27(start:rows);
% end ministry SD

% Y, data structure for 'measurement vector'. This is the ministry data
% because that is an example of output from the forward model
Y.Y = min_avgs;
% covariance matrix. ministry sensor has 5% accuracy, plus added 0.5 since
% integer rounding
%Y.Yvar = (0.5 + 0.05*min_avgs).^2;
%Y.Yvar = (0.29).^2 + (0.05*min_avgs).^2;

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
