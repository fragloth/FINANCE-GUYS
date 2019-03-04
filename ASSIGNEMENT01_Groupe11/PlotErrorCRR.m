function [M,errorCRR] = PlotErrorCRR (F0,K,B,T,sigma)
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time to maturity
% sigma: volatility
errorCRR = [];
M = [];
call = EuropeanOptionClosed(F0,K,B,T,sigma,1) ;
for m=1:9
    M = [M,2^m];
    errorCRR = [errorCRR, abs(call - EuropeanOptionCRR(F0,K,B,T,sigma,2^m,1) )];
end
loglog(M, errorCRR);hold on
loglog(M,M.^(-1));hold off
end




    
  
    
    