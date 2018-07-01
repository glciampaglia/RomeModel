function varargout = genCommercial(aCell)
% Genera i parametri per l'evento di creazione di una attività commerciale
% di livello locale

global param
global myCA
% global DEBUG

myparam = param.scripts.genCommercial;

classIdx = round(find(cumsum(myparam.personnelClassesPdf) >= rand,1,'first'));
start = myparam.personnelClasses(2*classIdx-1);
stop = myparam.personnelClasses(2*classIdx);
dCOM = ceil(start + rand*(stop-start));
dTAC = 100 * dCOM;

myCA(aCell).COM = myCA(aCell).COM + dCOM;
myCA(aCell).TAC = myCA(aCell).TAC + dTAC;
varargout = {{{'COM',dCOM},{'TAC',dTAC}}};
