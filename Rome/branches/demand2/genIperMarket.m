function varargout = genIperMarket(aCell)
% Genera i parametri per l'evento di costruzione di un centro commerciale 
% di livello urbano

global param
global myCA
% global DEBUG

myparam = param.scripts.genIperMarket;
SUL = 0;
while SUL <= 0,
	SUL = round(randn*myparam.surfStd + myparam.surfMean);
end
floors = ceil(rand*myparam.floorMax);

dSUR = round(SUL/floors);
dSLO = round(SUL * myparam.sulSloRatio);
dVUO = -(dSUR+dSLO);
dCOM = round(randn * myparam.personnelStd + myparam.personnelMean);
dTAC = dCOM * myparam.roomVol;

if (dSUR + dSLO < myCA(aCell).VUO),
	myCA(aCell).SUR = myCA(aCell).SUR + dSUR;
	myCA(aCell).SLO = myCA(aCell).SUR + dSLO;
	myCA(aCell).COM = myCA(aCell).SUR + dCOM;
	myCA(aCell).VUO = myCA(aCell).SUR + dVUO;
	myCA(aCell).TAC = myCA(aCell).SUR + dTAC;
	varargout = {{{'SUR',dSUR},{'VUO',dVUO},{'COM',dCOM},{'SLO',dSLO},...
		{'TAC',dTAC}}};
else
	% codice per tenere traccia degli eventi abortiti
	varargout = {{}};
	myparam.groundRequests = horzcat(myparam.groundRequests,dSUR + dSLO);
	return;
end
