% loop_all season daily average pAir cases
close all; clear all;
RHpAirErr = 0.025;
iplt = 1;
for i = 21:24
    pAir_oemF(i,RHpAirErr,iplt)
end

% plotHGF(RHpAirErr)

