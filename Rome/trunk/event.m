function updateVector = event( theCell, theRule )
% Applica la regola di aggiornamento di un evento

%  Qui estraiamo il vettore di beni \pi_{\alpha} e lo applichiamo alla
%  cella c estratta in poisson.m

global myCA
global param
global DEBUG

if nargin < 2,
	error('RomeModel:event','too few input arguments (%d found, 2 expected)',nargin);
end

switch theRule
	case 1 
		updateVector = genBuilding(theCell);
	case 2
		updateVector = genIperMarket(theCell);
	case 3
		updateVector = genFamily(theCell,'in');
	case 4
		updateVector = genFamily(theCell,'out');
	case 5
		updateVector = genGround(theCell);
	case 6
		updateVector = genCommercial(theCell);
	case 7
		updateVector = genService(theCell);
	otherwise
		error('RomeModel:event','bad rule number %d',theRule);
end