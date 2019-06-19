%% Settings
% Set filtering band limits
preproc.lpfreq      = 40; % Low pass frequency (Hz)
preproc.hpfreq      = .5; % High pass frequency (Hz)

% Set epoching parameters
baseline            = [-0.1 0]; % [-0.1 0] uses a 100ms pre-stim baseline
trialdef.prestim    = 0.1; % 0.1 = 100ms pre-stimulus
trialdef.poststim   = 1; % 1 = 1000 ms post-stimulus

% Max number of standard deviations from the mean before trial rejection
artfctdef.zvalue.cutoff      = 4;

% Trial types (trigger labels)
trials              = [];
trials.can          = [212,214,222,224,231,232,233,234,241,242,243,244]; % canonical
trials.vio          = [112,114,122,124,131,132,133,134,141,142,143,144]; % violation
% Trial definition parameters
trialdef.eventvalue = [trials.can trials.vio];

% Subject Identifiers
subs  = {'s_04nm','s_07ba'};

% Default cfg
cfg.preproc             = preproc;
cfg.baselinewindow      = baseline;
cfg.baseline            = baseline;
cfg.trialdef            = trialdef;
% cfg.trialfun            = 'ft_trialfun_swop';
default_cfg             = cfg;

% Latencies for ERP analysis
lats = {[.3 .5],[.5 .7],[.7 .9],[.9 1]};
mint = [.300,.500,.700,.900];
maxt = [.500,.700,.900,1];

% Electrode subsets
frontal = {'F4','F3','F7','F8'};