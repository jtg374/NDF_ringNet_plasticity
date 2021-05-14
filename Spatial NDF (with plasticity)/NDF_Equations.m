function dy = NDF_Equations(t,y,param)

% unpack variables
N = param.N;
MEE = param.MEE;
MEI = param.MEI;
MIE = param.MIE;
MII = param.MII;
R = y(2:N*6+1);R = reshape(R,N,6);RE = R(:,1);RI = R(:,2);SEE = R(:,3);SIE = R(:,4);SEI = R(:,5);SII = R(:,6);
IStim = y(1);

% load timing
TStimOn   = param.TStimOn;
TStimOff  = param.TStimOff;

% set stimulus location
shift= param.stimLoc;
IEo = circshift(param.IEo,shift);IIo = circshift(param.IIo,shift);
% transfer function
qE = @(x) x.*(x>0);
qI = @(x) x.*(x>0);

% main ode eqs
% % Neurons Populations and Synapses
dRe = 1./param.TE .*( -RE + qE(MEE*SEE - MEI*SEI + IEo*IStim));
dRi = 1./param.TI .*( -RI + qI(MIE*SIE - MII*SII + IIo*IStim));
dSee= 1./param.TEE.*(-SEE + RE);
dSie= 1./param.TIE.*(-SIE + RE);
dSei= 1./param.TEI.*(-SEI + RI);
dSii= 1./param.TII.*(-SII + RI);
% % External Stimilus
dIt =           1./param.Tinput .*( -IStim + sum(t>=TStimOn)   - sum(t>TStimOff)  );

% pack variable derivatives
dy=[dIt;dRe;dRi;dSee;dSie;dSei;dSii];  