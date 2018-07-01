function [varargout] = randexp( varargin )
% Generatore di numeri casuali con distribuzione esponenziale
%
% RAND(I,M) ritorna una matrice quadrata MxM di numeri casuali estratti con
% distribuzione esponenziale di intensita' I nell'intervallo (0.0,1.0)
% Si veda l'help di RAND per una descrizione completa del formato dei
% parametri di input di questa funzione.

%{
per prima cosa controlliamo se abbiamo entrambi gli argomenti
1. L'intensita' e' un parametro obbligatorio
2. Se omettiamo la size ritorniamo uno scalare. 
3. L'intensita' deve essere un numero strettamente positivo

Lavoriamo con dei CELL ARRAYS perche' e' molto piu' facile in questo modo
trattare segnature differenti. Una sorta di polimorfismo a uffa!

NOTA: MODIFICA LA FUNZIONE CON IL TRUCCO DEI VARARGIN E DEI PARAMETRI OBBLIGATORI
%}

% controlliamo l'intensita'
if ( isscalar(varargin{1}) )
    I = varargin{1};
else
    I = 1.0;
end
if ( I <= 0 )
    warning('Argument "Intensity" is not strictly positive: re-setting to 1.0');
    I = 1.0;
end

% controlliamo la dimensione dell'output.
% dobbiamo avere una situazione del genere:
%
% >> size(rand([1 2],2,2,2,2,2,2,[3 4]))
% Warning: Input arguments must be scalar.
% Warning: Input arguments must be scalar.
%
% ans =
%
%      1     2     2     2     2     2     2     3
%
% solo che nel nostro caso il primo parametro di input e' gia stato preso
% per la variabile I.
switch (nargin - 1)
    case 0,
        S = [1];
    case 1,
        if ( ~ isnumeric(varargin{2}) )
            error('Input must be numeric');
        end
        if ( isscalar(varargin{2}) )
            S = [varargin{2} varargin{2}];
        else
            warning('Input arguments must be scalar');
            S = varargin{2};
        end
    otherwise,
        if ( ~ isnumeric([varargin{2:nargin}]) )
            error('Input must be numeric');
        end
        S = zeros(1,nargin - 1);
        for i = [1:nargin - 1],
            if ( isscalar(varargin{i+1}) )
                S(i) = varargin{i+1};
            else 
                warning('Input arguments must be scalar');
                S(i) = varargin{i+1}(1);
            end
        end
end

% Qui utilizziamo la rand builtin per simulare la distribuzione
% esponenziale utilizzando una distribuzione uniforme.
out = zeros(S);
x = rand(S);
out = - log(1 - x) / I;
varargout = { out };

        
            
                
            
        
    
        
        
        


