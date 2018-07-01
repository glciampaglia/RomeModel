function varargout = test_classification(kRange,alpha,n)
% CLASSIFICATION test
% 
% NOTE Always call this script from the trunk/ directory, not from the parent
% directory trunk/test
%
% In this script we plot how the delay caused by the parameters \eps affects 
% the dynamics of G^\alpha. The idea is to plot the dynamics of G^\alpha(t)
% when G_0 = g(0)=g0 and g(t) = g1 t>0. And see how fast the value of G(t)
% converges to g1. 

global param;
global myCA;
muG = zeros(n,length(kRange)-1);
sdG = zeros(n,length(kRange)-1);
muF = zeros(n,length(kRange)-1);
sdF = zeros(n,length(kRange)-1);

for k = 1:length(kRange),
    Setup;
    param.scripts.classification.eps = kRange(k);
    for t = 1:n,
        [F G] = classification(data(myCA));
        muG(t,k) = mean(G(:,alpha));
        sdG(t,k) = std(G(:,alpha));
        muF(t,k) = mean(F(:,alpha));
        sdF(t,k) = std(F(:,alpha));
    end
end

varargout = {muG sdG muF sdF};