path = '../../../data/1y-10';
totL = linspace(0.1,10,10);
for i = 1:10,
    fprintf(1,'Regression with totL = %0.2g\n',totL(i));
    reg = regression_analysis(path,10,i,'RES',[200 1 1]);
    fprintf(1,'\n');
end