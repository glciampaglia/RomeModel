function pop = population(X)
% POP = POPULATION(X)
% 
% Questa funzione calcola la popolazione residente da una matrice di dati X. �
% essenzialmente un wrapper di sum(X(:,1)). Se X � una matrice cubica, POP
% � un vettore colonna.

if ndims(X) > 2,
    pop = squeeze(sum(X(:,1,:),1));
else
    pop = sum(X(:,1));
end