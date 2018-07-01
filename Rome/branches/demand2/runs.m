clear all;

ratios = [.075; .025; .2; .2; .1; .2; .2];
LAMBDA = zeros(7,4);
for totL = linspace(0.1,10,10),
    LAMBDA(:,1) = totL * ratios;
    for k = 1:10,
        Simulation(LAMBDA);
    end
end

	