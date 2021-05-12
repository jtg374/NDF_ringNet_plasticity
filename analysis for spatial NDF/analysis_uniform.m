function analysis_uniform(datapath)
    disp(datapath)
    nTrialPlot=5; % default draw 5 trials
    param = load([datapath 'param.mat'])
    nTrial = param.nTrial;
    Activity5TrialsRedraw(datapath,1,nTrialPlot);
    Activity5TrialsRedraw(datapath,nTrial-nTrialPlot+1,nTrial);
    ActPatrnSynRedrawAtTrial(datapath,nTrial);
    % DecodingErrPopVec(datapath);
    % f1Tuning(datapath);
    % f1Synapse(datapath);
    % EigenValueUniform(datapath);
    % disp('finished')