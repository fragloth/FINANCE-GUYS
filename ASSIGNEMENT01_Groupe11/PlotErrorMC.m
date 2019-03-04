function [M,stdEstim]=PlotErrorMC(F0,K,B,T,sigma)
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time to maturity
% sigma: volatility

stdEstim = [];
M = [];
call = EuropeanOptionClosed(F0,K,B,T,sigma,1);

% batch size to get smoother curve
b = 7;

for m=1:20
    M_ = 2^m;
    M = [M,M_];
    batch = 0 ;
    for i=1:b
        batch = batch + abs(call - EuropeanOptionMC(F0,K,B,T,sigma,M_,1) );
    end
    stdEstim = [stdEstim, batch/b ];
end
loglog(M, stdEstim);hold on;
loglog(M,M.^(-1/2));hold off;
end


    
  
    
    