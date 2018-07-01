function Storage
% Salvataggio dei dati di una simulazione
%
% Questa funzione salva i risultati di una simulazione in un M-file,
% salvando tutto quello che si trova nel workspace globale.

% global myCA
global param
% global DEBUG
global simulation
global store

myparam = param.scripts.Storage;

store.nAgents = zeros(param.nRules,1);
for iRule = 1:param.nRules,
	store.nAgents(iRule) = param.rulesparam(iRule).passive + ...
		sum(param.rulesparam(iRule).active);
end
for fName = param.saveTheseParams,
	store.(fName{:}) = param.(fName{:});
end
store.tStart = datenum('01-Jan-1991');

if ~isempty(myparam.dir),
    save(sprintf('%s/run_%s-%d',myparam.dir,datestr(now,'yyyymmdd'),simulation.simCount),...
	'store');
else
    save(sprintf('run_%s-%d',datestr(now,'yyyymmdd'),simulation.simCount),...
	'store');
end