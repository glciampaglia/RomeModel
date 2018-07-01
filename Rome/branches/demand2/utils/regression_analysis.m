function varargout = regression_analysis(path,nRuns,select,varname,varargin)
% REGRESSION_ANALYSIS(PATH,NRUNS,SELECT,VARNAME)
% REGRESSION_ANALYSIS(PATH,NRUNS,SELECT,VARNAME,GUESSES)
%
% Executes regression analysis on the SELECT-th batch of simulations, where
% each batch is made up of NRUNS simulations, whose data are stored in
% MAT-files residing under PATH. The analysis is carried with respect to
% VARNAME, expressed using its identification code.
%
% If a vector of guessed parameter is provided as GUESSES, then the
% function is non interactive
%
% See also, LOAD_DATA, MEAN_DYNAMICS, NLINFIT

stores = load_data(path);
nSims = length(stores);
nBatches = floor(nSims / nRuns);
if select == nBatches,
    runsIdx = ((select-1)*nRuns)+1:nSims;
else
    runsIdx = ((select-1)*nRuns)+1:select*nRuns;
end
Y = mean(mean_dynamics(stores,runsIdx,var2ind(varname)),2);
X = [1:length(Y)]';
if nargin > 4,
    inp = varargin{1};
else
    plot(Y);
    fighan = gcf();
    fprintf(1,'Use the plot to guess the parameters for regression analysis\n');
    inp = deal(input('Please insert the guessed parameters [saturation slope intercept]:'));
    close(fighan);
end
fprintf(1,'You specified [saturation=%.5g slope=%.5g intercept=%.5g]\n',...
    inp(1),inp(2),inp(3));
beta = inp(1:3)';
fun = @(b,x) b(1)./(1+exp(-b(2)*(x-b(3))));
[betahat, residuals, J] = nlinfit(X,Y,fun,beta);
betaci = nlparci(betahat,residuals,J);
analysis.model = fun;
analysis.betahat = betahat;
analysis.confidence = diff(betaci,1,2);
betaperc = round((analysis.confidence ./ abs(analysis.betahat))*100);
fprintf('Regression results\n');
for i = 1:3,
    fprintf(1,'Estimated Beta(%d) = %05.2g\t(%1.5g%% error at 95%% probability)\n',i,...
        betahat(i),betaperc(i));
end
varargout = {analysis};