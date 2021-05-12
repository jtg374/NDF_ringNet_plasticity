function ActPatrnSynRedrawAtTrial(datapath,iTrial)
    addpath('/gpfsnyu/home/jtg374/MATLAB/CubeHelix') 
    switch nargin
    case 1 % no trial assigned, just plot the last
        load([datapath,'param.mat'],'nTrial');
        iTrial = nTrial;
    case 2 % plot the assigned trial
        iTrial = iTrial;
    end
    load([datapath,'param.mat'],'x');
    load([datapath,'results.mat'],'RE_readout','g_readout','MEEt'); 
    RE_toPlot = RE_readout(:,:,iTrial);
    gMEE_toPlot = diag(g_readout(:,iTrial)) * MEEt(:,:,iTrial);

    %% plot activity pattern    
    h=figure;
    img=image(x,x,RE_toPlot);
    img.CDataMapping='scaled';
    ax = gca;
    ax.ActivePositionProperty = 'position';
    colormap(cubehelix)
    cb=colorbar;
    cb.Label.String='Activity';
    ax.DataAspectRatio = [1,1,1];
    xticks(-pi:pi/2:pi/2)
    xticklabels({'-\pi','\pi/2','0','\pi/2'})
    xlabel('stim loc')
    yticks(-pi:pi/2:pi/2)
    yticklabels({'-\pi','\pi/2','0','\pi/2'})
    ylabel('neuron')
    title(['Activity Pattern at Trial = ' num2str(iTrial)])
    saveas(h,[datapath 'ActPatternTrial' num2str(iTrial) 'FullRange' '.jpg'])
    saveas(h,[datapath 'ActPatternTrial' num2str(iTrial) 'FullRange' '.fig'])
    ax.CLim = [0 50];
    colorbar('off')
    saveas(h,[datapath 'ActPatternTrial' num2str(iTrial)  '.jpg'])
    saveas(h,[datapath 'ActPatternTrial' num2str(iTrial)  '.fig'])
    % remove old plot
    delete([datapath,'RE_X_*'])
    
    %% plot synaptic weight
    h=figure;
    img = image(x,x,gMEE_toPlot);
    img.CDataMapping='scaled';
    ax = gca;
    ax.ActivePositionProperty = 'position';
    colormap(cubehelix)
    cb=colorbar;
    cb.Label.String='Weight'; 
    ax.DataAspectRatio = [1,1,1];
    xticks(-pi:pi/2:pi/2)
    xticklabels({'-\pi','\pi/2','0','\pi/2'})
    xlabel('pre-syn')
    yticks(-pi:pi/2:pi/2)
    yticklabels({'-\pi','\pi/2','0','\pi/2'})
    ylabel('post-syn')
    title(['Synaptic Weights at Trial = ' num2str(iTrial)])
    saveas(h,[datapath 'gMEETrial' num2str(iTrial) 'FullRange' '.jpg'])
    saveas(h,[datapath 'gMEETrial' num2str(iTrial) 'FullRange' '.fig'])        
    ax.CLim = [0 12];
    colorbar('off')
    saveas(h,[datapath 'gMEETrial' num2str(iTrial)  '.jpg'])
    saveas(h,[datapath 'gMEETrial' num2str(iTrial)  '.fig'])
    % remove old plot
    delete([datapath,'g-MEE_*'])

end

