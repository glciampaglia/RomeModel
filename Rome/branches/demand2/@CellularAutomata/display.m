function display(obj);
	fprintf(1,'CellularAutomata of the city of %s,',obj.name);
	fprintf(1,' ');
	fprintf(1,'divided into %i cells,',size(obj.cells,1));
	fprintf(1,' ');
	fprintf(1,'at time %s',datestr(obj.time));
	fprintf(1,'\n');
end