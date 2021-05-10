function dydt = odefun_NegDer_DiffPlas_new_combined(t,y,alpha,Wneg,Istim,tstim)
% differential equations with differntial plasticity
% variables: y(1):activitu; y(2):postive feedback weight 
% parameters: alpha:learning rate; Wneg:derivative feedback
% strength; Istim:input strength; tstim:time when stim off and delay begin
dydt = zeros(2,1);
dydt(1) = (-(1+Wneg-y(2))*y(1)+Istim*(t<tstim))/(Wneg+1);% see Eq.1 in text, stimulus is applied before delay (t<tstim)
dydt(2) = -alpha*y(1)*dydt(1)*(t>tstim);% see Eq.2 in text, 
% note plasticity is only applied during delay period (t>tstim)

