% loop_all season daily average pAir cases
close all; clear all;
RHpAirErr = 0.025;
iplt = 1;
for i = 21:24
    pAir_oemF(i,RHpAirErr,iplt)
    if i == 21
        exportgraphics(gca, 'dailyWinterStat.pdf');
    elseif i == 22
        exportgraphics(gca, 'dailySpringStat.pdf');
    elseif i == 23
        exportgraphics(gca, 'dailySummerStat.pdf');
    else
        exportgraphics(gca, 'dailyFallStat.pdf');
    end
end





% plotHGF(RHpAirErr)

