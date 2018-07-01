function varargout = mean_dynamics(stores,runs,varargin)
% Calcola la media di una variabile di stato su più simulazioni. NOTA Questo
% metodo è utilizzabile sotto condizioni di stazionarietà dello stato del
% sistema, per cui è possibile mediare una variabile di stato su più
% simulazioni. 
%
% X = MEAN_DYNAMICS(STORES,RUNS,VARIDX) ritorna una matrice le cui colonne
% sono la dinamica media della variabile urbanistica avente indice di
% colonna VARIDX per ciascuna cella. La media è calcolata sulle simulazioni
% corrispondenti agli elementi dell'array STORES aventi indici in RUNS. X
% può essere usato direttamente per plottare le sue colonne.
%
% X = MEAN_DYNAMICS(STORES,RUNS,VARIDX,FIELD) ritorna una matrice le cui
% colonne sono la dinamica media della variabile VARNAME per ciascuna
% cella, dove la matrice di dati da referenziare corrisponde al campo FIELD
% all'interno di ciascuna struttura in STORES.
%
% [X E] = MEAN_DYNAMICS(..) fa lo stesso delle due versioni precedenti ed
% in più ritorna anche la matrice E contenete la deviazione standard
% associata ad ogni elemento di X. Può essere utile per valutare se la
% dinamica è effettivamente stazionaria.
%
% See also, LOAD_DATA, PLOT_VARIABLES

if nargin < 3,
    warning('RomeModel:utils:mean_dynamics','column index unspecified');
    if nargout == 1,
        varargout = {[]};
    else
        varargout = {[],[]};
    end
    return
end

varidx = varargin{1};
if nargin == 4,
    field = varargin{2};
else
    field = 'data';
end 

if ~isscalar(varidx),
    warning('RomeModel:utils:mean_dynamics','Using only the first variable index');
    varidx(2:end) = [];
end

if isempty(find(strcmp(fieldnames(stores),field), 1)),
    warning('RomeModel:utils:mean_dynamics','no field name %s',field);
    if nargout == 1,
        varargout = {[]};
    else
        varargout = {[],[]};
    end
    return
end

tmp = [];
try
for r = runs,
    tmp = cat(3,tmp,squeeze(stores(r).(field)(:,varidx,:))');
end
catch
    err = lasterror();
    if strcmp(err.identifier,'MATLAB:badsubscript');
        warning('RomeModel:utils:mean_dynamics',err.message);
        if nargout == 1,
            varargout = {[]};
        else
            varargout = {[],[]};
        end
        return
    else
        rethrow(err);
    end
end
    
X = mean(tmp,3);
if 1 == size(X,1),
    X = X';
end 
if nargout > 1,
    E = std(tmp,false,3);
    varargout = {X E};
else
    varargout = {X};
end