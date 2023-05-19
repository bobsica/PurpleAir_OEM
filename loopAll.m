% loop_all pAir cases
%close all; clear all;
RHpAirErr = 0.025
for i = 1:7
    pAir_oemF(i,RHpAirErr)
end
for i = 9:16
    pAir_oemF(i,RHpAirErr)
end

plotHGF(RHpAirErr)

