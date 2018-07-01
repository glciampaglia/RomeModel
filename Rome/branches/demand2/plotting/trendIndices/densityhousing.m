% PARAMETERS
path = '../../../data/1y-10';
savepath = '../../../figs/paper';
nruns = 91:100;

stores = load_data(path);
ABN_t = mean_dynamics(stores,nruns,var2ind('ABN'));
ABC_t = mean_dynamics(stores,nruns,var2ind('ABC'));
HS_t = ABC_t + ABN_t;
tEnd = size(HS_t,1);
HSInit_c = transpose(HS_t(1,:));
HSEnd_c = transpose(HS_t(end,:));

% PLOTS
scatter_indices(density(stores,nruns),HSInit_c,'Residential density',...
    'Houses Stock');
saveas(gcf,sprintf('%s/scatter.dRES.HS.fig',savepath),'fig');
print('-depsc',sprintf('%s/scatter.dRES.HS.eps',savepath));

scatter_indices(density(stores,nruns,'RES',tEnd),HSEnd_c - HSInit_c,...
    'Residential density','\Delta Houses Stock');
saveas(gcf,sprintf('%s/scatter.dRES.diffHS.fig',savepath),'fig');
print('-depsc',sprintf('%s/scatter.dRES.diffHS.eps',savepath));

scatter_indices(density(stores,nruns,'SLO'),HSInit_c,'Local services density',...
    'Houses Stock');
saveas(gcf,sprintf('%s/scatter.dSLO.HS.fig',savepath),'fig');
print('-depsc',sprintf('%s/scatter.dSLO.HS.eps',savepath));

scatter_indices(density(stores,nruns,'SLO',tEnd),HSEnd_c - HSInit_c,...
    'Local services density','\Delta Houses Stock');
saveas(gcf,sprintf('%s/scatter.dSLO.diffHS.fig',savepath),'fig');
print('-depsc',sprintf('%s/scatter.dSLO.diffHS.eps',savepath));

scatter_indices(density(stores,nruns,'VUO'),HSInit_c,'Undeveloped density',...
    'Houses Stock');
saveas(gcf,sprintf('%s/scatter.dVUO.HS.fig',savepath),'fig');
print('-depsc',sprintf('%s/scatter.dVUO.HS.eps',savepath));

scatter_indices(density(stores,nruns,'VUO',tEnd),HSEnd_c - HSInit_c,...
    'Undeveloped density','\Delta Houses Stock');
saveas(gcf,sprintf('%s/scatter.dVUO.diffHS.fig',savepath),'fig');
print('-depsc',sprintf('%s/scatter.dVUO.diffHS.eps',savepath));

scatter_indices(density(stores,nruns,'VER'),HSInit_c,'Green density',...
    'Houses Stock');
saveas(gcf,sprintf('%s/scatter.dVER.HS.fig',savepath),'fig');
print('-depsc',sprintf('%s/scatter.dVER.HS.eps',savepath));

scatter_indices(density(stores,nruns,'VER',tEnd),HSEnd_c - HSInit_c,...
    'Green density','\Delta Houses Stock');
saveas(gcf,sprintf('%s/scatter.dVER.diffHS.fig',savepath),'fig');
print('-depsc',sprintf('%s/scatter.dVER.diffHS.eps',savepath));

close all;