function cellularGrid(data,nRows,nCols,varargin)										
% Questa funzione disegna tante volte il reticolo cellulare della zona
% urbana assegnando ad ogni cella un colore corrispondente al valore di
% quella cella nella i-esima colonna della matrice data. Il numero di assi
% disegnato è pari al numero di colonne della matrice di dati.
% I colori sono mappati all'intervallo di valori compreso tra il massimo ed
% il minimo della matrice, come nella funzione pcolors
% 
%
subtitle = '';
if nargin > 3,
	subtitle = varargin{1};
end

%nRows*nCols>=nAxes perlomeno
[nCells nAxes] = size(data);
load('poly.mat','polyLines');

% this plots data as patches
pdata = cell(3*nCells,1);
for anAxis = 1:nAxes,
	for aCell = 1:nCells,
		pdata{3*aCell-2} = polyLines{aCell}(:,1);
		pdata{3*aCell-1} = polyLines{aCell}(:,2);
 		pdata{3*aCell} = data(aCell,anAxis);
	end
	if nRows*nCols > 1,
		subplot(nRows,nCols,anAxis);
	end
	fill(pdata{:});
	h=title(sprintf(subtitle,anAxis));
	if ~isempty(strfind(subtitle,'$$')),
		set(h,'interpreter','latex');	
	else
		set(h,'interpreter','none');
	end
	colorbar
 	axis image
	v = num2cell(axis());
	[xmin, xmax, ymin, ymax] = deal(v{:});
	xadj = (xmax - xmin)/20;
	yadj = (ymax - ymin)/20;
  	axis([xmin-xadj, xmax+xadj, ymin-yadj, ymax+yadj]);
	set(gca,'XTickLabel',[],'YTickLabel',[]);
end
