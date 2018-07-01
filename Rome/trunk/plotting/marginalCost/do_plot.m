% Disegna il grafico delle funzioni del costo marginale e della domanda.

xmin = 0;
xmax = 5;
ymin = 0;
ymax = 3;
x = xmin:xmax;
y = [ymin 0.5 0.6 0.9 1.5 ymax]; 
p = polyfit(x,y,3);

dp = marginalCost(x,y,3);

xi = linspace(x(1),x(end));
yi = polyval(p,xi);
dyi = polyval(dp,xi);
plot(x,y,'o',xi,yi,xi,dyi);
axis([x(1) x(end) y(1) y(end)]);
legend('Datapoints','total cost','marginal cost','Location', 'NorthWest');