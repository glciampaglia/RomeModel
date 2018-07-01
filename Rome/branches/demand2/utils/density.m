function dens_c = density(stores,runs,varargin)
% DENSITY(STORES,RUNS) Calcola la densità residenziale al tempo t=0 su un
% certo numero di run aventi indice in RUNS.  
% 
% DENSITY(STORES,RUNS,VARNAME) Idem ma per la variabile chiamata VARNAME
%
% DENSITY(STORES,RUNS,VARNAME,TIME) Idem ma al tempo TIME

error(nargchk(2,4,nargin));
varname = 'RES';
time = 1;
switch nargin
    case 3
        varname = varargin{1};
    case 4
        varname = varargin{1};
        time = varargin{2};
end
surfaces = {'RES' 'SUR' 'SLO' 'PAG' 'VUO' 'VER' 'PRO'};
nSurfVar = length(surfaces);
densVar = find(strcmp(surfaces,varname),1);
if isempty(densVar),
    warning('RomeModel:util:density',...
        'La variabile specificata per la densità non esiste');
    dens_c = {[]};
    return
end
nCells = size(stores(1).data,1);
nSteps = size(stores(1).data,3);
S_t = zeros(nSteps,nCells,nSurfVar);
for i = 1:nSurfVar,
    S_t(:,:,i)  = mean_dynamics(stores,runs,var2ind(surfaces{i}));
end
supCell_t = squeeze(sum(S_t,3));
supCity_t = sum(supCell_t,2); 
supError = max(supCity_t) - min(supCity_t);
check_passed = (0 == supError);
if ~check_passed,
    warning('RomeModel:util:density',...
        'Total surface varies over time! Error %0.2g',supError);
end
sup_c = transpose(supCell_t(1,:));
dens_c = transpose(squeeze(S_t(time,:,densVar))) ./ sup_c;



