function Evolution(mode,varargin)
% Simula la dinamica del sistema per una simulazione
%
%	EVOLUTION(TRUE) esegue il bootstrap del modello. In questo caso il
%	  processo di poisson non modifica lo stato dinamico dell'automa, ma
%	  solo quello delle popolazioni di agenti
%	EVOLUTION(FALSE) esegue la simulazione vera e propria.
% 
% Questo algoritmo simula l'evoluzione dell'automa cellulare che
% rappresenta il sistema urbano. La simulazione procede iterativamente per
% un certo numero di passi discreti, ciascuno di durata tDelta; Durante
% ciascun intervallo viene simulato un processo di Poisson composto, da cui
% generiamo gli eventi di aggiornamento del sistema. Tali eventi non
% modificano i valori di attrattivita' delle celle dell'automa per tutto
% l'intervallo tDelta. Una volta terminato aggiorniamo la matrice di stato
% dell'automa. 

%{
TODO LIST

STICKY (SUDDIVISIONE DELLO SCRIPT)
1.	loop principale che cicla per il numero di step richiesti. 
	Chiama ad ogni step una subfunction (vedi 2) che esegue il processo 
	globale relativamente a quello step ed una volta che questa ritorna 
    aggiorna la matrice di attrattivita' dell'automa cellulare (qui 
    bisogna ottimizzare usando operazioni matriciali!) mediante subfunction 
    (vedi 3). Dovrebbe anche tenere una lista di modifiche esogene all'automa   
    cellulare, e aggiornare le intensita' globali Delta maiuscolo per A,D,G,0. 
2.	function (poisson.m) che simula il processo durante uno step di 
	lunghezza tDelta. Estrae un certo numero (distribuito secondo Poisson!) 
	di eventi globali, da ciascuno di essi costruisce l-evento (\alpha,c,\pi) e 
	aggiorna l'automa cellulare 
3.	subfunction (che chiama classification.m??) che aggiorna le matrici di 
	attrattivita'. 
%}

global myCA
global param
global DEBUG
global store

% QUESTO BLOCCO DI CODICE PUò ESSERE TOLTO
% if DEBUG.DEBUG_ON,
% 	fprintf(DEBUG.DEBUG_FD,strcat(char(repmat(double('-'),[1 80])),'\n'));
% 	fprintf(DEBUG.DEBUG_FD,'\tEvolution.m STARTS\n');
% 	fprintf(DEBUG.DEBUG_FD,strcat(char(repmat(double('-'),[1 80])),'\n'));
% 	tic;
% end

% NOTA 1:
% se mode, allora faccio n step lunghi tDelta. Se ~mode, allora devo fare
% nStep quanti sono gli intervalli di lunghezza tDelta fra tStart e tStop,
% incluso un eventuale ultimo intervallo di lunghezza < tDelta.
% NOTA 2:
% notare che length(start:step:stop)-1 == floor((stop-start)/step)
% sottraggo uno a primo membro perche' start e' di default il primo
% elemento dell'array generato dall'operatore colon (:)
if mode,
	nSteps = varargin{1};
	offset = varargin{2}; % how many times I've been called before
	tNumArray = 0:param.tDelta:nSteps*param.tDelta;
else
	tStart = get(myCA,'time');
	nStep = (param.tStop - tStart)/param.tDelta;
	tNumArray = tStart:param.tDelta:param.tStop;
	% devo aggiungere l'intervallo [floor(nstep)*tDelta,tStop),
	% visto che tDelta non divide tStop-tStart!
	if (floor(nStep) ~= nStep),	tNumArray(end+1) = param.tStop; end
end

% NOTA 1:
% se mode, non serve fare la classificazione, per cui l'array di logicals
% che mi dice se fare classification ad ogni step discreto lo metto uguale
% a false in ogni posizione. Se ~mode, allora ogni nOfClassSteps devo fare
% classificazione. Allora l'elemento i-esimo e' pari a ( nOfClassSteps
% divides iArray(i) ).
% NOTA 2:
% uso la variabile n anziche' nOfClassSteps solo per leggibilita' del
% codice.
% NOTA 3:
% la funzione di aggiornamento non deve fare nulla, quindi
% l'handler da passare a poisson.m si riferisce ad una funzione
% speciale che non fa nulla (matlab non prevede funzioni anonime nulle,
% che schifo).
iArray = 1:length(tNumArray)-1;
if mode,	
	doClassFlagArray = false(size(iArray));
	handler = @null;
else
	n = param.nOfClassSteps;	
	doClassFlagArray = ( gcd(iArray,n) == repmat(n,size(iArray)) ); 
	handler = @event;
	store.lAttr = [];
	store.gAttr = [];
	store.HS_0 = [];
	store.GD = [];
	store.data = [];
end

% NOTA:
% queste dichiarazioni sono per leggibilita' e basta.
nRules = param.nRules;
nCells = param.nCells;
nDecs = param.nDecs;

