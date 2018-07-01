function R = demand(x,a,b,n)
% Calcola la Domanda nel modello stock/flow del mercato immobiliare.
% 
% R = DEMAND(x,a,b,n) dove:
% R è il prezzo di equilibrio per il mercato immobiliare in 
%   corrispondenza del livello di stock x.
% b > 0		Massimo valore per il prezzo di equilibrio. Determina il
%			livello della domanda.
% a <= b	t.c. (b/a) > 0 fissato indica il massimo valore di stock per il
%			mercato.
% n pari	Pendenza della curva.

errText = 'Param name: %s, Param value: %d, Reason: %s';
errName = 'BadParameterError';
compName = 'RomeModel:demand:';

if gcd(2,n) ~= 2,
	error(strcat(compName,errName),errText,'n',n,'not even');
end

if a > b,
	error(strcat(compName,errName),errText,'a',a,'a is not less than b');
end

if b <= 0,
	error(strcat(compName,errName),errText,'b',b,'b is not positive and non null');
end

R = (b - a*x).^n;
	