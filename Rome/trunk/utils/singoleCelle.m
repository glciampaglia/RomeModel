clear all
close all
workPath = pwd;
setupPath = ['C:\Documents and Settings\Administrator\My ',...
	'Documents\Matlab files\modello'];
cd(setupPath);
global myCA;
myCA = CellularAutomata('data.mat');
global param;
Setup();

variabili = get(myCA,'variables');

celle = get(myCA,'cells');
cellIdx = [11,12,14];
ids = {};
for aCell = cellIdx,
	ids = [ids,celle(aCell).id];
end

rulesIdx = 1;
varIdx = 1:23;
varIdx = varIdx(param.rulesparam(rulesIdx).rule ~= 0);

cd(workPath);
for run = {'run_20060826-19.mat'},
	load(run{:});
	for var = varIdx,
		figure;
		plot(cellStory(store,cellIdx,var));
		h=title(run);
		set(h,'interpreter','none');
		xlabel(sprintf('Tempo (\\Delta t = %d gg)',store.tDelta));
		ylabel(variabili{var});
		legend(ids);
	end
end