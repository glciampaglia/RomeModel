clear all;

ratios = [.075; .025; .2; .2; .1; .2; .2]; 
LAMBDA = zeros(7,4);
% Per ogni valore di L tra 0 e 2 esegue 10 simulazioni
for totL = [1,5,10];
    LAMBDA(:,1) = totL * ratios;
    Simulation(LAMBDA);
end

	