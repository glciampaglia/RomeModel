function Custom(ccode);
% Esegue del codice MATLAB sulle strutture dati inizializzate dopo il Setup
%
% See also EVALIN

global param
global DEBUG
global myCA

Setup;
evalin('base',ccode);
