function y = marginalCost(x,y0,xm,ym)
% Calcola il Costo Marginale nel modello stock / flow del mercato
% immobiliare. 
%
% La curva del costo marginale è di secondo grado con nessuna
% radice reale, quindi ha equazione y = ax^2 - bx +c. I parametri y0, xm e
% ym servono a calcolare i coefficienti dell'equazione di secondo grado ed
% hanno il seguente significato:
% y0 = y(0)
% (xm,ym) è il minimo della funzione.

if ~isscalar(y0) || ~isscalar(xm) || ~isscalar(ym),
    error('RomeModel:marginalCost','Function parameters are not scalar');
end

if ~isnumeric([y0,xm,ym]) || ~isnumeric(x),
    error('RomeModel:marginalCost','Non numeric input');
end

if (y0<ym) || ~abs(y0 - ym) > eps,
    error('RomeModel:marginalCost','Parameters y0=%.5g and ym=%.5g are wrong',...
        y0,ym);
end

a = (y0 - ym)/xm^2;
b = 2*(y0 - ym)/xm;
c = y0;

y = a*x.^2 - b*x + c;