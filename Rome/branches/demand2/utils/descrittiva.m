function varargout = descrittiva(path,varargin)
%
% Questa funzione ritorna i valori della media e della deviazione standard
% della distribuzione dei valori medi delle variabili urbanistiche sul
% campione costituito da tutte le simulazioni memorizzate nella cartella
% 'path'.  È possibile selezionare sono un sottoinsieme delle variabili
% fornendo un vettore di indici di colonna.

if nargin > 1,
	idx = varargin{1};
else
	idx = 1:23;
end

cd(path);
matFiles = dir('*.mat');
fnames = {matFiles.name};
data = [];
for fn = fnames,
	load(fn{:});
	data = cat(3,data,store.data(:,:,end));
end

aggData = squeeze(mean(data,1))';
stdData = squeeze(std(data,1))';
variability = abs(aggData) ./ stdData;
% minData = squeeze(min(data))';
% maxData = squeeze(max(data))';
varargout = { aggData(:,idx), stdData(:,idx), variability(:,idx) };
% cd C:\D'ocuments and Settings\Administrator\My Documents\Matlab files\modell'o

% for i = 1:length(idx),
% 	subplot(5,2,i);
% 	errorbar(aggData(:,idx(i)),stdData(:,idx(i)));
% 	title(variabili(idx(i)));
% 	axis xy;
% end


