function varargout = cellStory(store,varargin)
% Questa funzione ritorna la dinamica di una cella, relativamente ad una
% variabile. E' possibile selezionare la dinamica di un insieme di celle e
% di un insieme di variabili. Prende in input obbligatorio lo store della
% simulazione da cui estrarre la dinamica
% 
% e.g plot(cellStory(store,1,1)) plotta la dinamica di POP (variabile 1)
% nella cella 6A (cella 1)

[nCells nVars nSims] = size(store.data);
switch nargin
	case 2,
		someCells = varargin{1};
		someVars = 1:nVars;
	case 3,
		someCells = varargin{1};
		someVars = varargin{2};
	otherwise
		someCells = 1:nCells;
		someVars = 1:nVars;
end

data = squeeze(zeros(nSims,length(someVars),length(someCells)));

for kSim = 1:nSims,
	data(kSim,:,:) = store.data(someCells,someVars,kSim)';
end

varargout = {data};
		
		
		

	