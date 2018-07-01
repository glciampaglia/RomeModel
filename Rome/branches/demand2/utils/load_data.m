function stores = load_data(varargin)
% S = LOAD_DATA()
% S = LOAD_DATA(PATH)
%
% Questa funzione carica tutti i MAT file che si trovano in un PATH fornito
% come input e crea un array di strutture S. Senza parametri carica tutti i
% file nel path corrente.

if nargin > 0,
    path = varargin{1};
else
    path = '.';
end
files = dir(sprintf('%s/*.mat',path));
nFiles = length(files);
for i = 1:nFiles,
    load(sprintf('%s/%s',path,files(i).name));
    stores(i) = store;
end
