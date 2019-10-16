% Plot averaged EEG data
% (c) Jeremy D. Yeaton
% Created April 2019

%% Load settings and relevant files
swopSettingsAnalysis
load('ft_results\struc_fr.mat','strucFr')
load('ft_results\struc_sw.mat','strucSw')
load('grandavg_sw.mat','grandavgsw');
load('grandavg_fr.mat','grandavgfr');
load('time.mat','time');
D = [];
D.sw = strucSw;
D.fr = strucFr;
%% Plot individuals
L1 = 'fr'
frontal = {'F4','F3','F7','F8'};
figure;
cfg = [];
% cfg.preproc.refchannel = 'M';
% cfg.preproc.reref = 'yes';
% cfg.refchannel = 'M';
% cfg.reref = 'yes';
if strcmp(L1,'fr')
    subs = [1,2,4];
    nrow = 2;
    ncol = 2;
    data = D.fr;
elseif strcmp(L1,'sw')
    subs = 1:length(swedSubs);
    nrow = 4;
    ncol = 5;
    data = D.sw;
end
for sub = 1:length(subs)
    subplot(nrow,ncol,sub)
    sub = subs(sub);
    cfg.channel = frontal;
    ft_singleplotER(cfg,data.Can{sub},data.Vio{sub},data.Diff{sub})
end
%% Topos SW vs FR by time
figure;
titles = {'300 - 500 ms','500 - 700 ms','700 - 900 ms','900 - 1000 ms'};
cfg = [];
nrow = 1;
ncol = 4;
cfg.channel = swedChans;
cfg.layout = elecLayout;
for lat = 1:length(lats)
    tmask = time >= lats{lat}(1) & time <= lats{lat}(2);
    cfg.xlim = lats{lat};
    cfg.zlim = [-1 2];
    cfg.comment = 'no';
    subplot(nrow,ncol,lat)
    title(titles{lat})
    ft_topoplotER(cfg,grandavgsw.Diff)
%     subplot(nrow,ncol,lat+ncol)
%     ft_topoplotER(cfg,grandavgfr.Diff)
end
%% Topos fr participants x time
figure('Renderer', 'painters', 'Position', [10 10 900 300]);
cfg = [];
nrow = 1;
ncol = 4;
cfg.channel = swedChans;
cfg.layout = elecLayout;
cfg.comment = 'no';
titles = {'300 - 500 ms','500 - 700 ms','700 - 900 ms','900 - 1000 ms'};

plotsize = [0.1300 0.3361 0.5422 0.7484];
for lat = 1:length(lats)
    cfg.xlim = lats{lat};
%     subplot(nrow,ncol,lat)
% %     cfg.zlim = [-5.5 5.5];
%     cfg.zlim = [0 5.5];
%     title(titles{lat})
%     h = ft_topoplotER(cfg,grandavgfr.Can);
%     if lat == 4
%         colorbar
%     end
%     get(gca,'Position')
%     set(gca,'Position',[plotsize(lat) 0.1100  0.1566 0.8150])
%     subplot(nrow,ncol,lat+ncol)
    subplot(nrow,ncol,lat)
%     cfg.zlim = [-3 3];
    cfg.zlim = [0 3];
    title(titles{lat})
    ft_topoplotER(cfg,grandavgsw.Can)   
    get(gca,'Position')
    if lat == 4
        colorbar
    end
    set(gca,'Position',[plotsize(lat) 0.1100  0.1566 0.8150])
end
colormap jet
%% Side by side multiplot
figure;
cfg = [];
cfg.interactive = 'no';
cfg.linestyle = {'-','--'};
cfg.layout = elecLayout;
cfg.showoutline = 'yes';
cfg.channel = swedChans;
cfg.showcomment = 'no';
subplot(1,2,1)
title('French')
ft_multiplotER(cfg,grandavgfr.Can,grandavgfr.Vio)
subplot(1,2,2)
title('Swedish')
ft_multiplotER(cfg,grandavgsw.Can,grandavgsw.Vio)
%% By electrode -- andersson et al figures can vs vio
% FR and SW for
nrow = 2;
ncol = 4;
fig2 = {'F7','F3','F4','F8'...
'FT7','FC3','FC4','FT8'};

fig3 = {'TP7','CP3','CP4','TP8',...
    'P7','P3','P4','P8'};
figure('Renderer', 'painters', 'Position', [10 10 900 600]);
cfg = [];
interactive = 'no';
cfg.linestyle = {'-','--','-'};
cfg.graphcolor = 'brk';
cfg.layout = elecLayout;
cfg.showoutline = 'yes';
for i = 1:length(fig3)
    subplot(nrow,ncol,i);
    cfg.channel = fig3{i};
    cfg.ylim = [-12 12];
    ft_singleplotER(cfg,grandavgfr.Can,grandavgfr.Vio);
    line([-.1 1],[0 0],'Color','k','LineWidth',.5)
    line([0 0],cfg.ylim,'Color','k','LineWidth',.5)
