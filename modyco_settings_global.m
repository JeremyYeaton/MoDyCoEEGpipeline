%% Settings
% Pilot data directory
load('biosemi_neighbours.mat','neighbors');
allElecs = readtable('biosemi64.txt');
% Directory names
folders             = [];
folders.prep        = 'preprocess';
folders.visRej      = 'visualRejection';
folders.ica         = 'icaComponents';
folders.rmvArtfct   = 'removeComponents';
folders.timelock    = 'timelock';
folders.results     = 'results';
folders.figs        = 'figures';

allFolders = {folders.prep,folders.visRej,folders.ica,folders.rmvArtfct,...
    folders.timelock,folders.results,folders.figs};
for folder = 1:length(allFolders)
    if ~isfolder(allFolders{folder})
        mkdir(allFolders{folder})
    end
end

% Default cfg
cfg                     = [];
cfg.layout              = 'biosemi64.lay';
cfg.neighbours          = neighbors;
cfg.method              = 'trial';
cfg.continuous          = 'yes';
cfg.demean              = 'yes';
cfg.reref               = 'yes';
cfg.refchannel          = {'M'};

% Global preprocessing settings
preproc             = [];
preproc.lpfilter    = 'yes'; 
preproc.hpfilter    = 'yes'; 
preproc.demean      = 'yes';
preproc.reref       = 'yes';
preproc.refchannel  = 'M';

% Global artifact rejections settings
eegChannels                  = [1:64,67];
artfctdef                    = [];
artfctdef.reject             = 'complete';
artfctdef.feedback           = 'no';
artfctdef.eog.channel        = {'HEOG','VEOG'};
artfctdef.zvalue.channel     = eegChannels;
artfctdef.zvalue.demean      = 'yes';

% Global trial definition settings
trialdef            = [];
trialdef.eventtype  = 'trigger';