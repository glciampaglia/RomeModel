function varargout = classification(varargin)
% Calcola la forza di attrazione urbana e regionale
%
% Questa funzione si occupa di fornire un metodo per calcolare i valori di
% attrattivita' delle celle per tutti i tipi di alfa evento.
% Questa funzione serve da interfaccia tra la parte del sistema che simula
% il processo di poisson globale e che esegue l'evoluzione dell'automa e la
% parte del sistema che implementa i metodi di classificazione in base ai
% quali e' possibile definire le funzioni di attrattivita' (NN, Fuzzy decisioni,
% PCA).
%
% INPUT:
% CLASSIFICATION()			- esegue la PCA di correlazione su myCA globale 
% CLASSIFICATION(X)			- esegue la PCA di correlazione su X
% CLASSIFICATION(MODE)		- esegue la PCA secondo mode su myCA globale
% CLASSIFICATION(X,MODE)	- esegue la PCA secondo mode su X
%
% OUTPUT:
% CLASSIFICATION(..)		- calcola l'attrattività in param globale
% F = CLASSIFICATION(..)	- calcola l'attrattività e la memorizza in F 
% [F G] = CLASSIFICATION(..)- calcola l'attrattività locale e globale 
global param
global myCA
global DEBUG

myparam = param.scripts.classification;

switch nargin,
	case 0
		X = myCA(:);
		mode = 'corr';
	case 1
		if ischar(varargin{1}),
			mode = varargin{1};
			X = myCA(:);
		else
			X = varargin{1};
			mode = 'corr';
		end
	otherwise
		X = varargin{1};
		mode = varargin{2};
end

% Visto che rawAttr non è definita positiva, applichiamo ai singoli
% contributi l'arcotangente calibrata sulla media e la deviazione standard
% dei contributi originari (dei dati iniziali). In questo modo ho
% contributi definiti positivi e posso sommarli senza problemi.
[lambda, factors, scores, loadings ] = pca(X, mode);
rawAttr = scores(:,1:myparam.r) * loadings(:,1:myparam.r)';
posAttr = 0.5 + atan((rawAttr-myparam.meanRaw)./ myparam.stdRaw)/pi;

for aRule = 1:param.nRules,
	colidx = (param.rulesparam(aRule).rule ~= 0);
	param.rulesparam(aRule).lAttr = param.rulesparam(aRule).lAttr + ...
		myparam.eps*(sum(posAttr(:,colidx),2)' - ...
		param.rulesparam(aRule).lAttr);
end

% L'indice di integrazione di una cella è la produttoria di una funzione
% positiva decrescente dei valori di DUN,DTL,DHO,DFM della cella
netInt = ones(param.nCells,1);
tmpInt = zeros(param.nCells,4);

k = 1;
for aVar = [myparam.distVar],
    aVarMean = mean(myCA.(aVar{:}));
    aVarStd = std(myCA.(aVar{:}));
	tmpInt(:,k) = 2*(1-hill(myCA.(aVar{:}),{aVarMean,0.5},{aVarMean+aVarStd,0.75}));
	netInt = prod(tmpInt,2);	
	k = k +1;
end

cells = get(myCA,'cells');
centers = cell2mat([cells.center]');
for aRule = 1:param.nRules,
	for aCell = 1:param.nCells,
% 		neigh = neighbourhood(myCA,aCell);
		aCellCenter = centers(aCell,:);
        distances = sqrt(sum(centers.^2+repmat(aCellCenter.^2,[size(centers,1),1]),2));
        tmpDist = 2*(1-hill(distances,{mean(distances),0.5},{mean(distances)+...
            std(distances),0.75}));
% 		tmpDist = distIndex(center,centers(neigh,:));
		tmpAttr = param.rulesparam(aRule).lAttr(:);
		tmpInt = netInt(:);
		param.rulesparam(aRule).gAttr(aCell) = mean(tmpDist.*tmpAttr.*tmpInt);
	end
end

varargout = {};
if nargout > 0,
 	varargout = {reshape([param.rulesparam.lAttr],...
 		[param.nCells param.nRules]); ...
 		reshape([param.rulesparam.gAttr],[param.nCells param.nRules])};
end

%
%	SUBFUNCTIONS
%

function d = distance(pointA,pointB)
% pointA and pointB are nx2 matrices where n is the number of couples of
% points (and of segments)
if (size(pointA,2) ~= 2) & (size(pointB,2) ~= 2),
	error('RomeModel:classification_distance','Wrong parameters size');
end
d = sqrt(sum((pointA-pointB).^2,2));

%
% funzione decrescente ottenuta per interpolazione dei seguenti punti di
% controllo: (0,2), (mu,1), (max+c,0), dove:
% mu è il valore medio dei valori della variabile var,
% max è il massimo dei valori di var
% c è un parametro di controllo per evitare che in max la funzione assuma
% valore nullo. 
% function i = intIndex(aVar)
% global myCA;
% global param;
% % global DEBUG;
% c = (max(myCA.(aVar)) - min(myCA.(aVar))) / param.nCells;
% x = [0, mean(myCA.(aVar)),max(myCA.(aVar))+c];
% y = [2,1,0];
% i = interp1(x,y,myCA.(aVar),'pchip');

%
% funzione decrescente della distanza tra i centri di due celle
% bCell può anche essere un array
%
function idx = distIndex(aCell,someCells)
% global myCA;
% global param;
% global DEBUG;

d = distance(repmat(aCell,[length(someCells) 1]),someCells);
idx = 1 ./ ( d + 1);