function [dates, discounts]=bootstrap(datesSet, ratesSet)
%Computes Euribor 3m bootstrap with a single-curve model

% INPUTS 
% dateSet : structure vector of end dates of underlying contracts
% rateSet : structure vector of Underlying bid/ask rates


%% Computation of Discount Factors for different assets

t0 = datesSet.settlement; % Settlement Date 


%% Deposits -  short-term interest rate :  discounts untilevaluated with depos

nd = 3; %first 3 depos

mid_depos  = (ratesSet.depos(1:nd,1)+ratesSet.depos(1:nd,2))/2;
B_depos = 1./(1+yearfrac(datesSet.settlement,datesSet.depos(1:nd),2).*mid_depos(1:nd))'; % row vector
% B_depos : bootstrap discount factors computed from depos

%% STIR Futures 3M  mid-term interest rates :  discounts evaluated until 2y with futures
% first 7 futures

nf = 7; % we use first 7 futures contract

mid_futures  = (ratesSet.futures(1:nf,1) + ratesSet.depos(1:nf,2))/2;
B_settlement = B_depos(nd); %interpolation of first settlement date of future; equal to final B of depos
B_forward = 1./(1+yearfrac(datesSet.futures(1:nf,1),datesSet.futures(1:nf,2),2).*mid_futures(1:nf)); %vector of forward discounts

% B_futures : bootstrap discount factors computed from futures

for i = 1:nf-1
    B_futures(i) = B_settlement*B_forward(i); % discount factor computed from futures
    B_settlement = interp_log_discounts(B_settlement,B_futures(i),datesSet.futures(i,1),datesSet.futures(i,2),datesSet.futures(i+1,1),t0);
end

B_futures(nf)=B_settlement*B_forward(nf); % last future


%% SWAP % from the second to the last one

ns = size(ratesSet.swaps,1); 

mid_swaps  = (ratesSet.swaps(1:ns,1) + ratesSet.swaps(1:ns,2))/2;

B_firstyear =  interp_log_discounts(B_futures(3),B_futures(4),datesSet.futures(3,2),datesSet.futures(4,2),datesSet.swaps(1),t0);
BPV=yearfrac( t0 ,datesSet.swaps(1),6)*B_firstyear; 

% B_swaps : bootstrap discount factors computed from swaps

for i= 2:ns  % 
    B_swaps(i-1) = (1-mid_swaps(i)*BPV)/(1+yearfrac(datesSet.swaps(i-1),datesSet.swaps(i),6)*mid_swaps(i));
    BPV= BPV + yearfrac(datesSet.swaps(i-1),datesSet.swaps(i),6)*B_swaps(i-1);  % we update BVP at each iteration
end

discounts= [B_depos, B_futures , B_swaps]'; 
dates=[datesSet.depos(1:nd); datesSet.futures(1:nf,2); datesSet.swaps(2:ns)];


                                                

end

