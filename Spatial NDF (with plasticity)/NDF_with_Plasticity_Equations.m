function dy = NDF_with_Plasticity_Equations(t,y,param)

% unpack variables
N = param.N; % number of E and I neurons (equal)
np = param.np; % number of parallel network (for different stimulus locations)
g = y(N*N+N*np*6+3:end); % post-synaptic gain (g_i in main text)
MEE = y(N*np*6+3:N*np*6+N*N+2); 
MEE = reshape(MEE,N,N); % E-to-E synaptic weight (H_ij in main text)
MEI = param.MEI; % E-to-I
MIE = param.MIE;
MII = param.MII;
R = y(3:N*np*6+2);R = reshape(R,N,np,6);
RE = R(:,:,1);RI = R(:,:,2);SEE = R(:,:,3);SIE = R(:,:,4);SEI = R(:,:,5);SII = R(:,:,6);
IStim = y(1); IWipe=y(2);

% load timing
TStimOn   = param.TStimOn;
TStimOff  = param.TStimOff;
TDelayOff = param.TDelayOff;
TForgetOff= param.TForgetOff;
iTrial    = param.iTrial;

% set stimulus location
IEo = param.IEo; % contains np colomns (np parallel networks)
IIo = param.IIo; % set to zero
% transfer function
qE = param.qE;
qI = param.qI;

% main ode eqs
% % Neurons Populations and Synapses
dRe = 1./param.TE .*( -RE + qE(diag(g)*MEE.*(MEE>=0)*SEE - MEI*SEI + IEo*IStim)*(1-IWipe));
dRi = 1./param.TI .*( -RI + qI(MIE*SIE - MII*SII + IIo*IStim)*(1-IWipe));
dSee= 1./param.TEE.*(-SEE + RE);
dSie= 1./param.TIE.*(-SIE + RE);
dSei= 1./param.TEI.*(-SEI + RI);
dSii= 1./param.TII.*(-SII + RI);
% % External Stimilus
dIt = 1./param.Tinput .*( -IStim + sum(t>=TStimOn)   - sum(t>TStimOff)  ); % stimulus is filtered because NDF cannot integrate fast changing (square wave) signal
dIw = 1./param.Tinput .*( -IWipe + sum(t>=(TDelayOff+0)) - sum(t>TForgetOff) ); % wipe for forget (not used)


% % Plasticity
iS = param.pNp(iTrial); % stimulus location chosen for this trial to apply plasticity
if any( (t>TStimOff).* (t<TDelayOff) ) % during delay period
    %
    fM_XS = param.fM_XS;
    fM_homeo = param.fM_homeo;
    dMEE= fM_XS(RE(:,iS),dRe(:,iS))* (1-IStim)-MEE.*(MEE<0); % apply differential plasticity + penalize negative values
    dg  = fM_homeo(RE(:,iS),g); % apply homeostatic plasticity
    %
else % no plasticity outside delay
    dMEE=-MEE.*(MEE<0); % penalize negative values to keep synaptic weight positive
    dg = zeros(N,1);
end

% pack variable derivatives
dy=[dIt;dIw;
    reshape(dRe,N*np,1);
    reshape(dRi,N*np,1);
    reshape(dSee,N*np,1);
    reshape(dSie,N*np,1);
    reshape(dSei,N*np,1);
    reshape(dSii,N*np,1);
    reshape(dMEE,N*N,1);
    dg];  