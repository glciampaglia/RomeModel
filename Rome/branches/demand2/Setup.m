function Setup
% File di configurazione del simulatore
%
% Questo file definisce i valori *tutti* i parametri del simulatore. Le
% strutture dati global vengono dichiarate qui per la prima volta durante
% l'esecuzione del programma. 
%
% -- PER ABILITARE GLI STATEMENT DI DEBUGGING --
% 1. Imposta a VERO la variabile DEBUG.DEBUG
% 2. Imposta a debug.log (decommenta la linea di codice già impostata) il
%    valore della variable DEBUG.DEBUG_FILENAME
%
% See also SIMULATION, BOOTSTRAP

% --- TOP LEVEL GLOBALS ---

% We declare them as global in order to have access to them in each 
% function's workspace
global myCA
global param
global DEBUG
global store

% Debug mode data structure. 
DEBUG = struct();	% empty struct;
param = struct();	% empty struct;

% Creation of the object of the cellular automata.
myCA = CellularAutomata('data.mat');

% Storage structure.
store = struct();

% --- DEBUGGING ---
% set to true if you want debugging output - performances will be affected
DEBUG.DEBUG_ON = false;

% put the filename here. set to empty string for the standard error
% DEBUG.DEBUG_FILENAME = 'debug.log';
DEBUG.DEBUG_FILENAME = '';	

% how many characters have been succesfully written
DEBUG.DEBUG_COUNT = 0;

% --- STORAGE PARAMETERS ---
store.register = [];
store.lAttr = [];
store.gAttr = [];
param.saveTheseParams = {'tStop','tDelta','nOfClassSteps','rulesparam'};
store.tStart = get(myCA,'time');

% --- BOOTSTRAP PARAMETERS
param.active = [];	% questo serve per il bootstrap
param.spikes = [];  % idem

% --- GENERAL PURPOSE PARAMETERS ---
param.rules = {'\alpha_1','\alpha_2','\alpha_3','\alpha_4','\alpha_5',...
	'\alpha_6','\alpha_7'};
param.decisions={'A','L','D','U'};	
% rules = num2cell([...
% 				0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 1 0 -1 0 0 0 0 0 0 0 0 0;...
% 				0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 -1 0 0 1 0 0 1 0 0 0;...
% 				1 1 -1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;...
% 				-1 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;...
% 				0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0;...
% 				0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0;...
% 				0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0;],2);
% quando toccherà levare le variabili CON SEM FOR URB
rules = num2cell([	0 0 1 0 0 0 0 0 1 0 0 1 0 -1 0 0 0 0 0 0 0 0 0;...
					0 0 0 0 0 0 0 0 0 0 1 1 0 -1 0 0 1 0 0 1 0 0 0;...
					1 1 -1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;...
					-1 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;...
					0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0;...
					0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0;...
					0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0;],2);
% pHS è potential housing starts, cioè il livello di nuove case che possono
% essere costruite. GD è la Ground demand.
param.nRules = length(param.rules);
param.nDecs = length(param.decisions);
[param.nCells param.nVars] = size(data(myCA));
param.pHS = 0;
param.GD = 0;

% --- GENERAL PURPOSE PARAMETERS - SIMULATION DEPENDENT ---
param.tStop = datenum('01-Jan-1993'); 
param.tDelta = 5;
param.nOfClassSteps = 3;	
param.simFlags = 'none';
% uncomment these lines to have fine control over process registration
%param.simFlags = { 'U','U','U','U','U','U','U' };

% Per ogni popolazione sono definiti:
% passive	- Numero di agenti passivi
% active	- Numero di agenti attivi per ciascuna cella
% LAMBDA	- Intensità globale dei sottoprocessi A, L, D, U
% gAttr		- Forza regionale di ciascuna cella
% lAttr		- Forza urbana di ciascuna cella
param.rulesparam = struct();
for iRule = 1:param.nRules,
	param.rulesparam(iRule).active = zeros(1,param.nCells);
	param.rulesparam(iRule).gAttr = zeros(1,param.nCells);
	param.rulesparam(iRule).lAttr = zeros(1,param.nCells);	
end
[param.rulesparam.rule] = deal(rules{:});

% Configurazione delle singole popolazioni
% ----------------------------------------
% 1 - Costruzione di un edificio residenziale
param.rulesparam(1).passive = 1000;
param.rulesparam(1).LAMBDA = [0, 1/3, 1, 1];
param.rulesparam(1).dLAMBDA = 0;

% 2 - Costruzione di un centro commerciale di livello urbano
param.rulesparam(2).passive = 1000;
param.rulesparam(2).LAMBDA = [0, 1/3, 1, 1];
param.rulesparam(2).dLAMBDA = 0;

% 3 - Occupazione di una residenza
param.rulesparam(3).passive = 1000;
param.rulesparam(3).LAMBDA = [0, 1/3, 1, 1];
param.rulesparam(3).dLAMBDA = 0;

