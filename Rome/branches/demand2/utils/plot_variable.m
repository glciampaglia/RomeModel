function varargout = plot_variable(path,varname,nruns,varargin)
% PLOT_VARIABLE(PATH,VARNAME,NRUNS)
% PLOT_VARIABLE(PATH,VARNAME,NRUNS,DATAMODE)
% PLOT_VARIABLE(PATH,VARNAME,NRUNS,DATAMODE,PLOTMODE)
% X = PLOT_VARIABLE(PATH,VARNAME,NRUNS,DATAMODE,PLOTMODE,SELECT) 
% [X E] = PLOT_VARIABLE(PATH,VARNAME,NRUNS,DATAMODE,PLOTMODE,SELECT)
%
% COSA DISEGNA:
% Questa funzione prende un PATH in cui si trovano un certo numero di
% simulazioni, divise in blocchi di run a parametri identici, ciascun
% blocco contenente NRUNS, e plotta la dinamica della media di una
% variabile specificata col suo codice VARNAME. È possibile specificare
% VARNAME con la forma 'A+B', in tal caso il grafico risultante sarà la
% somma dei valori di A e B. 
%
% COME LO DISEGNA:
% Se il parametro DATAMODE 
% viene specificato pari a 'sum', la dinamica graficata è della somma della
% variabile su tutto il sistema (e.g. la variabile a livello globale)
% PLOTMODE può essere sia 'subplot' che 'plot'.  
%
% COSA RITORNA:
% Se uno o due output sono specificati, la funzione esegue il plot e
% ritorna X, la dinamica graficata, ed E, la deviazione standard media
% (gosh!), per il blocco di simulazioni denotato da SELECT. Se SELECT non è
% specificato, lo si prende uguale all'indice dell'ultimo gruppo di
% simulazioni.
%
% See also LOAD_DATA, MEAN_DYNAMICS

clear store;
[curVar rest] = strtok(varname,'+');
idx = var2ind(curVar);
vars = {curVar};
while ~isempty(rest),
    varname = rest;
    [curVar rest] = strtok(varname,'+');
    idx = [idx, var2ind(curVar)];
    vars{end+1} = curVar;
end
if isempty(idx),
    return;
end

stores = load_data(path);
nSims = length(stores);
nBatches = floor(nSims/nruns);
totL = linspace(0.1,10,nBatches);
select = nBatches;
switch nargin,
    case {1,2,3}
        plotmode = 'subplot';
        datamode = 'avg';
    case 4
        datamode = varargin{1};
        plotmode = 'subplot';
    case 5
        datamode = varargin{1};
        plotmode = varargin{2};
    otherwise
        datamode = varargin{1};
        plotmode = varargin{2};
        select = varargin{3};
end
figure;
markers = {'.','o','x','+','*','s','d','v','^','<','>','p','h'};
colors = {'b','g','r','c','m','y','k'};
lines ={'-',':','-.','--'};
arg = cell(3*nBatches,1);
leg_arg = cell(nBatches,1);
for k = 1:nBatches;
    X = [];
    E = [];
    for i = idx,
        if k<nBatches,
            [tmpX tmpE] = mean_dynamics(stores,(k-1)*nruns+1:k*nruns,i);
        else
            [tmpX tmpE] = mean_dynamics(stores,(k-1)*nruns+1:nSims,i);
        end
        X = cat(3,X,tmpX);
        E = cat(3,E, tmpE);
    end
    X = squeeze(sum(X,3));
    E = squeeze(sum(E,3));
    what = '';
    if strcmp(datamode,'avg'),
        plotX = mean(X,2);
        plotE = mean(E,2);
        what = sprintf('Average v_{%s}(t)',vars{1});
    else
        plotX = sum(X,2);
        plotE = sum(X,2);
        what = sprintf('Total v_{%s}(t)',vars{1});
    end
    for i = 2:length(vars),
        what = sprintf('%s + v_{%s}(t)',what,vars{i});
    end
    if strcmp(plotmode,'subplot'),
        subplot(4,3,k);
        plot(plotX);
        title(sprintf('\\Lambda_A=%g',totL(k)),'Interpreter','tex');
        xlabel('Time (\Delta t)','Interpreter','tex');
        ylabel(what,'Interpreter','tex');
    else
        mk = mod(k,length(markers))+1;
        ck = mod(k,length(colors))+1;
        lk = mod(k,length(lines))+1;
        arg{3*k-2} = [1:length(plotX)]';
        arg{3*k-1} = plotX;
        arg{3*k} = sprintf('%s%s%s',colors{ck},markers{mk},lines{lk});
        leg_arg{k} = sprintf('\\Lambda_A=%0.5g',totL(k));
    end
    if k == select,
        retX = plotX;
        retE = plotE;
    end
end
if ~strcmp(plotmode,'subplot'),
    plot(arg{:});
    legend(leg_arg{:},'Location','Best');
    xlabel('Time (\Delta t)','Interpreter','tex');
    ylabel(sprintf(what,varname),'Interpreter','tex');
end
switch nargout,
    case 0
    case 1
        varargout = {retX};
    otherwise
        varargout = {retX retE};
end