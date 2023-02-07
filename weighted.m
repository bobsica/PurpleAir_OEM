function [wmean,wvar] = weighted(x,varx)

%function [wmean,wvar] = weighted(x,varx)
%Weighted mean and variance, as in Bevington, pg 88 1st edition
  
A = sum(1./varx);
wmean = sum(x./varx) ./ A;
wvar = 1 ./ A;

return
