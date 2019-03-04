function vega = VegaBlackScholes(F0,K,B,T,sigma,flag)
%Option Vega with Black Model
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% flag:  1 call, -1 put useless in this case
%
%OUTPUT
%vega:  value of vega multiplied by a variation of 1% in sigma in euros 
%row vector

d1 = (log(F0/K)+sigma^2*T/2)/(sigma*sqrt(T));

vega = F0.*B.*normpdf(d1)*sqrt(T); %probability density function of s.n. evaluated in d1 

vega = vega*sigma/100; % vega in euros

end

