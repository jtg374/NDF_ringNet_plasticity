function dydt = odefun_NegDer_DiffPlas_LowPass(t,y,alpha,Wneg,Istim,tstim)
% differential equations with differntial plasticity
% variables: y(1):activity; y(2):postive feedback weight; y(3):low-pass filtered activity 
% parameters: alpha:learning rate; Wneg:derivative feedback
% strength; Istim:input strength; tstim:time when stim off and delay begin
tau_p = 2; % time constatn of low-pass filter
dydt = zeros(3,1);
dydt(1) = (-(1+Wneg-y(2))*y(1)+Istim*(t<tstim))/(Wneg+1);% see Eq.1 in text, stimulus is applied before delay (t<tstim)
dydt(3) = (-y(3) + y(1))/tau_p;
dydt(2) = -alpha*y(3)*dydt(1);% see Eq.2 in text, 
% note plasticity is only applied during delay period (t>tstim)
