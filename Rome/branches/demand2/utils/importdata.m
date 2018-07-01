function importdata(workpath,filename)
% Importa i dati della città dal file EXCEL

startTime = datenum('01/01/1991');
cityName = 'Roma';
data = xlsread(filename,1,'C2:Y42');
[dummy variables] = xlsread(filename,1,'C2:Y2');
variables = transpose(variables);
[dummy cellNames] = xlsread(filename,1,'A3:A42');
[dummy cellIDs] = xlsread(filename,1,'B3:B42');
adjMatrix = logical(xlsread(filename,2,'B2:AO41'));
dinamicVariables = transpose(logical(xlsread(filename,3,'B2:X2')));
exogenVariables = transpose(logical(xlsread(filename,3,'B3:X3')));
polylines = xlsread(filename,4,'A3:CB152');
centroids = xlsread(filename,5,'C3:D42');
filter = ~isnan(polylines);
cellPoly = cell(40,2);
for i=1:40,
	poly = polylines(:,2*i-1:2*i);
	iFilt = filter(:,2*i-1:2*i);
	cellPoly{i,1} = poly(iFilt);
	cellPoly{i,1} = reshape(cellPoly{i},[length(cellPoly{i})/2,2]);
%	cellPoly{i,1}(end+1,:)= cellPoly{i}(1,:); questo serve solo per fare le
%	visualizzazioni delle celle
	cellPoly{i,2} = centroids(i,:);
end
scale = xlsread(filename,5,'E2');

cd(workpath);
save data.mat startTime cityName data variables cellNames cellIDs cellPoly adjMatrix dinamicVariables exogenVariables scale;
