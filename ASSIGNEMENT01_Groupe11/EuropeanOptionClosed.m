function optionPrice=EuropeanOptionClosed(F0,K,B,T,sigma,flag)
% ok 

% European option price with Closed formula
%
% INPUT
%
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% flag:  1 call, -1 put
% N:     number of MC steps

% [Call,Put] = blkprice(F0,K,Rate,Time,Volatility) 
% computes European put and call futures option prices using Black's model.

[call, put] = blkprice(F0, K, 0, T, sigma);

if flag == 1 
   optionPrice= B*call;
else
   optionPrice= B*put;
end

end % function EuropeanOptionClosed