end
% legend('V2','V3')
figure('Renderer', 'painters', 'Position', [10 10 900 600])
for i = 1:length(fig3)
    cfg.channel = fig3{i};
    subplot(nrow,ncol,i);
    cfg.ylim = [-5 5];
    ft_singleplotER(cfg,grandavgsw.Can,grandavgsw.Vio);
    line([-.1 1],[0 0],'Color','k','LineWidth',.5)
    line([0 0],cfg.ylim,'Color','k','LineWidth',.5)
end
% Invert axis
% set(gca,'Ydir','reverse')
%% Difference by electrode
nrow = 2;
ncol = 4;
fig2 = {'F7','F3','F4','F8'...
'FT7','FC3','FC4','FT8'};

fig3 = {'TP7','CP3','CP4','TP8',...
    'P7','P3','P4','P8'};
figure('Renderer', 'painters', 'Position', [10 10 900 600]);
cfg = [];
interactive = 'no';
cfg.linestyle = {'-','--','-'};
cfg.graphcolor = 'k';
cfg.layout = elecLayout;
cfg.showoutline = 'yes';
for i = 1:length(fig3)
    subplot(nrow,ncol,i);
    cfg.channel = fig3{i};
    cfg.ylim = [-6 6];
    ft_singleplotER(cfg,grandavgfr.Diff);
    line([-.1 1],[0 0],'Color','k','LineWidth',.5)
    line([0 0],cfg.ylim,'Color','k','LineWidth',.5)
end
figure('Renderer', 'painters', 'Position', [10 10 900 600])
for i = 1:length(fig3)
    cfg.channel = fig3{i};
    subplot(nrow,ncol,i);
    cfg.ylim = [-2 2];
    ft_singleplotER(cfg,grandavgsw.Diff);
    line([-.1 1],[0 0],'Color','k','LineWidth',.5)
    line([0 0],cfg.ylim,'Color','k','LineWidth',.5)
end
%% ERP traces at frontal sites
cfg = [];
cfg.channel = elecs.frontal;
cfg.linestyle = {'-','--','-.'};
cfg.graphcolor = 'brk';
figure('Renderer', 'painters', 'Position', [10 10 900 600]);
cfg.ylim = [-12 12];
ft_singleplotER(cfg,grandavgfr.Can,grandavgfr.Vio,grandavgfr.Diff);
line([-.1 1],[0 0],'Color','k','LineWidth',.5)
line([0 0],cfg.ylim,'Color','k','LineWidth',.5)
% legend('V2','V3','Difference')
figure('Renderer', 'painters', 'Position', [10 10 900 600]);
cfg.ylim = [-5 5];
ft_singleplotER(cfg,grandavgsw.Can,grandavgsw.Vio,grandavgsw.Diff);
line([-.1 1],[0 0],'Color','k','LineWidth',.5)
line([0 0],cfg.ylim,'Color','k','LineWidth',.5)
%% Plot amplitude at times against proficiency
figure('Renderer', 'painters', 'Position', [100 100 900 300]);
% amplitude at each time point, each subplot is time, xaxis proficiency,
% yaxis amplitude of difference
load('ft_results\\meanAmplitude.mat','D','data','cfg')
for cond = 1:3
    for lat = 1:4
        subplot(3,4,(cond - 1)*ncol + lat)
        plot(offline.ajt_dprime(subs),mean(data(subs,:,lat,cond),2),'.')
    end
end
        
        
    



%%
% Proficiency should correlate with posterior P6 (P and PO), cogntition should
% correlate with frontal components (F and FT)

%% Topoplots of correlation?
%% Swedish and French multiplot
cfg = [];
cfg.layout = elecLayout;
cfg.channels = swedChans;
cfg.showoutline = 'yes';
cfg.graphcolor = 'rb';
cfg.linestyle = {'--','-'};
cfg.showcomment = 'no';
figure('Renderer', 'painters', 'Position', [10 10 900 600]);
ft_multiplotER(cfg,grandavgfr.Diff,grandavgsw.Diff)
legend('French','Swedish')
%%
cfg = [];
% cfg.layout = elecLayout;
cfg.elec = elec;
cfg.channels = swedChans;
ft_layoutplot(cfg,grandavgsw.Diff)

%% All electrodes
figure;
cfg = [];
for i = 3:length(swedChans)
subplot(5,6,i-2);
cfg.channel = swedChans(i);
ft_singleplotER(cfg,grandavg_diff_sw,grandavg_can_sw,grandavg_vio_sw);
end

figure;
cfg = [];
for i = 3:length(swedChans)
subplot(5,6,i-2);
cfg.channel = swedChans(i);
ft_singleplotER(cfg,grandavg_diff_fr,grandavg_can_fr,grandavg_vio_fr);
end

