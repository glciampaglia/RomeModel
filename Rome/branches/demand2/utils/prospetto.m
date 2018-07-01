function prospetto(count)
% mi faccio un prospetto di ciascuna simulazione
%
% count va da 1 a 12

matFiles = dir('*.mat');
fnameArray = {};
maxCount = 12;
flag = true;
j = 0;
while flag,
	pattern = sprintf('.*-%d[.]mat',(j*maxCount)+count);
	haveFound = false;
	for i = 1:length(matFiles),
		matfile = matFiles(i);
		s = regexp(matfile.name,pattern);
		if s == 1,
			fnameArray = [fnameArray,{matfile.name}];
			haveFound = true;
		end
	end
	flag = haveFound;
	j = j + 1;
end

if isempty(fnameArray),
	fprintf('No file with code %d found!\n',count);
	return
end

for fname = fnameArray,
	figure;
	load(fname{:});
	subplot(3,2,1);
	plot(squeeze(sum(store.data(:,1,:),1)));								%POP
	title('Popolazione del sistema');										% nota forse è meglio la somma
	xlabel(sprintf('tempo \\DeltaT = %d gg',...
	store.tDelta*store.nOfClassSteps));
	ylabel('POP');
	
	subplot(3,2,2);
	plot(squeeze(sum(store.data(:,2,:),1)));								%ABC
	title('Abitazioni occupate del sistema');								% nota forse è meglio la somma
	xlabel(sprintf('tempo \\DeltaT = %d gg',...
	store.tDelta*store.nOfClassSteps));
	ylabel('ABC');
	
	subplot(3,2,3);
	plot(squeeze(sum(store.data(:,3,:),1)));								%ABN
	title('Abitazioni non occupate del sistema');							% nota forse è meglio la somma
	xlabel(sprintf('tempo \\DeltaT = %d gg',...
	store.tDelta*store.nOfClassSteps));
	ylabel('ABN');
	
	subplot(3,2,4);
	plot(squeeze(sum(sum(store.data(:,2:3,:),2),1)))						%ABN + ABC
	title('Abitazioni del sistema');										% nota forse è meglio la somma
	xlabel(sprintf('tempo \\DeltaT = %d gg',...
	store.tDelta*store.nOfClassSteps));
	ylabel('ABN + ABC');
	
	
	subplot(3,2,5);
	plot(squeeze(sum(store.data(:,9,:),1)));								%RES
	title('Superficie residenziale del sistema');						% nota forse è meglio la somma
	xlabel(sprintf('tempo \\DeltaT = %d gg',...
	store.tDelta*store.nOfClassSteps));
	ylabel('RES');
	
	subplot(3,2,6);
	plot(squeeze(sum(store.data(:,12,:),1)));								%SLO
	title('Superficie per servizi di lvl locale del sistema');		% nota forse è meglio la somma
	xlabel(sprintf('tempo \\DeltaT = %d gg',...
	store.tDelta*store.nOfClassSteps));
	ylabel('SLO');	
end
