function param = NDF_Parameters(MEE)
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
    if nargin
        nx = size(MEE,1); % number of E and I neurons (equal)
    else
        nx = 128;
    end
    dx = 2*pi/nx;
    x = -pi:dx:pi-dx; %periodic boundary 
    
    param.N = nx;
    param.dx= dx;
    param.x = x;
    
    %% Connectivity Profile
    J = 100; % feedback strength
    JEE = 1*J;JIE = 2*J;JEI = 1*J;JII = 2*J; 
    sigma_E = 0.2*pi; sigma_I = 0.1*pi; % wider excitatory synaptic projection
    f_E = 1*exp(-(x/sigma_E).^2); % excitatory weight profile
    f_I = 1*exp(-(x/sigma_I).^2); % inhibitory weight profile


    MIE = zeros(nx,nx);
    MEI = zeros(nx,nx);

    for i = 1:nx
        MIE(i,:) = dx*circshift(f_E,[0 -pi/dx-1+i]);
        MEI(i,:) = dx*circshift(f_I,[0 -pi/dx-1+i]);
    end
    MII = MEI;

    if nargin==0; MEE = JEE*MIE; end
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
    % threshold linear, non-saturating
    param.qE = @(x) x.*(x>0);
    param.qI = @(x) x.*(x>0);


    %% External Input
    JEO = 2*J; % strength
    IEO_init = 1.35*(exp(-(x/(pi/4)).^2)'+1*ones(nx,1));  % profile
    IEo = JEO*IEO_init; % external stimulus centered at 0

    param.IEo = gallery('circul',IEo); % copy around circle for nx stimulus locations
    param.IIo = 0; % no input to I population (does not affect response)
    
    %% simulation timing in milisecond

    T_on = 500; % time before stimulus on
    Tstim = 500; % stimlus duration
    Tmemory = 3000; % delay duration
    
    param.TStimOn = T_on;
    param.TStimOff  = T_on+Tstim;
    param.Tmax = T_on+Tstim+Tmemory;
    
    
    param.dt_store = 10;
