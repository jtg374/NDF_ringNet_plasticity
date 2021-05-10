function dy = NDF_with_Plasticity_Equations(t,y,param)

% unpack variables
N = param.N;
MEE = y(N*6+3:end);
MEE = reshape(MEE,N,N);MEE(MEE<0)=0;
MEI = param.MEI;
MIE = param.MIE;
MII = param.MII;
R = y(3:N*6+2);R = reshape(R,N,6);RE = R(:,1);RI = R(:,2);SEE = R(:,3);SIE = R(:,4);SEI = R(:,5);SII = R(:,6);
IStim = y(1); IWipe=y(2);

% load timing
TStimOn   = param.TStimOn;
TStimOff  = param.TStimOff;
TDelayOff = param.TDelayOff;
TForgetOff= param.TForgetOff;
nTrial    = sum(t>=TStimOn);
isTraining = nTrial<=param.nTrialTrain;

% set stimulus location
shift=0;
if nTrial
    shift = param.stimLoc(nTrial);
end
IEo = circshift(param.IEo,shift);IIo = circshift(param.IIo,shift);
% transfer function
qE = param.qE;
qI = param.qI;

% main ode eqs
% % Neurons Populations and Synapses
dRe = 1./param.TE .*( -RE + qE(MEE*SEE - MEI*SEI + IEo*IStim)*(1-IWipe));
dRi = 1./param.TI .*( -RI + qI(MIE*SIE - MII*SII + IIo*IStim)*(1-IWipe));
dSee= 1./param.TEE.*(-SEE + RE);
dSie= 1./param.TIE.*(-SIE + RE);
dSei= 1./param.TEI.*(-SEI + RI);
dSii= 1./param.TII.*(-SII + RI);
% % External Stimilus
dIt = 1./param.Tinput .*( -IStim + sum(t>=TStimOn)   - sum(t>TStimOff)  );
dIw = 1./param.Tinput .*( -IWipe + sum(t>=(TDelayOff+0)) - sum(t>TForgetOff) );
% % Plasticity
K=10/500;dRe_ = dRe;dRe_(dRe>K)=K; % set an upper bound for plasticity
if isTraining && any( (t>TStimOff).* (t<TDelayOff) )
    %
    fM = param.fM;
    dMEE= fM(RE,dRe_)* (1-IStim);
    %
else 
    dMEE=zeros(N,N);
end

% pack variable derivatives
dy=[dIt;dIw;dRe;dRi;dSee;dSie;dSei;dSii;reshape(dMEE,N*N,1)];  