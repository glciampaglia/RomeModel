function indiceFinale = end(aCA,posizioneIndice,totaleIndici);
% metodo di indicizzamento veloce END 
% 
% aCA(i:end) ritorna tutte le righe di aCA.data dall i-esima all'ultima

if posizioneIndice > 1,
	component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
	mnemonic = 'exceedsdims';
	message = sprintf('Index exceeds Automaton dimensions.');
	error(strcat(component,mnemonic),message);
end

indiceFinale = size(aCA.data,1);
