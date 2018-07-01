function [varargout] = poisson(tDelta,rDecCompound,handler,varargin)
% Simulazione del processo urbano di aggiornamento dell'automa
%
% varargin contiene i parametri per comandare la registrazione del processo
% di decisione degli agenti. Può essere:
% 1. Un cell array of string ad nRules componenti, in cui ciascuna
% componente è una stringa contenente i codici dei tipi di decisione che si
% intende loggare. Per quella classe di eventi Ad es.
% { 'ALDU', 'A', '', '', 'U', 'A', 'L'}
% Vuol dire che per la prima classe di eventi bisogna registrare tutte le
% attività degli agenti (Attivazione, Leaving, Diffusione, Decisione), per
% la seconda classe di eventi solo l'attivazione, per la terza classe
% nessuna attività e via dicendo.
%
% 2. La stringa 'all' (case sensitive) Equivale al cell array in cui
% ciascuna componente è pari alla stringa 'ALDU'
%
% 3. La stringa 'none' (case sensitive) Equivale al cell array in cui
% ciascuna componente è pari alla stringa ''
%
% Altri input oltre al primo vengono ignorati

% ATTENZIONE LE RESHAPE SONO INFINGARDE!!!!!

%global myCA
global param
%global DEBUG

% initialize everything

% convertiamo gli input ad un formato unificato
flags = false(param.nRules,param.nDecs);
if nargin > 3,
	if iscell(varargin{1}),
		inputFlags = varargin{1};
		sanity = (length(inputFlags) == 7) & iscellstr(inputFlags);
		if ~sanity,	error('RomeModel:poisson','bad flag parameters'); end
		for aRule = 1:param.nRules,
			tmpStr = inputFlags{aRule};
			for aDec = 1:min(param.nDecs,length(tmpStr)), %up to 4 chars
				idx = find([param.decisions{:}] == tmpStr(aDec));
				if ~isempty(idx), flags(aRule,idx)=true; end
			end
		end
	elseif ischar(varargin{1}),
		if strcmp(varargin{1},'all'),
			flags = true(param.nRules,param.nDecs);
		elseif strcmp(varargin{1},'none'),
			flags = false(param.nRules,param.nDecs);
		end
	end
% scartiamo tutto il resto che ci viene passato in input
end

