% Project/ experiment specific settings for EEG processing pipeline
% (c) Jeremy Yeaton
% Created: June 2019
% Updated: October 2019

%% Settings
modyco_settings_global
% mainDir      = 'C:\Users\jdyea\OneDrive\MoDyCo\_pilotSWOP\yaru'; % Change this to your experimental directory
mainDir = 'C:/Users/LPC/Documents/JDY/bilchin';

cd(mainDir); 

% Subject Identifiers
subs  = {'1014_FR_ER','1016_FR_PT','1017_FR_IQ','1018_BI_ZTT'};
% subs = {'1001_FR_PP_audVis','1001_FR_PP_vis','1002_BI_RG_aud','1002_BI_RG_vis',...
%     '1003_FR_MC','1004_FR_MV','1005_BI_CC','1006_BI_XYW_aud','1006_BI_XYW_vis',...
%     '1007_BI_YZH','1008_FR_AR','1010_BI_LJY','1011_BI_HXY','1012_FR_AL','1013_FR_SG'};

% Set filtering band limits
preproc.lpfreq      = 40; % Low pass frequency (Hz)
preproc.hpfreq      = .5; % High pass frequency (Hz)

% Set epoching parameters
baseline            = [-0.1 0]; % [-0.1 0] uses a 100ms pre-stim baseline
trialdef.prestim    = 0.1; % 0.1 = 100ms pre-stimulus
trialdef.poststim   = .8; % 1 = 1000 ms post-stimulus

% Max number of standard deviations from the mean before trial rejection
artfctdef.zvalue.cutoff      = 20;

% Trial types (trigger labels)
numberOfConditions  = 4;
trials              = [];
allTrials           = [];
% Specify trigger values for each condition:
trials{1}           = [115, 215]; 
trials{2}           = [125,225]; 
trials{3}           = [135,235]; 
trials{4}           = [145,245]; 
for condition = 1:numberOfConditions
    allTrials = [allTrials,trials{condition}];
end
trialdef.eventvalue = allTrials;
%%%% Grouping conditions for math? %%%%
% Condition pairs for subtraction
pairs = {[1 2]};

% Initialize default cfg
cfg.preproc             = preproc;
cfg.baselinewindow      = baseline;
cfg.baseline            = baseline;
cfg.trialdef            = trialdef;
cfg.trialfun            = 'ft_trialfun_bilchin';
default_cfg             = cfg;

% Latencies for ERP analysis
lats = {[.3 .5],[.5 .7],[.7 .9],[.9 1]}; % Latencies of interest in seconds

% Electrode subsets
% frontal = {'F4','F3','F7','F8'};
