function aCA = set(aCA,propertyName,newValue);
% metodo di accesso SET della classe CellularAutomata
%
% SET(aCA,'PROPERTY NAME',value) sets the value of aCA.property to value,
% where the property's name is 'PROPERTY NAME'.
% 
% NOTE: This method should not be used to access to aCA.cell and aCA.data


if strcmp(propertyName,'data') || strcmp(propertyName,'cells'),
	component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
	mnemonic = 'fieldAccessDenied';
	message = sprintf('Use subscripted referencing to access to this field.');
	error(strcat(component,mnemonic),message);
end
aCA.(propertyName) = newValue;
