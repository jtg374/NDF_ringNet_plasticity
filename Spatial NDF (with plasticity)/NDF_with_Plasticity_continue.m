function NDF_with_Plasticity_continue(datapath,nTrialAdd)
% script for continue running 
disp(datapath)

% load parameters and build stimulus timing
param = load([datapath,'param.mat']);
nx = param.N;  % number of E and I neurons (equal)
np = param.np; % number of parallel network (for different stimulus locations)

% build stimulus timing
T_on = param.TStimOn(1); % read stimulus on time
Tstim = param.TStimOff(1)-param.TStimOn(1); % read stimulus duration
Tmemory = param.TDelayOff(1) - param.TStimOff(1); % read delay duration
Tforget = param.TForgetOff(1) - param.TDelayOff(1);
tTrial = T_on+Tstim+Tmemory+Tforget; % length of a trial
tMin = param.Tmax;
tMax = param.Tmax + nTrialAdd*tTrial;
param.Tmax = tMax;

TStimOn = T_on:tTrial:tMax;

nTrialOld = param.nTrial;
param.nTrial = param.nTrial + nTrialAdd
param.TStimOn   = TStimOn;
param.TrialOn   = TStimOn-T_on;
param.TStimOff  = TStimOn+Tstim;
param.TDelayOff = TStimOn+Tstim+Tmemory;
param.TForgetOff= TStimOn+Tstim+Tmemory+Tforget;

pNp = randi(np,nTrialAdd,1); % for each trial, randomly choose a parallel network, and use its activity to guide plasticity
param.pNp = [param.pNp(:,1);pNp];

% load previous results
load([datapath,'results.mat']);
%% unpack Connectivity weight 
MEE = MEEt(:,:,end);
g = g_readout(:,end);

%% pack initial values
nx = param.N;
np = param.np;
y0 = [0;              % Stimlus Strength
      0;              % Wipe for forget (not used)
      zeros(6*nx*np,1);  % 6*N state variables
      reshape(MEE,nx*nx,1); % E to E Connection Strength
      g % gains
      ]; 

%% load timings
nTrial = param.nTrial; % number of trials
tTrial = param.tTrial; % total time of each trial
TrialOn = param.TrialOn; % beginning of each trial
TrialEnd = param.TDelayOff; % end of each trial
dt_store = param.dt_store; % time resolution for store
%% load plasticity


%% Solving ODE equations
options = odeset('RelTol',1e-3,'AbsTol',1e-5); 
disp(['Integration started at: ',datestr(now,'HH:MM:SS')])
new.MEEt = zeros(nx,nx,nTrialAdd);
new.RE_readout = zeros(nx,np,nTrialAdd);
new.g_readout = zeros(nx,nTrialAdd);
MEEt = cat(3,MEEt,new.MEEt);
RE_readout = cat(3,RE_readout,new.RE_readout);
g_readout = cat(2,g_readout,new.g_readout);
clear new
for iTrial=(nTrialOld+1):param.nTrial
    param.iTrial = iTrial;
    [t,y] = ode23(@(t,y0) NDF_with_Plasticity_Equations(t,y0,param),...
        TrialOn(iTrial):dt_store:TrialEnd(iTrial),y0,options);
    %% unpack and save results for each trial
    nt = length(t);
    gt = y(:,nx*nx+nx*np*6+3:end)';g=gt(:,end);
    Mt = y(:,nx*np*6+3:nx*nx+nx*np*6+2);Mt = reshape(Mt,nt,nx,nx);
    MEE = Mt(end,:,:); MEE = squeeze(MEE);
    Rt = y(:,3:nx*np*6+2);Rt = reshape(Rt,nt,nx,np,6);Rt = permute(Rt,[2,3,1,4]);
    RE = Rt(:,:,:,1);RI = Rt(:,:,:,2);SEE = Rt(:,:,:,3);SIE = Rt(:,:,:,4);SEI = Rt(:,:,:,5);SII = Rt(:,:,:,6); 
    % snapshot of each trial at the end of delay
    MEEt(:,:,iTrial) = MEE;    
    RE_readout(:,:,iTrial) = RE(:,:,end);
    g=gt(:,end);g_readout(:,iTrial) = g;
    MEEt(:,:,iTrial) = MEE;    
    %% plot and save
    % addpath('/gpfsnyu/home/jtg374/MATLAB/CubeHelix') % we use CubeHelix colormap
    if mod(iTrial,100)==0 | ismember(iTrial,[1,2,5,10,20,50])
        save([datapath,'/FullData/results_' num2str(iTrial) '.mat'],'t','RE','RI','gt');
        h2=figure; %imagesc([RE RE1])
        imagesc(squeeze(RE(:,param.pNp(iTrial),:)),[0 50]);
        ylabel('neuron')
        xlabel('Time')
        % colormap(cubehelix)
        saveas(h2,[datapath,'/ActFigures/RE_T_' num2str(iTrial) '.jpg'])
        h3=figure;
        imagesc(RE(:,:,end),[0 50])
        xlabel('stim position')
        ylabel('neuron')
        % colormap(cubehelix)
        colorbar
        saveas(h3,[datapath,'/ActFigures/RE_X_' num2str(iTrial) '.jpg'])
        h4=figure;
        imagesc(diag(g)*MEE,[0 10])
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
            reshape(MEE,nx*nx,1); % E to E Connection Strength
            g %gain
            ]; 
end
disp(['Integration ended at:   ',datestr(now,'HH:MM:SS')])

%% save results
disp(datapath)
save([datapath,'/results.mat'],'RE_readout','MEEt','-v7.3','g_readout');
save([datapath,'/param.mat'],'-struct','param');
saveas(h3,[datapath,'/RE_X_' num2str(iTrial) '.jpg'])
saveas(h2,[datapath,'/RE_T_' num2str(iTrial) '.jpg'])
saveas(h3,[datapath,'/RE_X_' num2str(iTrial) '.jpg'])
saveas(h4,[datapath,'/g-MEE_' num2str(iTrial) '.jpg'])
