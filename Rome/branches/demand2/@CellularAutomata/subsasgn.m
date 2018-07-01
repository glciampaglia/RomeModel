function aCA = subsasgn(aCA,S,rightHandVal)
% Metodo di assegnamento SUBSASGN
%
% 1. Structure field assignment. If POP is member of aCA.VARIABLES then
% aCA.POP = COLUMN_VECTOR assigns the colum vector COLUMN_VECTOR to the
% column of all values of variable POP on the cells of the automata aCA.
%
% 2. Structure field assignment by expression. If EXPRESSION evaluates to
% a member of the cell array aCA.VARIABLES, then aCA.(EXPRESSION) =
% COLUMN_VECTOR returns the colum vector of all values of variable POP on
% the cells of the automata aCA. 
%
% 3. Array assignment. If INDEX is an or an expression that evaluates to
% an index (e.g. "1","END-1"), then aCA(INDEX) = ROW_VECTOR assigns the row
% vector ROW_VECTOR to the row of aCA.data whose row index is INDEX (e.g.
% the data of the INDEX-th cell) 
%
% NOTE: Cell Array assignment, as is referencing, is not allowed!

newS = struct('type','()','subs',{{':',':'}});
while length(S) > 0,
	switch S(1).type,
		case '()'
			newS.subs{1} = S(1).subs{:};
		case '.'
% 			colSubs=strmatch(S(1).subs,aCA.variables,'exact');
			colSubs = aCA.var2subs.(S(1).subs);
			if isempty(colSubs),
				component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
				mnemonic = 'nonExistentField';
				message = 'Reference to non-existent field ''%s''.';
				error(strcat(component,mnemonic),message,S(1).subs);
			end
			newS.subs{2} = colSubs;
		otherwise
			component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
			mnemonic = 'nonStrucReference';
			message = 'Attempt to reference field of non-structure array.';
			error(strcat(component,mnemonic),message);
	end
	S(1) = [];
end

try
	aCA.data = subsasgn(aCA.data,newS,rightHandVal);
catch
	err=lasterror();
	if strcmp(err.identifier,'MATLAB:exceedsdims'),
		component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
		mnemonic = 'exceedsdims';
		message = 'Index exceeds Automaton dimensions.';
		error(strcat(component,mnemonic),message);
	end
	rethrow(err);
end