% 4 - Abbandono di una residenza
param.rulesparam(4).passive = 1000;
param.rulesparam(4).LAMBDA = [0, 1/3, 1, 1];
param.rulesparam(4).dLAMBDA = 0;

% 5 - Conversione di suolo agricolo in edificale
param.rulesparam(5).passive = 1000;
param.rulesparam(5).LAMBDA = [0, 1/3, 1, 1];
param.rulesparam(5).dLAMBDA = 0;

% 6 - Creazione di una attività commerciale di livello locale
param.rulesparam(6).passive = 1000;
param.rulesparam(6).LAMBDA = [0, 1/3, 1, 1];
param.rulesparam(6).dLAMBDA = 0;

% 7 - Creazione di una attività di terziario
param.rulesparam(7).passive = 1000;
param.rulesparam(7).LAMBDA = [0, 1/3, 1, 1];
param.rulesparam(7).dLAMBDA = 0;

% --- SINGLE SCRIPT SCOPED PARAMETERS ---
param.scripts = struct();

param.scripts.Bootstrap = struct();
param.scripts.Bootstrap.nPlotsPerLine = 3;

% Notare che r ed eps sono settati a mano dopo aver ispezionato i grafici
% generati con test/test_classification (per eps) oppure facendo il grafico
% della varianza di ciascuna componente.
param.scripts.classification = struct();
param.scripts.classification.r = 2;	
param.scripts.classification.distVar = {'DUN','DTL','DHO','DFM'};
param.scripts.classification.eps = 0.4;
[lambda, factors, scores, loadings ] = pca(data(myCA));
rawAttr = scores(:,1:param.scripts.classification.r) * ...
    loadings(:,1:param.scripts.classification.r)';
% Questi due parametri servono per calibrare la funzione arcotangente.
param.scripts.classification.meanRaw = ones(size(rawAttr))*diag(mean(rawAttr));
param.scripts.classification.stdRaw = ones(size(rawAttr))*diag(std(rawAttr));

% xi	- punti di controllo per la funzione del costo marginale
% yi	- sono un set di punti di valori ISTAT di prezzo delle case
% eqPrice - il prezzo di equilibrio è preso dai dati CRESME sul mercato
% immobiliare ed ha come unità di misura 10^3 Lire/mq
% a - numero tra 0 e 1 che da la frazione di case occupate che vengono
% conteggiate nello stock.
stockInc = 0.1;
priceThresh = 0.2;
eqPrice = 1000;
eqQuant = 5;
param.scripts.updateMarket = struct();
param.scripts.updateMarket.stockInc = stockInc;
param.scripts.updateMarket.priceThresh = priceThresh;
param.scripts.updateMarket.demandLvl = sum(myCA.ABC)+stockInc*sum(myCA.ABN);
param.scripts.updateMarket.eqPrice = eqPrice;
param.scripts.updateMarket.eqQuant = eqQuant;
param.scripts.updateMarket.xm = 1;
param.scripts.updateMarket.ym = eqPrice*(1-priceThresh);
b = eqQuant^2 - 2*eqQuant;
param.scripts.updateMarket.y0 = eqPrice*((1-priceThresh)*b+1)/(b+1);

param.scripts.genBuilding = struct();
param.scripts.genBuilding.floorsPdf = [0.159889752805118;...
		0.286415635056729;0.178400006264045;0.375294605874108];			
param.scripts.genBuilding.sup = 80;
param.scripts.genBuilding.groundRequests = [];

param.scripts.genIperMarket = struct();
param.scripts.genIperMarket.surfMean = 24000;
param.scripts.genIperMarket.surfStd = 7000;
param.scripts.genIperMarket.personnelMean = 4441;
param.scripts.genIperMarket.personnelStd = 441;
param.scripts.genIperMarket.roomVol = 100;
param.scripts.genIperMarket.floorMax = 4;
param.scripts.genIperMarket.sulSloRatio = 16/10;
param.scripts.genIperMarket.groundRequests = [];

param.scripts.genFamily = struct();
param.scripts.genFamily.householdPdf = [0.281664280105317 ...
	0.289806496066023 0.20997698123085 0.17248006066485 ...
	0.03847271621476 0.007599465718201];

param.scripts.genGround = struct();

param.scripts.genCommercial = struct();
param.scripts.genCommercial.personnelClasses = [1 9 10 19 20 49];
param.scripts.genCommercial.personnelClassesPdf = [0.833069885026697 ...
	0.094985557540714 0.071944557432589];

param.scripts.genService = struct();
param.scripts.genService.personnelClasses = [1 9 10 19 20 49];
param.scripts.genService.personnelClassesPdf = [0.434307003289604 ...
	0.291902817962031 0.273790178748365];

% La variabile dir imposta il path in cui salvare i MAT-file. Non deve
% contenere alcun separatore.
param.scripts.Storage = struct();
param.scripts.Storage.dir = 'runs';