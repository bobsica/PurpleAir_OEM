% makeY, make OEM data
% fake for fake data
% in is structure with start/stop heights
% pcl is structure with pcl data

function Y = makeY(fake, in, pcl);
  
if fake
    'fake data'
    load('./20120524pclFake2Dig.mat')
    tmp = find(zfake < in.zgo);
    start = size(tmp,1) + 1; %change +1
    tmp = find(zfake < in.in.zstop);
    fini = size(tmp,1);
    Y.YD = yfake(start:fini)'; %fake
    Y.YvarD = Y.YD;
    Y.zDATAd = zfake(start:fini);
    tmp = find(zfakeA < zgo2);
    start = size(tmp,1) + 1; %change +1
    tmp = find(zfakeA < in.zstopA);
    fini = size(tmp,1);
    Y.YA = yfakeA(start:fini)'; %fake
    Y.YvarA = Y.YA;
    Y.zDATAa = zfakeA(start:fini);
else
    tmp = find(pcl.alt < in.zgo);
    start = length(tmp) + 1; %change +1
    tmp = find(pcl.alt < in.zstop);
    fini = length(tmp);
    Y.YD = pcl.cts(start:fini); % real
    Y.YvarD = Y.YD;
    Y.zDATAd = pcl.alt(start:fini);
    tmp = find(pcl.altL < in.zgoA);
    start = length(tmp) + 1; %change +1
    tmp = find(pcl.altL < in.zstopA);
    fini = length(tmp);
    Y.YA = pcl.ctsA(start:fini); % real
    Y.YvarA = Y.YA;
    Y.zDATAa = pcl.altL(start:fini);    
end

Y.Y = [Y.YA; Y.YD];
Y.Yvar = [Y.YvarA; Y.YvarD];
Y.zDATA = [Y.zDATAa; Y.zDATAd];

return
