clear all
close all

epsValues = 0:.1:1;
n = 10;
[muG sdG muF sdF] = test_classification(epsValues,1,n);

plot_classification_test(muG,sdG,epsValues,n,'G');
figure;
plot_classification_test(muF,sdF,epsValues,n,'F');