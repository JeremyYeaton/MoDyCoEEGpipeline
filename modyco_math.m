%% Import settings from file
mainDir      = 'C:\\Users\\jdyea\\OneDrive\\MoDyCo\\_pilotSWOP'; % Change this to your experimental directory
cd(mainDir); 

modyco_settings_project
%% Mean and store data by participant
averages    = [];
differences = [];
for sub = 1:length(subs)
    subID = subs{sub};
    disp(['Loading subject ',subID,' (',num2str(sub),')...']);
    load([folders.rmvArtfct,'\\',subID,'_',folders.rmvArtfct,'.mat'],'data');
    cfg                  = default_cfg;%data.cfg;
    cfg.method           = 'average';
    cfg.missingchannel   = setdiff(allElecs.label,data.label);
    cfg.neighbours       = neighbors;
    cfg.feedback         = 'no';
    % Interpolate missing channels
    if ~isempty(cfg.missingchannel)
        disp('Interpolating missing electrodes:');
        for chan = cfg.missingchannel
            disp(chan);
        end
        data             = ft_channelrepair(cfg,data);
    end
    % Average all trials for each condition
    for cond = 1:numberOfConditions
        disp(['Averaging over trials for condition ',num2str(cond),'...']);
        cfg            = default_cfg;%data.cfg;
        cfg.trials     = find(ismember(data.trialinfo,trials{cond}));
        averages{cond} = ft_timelockanalysis(cfg,data);
        averages{cond} = ft_timelockbaseline(cfg,averages{cond});
    end
    % Do subtraction between condition pairs of interest
    for P = 1:length(pairs)
        pair = pairs{P};
        disp(['Computing difference between conditions ',num2str(pair(1)),' and ',num2str(pair(2)),'...']);
        cfg            = default_cfg;%data.cfg;
        cfg.operation  = 'subtract';
        cfg.parameter  = 'avg';
        differences{P} = ft_math(cfg, averages{pair(1)}, averages{pair(2)});
    end
    disp(['Saving data file ',subID,' (',num2str(sub),')...']);
    save([folders.timelock,'\\',subID,'_',folders.timelock,'_average.mat'],'averages');
    disp(['Saving difference file ',subID,' (',num2str(sub),')...']);
    save([folders.timelock,'\\',subID,'_',folders.timelock,'_diff.mat'],'differences');
end
waitbar(1,'Done! Now do grand averaging!');
%% Read data into array for grand averaging
D = [];
for sub = 1:length(subs)
    subID = subs{sub};
    disp(['Loading subject ',subID,' (',num2str(sub),')...']);
    load([folders.timelock,'\\',subID,'_',folders.timelock,'_average.mat'],'averages');
    load([folders.timelock,'\\',subID,'_',folders.timelock,'_diff.mat'],'differences');
    disp('Storing data in struct...');
    for cond = 1:numberOfConditions
        D.avgs{sub,cond} = averages{cond};
    end
    for P = 1:length(pairs)
        D.diffs{sub,P} = differences{P};
    end
end
save([folders.timelock,'\\allData.mat'],'D');
%% Calculate averages
cfg = [];
cfg.baseline = 'yes';
cfg.refchannel = 'M';
% cfg.channel = swedChans;
if strcmp(L1,'fr') 
    grandavgfr.Diff = ft_timelockgrandaverage(cfg, strucFr.Diff{1}, strucFr.Diff{2},...
        strucFr.Diff{4});%dataStruc.Diff{3}, 
    grandavgfr.Vio = ft_timelockgrandaverage(cfg, strucFr.Vio{1}, strucFr.Vio{2},...
        strucFr.Vio{4}); %dataStruc.Vio{3}, 
    grandavgfr.Can = ft_timelockgrandaverage(cfg, strucFr.Can{1}, strucFr.Can{2},...
        strucFr.Can{4}); %dataStruc.Can{3}, 