%{
MAIN EVOLUTION CYCLE:
	1 Applico gli eventi esogeni
	2 Aggiorno i fattori di scala delle intensita' dei processi
	  decisionali e aggiorno il mercato immobiliare etc
	3 Calcolo l'intensita' del processo globale relativo all'intero CA
	4 first we compute the intensities for the single agent's process.
	  During the time step of length tDelta these are homogenous processes
	  so they won't change. 
%}
for i = iArray,			
	% NOTA:
	% Se mode, ...
	% Se ~mode, aggiorno le quantita' dinamiche globali (il mercato) 
	% e passo a poisson.m il file "smista" tra le varie funzioni di
	% aggiornamento. 
	if mode,
		% boh!
	else
		for iRule = 1:nRules,
			param.rulesparam(iRule).LAMBDA(1) = param.rulesparam(iRule).LAMBDA(1) + ...
				param.rulesparam(iRule).dLAMBDA;
		end
		param.HS_0 = updateMarket(sum(myCA.ABN));
		param.GD = sum(param.scripts.genBuilding.groundRequests) + ...
			sum(param.scripts.genIperMarket.groundRequests);
		param.scripts.genBuilding.groundRequests = [];
		param.scripts.genIperMarket.groundRequests = [];
		if param.GD == 0,
			param.GD = ceil(10 * rand);
		end
		myCA = set(myCA,'time',tNumArray(i+1));
	end
	
	% NOTA:
	% rDec(:,:,1) contiene i rate per il processo di attivazione (A) per
	% singolo agente.
	% rDec(:,:,2) contiene i rate per il processo di abbandono (L) per
	% singolo agente.
	% rDec(:,:,3) contiene i rate per il processo di diffusione (D) per
	% singolo agente.
	% rDec(:,:,4) contiene i rate per il processo di evento urbano (0) per
	% singolo agente.
	LAMBDA = zeros(nRules,nRules,nDecs);	
%	tmpLAMBDA = zeros(nDecs, nRules);
	tmpLAMBDA = reshape([param.rulesparam.LAMBDA],[nDecs,nRules]);
	for aDec = 1:nDecs,
		LAMBDA(:,:,aDec) = diag(tmpLAMBDA(aDec,:));
	end
	param.gAttr = zeros(nRules,nCells);
	param.lAttr = zeros(nRules,nCells);
	for iRule = 1:nRules,
		param.gAttr(iRule,:) = [param.rulesparam(iRule).gAttr] / ...
			sum([param.rulesparam(iRule).gAttr],2);
		param.lAttr(iRule,:) = [param.rulesparam(iRule).lAttr];
	end
	rDec = zeros(nRules,nCells,nDecs);
	rDec(:,:,1) = LAMBDA(:,:,1) * param.gAttr; 
	rDec(:,:,2) = LAMBDA(:,:,2) * ones(nRules,nCells);
	rDec(:,:,3) = LAMBDA(:,:,3) * param.gAttr; 
	rDec(:,:,4) = LAMBDA(:,:,4) * param.lAttr; 

	if DEBUG.DEBUG_ON,
		fprintf(DEBUG.DEBUG_FD,'%s -> %s: ',datestr(tNumArray(i)),...
			datestr(tNumArray(i+1)));
	end
	
	% NOTA:
	% Il passaggio dei parametri in matlab e' esclusivamente by-value, per
	% cui rDec non viene modificata una volta che poisson.m ritorna
	% NOTA2:
	% se mode, dobbiamo ottenere una registrazione dei subprocesses di
	% attivazione e diffusione in modo da aggiornare i vettori globali
	% contenenti la dinamica del numero di agenti attivi ed i tempi di
	% interarrivo del processo composto globale.
	% NOTA3: 
	% si veda nota2: bisognerebbe modificare Setup.m per eliminare
	% param.active e param.spikes. Il codice relativo alla costruzione di
	% questi due array andrebbe in bootstrap.m, dato che è quella funzione
	% che ha bisogno di queste quantità. Si potrebbe anche pensare a fare
	% varie function separate che lavorano sulla struttura dati register
	% per ricavare le dinamiche di quantità rilevanti come avviene adesso
	% con il numero di agenti attivi.
	if mode, %bootstrap
		flags = 'all';
		register = poisson(tNumArray(i+1) - tNumArray(i),rDec,handler,...
			flags);
		% concateno i tempi di interarrivo ed il numero di agenti attivi
		% per ciascuna popolazione per questo intervallo 
		param.spikes = [param.spikes;reg2spikes(register,offset)];
		if isempty(param.active),
			param.active = [param.active;reg2active(register,...
				zeros(1,nRules))];
		else
			param.active = [param.active;reg2active(register,...
				param.active(end,:))];
		end
	else %simulation
		register = poisson(tNumArray(i+1) - tNumArray(i),rDec,handler,...
		param.simFlags);	
		store.register = [store.register,register];
	end
	if doClassFlagArray(i),
		if DEBUG.DEBUG_ON,
			fprintf(DEBUG.DEBUG_FD,'\t(updating classification)');
		end
		[lAttr gAttr] = classification();
		store.lAttr = cat(3,store.lAttr,lAttr);
		store.gAttr = cat(3,store.gAttr,gAttr);
		store.data = cat(3,store.data,myCA(:));
		store.HS_0 = [store.HS_0; param.HS_0];
		store.GD = [store.GD; param.GD];
	end
	if DEBUG.DEBUG_ON,
		fprintf(DEBUG.DEBUG_FD,'\n');
	end
end	

% if DEBUG.DEBUG_ON,
% 	t = toc;
% 	fprintf(DEBUG.DEBUG_FD,strcat(char(repmat(double('-'),[1 80])),'\n'));
% 	fprintf(DEBUG.DEBUG_FD,...
%		'\tEvolution.m STOPS (elapsed time = %d sec)\n',t); 
% 	fprintf(DEBUG.DEBUG_FD,strcat(char(repmat(double('-'),[1 80])),'\n'));
% end
% end of function

       
        