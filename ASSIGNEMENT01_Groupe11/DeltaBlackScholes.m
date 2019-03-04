function delta = DeltaBlackScholes(F0,K,B,T,sigma,flag)
%Option Delta with Black Model
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% flag:  1 call, -1 put
%
%OUTPUT
%delta:  value of delta in percentage, between 0 and 1 ( for call) 
%row vecot


d1 = (log(F0/K)+sigma^2*T/2)/(sigma*sqrt(T));

if flag == 1 % Call Option
    delta = normcdf(d1); %Normal cumulative distribution evaluated in d1  N(d1)
else % Put Option        
    delta = normcdf(d1) - 1; %Normal cumulative distribution evaluated in d1  N(d1)
end


end

