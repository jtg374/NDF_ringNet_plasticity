function dydt = odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,Istim,tstim)
% differential equations without plasticity
% variables: y(1):activitu; y(2):positive feedback weight (not used)
% parameters: alpha:learning rate (not used); Wneg:derivative feedback
% strength; Istim:input strength; tstim:time when stim off and delay begin
dydt = zeros(2,1);
dydt(1) = (-(1+Wneg-y(2))*y(1)+Istim*(t<tstim))/(Wneg+1); % see Eq.1 in text, stimulus is applied before delay (t<tstim)
dydt(2) = 0;

