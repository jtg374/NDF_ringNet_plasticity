function NDF_with_Plasticity_Frameworks(a,lrD,nTrial)
close all;lrH=0;r_target=20;
% clc;clear all;close all;    
datapath = ['C:\Users\golde\Documents\Research\data\tempData' datestr(now,'_yymmdd_HH_MM')  ];
mkdir(datapath)
disp(datapath)
mkdir([datapath '/FullData'])
mkdir([datapath '/ActFigures'])
%% load parameters
param = NDF_with_Plasticity_Parameters(a,lrD,lrH,nTrial,r_target)
save([datapath,'/param.mat'],'-struct','param');
nx = param.N;  % number of E and I neurons (equal)
np = param.np; % number of parallel network (for different stimulus locations)

%% unpack Connectivity matrix 
MEE = param.MEE;

%% pack initial values
y0 = [0;              % Stimlus 
      0;              % Wipe for forget (not used)
      zeros(6*nx*np,1);  % 6*N state variables * np parallel networks
      reshape(MEE,nx*nx,1) % E to E Connection Strength
      ones(nx,1) % gains
      ]; 

%% load timings
nTrial = param.nTrial; % number of trials
tTrial = param.tTrial; % total time of each trial
TrialOn = param.TrialOn; % beginning of each trial
TStimOff = param.TStimOff;
TrialEnd = param.TDelayOff; % end of each trial
dt_store = param.dt_store; % time resolution for store
%% Solving ODE equations
options = odeset('RelTol',1e-3,'AbsTol',1e-5); 
disp(['Integration started at: ',datestr(now,'HH:MM:SS')])
MEEt = zeros(nx,nx,nTrial);
RE_Stim = zeros(nx,np,nTrial);
g_readout = zeros(nx,nTrial);
for iTrial=1:nTrial
    param.iTrial = iTrial;
    [t,y] = ode23(@(t,y0) NDF_with_Plasticity_Equations(t,y0,param),...
        TrialOn(iTrial):dt_store:TrialEnd(iTrial),y0,options);
    %% unpack and save results for each trial
    nt = length(t);
    gt = y(:,nx*nx+nx*np*6+3:end)';
    Mt = y(:,nx*np*6+3:nx*nx+nx*np*6+2);Mt = reshape(Mt,nt,nx,nx);
    MEE = Mt(end,:,:); MEE = squeeze(MEE);
    Rt = y(:,3:nx*np*6+2);Rt = reshape(Rt,nt,nx,np,6);Rt = permute(Rt,[2,3,1,4]);
    RE = Rt(:,:,:,1);RI = Rt(:,:,:,2);SEE = Rt(:,:,:,3);SIE = Rt(:,:,:,4);SEI = Rt(:,:,:,5);SII = Rt(:,:,:,6); 
    % snapshot of each trial at the end of delay
    MEEt(:,:,iTrial) = MEE;    
    RE_Stim(:,:,iTrial) = RE(:,:,1+TStimOff(1)/dt_store);
    g=gt(:,end);g_readout(:,iTrial) = g;
    %% plot and save
    % addpath('/gpfsnyu/home/jtg374/MATLAB/CubeHelix') % we use CubeHelix colormap
    save([datapath,'/FullData/results_' num2str(iTrial) '.mat'],'t','RE','RI','SEE','SIE','SEI','SII');
    if mod(iTrial,20)==0 || ismember(iTrial,[1,2,5,10]) %may specifity which trials are saved
        h2=figure; %imagesc([RE RE1])
        imagesc(squeeze(RE(:,param.pNp(iTrial),:)),[0 100]);
        ylabel('neuron')
        xlabel('Time')
        colorbar
        % colormap(cubehelix)
        saveas(h2,[datapath,'/ActFigures/RE_T_' num2str(iTrial) '.jpg'])
        h3=figure;
        imagesc(RE(:,:,1+TStimOff(1)/dt_store),[0 100])
        xlabel('stim position')
        ylabel('neuron')
        colorbar
        % colormap(cubehelix)
        saveas(h3,[datapath,'/ActFigures/RE_X_' num2str(iTrial) '.jpg'])
        h4=figure;
        imagesc(diag(g)*MEE,[0 150])
        xlabel('pre-syn')
        xlabel('post-syn')
        % colormap(cubehelix)
        colorbar
        saveas(h4,[datapath,'/ActFigures/g-MEE_' num2str(iTrial) '.jpg'])
    end
    disp([num2str(iTrial) ' trials completed at: ',datestr(now,'HH:MM:SS')])
    %% initial value for next trial, activity reset and weight matrix updated 
    y0 = [  0;              
            0;              
            zeros(6*nx*np,1);  % 6*N state variables
            reshape(MEE,nx*nx,1) % E to E Connection Strength
            g]; 

end
disp(['Integration ended at:   ',datestr(now,'HH:MM:SS')])

save([datapath,'/results.mat'],'RE_Stim','MEEt');
saveas(h2,[datapath,'/RE_T_' num2str(iTrial) '.jpg'])
saveas(h3,[datapath,'/RE_X_' num2str(iTrial) '.jpg'])
saveas(h4,[datapath,'/g-MEE_' num2str(iTrial) '.jpg'])


