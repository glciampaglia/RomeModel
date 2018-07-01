function Bootstrap
% Calcola il numero iniziale di agenti
% 
% ATTENZIONE ATTENZIONE! Se il bootstrap e' stato gia' 
% eseguito allora questo script non dovrebbe rieseguirlo!
% piuttosto, la prima volta che lo esegue deve salvare
% i dati in un file MAT e successivamente ricaricarli.
%
% NOTA BENE:
% 1. esegui prima la classificazione
% 2. controlla se esiste già in memoria un numero di step da eseguire per
%    quel valore di nAgentStart
% 3. se non esiste:
% 4.		esegui l'evoluzione(*) per un certo numero di passi
% 5.		mostra all'utente un grafico degli agenti attivi di ogni pop.
% 6.		chiedi se la situazione è stazionaria
% 7.		se sì, registra il numero di step fatti ed esci dal bootstrap
% 8.		se no, torna la punto 4.
% 9. se invece esiste:
% 10.	esegui l'evoluzione(*) per quel numero di step
% 11.	esci dal bootstrap
% 
%  (*): passandogli handler alla funzione null.m

%global myCA
% global DEBUG
global param
global simulation

myparam = param.scripts.Bootstrap;
nPlotsPerCol = ceil(param.nRules / myparam.nPlotsPerLine);
classification();
nAgents = [param.rulesparam.passive];
idx = 0;
found = false;
while (idx < size(simulation.nAgents,1)) && ~found,
	idx = idx + 1;
	found = all(simulation.nAgents(idx,:) == nAgents);
end
if ~found,
	% punti 4 - 8
	stopFlag = false;
	fprintf('No previous bootstrap done,\n');
	count = 0;
	while ~stopFlag,
		Evolution(true,1,count*param.tDelta);
		count = count + 1;
		for i = 1:param.nRules,
			subplot(myparam.nPlotsPerLine,nPlotsPerCol,i);
			plot(param.spikes,param.active(:,i));
			title(sprintf('Active agents for rule %s',param.rules{i}));
			axis([0 param.tDelta*count 0 nAgents(i)]);
		end
		subplot(myparam.nPlotsPerLine,nPlotsPerCol,param.nRules+1);
		plot(param.spikes,sum(param.active,2));
		title('Total number of active agents');
		axis([0 param.tDelta*count 0 sum(nAgents)]);
		stopAsking = false;
		while ~stopAsking,
			answer = input('Stop bootstrap? [S/N]: ','s');
			stopAsking = any(strcmp(answer,{'S','s','N','n'}));
		end
%		close(gcf());
		if any(strcmp(answer,{'S','s'})),
			fprintf('\tSaving bootstrap results..');
			stopFlag = true;
			simulation.nAgents = [simulation.nAgents;nAgents];
			boot = input(['Choose bootstrap time [chose a value along',...
				'x-axis]: ']);
			bootSteps = ceil(boot/param.tDelta);
			fprintf('\tThe number of bootstrap steps I will execute\n');
			fprintf('\tnext time with this number of agents is %d..',...
				bootSteps);
			simulation.nSteps(end+1) = bootSteps;
		end
	end
else
	% punti 10 - 11
	fprintf('Found previous bootstrap..');
	Evolution(true,simulation.nSteps(idx),0);
end

% if DEBUG.DEBUG_ON,
% 	fprintf(DEBUG.DEBUG_FD,strcat(char(repmat(double('-'),[1 80])),'\n'));
% 	fprintf(DEBUG.DEBUG_FD,'\tBootstrap.m STARTS\n');
% 	fprintf(DEBUG.DEBUG_FD,strcat(char(repmat(double('-'),[1 80])),'\n'));
% end
% 
% if DEBUG.DEBUG_ON,
% 	fprintf(DEBUG.DEBUG_FD,strcat(char(repmat(double('-'),[1 80])),'\n'));
% 	fprintf(DEBUG.DEBUG_FD,'\tBoostrap.m STOPS\n');
% 	fprintf(DEBUG.DEBUG_FD,strcat(char(repmat(double('-'),[1 80])),'\n'));
% end
