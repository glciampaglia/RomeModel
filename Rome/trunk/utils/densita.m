function dens = densita(store)

popDin = squeeze(store.data(:,1,:))';
terr = squeeze(sum(store.data(:,9:15,:),2))';
dens = popDin./terr;

