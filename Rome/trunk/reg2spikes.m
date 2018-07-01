function spikes = reg2spikes(register,tStart)
% Questa funzione estrae l'array con i tempi di interarrivo dalla struttura
% register che memorizza il processo di Poisson composto.


spikes = [];
for aTimeRec = register.times,
	tmpRec = aTimeRec{1};
	spikes = [spikes;tmpRec{1}];
end
spikes = spikes + tStart;
