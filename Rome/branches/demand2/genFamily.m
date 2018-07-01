function varargout = genFamily(aCell,mode)
% Genera i parametri per l'evento di acquisto di una casa/appartamento da
% parte di un nucleo familiare

global param
global myCA
% global DEBUG

myparam = param.scripts.genFamily;

dPOP = round(find(cumsum(myparam.householdPdf) >= rand,1,'first'));

if strcmp(mode,'in'),
	if myCA(aCell).ABN == 0, 
		% codice per tenere traccia degli eventi abortiti
		varargout = {{}};
		return; 
	end
	myCA(aCell).POP = myCA(aCell).POP + dPOP;
	myCA(aCell).ABN = myCA(aCell).ABN - 1;
	myCA(aCell).ABC = myCA(aCell).ABC + 1;
	varargout = {{{'POP',dPOP},{'ABN',-1},{'ABC',1}}};
elseif strcmp(mode,'out'),
	if myCA(aCell).ABC == 0, 
		% codice per tenere traccia degli eventi abortiti
		varargout = {{}};
		return; 
	end
	myCA(aCell).POP = myCA(aCell).POP - dPOP;
	myCA(aCell).ABN = myCA(aCell).ABN + 1;
	myCA(aCell).ABC = myCA(aCell).ABC - 1;
	varargout = {{{'POP',-dPOP},{'ABN',1},{'ABC',-1}}};
else
	error('RomeModel:genFamily','The ''mode'' parameter must be ''in'' or ''out''.');
end
