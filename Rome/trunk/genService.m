function varargout = genService(aCell)
% Genera i parametri per l'evento di costruzione di una impresa di servizi

global param
global myCA
% global DEBUG

myparam = param.scripts.genService;

classIdx = round(find(cumsum(myparam.personnelClassesPdf) >= rand,1,'first'));
start = myparam.personnelClasses(2*classIdx-1);
stop = myparam.personnelClasses(2*classIdx);
dCAS = ceil(start + rand*(stop-start));
dTAC = 100 * dCAS;

myCA(aCell).CAS = myCA(aCell).CAS + dCAS;
myCA(aCell).TAC = myCA(aCell).TAC + dTAC;
varargout = {{{'CAS',dCAS},{'TAC',dTAC}}};