%     grandavgfr.Diff.cfg = rmfield(grandavgfr.Diff.cfg,'previous');
%     grandavgfr.Vio.cfg = rmfield(grandavgfr.Vio.cfg,'previous');
%     grandavgfr.Can.cfg = rmfield(grandavgfr.Can.cfg,'previous');
    disp('Saving French averages...');
    save('grandavg_fr.mat','grandavgfr');
elseif strcmp(L1,'sw')
    grandavgsw.Diff = ft_timelockgrandaverage(cfg, dataStruc.Diff{1}, dataStruc.Diff{2},...
        dataStruc.Diff{3}, dataStruc.Diff{4},dataStruc.Diff{5}, dataStruc.Diff{6},...
        dataStruc.Diff{7}, dataStruc.Diff{8}, dataStruc.Diff{9}, dataStruc.Diff{10},...
        dataStruc.Diff{11}, dataStruc.Diff{12}, dataStruc.Diff{13}, dataStruc.Diff{14},...
        dataStruc.Diff{15}, dataStruc.Diff{16}, dataStruc.Diff{17}, dataStruc.Diff{18},...
        dataStruc.Diff{19}, dataStruc.Diff{20});%,dataStruc.Diff{21},dataStruc.Diff{22});
    grandavgsw.Vio = ft_timelockgrandaverage(cfg, dataStruc.Vio{1}, dataStruc.Vio{2},...
        dataStruc.Vio{3}, dataStruc.Vio{4},dataStruc.Vio{5}, dataStruc.Vio{6},...
        dataStruc.Vio{7}, dataStruc.Vio{8}, dataStruc.Vio{9}, dataStruc.Vio{10},...
        dataStruc.Vio{11}, dataStruc.Vio{12}, dataStruc.Vio{13}, dataStruc.Vio{14},...
        dataStruc.Vio{15}, dataStruc.Vio{16}, dataStruc.Vio{17}, dataStruc.Vio{18},...
        dataStruc.Vio{19}, dataStruc.Vio{20});%,dataStruc.Vio{21},dataStruc.Vio{22});
    grandavgsw.Can = ft_timelockgrandaverage(cfg, dataStruc.Can{1}, dataStruc.Can{2},...
        dataStruc.Can{3}, dataStruc.Can{4},dataStruc.Can{5}, dataStruc.Can{6},...
        dataStruc.Can{7}, dataStruc.Can{8}, dataStruc.Can{9}, dataStruc.Can{10},...
        dataStruc.Can{11}, dataStruc.Can{12}, dataStruc.Can{13}, dataStruc.Can{14},...
        dataStruc.Can{15}, dataStruc.Can{16}, dataStruc.Can{17}, dataStruc.Can{18},...
        dataStruc.Can{19}, dataStruc.Can{20});%,dataStruc.Can{21},dataStruc.Can{22});
    grandavgsw.Diff.cfg = rmfield(grandavgsw.Diff.cfg,'previous');
    grandavgsw.Vio.cfg = rmfield(grandavgsw.Vio.cfg,'previous');
    grandavgsw.Can.cfg = rmfield(grandavgsw.Can.cfg,'previous');
    disp('Saving Swedish averages...');
    save('grandavg_sw.mat','grandavgsw');
end
%%
means = [];
elecMask = ismember(swedChans,frontal);
for t = 1:length(mint)
    mask = time >= mint(t) & time <= maxt(t);
    means.fr(:,t) = squeeze(mean(grandavgfr.Diff.avg(:,mask),2));
    means.sw(:,t) = squeeze(mean(grandavgsw.Diff.avg(:,mask),2));
end
a = mean(means.sw(elecMask,:))
%% Create matrices for R
% These mean amplitudes were subjected to repeated-measures ANOVA with Word 
% order (V2/V3), Hemisphere (right/ left), Lateral position (lateral/ medial), 
% and Anterior/ Posterior position or Ant/ Post (frontal/ fronto-temporal/ temporal/ central/ parietal/ occipital) 
% as the four within-subjects factors.
% Word order
% Hemisphere
% Lateral position (lateral/medial)
% Anterior/Posterior (Frontal, Fronto-temporal, temporal, central,
% parietal, occipital)
%%
L1 = 'fr';
if strcmp(L1,'fr')
    subs = frSubs;
    D = strucFr;
