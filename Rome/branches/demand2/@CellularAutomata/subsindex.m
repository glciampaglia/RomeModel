function d = subsindex(aCA);

component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
mnemonic = 'invalidIndex';
message = sprintf('Can''t use objects of class CellularAutomata as indices!');
error(strcat(component,mnemonic),message);