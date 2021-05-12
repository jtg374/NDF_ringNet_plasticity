function f1Synapse(datapath)
    addpath('/gpfsnyu/home/jtg374/MATLAB/CubeHelix') 
    disp(datapath)
    param = load([datapath,'param.mat']);
    load([datapath,'results.mat'],'MEEt','g_readout');
    N = param.N;
    nTrial = size(MEEt,3);
    ff = exp(1j*param.x); % Fourier filter of 1-cycle
    ff = reshape(ff,N,1);
    f1 = zeros(N,nTrial);
    for iTrial = 1:nTrial;
        f1(:,iTrial) = abs(diag(g_readout(:,iTrial))*MEEt(:,:,iTrial)*ff/N);
    end
    save([datapath,'f1MEE.mat'],'f1')

    f1mean = mean(f1,1); f1mean(f1mean<0.01)=NaN; 
    f1std = std(f1,1);
    f1stdNormalized=f1std./f1mean;
    f1mean = mean(f1,1);
    h=figure;

    subplot(224)
    plot(f1stdNormalized);
    % title(['Final f1 std/mean = ', num2str(f1stdNormalized(:,end))])
    xlabel('Trial')
    title('std/mean Fourier of incoming weights')

    subplot(222)
    plot(f1mean)
    % title(['Final f1 mean = ', num2str(f1mean(:,end))])
    xlabel('Trial')
    title('mean Fourier of incoming weights')

    subplot(223)
    plot(f1std)
    % title(['Final f1 std = ', num2str(std(f1(:,end)))])
    xlabel('Trial')
    title('std Fourier of incoming weights')

    c = hsv(8);
    subplot(221)
    f1Group = reshape(f1,8,8,nTrial);
    f1Group = squeeze(mean(f1Group,1))';
    plot(f1Group)
    set(gca, 'ColorOrder',c, 'NextPlot','ReplaceChildren');
    plot(f1Group)
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
    title('Fourier of incoming weights')

    f1meanFinal = mean(f1mean(end-500:end));
    f1stdFinal  = mean(f1std(end-500:end)); 

    saveas(h,[datapath,'f1GMEE'  '_m' num2str(f1meanFinal) '_sd' num2str(f1stdFinal) '_' num2str(f1stdFinal/f1meanFinal)  '.jpg'])
    saveas(h,[datapath,'f1GMEE'  '_m' num2str(f1meanFinal) '_sd' num2str(f1stdFinal) '_' num2str(f1stdFinal/f1meanFinal)  '.fig'])
