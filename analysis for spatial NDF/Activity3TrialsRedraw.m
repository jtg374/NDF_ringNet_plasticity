function Activity3TrialsRedraw(datapath,iTrial0,iTrial1)
    nTrialPlot=3; % default draw 5 trials
    load([datapath,'param.mat'],'nTrial');
    switch nargin
        case 1 % default draw begining trials
            iTrial0=1; iTrial1=iTrial0+nTrialPlot-1;
        case 2
            iTrial1=iTrial0;iTrial0=iTrial1-nTrialPlot+1;
        case 3
            iTrial0=iTrial0;iTrial1=iTrial1;
    end
    iTrial1 = min([iTrial1,nTrial]);
    load([datapath,'param.mat'],'x','pNp','N');
    fig=figure;
    ax = axes;
    tMin = NaN; tMax=NaN; % keep a record of xLim
    for iTrial = iTrial0:iTrial1
        load([datapath 'FullData/results_' num2str(iTrial),'.mat'],'RE','t')
        RE = squeeze(RE(:,pNp(iTrial),:)); % stim loc to plot, the one that plasticity was applied
        tMin = min([t;tMin]);
        tMax = max([t;tMax]);

        %% visualize activity of all neurons
        image(ax,'XData',t/1000,'YData',x,'CData',RE,'CDataMapping','scaled')


    end 
    for aa = ax; 
        xlim(aa,[tMin tMax]/1000); % remove white space
        xlabel(aa,'time (s)') ; 
        aa.ActivePositionProperty = 'position';
    end 
    
    axes(ax)
    addpath('/gpfsnyu/home/jtg374/MATLAB/CubeHelix') 
    colormap(ax,cubehelix)
    ax.CLim = [0 50];
    ylabel(ax,'neuron')
    ylim(ax,[-pi,pi])
    yticks([-pi,0,pi])
    yticklabels({'-\pi','0','\pi'})

    saveas(fig,[datapath,'Actvity_Trial_' num2str(iTrial0) '-' num2str(iTrial1) '.fig'])
    saveas(fig,[datapath,'Actvity_Trial_' num2str(iTrial0) '-' num2str(iTrial1) '.jpg'])
    disp([datapath,'Actvity_Trial_' num2str(iTrial0) '-' num2str(iTrial1) '.fig'])
    disp('finished')