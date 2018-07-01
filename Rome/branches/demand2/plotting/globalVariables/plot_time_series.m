path = '../../../data/1y-10';
savepath = '../../../figs/paper';

what = {'RES','ABC+ABN','POP','SLO','VUO','PAG'};
for i = what,
    plot_variable(path,i{:},'sum','plot');
    saveas(sprintf('%s/dynamics.%s.fig',savepath,what),'fig');
    print('-depsc',sprintf('%s/dynamics.%s.eps',savepath,what));
end

close all