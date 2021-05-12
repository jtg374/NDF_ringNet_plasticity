function ActPatrnSynRedrawAtTrial(datapath)
    load([datapath,'param.mat'],'x','perturbation');

    %% plot perturbation
    h=figure;
    img = image(x,x,perturbation);
    img.CDataMapping='scaled';
    ax = gca;
    ax.ActivePositionProperty = 'position';
    colormap(gray)
    cb=colorbar;
    cb.Label.String='Weight'; 
    ax.DataAspectRatio = [1,1,1];
    xticks(-pi:pi/2:pi/2)
    xticklabels({'-\pi','\pi/2','0','\pi/2'})
    xlabel('pre-syn')
    yticks(-pi:pi/2:pi/2)
    yticklabels({'-\pi','\pi/2','0','\pi/2'})
    ylabel('post-syn')  
    ax.CLim = [0.7 1];
    colorbar('off')
    saveas(h,[datapath 'perturbation.jpg'])
    saveas(h,[datapath 'perturbation.fig'])
end