elseif strcmp(L1,'sw')
    subs = swedSubs;
    load('time.mat','time');
    D = strucSw;
end
means = [];
elecMask = ismember(allElecs.label,swedChans);
nChans = 29;
for sub = 1:length(subs)
    Can = D.Can{sub}.avg;
    Vio = D.Vio{sub}.avg;
    temp = [];
    temp(1:2*nChans,1) = ones(2*nChans,1) * (sub + 100);
    temp(1:nChans,2) = find(elecMask);
    temp(nChans+1:nChans*2,2) = find(elecMask);
    temp(1:nChans,3) = ones(nChans,1);
    temp(nChans+1:nChans*2,3) = ones(nChans,1) * 2;
    for lat = 1:length(lats)
        tmask = time >= lats{lat}(1) & time <= lats{lat}(2);
        temp(1:nChans,lat + 3) = squeeze(mean(Can(elecMask,tmask),2));
        temp(nChans+1:nChans+nChans,lat + 3) = squeeze(mean(Vio(elecMask,tmask),2));
    end
    means(end + 1 : end + size(temp,1),:) = temp;
end
means = array2table(means,'VariableNames',{'subject_id','elec','can_vio','t3to5','t5to7',...
    't7to9','t9to1'});
means.elec = num2str(means.elec);
means.elec = allElecs.label(str2num(means.elec));
C = {'can','vio'};
means.can_vio = num2str(means.can_vio);
means.can_vio = C(str2num(means.can_vio))';
means.right = ismember(means.elec,elecs.right);
means.medial = ismember(means.elec,elecs.medial);
%% T-test
subs = frSubs;
D = strucSw;
means = cell2table(cell(0,10), 'VariableNames',{'subject_id','elec','t3to5can',...
    't5to7can','t7to9can','t9to1can','t3to5vio','t5to7vio','t7to9vio','t9to1vio'});
means.elec = string(means.elec);
nChans = 29;%64;
subs = 1:20;%[1,2,4];
for n = 1:length(subs)
    sub = subs(n);
    elecMask = ismember(D.Can{sub}.label,allElecs.label);
    Can = D.Can{sub}.avg;
    Vio = D.Vio{sub}.avg;
    temp = [];
    for lat = 1:length(lats)
        tmask = time >= lats{lat}(1) & time <= lats{lat}(2);
        temp(:,lat) = squeeze(mean(Can(find(elecMask),tmask),2));
        temp(:,lat + length(lats)) = squeeze(mean(Vio(elecMask,tmask),2));
    end
    E = string(D.Can{sub}.label(elecMask));
%     means.subject_id(64*(sub-1) + 1:64*sub,1) = ones(nChans,1) * (sub + 100);
    means.elec(nChans*(n-1) + 1:nChans*n,1) = E;
    means.t3to5can(nChans*(n-1) + 1:nChans*n,1) = temp(:,1);
    means.t5to7can(nChans*(n-1) + 1:nChans*n,1) = temp(:,2);
    means.t7to9can(nChans*(n-1) + 1:nChans*n,1) = temp(:,3);
    means.t9to1can(nChans*(n-1) + 1:nChans*n,1) = temp(:,4);
    means.t3to5vio(nChans*(n-1) + 1:nChans*n,1) = temp(:,5);
    means.t5to7vio(nChans*(n-1) + 1:nChans*n,1) = temp(:,6);
    means.t7to9vio(nChans*(n-1) + 1:nChans*n,1) = temp(:,7);
    means.t9to1vio(nChans*(n-1) + 1:nChans*n,1) = temp(:,8);    
end
% means.elec = num2str(means.elec);
% means.elec = allElecs.label(str2num(means.elec));
%%
a = ismember(means.elec,means.elec)%elecs.frontal);%[elecs.frontotemporal,elecs.frontal]);
[h,P] = ttest(means.t3to5can(a),means.t3to5vio(a))
[h,P] = ttest(means.t5to7can(a),means.t5to7vio(a))
[h,P] = ttest(means.t7to9can(a),means.t7to9vio(a))
[h,P] = ttest(means.t9to1can(a),means.t9to1vio(a))
%% Correlations to run
corrLats = {[0 .2],[.2 .4],[.5 .7],[.7 .9]};
% Clusters of interest: left anterior (vs right anterior), left hemisphere
% (vs right hemisphere), anterior vs posterior

