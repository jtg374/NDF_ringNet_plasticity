function GainActRedrawHomeo(datapath)
    load([datapath,'param.mat'])
    JEO = IEo(33)/2.35;
    JEO = round(JEO/100)*100;

    load([datapath,'results.mat'],'g_readout')
    h=figure;
    h.Position = [404,390,400,500];
    subplot(211)
    plot(g_readout')
    c = hsv(N);
    set(gca, 'ColorOrder',c, 'NextPlot','ReplaceChildren');
    plot(g_readout')
    xlabel('Trial')
    ylabel('gain')
    % ylim([0.95,1.05])
    title(['J_{stim} = ' num2str(JEO) '  target rate = ' num2str(r_target)])

    iTrial = size(g_readout,2);

    load([datapath,'FullData/results_' num2str(iTrial) '.mat'],'RE')
    ii = pNp(iTrial);
    subplot(212)
    plot(squeeze(RE(ii,ii,:)))
    xlabel('time')
    ylabel('activity')
    ylim([0 60])
    

    saveas(h,[datapath,'GainAndPeakAct.fig'])
    saveas(h,[datapath,'GainAndPeakAct.jpg'])
