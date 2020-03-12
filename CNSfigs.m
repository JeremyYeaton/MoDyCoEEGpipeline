% Make sure you're in the right folder

load('results\grandAvg.mat')
load('..\MoDyCoEEGpipeline\64chanlocs.mat')
%% Figure 1 - ERP traces
cfg = [];
cfg.linewidth = 1;
cfg.ylim = [-7 7];

elecName = 'Cz'
yLims = [-4 6];

figure;
pop = 2; % BILINGUAL
% Plot spo BI
subplot(2,2,1)
cond = 12;
data = grandAvg{cond,pop};
elec = ismember(data.label,elecName);
time = data.time*1000;
plot(time, data.avg(elec,:),'LineWidth',2)
hold on
% Plot sPo BI
cond = 10;
data = grandAvg{cond,pop};
elec = ismember(data.label,elecName);
time = data.time*1000;
plot(time, data.avg(elec,:),'LineStyle','-.','LineWidth',2)
plot([min(time) max(time)],[0 0],'k')
plot([0 0],yLims,'k')
set(gca,'Ydir','reverse')
ylim(yLims)
xlim([min(time) max(time)])
legend({'spo','sPo'})
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([elecName ' Bilingual']) 

% Plot spo BI
subplot(2,2,3)
cond = 12;
data = grandAvg{cond,pop};
elec = ismember(data.label,elecName);
time = data.time*1000;
plot(time, data.avg(elec,:),'LineWidth',2)
hold on
% Plot spO BI
cond = 11;
data = grandAvg{cond,pop};
time = data.time*1000;
plot(time, data.avg(elec,:),'g','LineStyle','--','LineWidth',2)
plot([min(time) max(time)],[0 0],'k')
plot([0 0],yLims,'k')
set(gca,'Ydir','reverse')
ylim(yLims)
xlim([min(time) max(time)])
legend({'spo','spO'})
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([elecName ' Bilingual'])


pop = 1; % FRENCH
% Plot spo FR
subplot(2,2,2)
cond = 12;
data = grandAvg{cond,pop};
elec = ismember(data.label,elecName);
time = data.time*1000;
plot(time, data.avg(elec,:),'LineWidth',2)
hold on
% Plot sPo FR
cond = 10;
data = grandAvg{cond,pop};
elec = ismember(data.label,elecName);
time = data.time*1000;
plot(time, data.avg(elec,:),'LineStyle','-.','LineWidth',2)
plot([min(time) max(time)],[0 0],'k')
plot([0 0],yLims,'k')
set(gca,'Ydir','reverse')
ylim(yLims)
xlim([min(time) max(time)])
legend({'spo','sPo'})
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([elecName ' French'])

% Plot spo FR
subplot(2,2,4)
cond = 12;
data = grandAvg{cond,pop};
elec = ismember(data.label,elecName);
time = data.time*1000;
plot(time, data.avg(elec,:),'LineWidth',2)
hold on
% Plot spO FR
cond = 11;
data = grandAvg{cond,pop};
elec = find(ismember(data.label,elecName));
time = data.time*1000;
plot(time, data.avg(elec,:),'g','LineStyle','--','LineWidth',2)
plot([min(time) max(time)],[0 0],'k')
plot([0 0],yLims,'k')
set(gca,'Ydir','reverse')
ylim(yLims)
xlim([min(time) max(time)])
legend({'spo','spO'})
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([elecName ' French'])

%% Figure 2 - Topographies
tLims = [.3 .5];
cLims = [-3 3];

figure;
pop = 2; % BILINGUAL
cond = 12; % spo
spo = grandAvg{cond,pop};
% Topo BI sPo-spo
subplot(2,2,1)
cond = 10;
data = grandAvg{cond,pop};
tMask = data.time >= tLims(1) & data.time <= tLims(2);
toplot = mean(data.avg(1:64,tMask)-spo.avg(1:64,tMask),2);
topoplot(toplot,chanlocs);
title('Bilingual sPo - spo')
caxis(cLims);
h = colorbar;
set(get(h,'title'),'string','\muV');

% Topo BI spO-spo
subplot(2,2,3)
cond = 11;
data = grandAvg{cond,pop};
tMask = data.time >= tLims(1) & data.time <= tLims(2);
toplot = mean(data.avg(1:64,tMask)-spo.avg(1:64,tMask),2);
topoplot(toplot,chanlocs);
title('Bilingual spO - spo')
caxis(cLims);
h = colorbar;
set(get(h,'title'),'string','\muV');


pop = 1; % FRENCH
cond = 12; % spo
spo = grandAvg{cond,pop};

% Topo FR sPo-spo
subplot(2,2,2)
cond = 10;
data = grandAvg{cond,pop};
tMask = data.time >= tLims(1) & data.time <= tLims(2);
toplot = mean(data.avg(1:64,tMask)-spo.avg(1:64,tMask),2);
topoplot(toplot,chanlocs);
title('French sPo - spo')
caxis(cLims);
h = colorbar;
set(get(h,'title'),'string','\muV');

% Topo FR spO-spo
subplot(2,2,4)
cond = 11;
data = grandAvg{cond,pop};
tMask = data.time >= tLims(1) & data.time <= tLims(2);
toplot = mean(data.avg(1:64,tMask)-spo.avg(1:64,tMask),2);
topoplot(toplot,chanlocs);
title('French spO - spo')
caxis(cLims);
h = colorbar;
set(get(h,'title'),'string','\muV');
