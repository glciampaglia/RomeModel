function idx = var2ind(varname)
% IDX = VAR2IND(VARNAME) translates a variable name into a numerical index
myCA = CellularAutomata('data.mat');
variables = get(myCA,'variables');
idx = find(strcmp(variables,varname));
if isempty(idx),
    warning('RomeModel:utils:var2ind','Unknown variables name');
end