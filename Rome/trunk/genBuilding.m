function varargout = genBuilding(aCell)
% Genera i parametri per l'evento di costruzione di un edificio
% residenziale

global param
% global DEBUG
global myCA

myparam = param.scripts.genBuilding;

% NOTA:
lAttr = param.rulesparam(1).lAttr / sum(param.rulesparam(1).lAttr);
nmax = lAttr(aCell) * param.HS_0;

% extract a poisson distributed random number
spikes = randexp(nmax,1,ceil(nmax));
while sum(spikes) < 1,
	spikes = horzcat(spikes,randexp(nmax,1,ceil(nmax)));
end
n = find(cumsum(spikes) >= 1,1,'first');

% extract other values
p = find(cumsum(myparam.floorsPdf) >= rand(1),1,'first');	% numero di piani
fact = (2*p) / ((p+2) * myparam.sup);

dABN = n;
dRES = (n * myparam.sup)/p;
dSLO = (n * myparam.sup)/2;
dVUO = - (n/fact);

if n <= fact * myCA.VUO(aCell),
	myCA(aCell).ABN = myCA(aCell).ABN + dABN;
	myCA(aCell).VUO = myCA(aCell).VUO + dVUO;
	myCA(aCell).RES = myCA(aCell).RES + dRES;
	myCA(aCell).SLO = myCA(aCell).SLO + dSLO;
	varargout = {{{'ABN',dABN},{'VUO',dVUO},{'RES',dRES},{'SLO',dSLO}}};
else
	% codice per tenere traccia degli eventi abortiti
	varargout = {{}};
	myparam.groundRequests = [myparam.groundRequests,dRES + dSLO];
	return;
end




