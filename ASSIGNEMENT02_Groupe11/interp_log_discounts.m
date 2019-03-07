function [ new_discount] = interp_log_discounts( settlement_discount, expiry_discount, settlement_prev_future ,expiry_prev_future, settlement_date, initial_date )
%interpolated discount factor of an asset if necessary

% INPUT
% settlement_discount      discount factor at settlement time of previous future
% expiry_discount          discount factor at settlement time of previous  future                                                         
% settlement_prev_future   settlement date of previous future
% expiry_prev_future       expiry date of previous future
% settlement_date          settlement date of new future
% initial_date              date at which discount is computed 

 if       settlement_date == expiry_prev_future  % if they coincides
          new_discount = expiry_discount;
          
          return;
    
 elseif   settlement_date > expiry_prev_future %extrapolation
        
          r1 = -log(settlement_discount)/yearfrac(initial_date, settlement_prev_future,3);
          r2 = -log(expiry_discount)/yearfrac(initial_date, expiry_prev_future,3);
          r = interp1([settlement_prev_future ,expiry_prev_future],[r1,r2],settlement_date,'linear','extrap');
          
          
else     % settlement_date < expiry_prev_future      interpolation

          r1 = -log(settlement_discount)/yearfrac(initial_date, settlement_prev_future,3);
          r2 = -log(expiry_discount)/yearfrac(initial_date, expiry_prev_future,3);
          r = interp1([settlement_prev_future , expiry_prev_future],[r1, r2],settlement_date,'linear');
        
 end
 
 new_discount = exp(-r*yearfrac(initial_date, settlement_date,3));





end

