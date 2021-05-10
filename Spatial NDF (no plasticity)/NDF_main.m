clc;clear all;close all;    
%% load parameters
param = NDF_Parameters()
% learned or perturbed E-to-E weight matrix may be loaded as MEE and run
% param = NDF_parameters(MEE)
%% unpack Connectivity profile 
MEE = param.MEE;
MEI = param.MEI;
MIE = param.MIE;
MII = param.MII;

%% output time resolution
dt_store = param.dt_store;

%% pack initial values
nx = param.N; % number of neuron
np = nx; % number of stimulus locations (parallel network)
y0 = [0;              % Stimlus Current Strength
      zeros(6*nx*np,1);  % 6*N state variables
      ]; 
%% load timing
TStimOn   = param.TStimOn;
TStimOff  = param.TStimOff;
Tmax = param.Tmax;

%% Solving ODE equations
clear textprogressbar % will cause trouble if integrate with @odetpbar while textprogressbar is in environment
options = odeset('RelTol',1e-3,'AbsTol',1e-5,'OutputFcn',@odetpbar); % will print progressbar
disp(['Integration started at: ',datestr(now,'HH:MM:SS')])
[t,y] = ode23(@(t,y0) NDF_Equations(t,y0,param),...
    0:dt_store:Tmax,y0,options);
disp(['Integration ended at:   ',datestr(now,'HH:MM:SS')])

nt = length(t);
Rt = y(:,2:nx*np*6+1);
Rt = reshape(Rt,nt,nx,np,6);
RE = Rt(:,:,:,1); RE = permute(RE,[2,1,3]);
clear y

%% Figures
x = param.x; % neuron index
N = nx;
sp = 1; % stimulus index, 1:0, nx/2:pi
% % full activity time course at a single stimlus location (heatmap)
h2=figure(2); %imagesc([RE RE1])
ax = axes;
image(ax,'XData',t,'YData',x,'CData',RE(:,:,sp),'CDataMapping','scaled')
% colormap(cubehelix) % colormap can be found on FileExchange https://www.mathworks.com/matlabcentral/fileexchange/43700-cubehelix-colormap-generator-beautiful-and-versatile
colorbar
xlim(ax,[t(1),t(end)])
xlabel('Time (ms)','FontSize',14)
ylabel('neuron index \theta','FontSize',10)
ylim(ax,[x(1),x(end)])
yticks([-pi,-pi/2,0,pi/2])
yticklabels({'-\pi','-\pi/2','0','\pi/2'})
% % activity pattern evolution at delay
h7=figure(7);hold on;
ntd = sum(t>=TStimOff);
colors = copper(ntd);
set(gca,'ColorOrder',colors)
plot(x,RE(:,t>=TStimOff,sp)','LineWidth',0.5)
title('Evolution of activity pateern at delay period')
xlabel('\theta','FontSize',14);ylabel('Firing Rate (Hz)','FontSize',14)
set(gca,'Xtick',pi*(-1:0.5:1),'FontSize',14)
set(gca,'XTickLabel',{'-pi','-pi/2','0','pi/2','pi'})
xlim([-pi pi]);
set(gca,'Ytick',0:50:100,'FontSize',14)
ylim([0 120])
hold off
colormap('copper')
hc=colorbar;
hc.Ticks=[0,1];
hc.TickLabels={'early','late'};
% % snapshot of activity pattern for all stimlus activity at end of delay
h3 = figure(3);
ax = axes;
image(ax,'XData',x,'YData',x,'CData',squeeze(RE(:,end,[N/2+1:N,1:N/2])),'CDataMapping','scaled')
ylim(ax,[x(1),x(end)])
ylabel('neuron index \theta','FontSize',10)
yticks([-pi,-pi/2,0,pi/2])
yticklabels({'-\pi','-\pi/2','0','\pi/2'})
xlim(ax,[x(1),x(end)])
xlabel('stimlus location','FontSize',10)
xticks([-pi,-pi/2,0,pi/2])
xticklabels({'-\pi','-\pi/2','0','\pi/2'})

