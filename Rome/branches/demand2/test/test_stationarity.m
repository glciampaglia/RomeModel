function test_stationarity(path,varargin)
% TEST_STATIONARITY(PATH) disegna, per ciascuno store-file presente in
% path, il grafico a barre d'errore del valor medio della forza di
% attrazione locale dei sette processi di trasformazione.
%
% TEST_STATIONARITY(PATH,'gAttr') fa lo stesso ma per la forza di
% attrazione regionale.
%
% Questi grafici sono utili per testare che la dinamica della
% configurazione del sistema sia stazionaria

if nargin > 1,
    fieldname = varargin{1};
else
    fieldname = 'lAttr';
end
stores = load_data(path);
nSets = length(stores);
nRules = 7;
plotRows = 4;
plotCols = 2;
if nSets > 0,
    nSteps = size(stores(1).(fieldname),3);
    meanG = zeros(nSteps,nRules,nSets);
    stdG = zeros(nSteps,nRules,nSets);
    for i=1:nSets,
        meanG(:,:,i) = squeeze(mean(stores(i).(fieldname)))';
        stdG(:,:,i) = squeeze(std(stores(i).(fieldname)))';
        figure;
        for k =1:nRules,
            subplot(plotRows,plotCols,k);
            errorbar(1:nSteps,meanG(:,k,i),stdG(:,k,i)./2,'LineStyle','none','Marker','.');
        end
    end
end