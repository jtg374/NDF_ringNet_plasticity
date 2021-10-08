function param = NDF_with_Plasticity_Parameters(a,lrD,lrH,nTrial,r_target)
    % a: perturbation strength, a=0.9 is 10% perturbation, a=0.85 is 15% perturbation, a=1 is no perturbation
    % nTrial: number of trials
    % lrD: learnign rate of differential plasticity
    % lrH: learnign rate of homeostatic plasticity
    % r_target: target activity of homeostatic plasticity
    %% Time constants
    % % neurons 
    param.TE = 20; % Excitatory population
    param.TI = 10; % Inhibitory population
    % % synapses
    param.TEE = 100; % E-to-E
    param.TIE = 25; % E-to-I
    param.TEI = 10;
    param.TII = 10;
    % % stimulus filter
    param.Tinput = 100; % NDF network cannot integrate fast-changing stimulus, see Lim & Goldman 2013 supp

    %% Discretizing the space x
    nx = 4; % number of E and I neurons (equal)
    dx = 2*pi/nx;
    x = -pi:dx:pi-dx; %periodic boundary 
    np = nx; % number of parallel network (for different stimulus locations)
    
    param.N = nx;
    param.dx= dx;
    param.x = x;
    param.np = np;
    
    %% Connectivity Profile
    J = 100;
    JEE = 1*J;JIE = 2*J;JEI = 1*J;JII = 2*J; 
    sigma_E = 0.2*pi; sigma_I = 0.1*pi; % wider excitatory synaptic projection
    f_E = 1*exp(-(x/sigma_E).^2); % excitatory weight profile
    f_I = 1*exp(-(x/sigma_I).^2); % inhibitory weight profile


    MEE = zeros(nx,nx);
    MEI = zeros(nx,nx);

    for i = 1:nx
        MEE(i,:) = dx*circshift(f_E,[0 -pi/dx-1+i]);
        MEI(i,:) = dx*circshift(f_I,[0 -pi/dx-1+i]);
    end
    MIE = MEE;
    MII = MEI;

    MEE = JEE*MEE;
    MIE = JIE*MIE;
    MEI = JEI*MEI;
    MII = JII*MII;

    param.MEE = MEE;
    param.MIE = MIE;
    param.MEI = MEI;
    param.MII = MII;

    %% Transfer Function
    % nonlinear transfer function (not used here)
    NE = 2;
    thE = 10;
    sigE = 40;
    maxfE = 100;
    qE = @(x) maxfE*(x-thE).^NE./(sigE^NE+(x-thE).^NE).*(x>thE);
    
    NI = 2;
    thI = 10;
    sigI = 40;
    maxfI = 100;
    qI = @(x) maxfI*(x-thI).^NI./(sigI^NI+(x-thI).^NI).*(x>thI);
%     param.qE = qE;
%     param.qI = qI;
    % threshold linear, saturating
    param.qE = @(x) x.*(x>0) - (x-maxfE).*(x>maxfE);
    param.qI = @(x) x.*(x>0) - (x-maxfI).*(x>maxfI);

    %% Perturbations
%     a = 0.9; % perturbation stregnth set in function argument
    % % smooth local perturbation
    index_x = 0;
    width_x = 1e-10;
    perturbation = 1 - (1-a)*exp(-((x-index_x)/width_x).^2);
    param.perturbation = perturbation;
    perturbation = repmat(perturbation',1,nx);
    MEE0 = MEE; MEE = MEE.*perturbation;
    param.MEE = MEE;
    param.MEE_unperturbed = MEE0;
    param.perturbation_type = 'local-rowwise(postsyn)';
%     param.perturbation_strength = a;    
%     param.perturbation_index = index_x;
%     param.perturbation_width = width_x;
% global perturbation
    % MEE0 = MEE; MEE = MEE*a;
    % param.MEE = MEE;
    % param.MEE_unperturbed = MEE0;
    % param.perturbation_type = 'Global';
    % param.perturbation_strength = a;
% random perturbation
%     a = 0.01;
%     param.perturbation_strength = a;
%     perturbation = 10.^(randn(nx)*a);
%     MEE0 = MEE; MEE = MEE.*perturbation;
%     param.perturbation_type = 'MEE-random-lognormal';
%     a = 0.03;
%     param.perturbation_strength = a;
%     perturbation = randn(nx)*a+1;
%     MEE0 = MEE; MEE = MEE.*perturbation;
%     param.perturbation_type = 'MEE-random-normal';
%     r = [0.9 1.1]; 
%     param.perturbation_range = r;
%     perturbation = rand(nx)*(r(2)-r(1))+r(1);
%     MEE0 = MEE; MEE = MEE.*perturbation;
%     param.perturbation_type = 'MEE-random-uniform';
    % a = 0.03;
    % param.perturbation_strength = a;
    % perturbation = gamrnd(1/a^2,a^2,nx,nx);
    % MEE0 = MEE; MEE = MEE.*perturbation;
    % param.perturbation_type = 'MEE-random-gamma';
%
    % param.perturbation = perturbation;
    % param.MEE = MEE;
    % param.MEE_unperturbed = MEE0;

    %% External Input
    JEO = 2*J*sqrt(64/nx); % strength
    IEO_init = 1.35*(exp(-(x/(pi/4)).^2)'+1*ones(nx,1));  % profile
    IEo = JEO*IEO_init; % external stimulus centered at 0

    param.IEo = gallery('circul',IEo); % copy around circle for nx stimulus locations
    param.IEo = param.IEo([nx/2+1:nx,1:nx/2],:); % put 0 at center of stimulus array
    param.IIo = 0; % no input to I population (does not affect response)
    
    %% simulation timing in milisecond

    T_on = 500; % time before stimulus on
    Tstim = 2000; % stimlus duration
    Tmemory = 6000; % delay duration
    Tforget = 0; % time to depress activity to null (not used)
    
    nTrial=nTrial; % number of trails
    tTrial = T_on+Tstim+Tmemory+Tforget; % length of a trial
    tMax = nTrial*tTrial; % total time in ms

    TStimOn = T_on:tTrial:tMax;

    param.nTrial = nTrial;
    param.TStimOn   = TStimOn;
    param.TrialOn   = TStimOn-T_on;
    param.TStimOff  = TStimOn+Tstim;
    param.TDelayOff = TStimOn+Tstim+Tmemory;
    param.TForgetOff= TStimOn+Tstim+Tmemory+Tforget;
    param.Tmax = tMax;
    param.tTrial = tTrial;
    param.dt_store = 100;

    %% randomize stimlus location (for plasticity)
    pNp = randi(np,nTrial,1); % for each trial, randomly choose a parallel network, and use its activity to guide plasticity
    % this is the same as successively stimulate a single network at random locations and apply plasticity
    param.pNp = pNp;

    %% parameters for plasticity rules
    % x: nx by 1, x: post-syn, x': pre-syn
    param.fM_XS_expr = '@(x,dx)  -lrD .* dx*x'' '; %differential plasticity 
    param.fM_homeo_expr = '@(x,g)  lrH * (r_target-x).*g '; %homeostatic plasticity
    param.fM_XS = eval(param.fM_XS_expr);
    param.fM_homeo = eval(param.fM_homeo_expr);
    
    param.LearningRateDifferential = lrD;
    param.LearningRateHomeostatic = lrH;
    param.r_target = r_target;
    
    
