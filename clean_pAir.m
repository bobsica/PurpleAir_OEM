% retrieves and averages data from pAir .csv files
% currently has a quality flag that keeps ~97% of the data for our sensor

% inputs
a_primary = 'Example/July_A.csv'; % Primary (A) file
b_primary = 'Example/July_B.csv'; % Primary (B) file
timezone = -4; % compared to UTC
quality_percent = 0.25; % keep readings where channels agree within 25%
quality_absolute = 4; % keep readings where channels agree within 4ug/m3
option = 'hourly'; % 'daily' or 'hourly' averaging

% read data
Test = readtable('Example/July_A.csv','NumHeaderLines',1);
[i_a,t_a,r_a] = xlsread(a_primary);
[i_b,t_b,r_b] = xlsread(b_primary);
r_a(1,:) = [];
[m,n] = size(r_a);
for t=1:m
    s = r_a{t,1};
    r_a(t,1) = {s(1:end-4)};
end
r_b(1,:) = [];
[m,n] = size(r_b);
for t=1:m
    s = r_b{t,1};
    r_b(t,1) = {s(1:end-4)};
end
times_a = datetime(r_a(:,1), 'InputFormat', 'yyyy-MM-dd HH:mm:ss') + hours(timezone);
times_b = datetime(r_b(:,1), 'InputFormat', 'yyyy-MM-dd HH:mm:ss') + hours(timezone);

% Daylight savings times - uncomment and update if you need
% daylight savings for March
% for j=1:length(times_a)
%     if times_a(j) < datetime('2021-03-14 02','InputFormat', 'yyyy-MM-dd HH')
%         times_a(j) = times_a(j) - hours(5);
%     else
%         times_a(j) = times_a(j) - hours(4);
%     end
% end
% for j=1:length(times_b)
%     if times_b(j) < datetime('2021-03-14 02','InputFormat', 'yyyy-MM-dd HH')
%         times_b(j) = times_b(j) - hours(5);
%     else
%         times_b(j) = times_b(j) - hours(4);
%     end
% end
% daylight savings for Nov
% for j=1:length(times_a)
%     if times_a(j) < datetime('2021-11-07 06','InputFormat', 'yyyy-MM-dd HH')
%         times_a(j) = times_a(j) - hours(4);
%     else
%         times_a(j) = times_a(j) - hours(5);
%     end
% end
% for j=1:length(times_b)
%     if times_b(j) < datetime('2021-11-07 06','InputFormat', 'yyyy-MM-dd HH')
%         times_b(j) = times_b(j) - hours(4);
%     else
%         times_b(j) = times_b(j) - hours(5);
%     end
% end

pm_a = i_a(:,9);
rh = i_a(:,8);
T = i_a(:,7);
pm_b = i_b(:,9);

% delete duplicate entries
to_delete = zeros(length(times_a), 1);
max_time = times_a(1);
for k=1:length(times_a)
    if times_a(k) >= max_time
        max_time = times_a(k);
    else
        to_delete(k) = k;
    end
end
v = nonzeros(to_delete);
times_a(v) = [];
pm_a(v) = [];
rh(v) = [];
T(v) = [];

to_delete = zeros(length(times_b), 1);
max_time = times_b(1);
for k=1:length(times_b)
    if times_b(k) >= max_time
        max_time = times_b(k);
    else
        to_delete(k) = k;
    end
end
v = nonzeros(to_delete);
times_b(v) = [];
pm_b(v) = [];

% delete readings with only 1 channel
index = 1;
while index < min([length(times_a), length(times_b)]) - 1
    for i=index:min([length(times_a), length(times_b)])
        index = i;
        if times_b(i) - times_a(i) > seconds(20)
            times_a(i) = [];
            pm_a(i) = [];
            break;
        elseif times_a(i) - times_b(i) > seconds(20)
            times_b(i) = [];
            pm_b(i) = [];
            break;
        end
    end
end
if length(times_a) ~= length(times_b)
    disp('get_pAir messed up!');
end

% take average of channel A and B
pm = (pm_a + pm_b) / 2;

% quality flag: keep readings if difference <25% or <4
to_keep = zeros(length(pm), 1);
for j=1:length(pm)
    dif = abs(pm_a(j) - pm_b(j));
    if pm(j) == 0
        percentage = 0;
    else
        percentage = dif / pm(j);
    end
    if (percentage < quality_percent || dif < quality_absolute) && pm(j) < 120
        to_keep(j) = j;
    end
end
indices = nonzeros(to_keep);
pm = pm(indices);
times_a = times_a(indices);
rh = rh(indices);
pm_a = pm_a(indices);
pm_b = pm_b(indices);
T = T(indices);

% get averages
pm_averages = [];
rh_avgs = [];
T_avgs = [];
[current_year,current_month,current_day] = ymd(times_a(1));
dayss = [];

if strcmp(option, 'hourly')
    hours = [];
    [current_hour,current_minute,current_sec] = hms(times_a(1));
    pm_hourly = [];
    rh_hourly = [];
    T_hourly = [];
    for t=1:length(times_a)
        [year,month,day] = ymd(times_a(t));
        [hour,minute,sec] = hms(times_a(t));
        if year == current_year && month == current_month && day == current_day && hour == current_hour
            pm_hourly(end+1) = pm(t);
            rh_hourly(end+1) = rh(t);
            T_hourly(end+1) = T(t);
        elseif hour > current_hour || day > current_day
            hours(end+1) = current_hour + 1;
            dayss(end+1) = current_day;
            [current_year,current_month,current_day] = ymd(times_a(t));
            [current_hour,current_minute,current_sec] = hms(times_a(t));
            pm_averages(end+1) = mean(pm_hourly);
            rh_avgs(end+1) = mean(rh_hourly);
            T_avgs(end+1) = mean(T_hourly);
            pm_hourly = [pm(t)];
            rh_hourly = [rh(t)];
            T_hourly = [T(t)];
        end
    end
    pm_averages(end+1) = mean(pm_hourly);
    rh_avgs(end+1) = mean(rh_hourly);
    T_avgs(end+1) = mean(T_hourly);
    hours(end+1) = current_hour + 1;
    dayss(end+1) = current_day;
    
else
    pm_daily = [];
    rh_daily = [];
    T_daily = [];
    stds = [];
    for t=1:length(times_a)
        [year,month,day] = ymd(times_a(t));
        if month == current_month && day == current_day
            pm_daily(end+1) = pm(t);
            rh_daily(end+1) = rh(t);
            T_daily(end+1) = T(t);
        elseif (day > current_day && month == current_month) || month ~= current_month
            dayss(end+1) = current_day;
            [current_year,current_month,current_day] = ymd(times_a(t));
            pm_averages(end+1) = mean(pm_daily);
            rh_avgs(end+1) = mean(rh_daily);
            T_avgs(end+1) = mean(T_daily);
            stds(end+1) = std(pm_daily);
            pm_daily = [pm(t)];
            rh_daily = [rh(t)];
            T_daily = [T(t)];
        end
    end
    pm_averages(end+1) = mean(pm_daily);
    rh_avgs(end+1) = mean(rh_daily);
    T_avgs(end+1) = mean(T_daily);
    stds(end+1) = std(pm_daily);
    dayss(end+1) = current_day;
end
%[dayss',pm_averages',rh_avgs',T_avgs'] % print the data

round(days(times_a(end)-times_a(1)));
if round(days(times_a(end)-times_a(1))) > length(pm_averages)
    disp('Warning: At least one day has missing pAir data. Edit ministry data file accordingly to avoid indexing errors.');
end