register = struct();
regFlag = any(any(flags));
if regFlag,
	% Structure of the 'register' struct.
	% register.times is a cell array with each cell holding times and subs
	% (in a cell array to reference the register.events struct; for
	% example: 
	% register.times = [{ [{1},{ {1,'A',1} }] },{ [{2},{ {2,'A',1} } ]  }]
	% is made by two 2x1 cells; register.times{1}, 
	% e.g. ans = { [{1},{ {1,'A',1} }] }, records data for is the first
	% event and is 2x1 cell where 
	%  - the first cell, e.g. {1}, is the time at which a poisson event was
	% drawn. 
	%  - the second cell, e.g. {1,'A',1} is a 3x1 cell array with
	%  subscripts that can be used to reference the actual event in the
	%  structure register.events, where,
	%    - the first component, e.g. 1, is the subscript in the struct
	%    array to address the actual population of agents. It returns
	%    references to a struct.
	%	 - the second component, e.g. 'A' is string that can be used to
	%	 dinamically reference the field for the decision type (see
	%	 param.decisions). It references to an array.
	%	 - the third component, e.g. 1, is the index that can be used
	%	 to reference the component that holds the data about that poisson
	%	 event. It contains parameters (e.g. if the field is 'A' we may
	%	 record the activation cell for the agent that decided to activate
	%	 according to the poisson process, if the field is 'U' we can
	%	 record the array with goods and resources used to update the CA,
	%	 and so on) 
	%
	% Thus we can scan a process globally using register.times or we can scan an
	% actual subprocess like the activation process for agents in the
	% population number 1, and so on. 
	register.times = []; 
	tmpStruct = {};
	for aDec = 1:param.nDecs,
		tmpStruct = [tmpStruct, {param.decisions{aDec},[]}];
	end
	register.events = struct(tmpStruct{:});
	for aRule = 2:param.nRules,
		register.events = [register.events, struct(tmpStruct{:})];
	end
end

% Mi serve per decidere quando uscire dal ciclo interno di generazione
% degli eventi 
outOfIntervalFlag = false;             
										
tCurrent = 0;
[nRules nCells nDecs] = size(rDecCompound);
rDecTotal = zeros([nRules nCells nDecs]);
rDecTotal(:,:,1) = diag([param.rulesparam.passive]) * rDecCompound(:,:,1);
for iDec = 2:nDecs
	rDecTotal(:,:,iDec) = vertcat(param.rulesparam.active) .* ...
		rDecCompound(:,:,iDec);
end
rGlobal = sum(sum(sum(rDecTotal,1),2),3);

% DA TOGLIERE
% creazione degli array di salvataggio dei valori da plottare
% if nargout > 0,
% 	meanLen = round(rGlobal*tDelta);
% 	sizeSave = [meanLen param.nRules];
% 	indexSave = 0;
% 	
% 	tArray = zeros([meanLen 1],'single');
% 	
% 	if saveRateFlag,
% 		rateArray = zeros(sizeSave,'uint32');
% 	end
% 
% 	if saveActiveFlag,
% 		nActiveArray = zeros(sizeSave,'uint32');
% 	end
% end

while ( ~ outOfIntervalFlag ) ,
	tSalto = randexp(rGlobal);
	% L'intervallo entro cui simuliamo il processo e' aperto a destra.
	if ( tSalto < tDelta - tCurrent),   
		tCurrent = tCurrent + tSalto;
		% find(fdr >= rand(1),1,'first') mi fa da generatore a
		% partire da una f.d.r. di una qualsiasi distribuzione
		
		% estraggo la cella
		pdfCells = sum(sum(rDecTotal(:,:,:),1),3)/rGlobal;
		%the cdf is the cumulative sum of the pdf
		theCell = find(cumsum(pdfCells) >= rand(1),1,'first');	

		% estraggo il tipo di decisione
		pdfDecs =  sum(rDecTotal(:,theCell,:),1)/...
			(pdfCells(theCell)*rGlobal);
		pdfDecs = reshape(pdfDecs, [1 nDecs]);
		%the cdf is the cumulative sum of the pdf
		theDecision = find(cumsum(pdfDecs) >= rand(1),1,'first');	

		% estraggo la classe di eventi
		pdfRules = rDecTotal(:,theCell,theDecision)/...
			(pdfDecs(theDecision)*pdfCells(theCell)*rGlobal);
		pdfRules = reshape(pdfRules, [1 nRules]);
		%the cdf is the cumulative sum of the pdf
		theRule = find(cumsum(pdfRules) >= rand(1),1,'first');	

		switch char(param.decisions(theDecision));
			case 'A'
				if (param.rulesparam(theRule).passive <= 0), 
					warning('RomeModel:poisson','illegal op.!'); 
				end
				param.rulesparam(theRule).passive = ...
					param.rulesparam(theRule).passive - 1;
				param.rulesparam(theRule).active(theCell) = ...
					param.rulesparam(theRule).active(theCell) + 1;
				rDecTotal(theRule,:,theDecision) = ...
					rDecTotal(theRule,:,theDecision) - ...
					rDecCompound(theRule,:,theDecision);
				rDecTotal(theRule,theCell,2:nDecs) = rDecTotal(theRule,...
					theCell,2:nDecs) + rDecCompound(theRule,theCell,...
					2:nDecs);
				rGlobal = sum(sum(sum(rDecTotal)));
% 				rGlobal = rGlobal - sum(rDecCompound(theRule,:,...
% 					theDecision)) + sum(rDecCompound(theRule,theCell,...
% 					2:nDecs));
				% for Activation, we just record the activation cell
				if flags(theRule,theDecision),
					register.events(theRule).A = ...
						[register.events(theRule).A,{uint32(theCell)}];
					register.times = [ register.times, {[{tCurrent}, ...
						{{uint8(theRule),'A',uint32(length(...
						register.events(theRule).A))}}]} ]; 
				end
			case 'L'
				if (param.rulesparam(theRule).active(theCell) <= 0), ...
						warning('RomeModel:poisson','illegal op.!'); 
				end
				param.rulesparam(theRule).passive = ...
					param.rulesparam(theRule).passive + 1;
				param.rulesparam(theRule).active(theCell) = ...
					param.rulesparam(theRule).active(theCell) - 1;
				rDecTotal(theRule,theCell,2:nDecs) = rDecTotal(theRule,...
					theCell,2:nDecs) - rDecCompound(theRule,theCell,...
					2:nDecs);
				rDecTotal(theRule,:,1) = rDecTotal(theRule,:,1) + ...
					rDecCompound(theRule,:,1);
				rGlobal = sum(sum(sum(rDecTotal)));
% 				rGlobal = rGlobal + sum(rDecCompound(theRule,:,1)) - ...
% 					sum(rDecCompound(theRule,theCell,2:nDecs));
				% for Leaving, we just record the leaving cell
				if flags(theRule,theDecision),
					register.events(theRule).L = ...
						[register.events(theRule).L,{uint32(theCell)}];
					register.times = [ register.times, {[{tCurrent},...
						{{uint8(theRule),'L',uint32(length(...
						register.events(theRule).L))}}]} ];
				end
			case 'D'
				if (param.rulesparam(theRule).active(theCell) <= 0), 
					warning('RomeModel:poisson','illegal op.!'); 
				end
				anotherCell = find(cumsum(param.gAttr(theRule,:),2) >= ...
					rand(1),1,'first');
				param.rulesparam(theRule).active(theCell) = ...
					param.rulesparam(theRule).active(theCell) - 1;
				param.rulesparam(theRule).active(anotherCell) = ...
					param.rulesparam(theRule).active(anotherCell) + 1;
				rDecTotal(theRule,theCell,2:nDecs) = rDecTotal(theRule,...
					theCell,2:nDecs) - rDecCompound(theRule,theCell,...
				2:nDecs);
				rDecTotal(theRule,anotherCell,2:nDecs) = ...
					rDecTotal(theRule,anotherCell,2:nDecs) + ...
					rDecCompound(theRule,anotherCell,2:nDecs);
				rGlobal = sum(sum(sum(rDecTotal)));
% 				rGlobal = rGlobal - sum(rDecCompound(theRule,theCell,...
% 					2:nDecs)) + sum(rDecCompound(theRule,anotherCell,...
% 					2:nDecs));
				% for Diffusion, we record both cells
				if flags(theRule,theDecision),
					register.events(theRule).D = ...
						[register.events(theRule).D,{{uint32(theCell),...
						uint32(anotherCell)}}];
					register.times = [ register.times, {[{tCurrent},...
						{{uint8(theRule),'D',uint32(length(...
						register.events(theRule).D))}}]} ]; 
				end
			case 'U'
				if (param.rulesparam(theRule).active(theCell) <= 0), 
					warning('RomeModel:poisson','illegal op.!'); 
				end		
				updateVector = handler(theCell,theRule);
				param.rulesparam(theRule).passive = ...
					param.rulesparam(theRule).passive + 1;
				param.rulesparam(theRule).active(theCell) = ...
					param.rulesparam(theRule).active(theCell) - 1;
				rDecTotal(theRule,theCell,2:nDecs) = rDecTotal(theRule,...
					theCell,2:nDecs) - rDecCompound(theRule,theCell,...
				2:nDecs);
				rDecTotal(theRule,:,1) = rDecTotal(theRule,:,1) + ...
					rDecCompound(theRule,:,1);
				rGlobal = sum(sum(sum(rDecTotal)));
% 				rGlobal = rGlobal + sum(rDecCompound(theRule,:,1)) - ...
% 					sum(rDecCompound(theRule,theCell,2:nDecs));
				% For update, we record also the update vector returned 
				if flags(theRule,theDecision),
					register.events(theRule).U = ...
						[register.events(theRule).U,{{uint32(theCell),...
						updateVector}}];
					register.times = [ register.times, {[{tCurrent},...
						{{uint8(theRule),'U',uint32(length(...
						register.events(theRule).U))}}]}];
				end		
			otherwise
				error('RomeModel:poisson','what the fuck (%g,%g,%g)?\n,',...
					theRule,theCell,theDecision);
		end
	else
		outOfIntervalFlag = true;
	end
	
% Posso riciclare questo codice nel caso in cui le istruzioni di
% registrazione del processo di poisson introducano troppo hoverhead (e.g.
% le concatenazioni prendano troppo tempo self-time come risultato del
% profiling del codice)
%
%if nargout > 0,
% 		indexSave = indexSave + 1;
% 		
% 		if indexSave > length(tArray),
% 			tArray = vertcat(tArray,zeros([meanLen 1],'single'));
% 		end
% 		tArray(indexSave) = tCurrent;
% 		
% 		if saveRateFlag,
% 			if indexSave > length(rateArray), rateArray = ...
% 					vertcat(rateArray,zeros(sizeSave,'uint32'));
% 			end
% 			rateArray(indexSave,:) = sum(sum(rDecTotal,2),3);
% 		end
% 		if saveActiveFlag,
% 			if indexSave > length(nActiveArray), nActiveArray = ...
% 			vertcat(nActiveArray,zeros(sizeSave,'uint32'));
% 			end
% 			for aRule=1:param.nRules, nActiveArray(indexSave,aRule) = ...
% 					sum(param.rulesparam(aRule).active);
% 			end
% 		end
% 	end
end

% Questo codice serve solo se utilizzo il trucco nel codice commentato in
% precedenza, quindi così com'è adesso non serve.
%
%if nargout > 0,
% 	tArray(indexSave+1:end) = [];
% 	if saveRateFlag, rateArray(indexSave+1:end,:) = [];	end
% 	if saveActiveFlag, nActiveArray(indexSave+1:end,:) = []; end
% end

switch nargout
	case 0
		varargout = {};
	case 1
		varargout = {register};
	otherwise
		error('RomeModel:poisson',...
			'Too much output arguments! (%d, max is 1)',nargout);
end

% questo codice potrebbe essere cancellato
% 
%% subfunction
% if DEBUG.DEBUG_ON,
% 	if ~(rGlobal == sum(sum(sum(rDecTotal)))),
% 		rGlobal
% 		sum(sum(sum(rGlobal)))
% 		warn = sprintf('Discrepancy after (%d - %d - %d)-event:',theRule,theCell,theDecision);
% 		warn = strcat(warn,sprintf('rGlobal is %d sum(sum(sum(rDecTotal))) is %d!\n',rGlobal,sum(sum(sum(rDecTotal)))));
% 		warning(warn);
% 	end
% end
