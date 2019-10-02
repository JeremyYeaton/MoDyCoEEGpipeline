% Pipeline of processing for EEG data for the MoDyCo Lab
% (c) Jeremy Yeaton
% Created: June 2019
% Updated: October 2019

%% Import settings from file
mainDir      = 'C:\\Users\\jdyea\\OneDrive\\MoDyCo\\_pilotSWOP'; % Change this to your experimental directory
cd(mainDir); 

modyco_settings_project
%% Import; epoch; filter; separate & mean EOGs
tic
currSub = 1;
for sub = currSub:length(subs)
    subID            = subs{sub};
    disp(['Loading subject ',subID,' (',num2str(sub),')...']);
    EEGLABFILE       = [folders.prep,'\\',subID,'_',folders.eeglabTag,'.set'];
    if ~isfile(EEGLABFILE)
        EEG              = pop_biosig([mainDir,'\\raw_data\\',subID,'.bdf'],...
            'channels',1:70,'ref',[65 66] ,'refoptions',{'keepref' 'on'});
        EEG              = eeg_checkset( EEG );
        EEG              = pop_saveset( EEG, 'filename',EEGLABFILE,'filepath',[mainDir,'\\']);
    end
    cfg                     = default_cfg;
    cfg.refchannel          = {'M1' 'M2'};
    cfg.preproc.refchannel  = {'M1' 'M2'};
    cfg.dataset             = EEGLABFILE;
    cfg                     = ft_definetrial(cfg);
    data                    = ft_preprocessing(cfg);
    % Separate, mean, and recombine bipolar channels
    % HEOG
    cfg                     = data.cfg;
    cfg.channel             = {'HEOG1','HEOG2'};
    cfg.reref               = 'yes';
    cfg.implicitref         = [];
    cfg.refchannel          = {'HEOG2'};
    eogh                    = ft_preprocessing(cfg, data);
    cfg                     = data.cfg;
    cfg.channel             = 'HEOG1';
    eogh                    = ft_selectdata(cfg, eogh);
    eogh.label              = {'HEOG'};
    % VEOG
    cfg                     = data.cfg;
    cfg.channel             = {'VEOG1','VEOG2'};
    cfg.reref               = 'yes';
    cfg.implicitref         = [];
    cfg.refchannel          = {'VEOG2'};
    eogv                    = ft_preprocessing(cfg, data);
    cfg                     = data.cfg;
    cfg.channel             = 'VEOG1';
    eogv                    = ft_selectdata(cfg, eogv);
    eogv.label              = {'VEOG'};
    % Mastoid reference
    cfg                     = data.cfg;
    cfg.channel             = {'M1','M2'};
    cfg.reref               = 'yes';
    cfg.implicitref         = [];
    cfg.refchannel          = {'M2'};
    mast                    = ft_preprocessing(cfg, data);
    cfg                     = data.cfg;
    cfg.channel             = 'M1';
    mast                    = ft_selectdata(cfg, mast);
    mast.label              = {'M'};
    cfg                     = data.cfg;
    cfg.channel             = setdiff(1:64, 65:70);
    data                    = ft_selectdata(cfg, data);
    % Append the Mast EOGH and EOGV channel to the EEG channels
    cfg                     = data.cfg;
    data                    = ft_appenddata(cfg, data, eogv, eogh, mast);
    cfg.reref               = 'yes';
    cfg.refchannel          = 'M';
    cfg.preproc.refchannel  = 'M';
    cfg.demean              = 'yes';
    data.cfg.channel        = data.label;
    % Automatic artifact rejection
    cfg.artfctdef                    = artfctdef;
    [cfg, artifact_eog]              = ft_artifact_eog(cfg,data);
%     cfg.artfctdef.zvalue.cutoff      = 20;
    [cfg, artifact_zval]             = ft_artifact_zvalue(cfg,data);
    % Add artifacts to cfg
    cfg.artfctdef.eog.artifact       = artifact_eog;
    cfg.artfctdef.zvalue.artifact    = artifact_zval;
    % Reject artifacts and save
    data                             = ft_rejectartifact(cfg,data);
    fileName = [folders.prep,'\\',subID,'_',folders.prep,'.mat'];
    disp(['Saving ',fileName,' (',num2str(sub),')...']);
    save(fileName,'data')
    toc
end
waitbar(1,'Done! Now do visual rejection!');
%% Visual rejection (Summary, channel, or trial)
for sub = 1:length(subs)
    subID                = subs{sub};
    disp(['Loading subject ',subID,' (',num2str(sub),')...']);
    load([folders.prep,'\\',subID,'_',folders.prep,'.mat'],'data');
    % Visual inspection
    cfg                  = default_cfg;%data.cfg;
    cfg.channel          = data.label;%'all';
    cfg.method           = 'summary';
    data                 = ft_rejectvisual(cfg,data);
    rep = input('Further review necessary? [y/n]: ','s');
    while ~strcmp(rep,'n')
        if ismember(rep,{'summary','trial','channel'})
            cfg.method = rep;
        else
            cfg.method = input('Summary, channel or trial? ','s');
        end
        data             = ft_rejectvisual(cfg,data);
        rep = input('Further review necessary? [y/n]: ','s');
    end
    cfg.missingchannel   = setdiff(allElecs.label,data.label);
    disp(['Saving file ',subID,' (',num2str(sub),')...']);
    save([folders.visRej,'\\',subID,'_',folders.visRej,'.mat'],'data');
end
waitbar(1,'Done! Now do ICA decomposition!');
%% ICA decomposition
for sub = 1:length(subs)
    subID      = subs{sub};
    saveName   = [folders.ica,'\\',subID,'_',folders.ica,'.mat'];
    saveFile   = 'y';
    if isfile(saveName)
        saveFile = input(['File for ',subID,' already exists. Overwrite? [y/n]'],'s');
        if strcmp(saveFile,'n')
            disp('File not saved. ICA decomp already exists.');
        end
    end
    if strcmp(saveFile,'y')
        disp(['Loading subject ',subID,' (',num2str(sub),')...']);
        load([folders.visRej,'\\',subID,'_',folders.visRej,'.mat'],'data');
        cfg              = default_cfg;%data.cfg;
        cfg.numcomponent = 25;
        cfg.method       = 'runica';
        comp             = ft_componentanalysis(cfg, data);
        disp(['Saving file ',subID,' (',num2str(sub),')...']);
        save(saveName,'data','comp');
    end
end
waitbar(1,'Done! Now do component rejection!');
%% Component rejection
for sub = 1:length(subs)
    subID         = subs{sub};
    disp(['Loading subject ',subID,' (',num2str(sub),')...']);
    load([folders.ica,'\\',subID,'_',folders.ica,'.mat'],'data','comp');
    cfg           = [];
    cfg.trl       = data.cfg.trl;
    cfg.layout    = 'biosemi64.lay';
    cfg.component = 1:25;
    cfg.comment   = 'no';
    cfg.viewmode  = 'component';
    figure; ft_topoplotIC(cfg, comp)
    ft_databrowser(cfg, comp)
    artComp       = input('Enter components for removal separated by spaces: ','s');
    artComp       = sscanf(artComp,'%f')';
    cfg.component = artComp;
    data          = ft_rejectcomponent(cfg, comp, data);
    disp(['Saving file ',subID,' (',num2str(sub),')...']);
    save([folders.rmvArtfct,'\\',subID,'_',folders.rmvArtfct,'.mat'],'data');
    close all
end
waitbar(1,'Done! Now do time lock analysis!');
