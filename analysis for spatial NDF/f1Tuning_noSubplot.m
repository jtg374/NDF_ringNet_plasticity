function f1Tuning(datapath)
    disp(datapath)
    param = load([datapath,'param.mat']);
    load([datapath,'results.mat'],'RE_readout');
    N = param.N;
    nTrial = size(RE_readout,3);
    ff = exp(1j*param.x); % Fourier filter of 1-cycle
    ff = reshape(ff,N,1);
    f1 = zeros(N,nTrial);
    for iTrial = 1:nTrial;
        f1(:,iTrial) = abs(RE_readout(:,:,iTrial)*ff/N);
    end
    save([datapath,'f1.mat'],'f1')

    f1mean = mean(f1,1); f1mean(f1mean<0.01)=NaN; 
    f1std = std(f1,1);
    f1stdNormalized=f1std./f1mean;
    f1mean = mean(f1,1);
    
    h=figure;
    plot(f1stdNormalized);
    ax=gca;
    ax.ActivePositionProperty = 'position';    
    title(['Final f1 std/mean = ', num2str(f1stdNormalized(:,end))])
    xlabel('Trial')
    ylabel('std/mean Fourier')
    saveas(h,[datapath,'f1TuningStdNormalized.fig'])

    h=figure;
    plot(f1mean)
    ax=gca;
    ax.ActivePositionProperty = 'position';    % title(['Final f1 mean = ', num2str(f1mean(:,end))])
    xlabel('Trial')
    ylabel('Fourier tuning')
    hold on
    plot(f1std)
    legend({'mean','std'})
    saveas(h,[datapath,'f1TuningMeanAndStd.fig'])

    c = hsv(8);
    h=figure;
    f1Group = reshape(f1,8,8,nTrial);
    f1Group = squeeze(mean(f1Group,1))';
    plot(f1Group)
    set(gca, 'ColorOrder',c, 'NextPlot','ReplaceChildren');
    plot(f1Group)
    ax=gca;
    ax.ActivePositionProperty = 'position';
    lg=legend({
        '-\pi to -3\pi/4',
        '-3\pi/4 to -\pi/2',
        '-\pi/2 to -\pi/4',
        '-\pi/4 to 0',
        '0 to \pi/4',
        '\pi/4 to \pi/2',
        '\pi/2 to 3\pi/4',
        '3\pi/4 to \pi',
        });
    lg.Location = 'northwest';
    lg.Box = 'off';
    
    xlabel('trial')
    ylabel('Fourier tuning')
    saveas(h,[datapath,'f1TuningGroup.fig'])

    % f1meanFinal = mean(f1mean(end-500:end));
    % f1stdFinal  = mean(f1std(end-500:end));


    % saveas(h,[datapath,'f1Tuning_' 'm' num2str(f1meanFinal) '_sd' num2str(f1stdFinal) '_' num2str(f1stdFinal/f1meanFinal) '.jpg'])
    % saveas(h,[datapath,'f1Tuning_' 'm' num2str(f1meanFinal) '_sd' num2str(f1stdFinal) '_' num2str(f1stdFinal/f1meanFinal) '.fig'])

