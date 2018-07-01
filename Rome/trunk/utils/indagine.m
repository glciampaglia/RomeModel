clear all;
workPath = pwd;
setupPath = 'C:\Documents and Settings\Administrator\My Documents\Matlab files\modello';
cd(setupPath);
myCA = CellularAutomata('data.mat');
variabili = get(myCA,'variables');
cd(workPath);
close all;
collectAttr;

figure;
for k=1:8,
	subplot(3,3,k);
	plot(data.totPOP{k});
	h=title(data.name{k});
	set(h,'interpreter','none');
	xlabel(sprintf('Tempo (\\Delta T = %d gg)',data.DeltaT{k}));
	ylabel('Abitanti');
end
saveas(gcf,'POP_totale.fig');
% gtext('Dinamica della popolazione complessiva del sistema');

figure;
for k = 1:8,
	subplot(3,3,k);
	plot(data.totAB{k});
	h=title(data.name{k});
	set(h,'interpreter','none');
	legend(variabili{2},variabili{3})
	xlabel(sprintf('Tempo (\\Delta T = %d gg)',data.DeltaT{k}));
	ylabel('Abitazioni');
end
saveas(gcf,'AB_totale.fig');
% gtext('Dinamica delle abitazioni del sistema');

figure;
for k = 1:8,
	subplot(3,3,k);
	plot(data.totSURF{k});
	h=title(data.name{k});
	set(h,'interpreter','none');
	legend(variabili{9:14});
	xlabel(sprintf('Tempo (\\Delta T = %d gg)',data.DeltaT{k}));
	ylabel('Ettari (ha)');
end
saveas(gcf,'SURF_totale.fig');
% gtext(sprintf('Dinamica della superficie territorale\ndel sistema per destinazione d''uso'));

figure;
for k=1:8,
	subplot(3,3,k);
	plot(data.GD{k});
	h=title(data.name{k});
	set(h,'interpreter','none');
	xlabel(sprintf('Tempo (\\Delta T = %d gg)',data.DeltaT{k}));
	ylabel('Ettari (ha)');
end
saveas(gcf,'GD.fig');
% gtext('Dinamica della richiesta di conversione\nd''uso del suolo per scopo edificabile');

figure;
for k=1:8,
	subplot(3,3,k);
	plot(data.HS_0{k});
	h=title(data.name{k});
	set(h,'interpreter','none');
	xlabel(sprintf('Tempo (\\Delta T = %d gg)',data.DeltaT{k}));
	ylabel('Abitazioni');
end
saveas(gcf,'HS.fig');
% gtext('Dinamica del livello di stock del mercato immobiliare');