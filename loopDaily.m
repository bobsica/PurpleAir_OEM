% loop_all season daily average pAir cases
close all; clear all;
% run all cases
%hourly = 1
RHpAirErr = 0.025;
iplt = 1;
% if hourly == 1
%     igo = 13; istop = 16;
% else
%     igo = 21; istop = 24;
% end
igo = 13; istop = 16;
for i = igo:istop
    pAir_oemF(i,RHpAirErr,iplt)
end
igo = 21; istop = 24;
for i = igo:istop
    pAir_oemF(i,RHpAirErr,iplt)
end

%     if i == 21
%         exportgraphics(gca, 'dailyWinterStat.pdf');
%     elseif i == 22
%         exportgraphics(gca, 'dailySpringStat.pdf');
%     elseif i == 23
%         exportgraphics(gca, 'dailySummerStat.pdf');
%     else
%         exportgraphics(gca, 'dailyFallStat.pdf');
%     end
% end





% plotHGF(RHpAirErr)

