close all
%% parameters
alpha = 0.01; % learnign rate
Wneg = 500; % derivative feedback strength

TStim = 50; % time when stim off and delay begin 
TAll = 350; % tiem when delay ends
n = 100; % number of trials

% Istim = Wneg*ones(n,1); % fixed input strength
Istim = 2*Wneg*rand(n,1); % variable input strength
InputTest = Wneg*1*[.5 1 2]; % input used to test weight
%% test weight without plasticity
figure;hold on
yinit = [0; Wneg*1]; % initial value of (activit, weight); balanced positive and derivative feedback 
[t, y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(1),TStim),[0 TAll],yinit);
plot(t,y(:,1))
[t, y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(2),TStim),[0 TAll],yinit);
plot(t,y(:,1))
[t, y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(3),TStim),[0 TAll],yinit);
plot(t,y(:,1))
% ylim([0 0.1*r0])
hold off
xlabel('time')
ylabel('r')

figure;hold on
yinit = [0; Wneg*.9]; % initial value of (activit, weight); 10% pergurbation
[t, y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(1),TStim),[0 TAll],yinit);
plot(t,y(:,1))
[t, y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(2),TStim),[0 TAll],yinit);
plot(t,y(:,1))
[t, y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(3),TStim),[0 TAll],yinit);
plot(t,y(:,1))
% ylim([0 .1*r0])
hold off
xlabel('time')
ylabel('r')

%% with plasticity
Start = now;
i = 1; % first trial
yinit = [0; Wneg*.9]; % begin with a 10% perturbation
dt_store = 0.5;
[t, y]=ode23(@(t,y) odefun_NegDer_DiffPlas_new_combined(t,y,alpha,Wneg,Istim(i),TStim),0:dt_store:TAll,yinit);
nt=length(t);
Wend = zeros(n,1); % record weight balance ratio evolution with resolution of trial
Wend(1) = y(end,2)/Wneg;
ytotal = zeros(2,nt,n); % record activity time course
ytotal(:,:,1) = y';
for i = 2:n
    if any(i == floor([1, 5:5:100]*n/100)) % report percentage of running
        Lap = now; 
        disp(['    ', num2str(round(100*i/n)), '%', ' Time elapsed: ', ...
                datestr(Lap-Start, 'HH:MM:SS')])
    end
    yinit = [0; y(end,2)];
    [t, y]=ode23(@(t,y) odefun_NegDer_DiffPlas_new_combined(t,y,alpha,Wneg,Istim(i),TStim),0:dt_store:TAll,yinit);
    Wend(i) = y(end,2)/Wneg;
    ytotal(:,:,i) = y';
end
ytotal = reshape(ytotal,[2,n*nt]);
%% plot weight ratio evolution
figure
plot(Wend)
xlabel('trial')
ylabel('w_{pos}')
%% test final weight
figure;hold on
yinit = [0; Wend(n)*Wneg];
[t y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(1),TStim),[0 TAll],yinit);
plot(t,y(:,1))
[t y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(2),TStim),[0 TAll],yinit);
plot(t,y(:,1))
[t y]=ode23(@(t,y) odefun_NegDer_NoPlas_new_combined(t,y,alpha,Wneg,InputTest(3),TStim),[0 TAll],yinit);
plot(t,y(:,1))
hold off
xlabel('time')
ylabel('r')
%% plot phase plane
Wneg = 500;
[X,Y] = meshgrid(Wneg*0:Wneg*0.005:0.1*Wneg,Wneg*0.9:Wneg*0.002:1.01*Wneg);
U = (-(1+Wneg-Y).*X)/(Wneg+1); % derivative of activity
V = -alpha*X.*U; % derivative of weight
figure;
quiver(X,Y,U,V) % vector field
hold on
plot(ytotal(1,:),ytotal(2,:)) % activity and weight time course
xlim([0 50]);ylim([Wneg*0.9 1.01*Wneg])
ylabel('W_{pos}')
xlabel('r')