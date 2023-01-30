
% dump file for code testing
% 
% to read csv files
t=readtable('July_AA.csv','Delimiter',{' ' ','}, 'MultipleDelimsAsOne', false,'Format','auto'); % reads file
time = t.Var1 + t.Var2; % you only see 2021-07-01
% To show time as a string:
fmt = "dd MMMM yyyy, hh:mm:ss a";
string(time,fmt); % "01 July 2021, 04:00:50 AM"





% wrong
t = readtable('July_AA.csv','Delimiter',{'space', ','}, 'MultipleDelimsAsOne', true)
ts = string(t.time); % makes it a string
readtable('July_AA.csv','Delimiter',{' ' ','}) % this one breaks up time
readtable('July_AA.csv','Delimiter',{' ' ','},'Format','%{yyyy-MM-dd}D,%{hh:mm:ss}D,%s,%f,%f,%f,%f,%f,%f,%f,%f,%f')

T1 = readtable('test.txt');

T1 = t;
T1.Var1 = datetime(T1.Var1, 'InputFormat','yyyy/MM/dd');
T1.Var2 = datetime(T1.Var2, 'InputFormat','hh:mm:ss');
T1.Var1 = T1.Var1 + T1.Var2;
T1.Var2 = [];
% end wrong