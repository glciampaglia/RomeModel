function ccm = marginalCost(x,y,n)
% Calcola il Costo Marginale nel modello stock / flow del mercato
% immobiliare
%
% Questa funzione ritorna la funzione del costo di costruzione marginale 
% sotto forma di derivata prima del polinomio interpolante i punti di controllo (xi,yi).
% Le ascisse dei punti di controllo vengono passate nel vettore x, le
% ordinate nel vettore y e nello scalare n viene passato il grado del
% polinomio.
%
% I punti (xi,yi) sono parametri del modello da calibrare manualmente
% oppure mediante dati statistici sul costo di costruzione totale in
% funzione del numero di prodotti da costruire (e.g. costi di costruzioni
% edili in funzione del numero di abitazioni da costruire)

errText = 'Param name: %s, Param value: %d, Reason: %s';
errName = 'BadParameterError';
compName = 'RomeModel:marginalCost:';

if n >= length(x),
	error(strcat(compName,errName),errText,'n',n,...
		'polynomial grade is not less than the number of points');
end

p = polyfit(x,y,n);
dp = polyder(p);
ccm = dp;
