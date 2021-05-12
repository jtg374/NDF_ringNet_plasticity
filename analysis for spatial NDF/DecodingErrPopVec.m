function DecodingErrPopVec(datapath)
%% load data
data1 = load([datapath,'results.mat']);
data1.param = load([datapath,'param.mat']);

%% decoding
N = data1.param.N;
Nt = data1.param.nTrial;
np = data1.param.np;
x = data1.param.x;
% RE_readout = data1.RE(:,:,t_readout/dt_store);
RE_readout = data1.RE_readout;
nRE = poissrnd(RE_readout*200/1000); % simulate spike counts in 200ms
theta_hat = zeros(np,Nt);
Err = zeros(np,Nt,1); %%%%%%%%
for in = 1:size(Err,3)
    for it = 1:Nt
        theta_hat(:,it) = atan2(sin(x)*nRE(:,:,it),cos(x)*nRE(:,:,it));
    end
    Err(:,:,in)  = 1-cos(theta_hat - data1.param.stimLoc_theta);
end
save([datapath,'DecodeErr.mat'],'Err')

ErrMean = mean(mean(Err,3),1);
ErrFinal = mean(ErrMean(end-500:end));

%%
fig = figure;
plot(ErrMean)
ax=gca;
ax.ActivePositionProperty = 'position';
xlabel('Trial')
ylabel('Decoding Error')


ErrConverge = mean(ErrMean(end-500:end),'omitnan');
TT = 50; % convultion time window
ErrSm = conv(ErrMean,ones(TT,1)/TT,'valid');
temp = find(ErrSm<ErrConverge);
iTrial = TT+temp(1);

sss = sprintf('Final%0.5fat%d.mat', ErrConverge,iTrial);

saveas(fig,[datapath,'DecodeErr_' sss '.jpg'])
saveas(fig,[datapath,'DecodeErr_' sss '.fig'])
