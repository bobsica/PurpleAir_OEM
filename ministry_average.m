% weighted average ministry data

t = readtable('./Example/Ministry.xlsx');
tarray =  table2array(t(:,2:25));
time = table2array(t(:,1));
for i = 1:height(t)
    hourAv(i) = mean(tarray(i));
end
plot(time,hourAv,':o')
