function y = demand(x,a)
% Curva della domanda del modello stock / flow
%
% il parametro a è definito come a = SH0 * R0, dove SH0 è il livello di
% stock corrente ed R0 è il prezzo di equilibrio. A loro volta, questi
% parametri sono aggiornati all'interno di updateMarket. In particolare SH0
% è uguale alle abitazioni non occupate più una percentuale delle
% abitazioni occupate (il cosiddetto patrimonio residenziale o abitativo).

if x <= 0,
    error('RomeModel:demand','non positive parameter x=%0.5g',x);
end

if ~isnumeric(x) || ~isnumeric(a),
    error('RomeModel:demand','non numeric input');
end

if ~isscalar(a),
    error('RomeModel:demand','parameter a is not a scalar');
end

y = a ./ x;
	