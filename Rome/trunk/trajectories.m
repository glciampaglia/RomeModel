function varargout = trajectories(myCA,store,field,varargin)
% Estrae la traiettoria della dinamica di una o più variabili.

[zid zind] = getZones(myCA);
% zind = num2cell(1:40);														% this is a dirty hack
nZones = length(zind);
work = store.(field);
[nCells nRules nSims] = size(work);

flag = false;

if nargin > 3,
	mode = varargin{1};
	if strcmp(mode,'norm'),
		flag = true;
	else
		warning(['provided a wrong ''mode'' string: $s,',...
			' it should be ''norm'''],mode);
	end
end

% per prima cosa, normalizziamo i risultati
if flag,
	for aSim = 1:nSims,
		for aRule = 1:nRules,
			work(:,aRule,aSim) = work(:,aRule,aSim)/sum(work(:,aRule,aSim));
		end
	end
end
	
% quindi, aggreghiamo i valori di attrattività su ciascuna zona
meanAttr = zeros(nZones,nRules,nSims);										% pre-allocate for faster subscripting
for ithZone = 1:nZones,
	ithZIndxs = zind{ithZone};												% unpack the indices from the cell array
	meanAttr(ithZone,:,:) = mean(work(ithZIndxs,:,:),1);					% compute mean along the first dimension
end

% now we need to manipulate the meanAttr in order to have 
% 1st dim: time		
% 2nd dim: rules 	
% 3rd dim: zones (so we can eventually split into 4 2D matrices with
%	meaningful content - and plot without further manipulation all rules
%   for each zone.
% 1) shift dimensions to have nZones last
% nZones,nRules,nSims   
%    <- ,  <-  , <-		(shift to the left by 1 and wrap)
% nRules,nSims,nZones
% traj = zeros(nRules,nSims,nZones);										% M-LINT complains.. 
traj = shiftdim(meanAttr,1);
% 
% 2) for each traj = traj(:,:,1) ... traj(:,:,nSims),
% transpose traj and store it in a page of a nSims,nRules,nZones matrix
traj2 = zeros(nSims,nRules,nZones);
for ithZone = 1:nZones
	traj2(:,:,ithZone) = traj(:,:,ithZone)';
end

varargout = { traj2 };
	
	


