function Activity5TrialsRedraw(datapath,iTrial0,iTrial1)
    nTrialPlot=5; % default draw 5 trials
    switch nargin
        case 1 % default draw begining trials
            iTrial0=1; iTrial1=iTrial0+nTrialPlot-1;
        case 2
            iTrial0=iTrial0;iTrial1=iTrial0+nTrialPlot-1;
        case 3
            iTrial0=iTrial0;iTrial1=iTrial1;
    end
    load([datapath,'param.mat'],'nTrial');
    iTrial1 = min([iTrial1,nTrial]);
    load([datapath,'param.mat'],'x','pNp','N');
    fig=figure;
    ax(1) = subplot(311);
    ax(2) = subplot(312);
    ax(3) = subplot(313);
    tMin = NaN; tMax=NaN; % keep a record of xLim
    for iTrial = iTrial0:iTrial1
        load([datapath 'FullData/results_' num2str(iTrial),'.mat'],'RE','t')
        RE = squeeze(RE(:,pNp(iTrial),:)); % stim loc to plot, the one that plasticity was applied
        tMin = min([t;tMin]);
        tMax = max([t;tMax]);

        %% visualize activity of all neurons
        image(ax(1),'XData',t/1000,'YData',x,'CData',RE,'CDataMapping','scaled')

        %% visualize peak activity
        plot(ax(2),t/1000,RE(pNp(iTrial),:),'k');hold(ax(2),'on')
        plot(ax(2),t(end)/1000*[1,1],[RE(pNp(iTrial),end),0],'k--')
        
        %% Fourier modes
        cs = winter(5); % colors
        cc0 = cs(4,:);cc1=cs(3,:);cc2=cs(2,:); % take middle colors
        mode0 = mean(RE,1);         l0=plot(ax(3),t/1000,mode0,'Color',cc0); hold(ax(3),'on'); plot(ax(3),t(end)*[1,1]/1000,[mode0(end),0],'Color',cc0,'LineStyle','--')
        mode1 = cos(x)*RE/N*8;      l1=plot(ax(3),t/1000,mode1,'Color',cc1); hold(ax(3),'on'); plot(ax(3),t(end)*[1,1]/1000,[mode1(end),0],'Color',cc1,'LineStyle','--')
        mode2 = cos(x*2)*RE/N*8;    l2=plot(ax(3),t/1000,mode2,'Color',cc2); hold(ax(3),'on'); plot(ax(3),t(end)*[1,1]/1000,[mode2(end),0],'Color',cc2,'LineStyle','--')


    end 
    hold(ax(2),'off')
    hold(ax(3),'off')

    for aa = ax; 
        xlim(aa,[tMin tMax]/1000); % remove white space
        xlabel(aa,'time (s)') ; 
        aa.ActivePositionProperty = 'position';
    end 
    
    axes(ax(1))
    addpath('/gpfsnyu/home/jtg374/MATLAB/CubeHelix') 
    colormap(ax(1),cubehelix)
    ax(1).CLim = [0 50];
    ylabel(ax(1),'neuron')
    ylim(ax(1),[-pi,pi])
    yticks([-pi,0,pi])
    yticklabels({'-\pi','0','\pi'})
    cb = colorbar(ax(1));
    ax1Pos = ax(1).Position;
    cb.Position = [ax1Pos(1)+ax1Pos(3)+0.03,ax1Pos(2),0.01,ax1Pos(4)]; %left,bottom,width,height
    cb.Label.String = 'Activity';

    axes(ax(2))
    ylabel('peak act')
    ylim([0 50])

    axes(ax(3))
    ylabel('pop act')
    lg=legend([l0,l1,l2],'average','8cos(x)','8cos(2x)');
    lg.Box='off';
    ax3Pos = ax(3).Position;
    % lg.Position = [ax3Pos(1)+ax3Pos(3)+0.02,ax3Pos(2),0.1,ax3Pos(4)]; %left,bottom,width,height

    saveas(fig,[datapath,'Actvity_Trial_' num2str(iTrial0) '-' num2str(iTrial1) '.fig'])
    saveas(fig,[datapath,'Actvity_Trial_' num2str(iTrial0) '-' num2str(iTrial1) '.jpg'])

    disp('finished')