function OptionPrice=EuropeanOptionCRR(F0,K,B,T,sigma,N,flag)
% ok

% European option price with Cox-Ross-Rubinstein Method (CRR)
%
% INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time to maturity
% sigma: volatility
% N:     number of CRR steps
% flag:  1 call, -1 put

n= T/N;% length of 1 step

u = exp(sigma*sqrt(n));
d = 1/u;

q =  (1-sigma*sqrt(n)/2)/2; % expected value exp(rt) = q*u + (1-q)*d   <--EXPLAIN THIS AS xpected time-step log-return     

leaf = zeros(N+1,1); %column vector of tree final nodes 

if flag == 1 % call, so payoff max(0,F(t,t)-K)
   for i=1:N+1 
   leaf(i) = max(0,F0*u^(+N-2*(i-1))-K);  
   end

    for j= N:-1:1
        for k=1:j
            leaf(k)=(q*leaf(k)+(1-q)*leaf(k+1));
        end
    end
    
else % put, so payoff is max(0,K-F(t,t))
   for i=1:N+1 
       leaf(i)=max(0,K-F0*u^(+N-2*(i-1)));
   end
   
   % first we calculate all the possible payoff at the end of the tree
   % starting from the top : max(0,K-F0*u^(-N))
   % down to the bottom : max(0,K-F0*u^(-N))
   

   for j= N:-1:1
        for k=1:j
            leaf(k)=(q*leaf(k)+(1-q)*leaf(k+1));  % and then backward we price all the tree
        end
    end
           
    
end

OptionPrice=leaf(1)*B;

end
