function DecodingErrPopVecLocal(datapath)
%% load data
load([datapath,'DecodeErr.mat'],'Err')
c=hsv(8);
fig=figure;
ErrMean = mean(Err,3);
ErrMean = reshape(ErrMean,8,8,[]);
ErrMean = squeeze(mean(ErrMean,1))';
plot(ErrMean)
set(gca, 'ColorOrder',c, 'NextPlot','ReplaceChildren');
ax=gca;
ax.ActivePositionProperty = 'position';
plot(ErrMean)
legend({
    '-\pi to -3\pi/4',
    '-3\pi/4 to -\pi/2',
    '-\pi/2 to -\pi/4',
    '-\pi/4 to 0',
    '0 to \pi/4',
    '\pi/4 to \pi/2',
    '\pi/2 to 3\pi/4',
    '3\pi/4 to \pi',
    })

% xlim([0 800])
ylim([0 1.2])
xlabel('trial')
ylabel('decoding Error')


saveas(fig,[datapath,'DecodeErrLocal' '.jpg'])
saveas(fig,[datapath,'DecodeErrLocal' '.fig'])
