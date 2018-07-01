function pHS = updateMarket()
% Modello del mercato immobiliare
%
% Questa funziona ritorna il numero di nuove abitazioni costruibili con
% profitto da agenti costruttori e costruttori/possessori di abitazioni
% residenziali 
%
% See also MARGINALCOST, DEMAND

global param;
global myCA;
 
myparam = param.scripts.updateMarket;
HS = sum(myCA.ABC)+ myparam.stockInc*sum(myCA.ABN);
% Se il prezzo di mercato esce da un intervallo di più o meno una soglia
% percentuale rispetto al prezzo di equilibrio, il modello deve essere
% ricalibrato. Il nuovo prezzo di equilibrio viene preso come quello
% corrente, e vengono ricalibrati i parametri della curva del costo
% marginale in modo tale che il numero medio eqQuant di case costruite coincida con
% il profitto "ottimale" all'equilibrio. Notare che xm = 1 eq eqQuant non
% cambia, quindi la curva diventa più o meno ripida ma non degenera mai in
% una singolarità (si spera...)
recalFlag = false;
while ~recalFlag,
    eqPrice = demand(HS,myparam.demandLvl*myparam.eqPrice);
    thresh = eqPrice / myparam.eqPrice;
    if abs(thresh-1) >= myparam.priceThresh,
        warning('RomeModel:updateMarket',...
            'Equilibrium price out of threshold: recalibratring the model');
        myparam.eqPrice = eqPrice;
        b = myparam.eqQuant^2 - 2*myparam.eqQuant;
        myparam.y0 = myparam.eqPrice*((1-myparam.priceThresh)*b+1)/(b+1);
    else
        recalFlag = true;
    end
end
   
% Trovo l'intercetta con fzero risolvendo il sistema attorno ad xm+1,
% questo mi assicura soluzioni positive. Se non converge o trova NaN, setto
% HS a 0, ma questo non dovrebbe proprio succedere. La simulazione potrebbe
% non avere senso.
revFunc = @(x) marginalCost(x,myparam.y0,myparam.xm,myparam.ym) - eqPrice;
options.FunValCheck = 'on';
options.Display = 'off';
[pHS, fval, flags] = fzero(revFunc,myparam.xm+1,options);
if flags ~= 1,
    warning('RomeModel:updateMarket','Unable to converge to a solution. Return 0');
    pHS = 0;
end