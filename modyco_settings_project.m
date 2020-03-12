% Project/ experiment specific settings for EEG processing pipeline
% (c) Jeremy Yeaton
% Created: June 2019
% Updated: October 2019

%% Settings
modyco_settings_global
% mainDir      = 'C:\Users\jdyea\OneDrive\MoDyCo\_pilotSWOP\yaru'; % Change this to your experimental directory
% mainDir = 'C:/Users/LPC/Documents/JDY/bilchin';
% mainDir = 'C:/Users/S2CH/Documents/BILCHIN';
mainDir = 'E:/MoDyCo/BILCHIN';
% mainDir = 'C:\Users\S2CH\Desktop\BILCHIN_Analysis';


cd(mainDir); 

% Subject Identifiers
subs = {'1003_FR_MC','1004_FR_MV','1006_BI_XYW',... %'1002_BI_GRW','1005_BI_CC',
    '1007_BI_YZH','1009_FR_MD','1010_BI_LJY','1011_BI_HXY','1012_FR_AL',...
    '1013_FR_SG','1014_FR_ER','1015_FR_OB','1016_FR_PT','1017_FR_IQ','1018_BI_ZTT',...
    '1020_BI_ZWT','1021_BI_LRX','1022_FR_CB','1023_FR_AV',...%'1019_BI_LT',
    '1024_FR_AB','1025_FR_IA','1026_FR_MR','1028_FR_EC'...
    '1029_FR_MS','1030_BI_LSY',...
    '1031_FR_AF','1032_FR_RA','1033_FR_CA'};%,'1034_FR_CC','1035_FR_TP',...
    %'1036_FR_PV','1037_FR_JF'}; %'1027_FR_CH',

% Set filtering band limits
preproc.lpfreq      = 40; % Low pass frequency (Hz)
preproc.hpfreq      = .5; % High pass frequency (Hz)

% Set epoching parameters
baseline            = [-0.1 0]; % [-0.1 0] uses a 100ms pre-stim baseline
trialdef.prestim    = 0.1; % 0.1 = 100ms pre-stimulus
trialdef.poststim   = .8; % 1 = 1000 ms post-stimulus

% Max number of standard deviations from the mean before trial rejection
artfctdef.zvalue.cutoff = 20;

% Trial types (trigger labels)
numberOfConditions  = 12;
trials              = [];
allTrials           = [];
% Specify trigger values for each condition:
% Auditory
trials{1}           = [115];%,'115'}; 
trials{2}           = [125];%,'125'}; 
trials{3}           = [135];%,'135'}; 
trials{4}           = [145];%,'145'}; 
% Visual
trials{5}           = [215];%,'215'}; 
trials{6}           = [225];%,'225'}; 
trials{7}           = [235];%,'235'}; 
trials{8}           = [245];%,'245'};
% Combined
trials{9}           = [115 215]; % Spo
trials{10}          = [125 225]; % sPo
trials{11}          = [135 235]; % spO
trials{12}          = [145 245]; % spo

for condition = 1:numberOfConditions
    allTrials = [allTrials,trials{condition}];
end
trialdef.eventvalue = allTrials;
%%%% Grouping conditions for math? %%%%
% Condition pairs for subtraction
pairs = {[10 12],[11 12]};%{[2 3],[2 4],[3 4],[6 7],[6 8],[7 8]};

% Initialize default cfg
cfg.preproc             = preproc;
% cfg.baselinewindow      = baseline;
cfg.baseline            = baseline;
cfg.trialdef            = trialdef;
cfg.trialfun            = 'ft_trialfun_bilchin';
default_cfg             = cfg;

% Latencies for ERP analysis
lats = {[.3 .5],[.5 .7],[.7 .9],[.9 1]}; % Latencies of interest in seconds

% Electrode subsets
% frontal = {'F4','F3','F7','F8'};