%%
cfg = [];
cfg.interactive = 'no';
cfg.showoutline = 'yes';
cfg.layout = elecLayout;
% cfg.channel = swedChans;
cfg.baselinetype = 'zscore';
nrow = 2;
ncol = 2;
figure;
% % subplot(nrow,ncol,1)
% % ft_multiplotER(cfg, grandavgsw.Diff)
% % subplot(nrow,ncol,2)
% % ft_multiplotER(cfg, grandavgfr.Diff)
% % subplot(nrow,ncol,3)
ft_multiplotER(cfg, grandavgfr.Diff,grandavgsw.Diff)
% ft_multiplotER(cfg, grandavgfr.Can,grandavgfr.Vio)
% ft_multiplotER(cfg, grandavgfr.Can,grandavgsw.Can)
% % ft_multiplotER(cfg, grandavg_diff_fr,grandavg_can_fr,grandavg_vio_fr)
% % ft_multiplotER(cfg, grandavg_diff_sw,grandavg_can_sw,grandavg_vio_sw)
%%
figure;
cfg.xlim = [.5 .7];
cfg.zlim = [-1.7 1.7]
subplot(1,2,1)
ft_topoplotER(cfg,grandavgfr.Diff)
subplot(1,2,2)
ft_topoplotER(cfg,grandavgsw.Diff)
%%
cfg = data.cfg;
cfg.operation = 'subtract';
cfg.parameter = 'avg';
difference = ft_math(cfg, dataVio, dataCan);
cfg.interactive = 'yes';
cfg.showoutline = 'yes';
ft_multiplotER(cfg, difference,dataCan, dataVio);
%%
figure;
cfg = [];
cfg.layout = elecLayout;
cfg.xlim = [-.1 .3];
ft_topoplotER(cfg,grandavgfr.Diff)
%% 
tag = 'Diff';
set(0,'DefaultFigureVisible','off')
gifname = ['topo_',tag,'.gif'];
frameTime = .2;
topoAxis = [-1.5,2.5];
gap = 20;
nrow = 2;
ncol = 2;
elecMask = ismember(grandavgfr.Diff.label,swedChans);

for n = 1:gap:length(time)
    cfg = [];
    disp(num2str(n))
    h = figure;
    cfg.zlim = topoAxis;
    cfg.layout = elecLayout;
    cfg.comment = 'no';
%     ft_singleplotER(cfg,grandavgfr.Can);
    cfg.xlim = [time(n),time(n+gap)];
    subplot(nrow,ncol,1);
    ft_topoplotER(cfg,grandavgfr.Diff);
    title(round(time(n)*1000)) % Topo title is time in ms
    subplot(nrow,ncol,2);
    plot(time,mean(grandavgfr.Diff.avg(elecMask,:)))
    title(['Mean French ERP - ',tag])
    line([time(n) time(n)],[-5 5],'Color','r','LineStyle',':')
    axis([-.1 1 topoAxis(1) topoAxis(2)])
    subplot(nrow,ncol,3);
    ft_topoplotER(cfg,grandavgsw.Diff);
    subplot(nrow,ncol,4);
    plot(time,mean(grandavgsw.Diff.avg))
    title(['Mean Swedish ERP - ',tag])
    line([time(n) time(n)],[-5 5],'Color','r','LineStyle',':')
    axis([-.1 1 topoAxis(1) topoAxis(2)])
    drawnow 
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if n == 1 
          imwrite(imind,cm,gifname,'gif', 'Loopcount',inf,'DelayTime',frameTime);
      else 
          imwrite(imind,cm,gifname,'gif','WriteMode','append','DelayTime',frameTime);
      end 
      hold off
end

%% GIF
gifname = ['EEG/figures/' subj '_topoplot_grid.gif']
trfAxis = [-100,400,-200,150];
topoAxis = [-100,100];
frameTime = .15; % How long the gif remains on each frame

titles = {'TRF L1','TRF L2',}

for n = 1:length(t)
    disp(num2str(n))
    h = figure;
    % Top Left
    subplot(2,2,1)
    topoplot(eegModEn(:,n),chanlocs); % Topographic data here
    caxis(topoAxis)
    title(round(t(n))) % Topo title is time in ms
    % Top Right
    subplot(2,2,2)
    hold on
    plot(t,trfEn);
    scatter(t(n),trfEn(n))
    axis(trfAxis)
    title(titles{1})
    hold off
    % Bottom Left
    subplot(2,2,3)
    topoplot(eegModFr(:,n),chanlocs); 
    caxis(topoAxis)
    % Bottom Right
    subplot(2,2,4)
    hold on
    plot(t,trfFr) 
    scatter(t(n),trfFr(n)) 
    axis(trfAxis)
    title(titles{2})
    drawnow 
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if n == 1 
          imwrite(imind,cm,gifname,'gif', 'Loopcount',inf,'DelayTime',frameTime);
      else 
          imwrite(imind,cm,gifname,'gif','WriteMode','append','DelayTime',frameTime);
      end 
      hold off
end
%%
cfg = [];
cfg.elec = ft_read_sens('dataWchans.set','fileformat','eeglab_set');
% cfg.elec = elec
% cfg.mask = 'headshape';
% cfg.outline = 'headshape';
% cfg.viewpoint = 'superior';
lay = ft_prepare_layout(cfg);
cfg.layout = lay;
ft_layoutplot(cfg)

%%
figure;ft_plot_topo3d(elec.chanpos,grandavgfr.Diff.avg(1:64,200))
