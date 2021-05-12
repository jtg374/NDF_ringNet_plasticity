function FModes(datapath)
    load([datapath,'param.mat'],'nTrial');
    load([datapath,'param.mat'],'x','pNp','N');
    load([datapath,'param.mat'],'tTrial','dt_store');
    nt = tTrial/dt_store + 1;
    mode0 = zeros(N,nt,nTrial); %(stim,time,trial)
    modec1 = zeros(N,nt,nTrial);
    modes1 = zeros(N,nt,nTrial);
    modec2 = zeros(N,nt,nTrial);
    modes2 = zeros(N,nt,nTrial);
    c1=cos(x);
    s1=sin(x);
    c2=cos(2*x);
    s2=sin(2*x);
    for iTrial = 1:nTrial
        load([datapath 'FullData/results_' num2str(iTrial),'.mat'],'RE','t')
        % RE (neuron,stim,time); 
        %% Fourier modes
        mode0(:,:,iTrial) = mean(RE,1);
        for stim = 1:N
            RE_s = squeeze(RE(:,stim,:));     
            modec1(stim,:,iTrial) = c1*RE_s;
            modes1(stim,:,iTrial) = s1*RE_s;
            modec2(stim,:,iTrial) = c2*RE_s;
            modes2(stim,:,iTrial) = s2*RE_s;
        end
    end 

    mode1 = sqrt(modec1.^2 + modes1.^2);
    mode2 = sqrt(modec2.^2 + modes2.^2);
    
    save([datapath,'FModes.mat'],'mode0','mode1','mode2')
    load([datapath,'FModes.mat'])
    minimode = mode1(5,:,4000:100:5000); minimode = minimode(:);
    save([datapath,'minimode'],'minimode')

    fig = figure; plot(minimode)
    
    saveas(fig,[datapath,'minimode.jpg'])

    disp('finished')