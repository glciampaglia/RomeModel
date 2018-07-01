function ref = subsref(aCA,S)
% Metodo di referenziamento SUBSREF
%
% 1. Structure field referencing. If POP is member of aCA.VARIABLES then
% aCA.POP returns the colum vector of all values of variable POP on the
% cells of the automata aCA.
%
% 2. Structure field referencing by expression. If EXPRESSION evaluates to
% a member of the cella array aCA.VARIABLES, then aCA.(EXPRESSION) returns
% the colum vector of all values of variable POP on the cells of the
% automata aCA. 
%
% 3. Array referencing. If INDEX is an or an expression that evaluates to
% an index (e.g. END-1), then aCA(INDEX) returns the row vector of values
% of aCA.data whose row index is INDEX (e.g. the data of the INDEX-th cell)
%
% NOTE: Cell Array referencing is not allowed!

%{
TODO LIST
	STICKY: Forse bisogna fare una subfunction con lo switch e rendere 
	ricorsiva la chiamata a subsref (e subsasgn). Sta cagata de Matlab manco
	gestisce sto meccanismo ricorsivamente... oppure sono io che lo devo fare?
%}

newS = struct('type','()','subs',{{':',':'}});
while length(S) > 0,
	switch S(1).type,
		case '()'
			newS.subs{1} = S(1).subs{:};
		case '.'
			%colSubs=strmatch(S(1).subs,aCA.variables,'exact');
			colSubs = aCA.var2subs.(S(1).subs);
			if isempty(colSubs),
				component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
				mnemonic = 'nonExistentField';
				message = 'Reference to non-existent field ''%s''.';
				error(strcat(component,mnemonic),message,S(1).subs);
			end
			newS.subs{2} = colSubs;
		otherwise
	end
	S(1) = [];
end

ref = subsref(aCA.data,newS);