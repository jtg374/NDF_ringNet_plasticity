function dydt = odefun_NegDer_Homeo_new_combined(t,y,alpha,r0,Wneg,Istim,tstim)
% differential equations with homeostatic plasticity
% variables: y(1):activitu; y(2):positive feedback weight 
% parameters: alpha:learning rate; r0: target firing rate
% Wneg:derivative feedback strength; 
% Istim:input strength; tstim:time when stim off and delay begin
dydt = zeros(2,1);
dydt(1) = (-(1+Wneg-y(2))*y(1)+Istim*(t<tstim))/(Wneg+1);% see Eq.1 in text, stimulus is applied before delay (t<tstim)
dydt(2) = -alpha*(y(1)-r0)*y(2)/Wneg*(t>tstim); % see Eq.3 in text, 
% note plasticity is only applied during delay period (t>tstim)
