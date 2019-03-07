function [dates, discounts]=bootstrap(datesSet, ratesSet)
%Computes Euribor 3m bootstrap with a single-curve model

% INPUTS 
% dataSet : structure vector of end dates of underlying contracts
% rateSet  : structure vector of Underlying Midprice 


%% Computation of Discount Factors for different assets

t0 = dateSet.settlement; % Settlement Date


%% Depos -  short-term interest rate :  discounts untilevaluated with depos

mid_dipos  = (ratesSet.depos(1:md,1)+ratesSet.depos(1:md,2))/2;
B(1:md)= 1./(1+yearfrac(datesSet.settlement,datesSet.depos(1:md),2).*mid_prices(1:md)); 

%% STIR Futures 3M  mid-term interest rates :  discounts evaluated until 2y with futures
% first 7 futures

mf = 7; % we use first 7 futures contract

mid_futures  = (ratesSet.futures(1:mf,1) + ratesSet.depos(1:mf,2))/2;
B_futures_settlement = B(md); %interpolation of first settlement date of future; equal to final B of depos
B_Forward_futures = 1./(1+yearfrac(datesSet.futures(1:mf,1),datesSet.futures(1:mf,2),2).*mid_futures(1:mf));


for i = 1:mf
    B(i + md)=B_futures_settlement*B_forward(i); % B4 to B10
    B_futures_settlement = interp_log_discounts(B(i),B(i+1),datesSet.futures(i,1),datesSet.futures(i,2),datesSet.futures(i+1,1),t0);
end

B(i+mf)=B_futures_settlement*B_forward(mf); % last future
   

%% SWAP % from the second to the last one

ms = size(rateSet.swaps,1) - 1; % we don't use the first value

mid_swaps  = (ratesSet.swaps(2:ms,1) + ratesSet.depos(2:ms,2))/2;
B_firstyear =  interp_log_discounts(B(3),B(4),datesSet.futures(4,1),datesSet.futures(4,2),datesSet.swap(1),t0);

BPV=yearfrac(datesSet.settlement,datesSet.swaps(1),6)*B_firstyear; 

for i= md+mf+1: md+mf+ms-1  % from 11 to 59
    B(i)=(1-mid_swaps(i - (md+ mf))*BPV)/(1+yearfrac(datesSet.swaps(i-(md+ mf)),datesSet.swaps(i-(md+ mf-1)),6)*mid_swaps(i -( md+ mf)));
    BPV=BPV+yearfrac(datesSet.swaps(i - (md + mf - 1 )),datesSet.swaps(i-(md + mf - 2)),6)*B(i); 
    end
end

discounts= B'; 

dates=[datesSet.depos(1:md); datesSet.futures(1:mf,2); datesSet.swaps(2:ms)];

                                                

end

