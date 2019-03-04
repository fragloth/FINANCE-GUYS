function OptionPrice = EuropeanOptionMC(F0,K,B,T,sigma,N,flag)
% ok

% European option price with Monte Carlo method (MC)
%
% INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time to maturity
% sigma: volatility
% N:     number of MC steps
% flag:  1 call, -1 put

pay=0;

if flag==1 % call, so payoff is max(0,F(t,t)-K)
    for i=1:N
    pay=pay+max(0,F0*exp(-(sigma^2)*T/2+sigma*sqrt(T)*randn(1))-K);
    % where randn(1) generate a random number following N(0,1)
    end
else % put , so payoff is max(0,K-F(t,t))
    for i=1:N
    pay=pay+max(0,K-F0*exp(-(sigma^2)*T/2+sigma*sqrt(T)*randn(1)));
    end
end    
OptionPrice = (B*pay)/N;
end

