function plot_classification_test(muM,sdM,epsValues,n,lett)
% plots the result of test_classification. Use it do_test_classification

maxMu=max(max(muM));
for f = 1:length(epsValues),
    subplot(3,4,f);
    h=errorbar(muM(:,f),sdM(:,f)/2);
    xlabel('time (1 day)');
    ylabel(sprintf('Urban force of\nattraction %s\n(adimensional)',lett));
    l=legend(h,sprintf('e = %1.1g',epsValues(f)));
    set(l,'Location','SouthEast');
    axis([0,n,-1,maxMu+1]);
end