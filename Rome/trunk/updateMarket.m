function HS_0 = updateMarket(SH)
% Modello del mercato immobiliare
%
% Questa funziona ritorna il numero di nuove abitazioni costruibili con
% profitto da agenti costruttori e costruttori/possessori di abitazioni
% residenziali 
%
% See also MARGINALCOST, DEMAND

global param
global DEBUG
 
myparam = param.scripts.updateMarket;

if SH > myparam.maxStock,
	warning('RomeModel:updateMarket','Current stock exceeds maximumStock');
	% the next line is experimental!
	myparam.maxStock = SH;
end
b = nthroot(myparam.demandLvl,myparam.n);
a = b / myparam.maxStock;
R_0 = demand(SH,a,b,myparam.n);	
CC = marginalCost(myparam.xi,myparam.yi,3);		
CC(end) = CC(end) - R_0;
solCC = roots(CC);

if isreal(solCC),
	switch length(find(solCC > 0))
		case 0, error('RomeModel:updateMarket',...
                'bad cost function for housing starts!');
		case 1, HS_0 = solCC(solCC > 0);
		case 2, HS_0 = solCC(ceil(2*rand(1))); 
		otherwise,	error('RomeModel:updateMarket',...
                'unexpected situation finding housing starts!');
	end
else 
	if DEBUG.DEBUG_ON,
		fprintf(DEBUG.DEBUG_FD,...
            '\tThere are no real solutions for housing starts! (HS_0 = 0)\n');
	end
	HS_0 = 0;
end
% end of function