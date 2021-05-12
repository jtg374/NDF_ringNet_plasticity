function analysis_local(datapath)
    disp(datapath)
    param = load([datapath 'param.mat'])
    nTrial = param.nTrial;
    Activity5TrialsRedraw(datapath,1);
    Activity5TrialsRedraw(datapath,nTrial-4);
    Activity3TrialsRedraw(datapath,nTrial);
    ActPatrnSynRedrawAtTrial(datapath,nTrial);
    f1Tuning_noSubplot(datapath);
    DecodingErrPopVec(datapath);
    DecodingErrPopVecLocal(datapath);
    f1Tuning(datapath);
    % f1Synapse(datapath);
    % EigenValueUniform(datapath);