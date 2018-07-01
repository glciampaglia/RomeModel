function property = get(aCA,propertyName);
% metodo di accesso GET della classe CellularAutomata
%
% GET(aCA,'PROPERTY NAME') returns the value of aCA.property
% where the property's name is 'PROPERTY NAME'.
% 
% NOTE: This method should not be used to access to aCA.cell and aCA.data

%{
TODO LIST
%	NOTA NOTA NOTA QUESTA QUI CAMBIA E DIVENTA IL METODO PER 
%	ACCEDERE AGLI ALTRI CAMPI DELL'AUTOMA, VISTO CHE ADESSO HO IL
%	REFERENCING PER ACCEDERE AI DATI DEL MODELLO
%}

if strcmp(propertyName,'data'), %|| strcmp(propertyName,'cells'),
	component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
	mnemonic = 'fieldAccessDenied';
	message = sprintf('Use subscripted referencing to access to this field.');
	error(strcat(component,mnemonic),message);
end
property = aCA.(propertyName);
