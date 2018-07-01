function obj = CellularAutomata (varargin)
% Costruttore della classe CELLULARAUTOMATA
% struttura:
% -> name :		nome della citta'
% -> time :		data corrente sotto forma di serial date number
% -> cells :	insieme di celle (structure array)
% 	*> cell.id :	id cella
% 	*> cell.name :	nome cella
% 	*>	(espandibile se voglio aggiungere altre info (coordinate del centro,
%		shape))
% -> data :	matrice di dati multivariati per colonna (dinamici, esogeni e non usati)
% -> adjacency :	matrice logica di adiacenza (simmetrica definita)
% -> dinamic :		array di indicizzamento logico per le variabili
%					dinamiche
% -> exogen :		array di indicizzamento dinamico per le variabili lente
% 
% 
% Possibili input
% 1. nessun input, creo un automa con una cella con vettore di stato e vettore 
%    esogeni unidimensionali
% 2. nome di file-MAT, carico il workspace e uso le variabil data, id, names, 
%    startTime, variables per popolare l'automa (e anche una variabile per le 
%    adiacenze)
% 3. data, id, names, startTime, variables, adjMatrix, costruisco il nuovo automa
% 4. Oggetto CellularAutomata, restituisco l'oggetto.

%{ 
TODO LIST
8/6/2006 
	Aggiustare le error per i due casi dello switch con parametri sbagliati
	Ripulire la struttura, usare delle subfunction etc etc.
%}

MATsignature = {'adjMatrix', 'cityName', 'data', 'dinamicVariables', ...
	'exogenVariables', 'scale', 'cellIDs', 'cellNames', 'cellPoly', 'startTime', ...
	'variables'};


switch nargin
	case 0
		defaultObj.name = 'Unknown City';
		defaultObj.time = now;
		defaultObj.data = zeros(1,1);
		defaultObj.variables = {'VAR'};
		defaultObj.scale = 1;
		defaultObj.cells = struct('id','00','name','Unknown Cell','poly',[0.,0.;1.,0.;1.,1.;0.,1.],'center',[0.5,0.5]);
		defaultObj.var2subs = struct('VAR',1);
		defaultObj.dinamic = false;
		defaultObj.exogen = false;
		defaultObj.adjacency = true;
		obj = class(defaultObj,'CellularAutomata');
	case 1
		% Se in input ho il path ad un file .MAT carico il workspace e creo
		% l'oggetto.
		if isa(varargin{1},'char'),
			fn = varargin{1};
			try loadedData = load(fn); catch
				fprintf(2,'Cannot instantiate object CellularAutomata\n\tCannot load data from MAT file!\n');
				rethrow(lasterror());
			end
			% Controllo che il workspace sia quello giusto!
			if ~ all(strcmp(sort(fieldnames(loadedData)), sort(MATsignature)')),
				component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
				mnemonic = 'WrongWorkspaceError';
				message = 'The Workspace loaded from %s does not contain a CA description!';
				error(strcat(component,mnemonic),message,fn);
			end
			% now let's build the CellularAutomata from the structure loadedData
			newObj.name = loadedData.cityName;
			newObj.time = loadedData.startTime;
			newObj.data = loadedData.data;
			newObj.variables = loadedData.variables;
			newObj.scale = loadedData.scale;
			nCells = size(loadedData.cellIDs,1);
			for aCell = 1:nCells,
				newObj.cells(aCell,1).id = loadedData.cellIDs(aCell);
				newObj.cells(aCell,1).name = loadedData.cellNames(aCell);
				newObj.cells(aCell,1).poly = loadedData.cellPoly(aCell,1);
				newObj.cells(aCell,1).center = loadedData.cellPoly(aCell,2);
			end
			newObj.var2subs = struct();
			for i = 1:length(loadedData.variables),
				newObj.var2subs.(loadedData.variables{i}) = i;
			end
			newObj.dinamic = loadedData.dinamicVariables;
			newObj.exogen = loadedData.exogenVariables;
			% controlliamo che i due array di indicizzamento non si
			% sovrappongano
			if any(newObj.dinamic & newObj.exogen),
				component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
				mnemonic = 'WrongWorkspaceError';
				message = 'Sanity check failed. Variables cannot be both dinamic and exogen!\n';
				error(strcat(component,mnemonic),message);
			end
			newObj.adjacency = loadedData.adjMatrix;
			obj = class(newObj,'CellularAutomata');
		elseif isa(varargin{1},'CellularAutomata'),
			% abbiamo in ingresso un oggetto di questa classe, lo
			% ritorniamo paro paro
			obj = varargin{1};
		else
			% non vogliamo altre tipi di input!
			component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
			mnemonic = 'InstantiationError';
			message = 'Wrong parameters passed to constructor!\n';
			error(strcat(component,mnemonic),message);
		end
	otherwise
		% in realta' sarebbe meglio fargli fare lo stesso del case 1 sul
		% primo parametro e basta... per questo meglio suddividere il file
		% in subfunctions...
		component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
		mnemonic = 'InstantiationError';
		message = 'Wrong parameters passed to constructor!\n';
		error(strcat(component,mnemonic),message);
end
			
		

			
