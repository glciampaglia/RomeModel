function varargout = dynamics(store,aVar,varargin)
%
% in varargin mettiamo tutte le celle di cui vogliamo la dinamica. Se è
% vuoto è 1:nCells
%
[nCells nVars nEpochs] = size(store.data);


cellsIdx = 1:nCells;
if nargin > 2,
	cellsIdx = cell2mat(varargin);
end

if ndims(store.data)<3,
	fprintf('This simulations didn''t record data dynamics');
	return;
end


data = squeeze(store.data(cellsIdx,aVar,:))';

varargout = { data };