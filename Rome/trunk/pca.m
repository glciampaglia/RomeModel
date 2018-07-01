function [ varargout ] = pca( X, varargin )
% Analisi delle componenti principali
%
% [lambda, factors, scores, loadings ] = PCA(X, mode) 
% [lambda, factors ] = PCA(X,mode)
%
% Analisi delle componenti principali della matrice di dati X
%
% In INPUT: 
% 1. X         matrice di dati grezzi
% 2. mode      una tra le due possibile string 'corr', 'cov' (default is
%              'cov');
%
% In OUTPUT:
% 1. lambda    vettore colonna di autovalori della matrice di
%              correlazione/covarianza dei dati, ordinati in ordine
%              decrescente (per eseguire scree test e/o kaiser test)
% 2. factors   matrice di autovettori (per colonna) della matrice di
%              correlazione covarianza relativi agli autovalori lambda
% 3. loadings  matrice di correlazione delle vecchie variabili con le
%              nuove variabili (cioe' i fattori)
% 4. scores    matrice dei dati trasformati

if nargin < 1,
	component = strcat('RomeModel:',mfilename(),':');
	mnemonic = 'NotEnoughArgumentsError';
	error(strcat(component,mnemonic), ...
		'You provided %d arguments, at least one is needed!',nargin);
end
m = size(X,1);
n = size(X,2);

% The mode string acts as a switch between two possible modes of operation of
% this function: PCA of the correlation matrix of the dataset or PCA of the
% covariance matrix of the dataset. Note that in general results may
% differ! (See Mardia K.V. et al, Multivariate Analysis, p. 219-220)
if nargin > 1,
	mode = varargin{1};
else
	mode = 'cov';
end
if ~strcmp(mode,'cov') && ~strcmp(mode,'corr'),
	component = strcat('RomeModel:',mfilename(),':');
	mnemonic = 'BadArgumentsError';
	error(strcat(component,mnemonic), ...
		'The ''mode'' argument must either be ''cov'' or ''corr''!');
end

mu_X = mean(X);				% mu_X is a row vector
sigma_X = std(X);			% sigma_X is a row vector
if strcmp(mode,'cov'),		% dataset is "centered"
	Z = (X - repmat(mu_X, [m 1]));	
else						% dataset is "centered" and "standardized"
	Z = (X - repmat(mu_X, [m 1])) ./ repmat(sigma_X, [m 1]);	
end

% Calcoliamo un sistema di autovettori ortonormali mediante SVD (economy
% sized version)
[U S V] = svd(Z/sqrt(m-1),0); 
lambda = diag(S) .^ 2;		% gli autovalori sono il quadrato dei valori 
							% singolari e sono gia' ordinati
factors = V;				% i fattori sono gli autovettori corrispondenti   
scores = Z * factors;		% scores contiene le coordinate nella base del 
							% sottospazio
loadings = zeros(n);
if strcmp(mode,'cov'),
	for i = 1:n,
		for j = 1:n,
			loadings(i,j) = factors(i,j) * sqrt(lambda(j))/sigma_X(i);
		end
	end
else
	for i = 1:n,
		for j = 1:n,
			loadings(i,j) = factors(i,j) * sqrt(lambda(j));
		end
	end
end

if nargout == 4,
	varargout = {lambda, factors, scores, loadings};
elseif nargout == 2,
	varargout = {lambda, factors};
else
	component = strcat('RomeModel:',mfilename(),':');
	mnemonic = 'WrongNumberOfOutputsError';
	error(strcat(component,mnemonic), ...
		'You wanted %d outputs, only 2 or 4 outputs are to be returned!',nargout);
end		