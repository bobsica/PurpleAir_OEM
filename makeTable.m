
load Hourly_spring;
load Hourly_summer;
load Hourly_fall;
load Hourly_winter;

input.data = [springX.mae,springX.maeStat,springX.bias,springX.biasStat;summerX.mae,summerX.maeStat,summerX.bias,summerX.biasStat;fallX.mae,fallX.maeStat,fallX.bias,fallX.biasStat; winterX.mae,winterX.maeStat,winterX.bias,winterX.biasStat];
latexHourly = latexTable(input);

'break ***********'
clear all

load daily-spring;
load daily-summer;
load daily-fall;
load daily-winter;


input.data = [sprDX.mae,sprDX.maeStat,sprDX.bias,sprDX.biasStat;sumDX.mae,sumDX.maeStat,sumDX.bias,sumDX.biasStat;fallDX.mae,fallDX.maeStat,fallDX.bias,fallDX.biasStat; winDX.mae,winDX.maeStat,winDX.bias,winDX.biasStat];
latexDaily = latexTable(input);