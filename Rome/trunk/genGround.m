function varargout = genGround(aCell)
% Genera i parametri per l'evento di cambio d'uso d'un lotto di terreno
% vuoto

global param
global myCA
% global DEBUG

myparam = param.scripts.genGround;

lAttr = param.rulesparam(5).lAttr / sum(param.rulesparam(5).lAttr);
smax = lAttr(aCell) * param.GD;

% extract a poisson distributed random number
spikes = randexp(smax,1,ceil(smax));
while sum(spikes) < 1,
	spikes = horzcat(spikes,randexp(smax,1,ceil(smax)));
end
s = find(cumsum(spikes) >= 1,1,'first');

dVUO = s;
dPAG = -s;

if s < myCA(aCell).PAG,
	myCA(aCell).PAG = myCA(aCell).PAG + dPAG;
	myCA(aCell).VUO = myCA(aCell).VUO + dVUO;
	varargout = {{{'PAG',dPAG},{'VUO',dVUO}}};
else
	%codice per tenere traccia degli eventi abortiti
	varargout = {{}};
	return
end