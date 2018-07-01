function active = reg2active(register,base)
% Questa funzione estrae l'array con il numero di agenti attivi, per
% ciascuna popolazione, dalla struttura register, la quale  memorizza il
% processo di Poisson composto. 


active = [];
for aTimeRec = register.times,
	theRule = cell2mat(aTimeRec{1}{2}(1));
	theDec = char(aTimeRec{1}{2}(2));
	switch theDec,
		case 'A'
			base(theRule) = base(theRule) + 1;
		case 'L'
			base(theRule) = base(theRule) - 1;
		case 'D'
			
		case 'U'
			base(theRule) = base(theRule) - 1;
		otherwise
	end
	active = [active;base];
end