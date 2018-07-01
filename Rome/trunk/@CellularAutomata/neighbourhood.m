function varargout = neighbourhood(aCA,varargin)

tmp = {};
cells = [1:length(aCA.cells)];
for i = 1:length(varargin),
	arg = varargin{i};
	for d = 1:length(arg), 
		tmp{d*i} = cells(aCA.adjacency(arg(d),:));
	end
end
if length(tmp) > 1,
	varargout = {tmp};
else
	varargout = tmp;
end
% if nargin == 0,
% 	component = strcat('RomeModel:',mfilename('class'),'_',mfilename(),':');
% 	warning(component,'No distance variables found');
% 	return;
% end
% 
% vArray = [varargin];
% for i = vArray;
% 	field = char(i);
% 	site.(field) = [];
% 	for pCell = 1:length(aCA.cells),
% 		[ppoly pcent] = deal(aCA.cells(pCell).poly{:});
% 		pmedians = median(ppoly,circshift(ppoly,1));
% 		urbDist = subsref(aCA,[struct('type','.','subs',i),...
% 			struct('type','()','subs',{{pCell}})]);
% 		pmDist = distance(repmat(pcent,[length(pmedians) 1]),pmedians);
% 		if urbDist < mean(pmDist)*aCA.scale,
% 			site.(field) = horzcat(site.(field),pCell);
% 		end
% % 		plot(ppoly(:,1),ppoly(:,2),'.-',pmedians(:,1),pmedians(:,2),'+',pcent(1),pcent(2),'*');
% % 		hold on
% % 		axis image
% 	end
% end
% varargout = {site};
% 
% %
% % SUBFUNCTIONS
% %
% 
% function d = distance(pointA,pointB)
% % pointA and pointB are nx2 matrices where n is the number of couples of
% % points (and of segments)
% if (size(pointA,2) ~= 2) & (size(pointB,2) ~= 2),
% 	error();
% end
% d = sqrt(sum((pointA-pointB).^2,2));
% 
% function m = median(pointA,pointB)
% % pointA and pointB are nx2 matrices where n is the number of couples of
% % points (and of segments)
% if (size(pointA,2) ~= 2) & (size(pointB,2) ~= 2),
% 	error();
% end
% m = (pointA + pointB)/2;
