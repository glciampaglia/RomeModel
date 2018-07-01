function [ varargout ] = data(obj, varargin);
	if nargin == 1,
		varargout = { obj.data };
		return
	end
	if isnumeric(varargin{1}),
		obj.data = varargin{1};
	end
end
		