function dy = NDF_Equations(t,y,param)

% unpack variables
N = param.N; % index of neuron
Np = N; % index of stimulus (parallel network)
MEE = param.MEE; % E-to-E synaptic weight
MEI = param.MEI; % I-to-E synaptic weight
MIE = param.MIE;
MII = param.MII;
IEo = param.IEo;
IIo = param.IIo;
IStim = y(1); % frist variable is stimulus trace
R = y(2:N*Np*6+1); % rate and synaptic variables
R = reshape(R,N,Np,6);
RE = R(:,:,1);RI = R(:,:,2);SEE = R(:,:,3);SIE = R(:,:,4);SEI = R(:,:,5);SII = R(:,:,6);

% load timing
TStimOn   = param.TStimOn;
TStimOff  = param.TStimOff;

% transfer function
qE = param.qE;
qI = param.qI;

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
dy=[dIt;dRe(:);dRi(:);dSee(:);dSie(:);dSei(:);dSii(:)];  