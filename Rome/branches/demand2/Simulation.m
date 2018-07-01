function Simulation(varargin)
% Simulazione dell'evoluzione del sistema urbano
%
% SIMULATION()
% SIMULATION(LAMBDA)
% SIMULATION(LAMBDA,dLAMBDA)
%  Ordine delle operazioni di cui si occupa questo script:
%	1. setup
%	2. bootstrap del modello (oppure carica un bootstrap precedente)
%	3. evoluzione
%	4. risultati (grafici etc)
%
% NOTA: L'ordine degli assegnamenti del setup è il seguente:
% Per prima cosa vengono eseguiti tutti gli assegnamenti in Setup.m.
% Quindi, se esiste un file param.mat, vengono eseguiti gli assegnamenti, ai
% soli campi della struttura param, dei valori contenuti nella struttura
% customParam del file param.mat; Se sono passati dei parametri questi
% devono avere la forma:
%
% LAMBDA - matrice nRules * 4 si somma all'inizializzazione di
% param.rulesparam(:).LAMBDA
%
% dLAMBDA - vettore nRules*1 con i dati per calcolare la crescita
% lineare delle LAMBDA_A ad ogni iterazione dell'algoritmo di evoluzione
% (anche in questo caso si somma ai valori già dichiarati in Setup)
%
% See also SETUP, BOOTSTRAP, EVOLUTION, STORAGE 
clear myCA param DEBUG simulation store;

global myCA
global param
global DEBUG
global simulation
global store

% now we have a clean workspace!
try
	load('sim.mat','simulation');                   % this file contains useful information
	simulation.simCount = simulation.simCount + 1;  % now we update the counter
catch
	err = lasterror();
	warnMessage = strcat('initializing simulation counter \n',...
		'\tbecause of %s\n\t(it should be MATLAB:load:couldNotReadFile)');
	warning(warnMessage,err.identifier);
    % these are the initialization values for the structure simulation
	simulation = struct();
	simulation.simCount = 1;
	simulation.nAgents = [];
	simulation.nSteps = [];
end

% Greeting
fprintf(1,'%s: Beginning simulation no. %d:\n',datestr(now),...
	simulation.simCount);

% Let's execute the setup of everything. We first execute the setup script,
% then we look for a param.mat file or for input arguments to the function.
% In case we find any of them we first extract customParam from param.mat and 
% overwrite the fields of param whose name is also in customParam. In the
% end we remove the param.mat file, so that those modifications influence
% only one simulation and leave intact the configuration for the subsequents.
% 
% NOTE that this works only for top-level parameters in the param struct,
% e.g. parameters like param.scripts.blah = 1 is not accessible in this way
fprintf(1,'\tperforming setup..');
Setup;
customParamFlag = true;
try 
    load('param.mat','customParam');
catch
    err = lasterror();
    if ~strcmp(err.identifier,'MATLAB:load:couldNotReadFile'),
        warning(err.identifier,err.message);
    end
    customParamFlag = false;
end
% NOTE: unfortunately there is no error check if one puts the wrong type of
% data for a parameters in customParam
if customParamFlag,
    nuNames = fieldnames(customParam);
    for idx = 1:length(nuNames),
        aName = nuNames{idx};
        if isfield(param,aName),
            param.(aName) = customParam.(aName);
        else
            warning('RomeModel:Simulation',...
                sprintf('Parameter %s does not exist.',aName));
        end
    end
    delete param.mat;
end

switch nargin,
    case 0
        LAMBDA = zeros(param.nRules,4);
        dLAMBDA= zeros(param.nRules,1);
    case 1
        LAMBDA = varargin{1};
        dLAMBDA = zeros(param.nRules,1);
    otherwise
        LAMBDA = varargin{1};
        dLAMBDA = varargin{2};
end
if any(size(LAMBDA)~=[param.nRules,4]) || ~isnumeric(LAMBDA),
    error('RomeModel:Simulation','Wrong parameter LAMBDA');
end
if any(size(dLAMBDA)~=[param.nRules,1]) || ~isnumeric(dLAMBDA),
    error('RomeModel:Simulation','Wrong parameter dLAMBDA');
end
for i = 1:param.nRules,
    param.rulesparam(i).LAMBDA = param.rulesparam(i).LAMBDA + LAMBDA(i,:);
    param.rulesparam(i).dLAMBDA = param.rulesparam(i).dLAMBDA + dLAMBDA(i);
end
        
fprintf(1,'done\n');

if DEBUG.DEBUG_ON,
	if ~ischar(DEBUG.DEBUG_FILENAME),
		warning('RomeModel:Simulation','Dumping debug log to default file ''debug.log''');
		DEBUG.DEBUG_FILENAME='debug.log';
	end
	if strcmp(DEBUG.DEBUG_FILENAME,''),
		DEBUG.DEBUG_FD = 2;					% File descriptor 2 is the standard error
	else
		[DEBUG.DEBUG_FD message] = fopen(DEBUG.DEBUG_FILENAME,'w');
		if DEBUG.DEBUG_FD == -1,
			warning(strcat('Setting debug mode to ''false'' because of: ',message));
			DEBUG.DEBUG_ON = false;
		end
	end
end

% let's execute the bootstrap for the populations
fprintf(1,'\tperforming bootstrap..');
Bootstrap;
fprintf(1,'done\n');

% now we can start the real simulation
fprintf(1,'\tnow starting simulation..');
Evolution(false);
fprintf(1,'done\n');

% all done, let's save data for further processing.
fprintf(1,'\tsaving simulation data into storage..');
Storage;
fprintf(1,'done\n');

% say good-bye top user.
fprintf('%s: Simulation no. %d ended, good-bye.\n',datestr(now),...
	simulation.simCount);
save('sim.mat','simulation');

if DEBUG.DEBUG_ON && (DEBUG.DEBUG_FD ~= 2 ), 
	fclose(DEBUG.DEBUG_FD);
end