% Linguistic effects: ELAN, anterior P3 & P6, posterior P6
% Attention effects: P3, anterior P6

% EEG: need mean value per latency for all electrodes by participant
% D(electrodes,participant,latency,condition)
%% Meaned amplitude data in windows
cfg = [];
cfg.channel = swedChans;
% cfg.channel = allElecs.label;
cfg.avgovertime = 'yes';
D = [];
data = [];
subs = [1,2,4];
for lat = 1:length(corrLats)
    cfg.latency = corrLats{lat};
    for sub = subs
        D{sub,lat,1} = ft_selectdata(cfg,strucFr.Can{sub});
        D{sub,lat,2} = ft_selectdata(cfg,strucFr.Vio{sub});
        D{sub,lat,3} = ft_selectdata(cfg,strucFr.Diff{sub});
        [labels,S] = sort(D{sub,lat,1}.label);
        data(sub,S,lat,1) = D{sub,lat,1}.avg;
        data(sub,S,lat,2) = D{sub,lat,2}.avg;
        data(sub,S,lat,3) = D{sub,lat,3}.avg;
    end
end
% data(:,3,:,:) = data(:,4,:,:)
sc = sort(swedChans);
fc = sort(allElecs.label);
save('ft_results\\meanAmplitude.mat','D','data','cfg')
%%
alpha = 0.01;
% elc = elecs.central;
clear r p c
for lat = 1:length(corrLats)
    for cond = 1:3
    [r(:,lat,cond),p(:,lat,cond)] = corr(offline.rtCostIncong(subs), data(subs,:,lat,cond));
%     r(p<alpha)
%     sc(p<alpha)
    end
end
a = p < alpha;
b = p.* a;
[c(:,1),c(:,2)] = find(a);
d = r(a);

%%
[qr,qp] = corr(offline.swedex(subs),offline.ajt_dprime(subs))
%% Query
q = {'Cz','Pz','CP3'};
p(ismember(sc,q))
%%
cfg = [];
cfg.channel = frontal;
cfg.avgovertime = 'yes';
cfg.latency = [.9 1];
can = [];
for i = [1,2,4]
    can{i} = ft_selectdata(cfg,strucFr.Can{i});
    vio{i} = ft_selectdata(cfg,strucFr.Vio{i});
end
ttest([can{1}.avg,can{2}.avg,can{4}.avg],[vio{1}.avg,vio{2}.avg,vio{4}.avg])
%%
cfg = [];
can = [];
vio = [];
cfg.channel = swedChans;
cfg.avgovertime = 'yes';
for i = 1:4
    cfg.latency = lats{i};
    can = ft_selectdata(cfg,grandavgfr.Can);
    vio = ft_selectdata(cfg,grandavgfr.Vio);
    [y,p] = ttest(can.avg,vio.avg,'dim',1,'alpha',.005)
end
% y = ttest(grandavgsw.Can.avg,grandavgsw.Vio.avg,'dim',1,'alpha',.001)
%%
plot(grandavgsw.Can.time,y,'.')

%%
C = {'can','vio'};
means.can_vio = num2str(means.can_vio);
means.can_vio = C(str2num(means.can_vio))';
means.right = ismember(means.elec,elecs.right);
means.medial = ismember(means.elec,elecs.medial);

%%
%% Steps for dipfit
cfg = [];
cfg.method = 'singlesphere';
cfg.layout = elecLayout;
elec = ft_read_sens(elecLayout);
cfg.elec = elec;
headmodel = ft_prepare_headmodel(cfg,grandavgsw.Vio)
%%
cfg = [];
cfg.latency = [.2,.4];
source = ft_dipolefitting(cfg,grandavgsw.Vio);