function y=hill(x,varargin)
% Hill's threshold function
%
% Computes the hill's threshold function given by
% $$y = \frac{x^\alpha}{x^\alpha + \beta}$$ for $\alpha > 1$ 
%
% Syntax:
% Y = HILL(X),          computes Y with $\alpha = 2$, $\beta = 1$
% HILL(X,A),            computes Y with $\alpha = A$, $\beta = 1$
% HILL(X,A,B),          computes Y with $\alpha = A$, $\beta = B$
% HILL(X,{X1},{X2}},    computes y with parameters such that HILL(X1) = 0.25 and
%   HILL(X2) = 0.75
% HILL(X,{X1,Y1},{X2,Y2}), computes Y with parameters such that HILL(X1) = Y1 and
%   HILL(X2) = Y2

global DEBUG;

% Check the arguments
error(nargchk(1,3,nargin,'struct'));

switch nargin-1,
    case 0
        % default values of the parameters
        a = 2; 
        b = 1;
    case 1
        if isscalar(varargin{1}) && isnumeric(varargin{1}),
            a = varargin{2};
            b = 1;
        else
            error('RomeModel:hill',...
                'Non scalar or non numeric parameter');
        end
    case 2
        if isscalar(varargin{1}) && isnumeric(varargin{1}) && ...
                isscalar(varargin{2}) && isnumeric(varargin{2}),
            a = varargin{1};
            b = varargin{2};
            aOK = a > 1;
            bOK = b > 0;
            switch aOK + bOK
                case 0 
                    warning('RomeModel:hill','Resetting parameters to default');
                    a = 2; b = 1;
                case 1
                    if aOK,
                        b = 1;
                    else
                        a = 2;
                    end
                case 2
                    % this is the good case
                otherwise
                    error('RomeModel:hill','Unexpected error');
            end
        elseif iscell(varargin{1}) && iscell(varargin{2}),
            x1 = varargin{1}{1};
            if length(varargin{1}) > 1,
                y1 = varargin{1}{2};
            else
                y1 = 0.25;
            end
            x2 = varargin{2}{1};
            if length(varargin{2}) > 1,
                y2 = varargin{2}{2};
            else
                y2 = 0.75;
            end
            if ~isnumeric([x1 x2 y1 y2]),
                error('RomeModel:hill','Non scalar or non numeric parameter');
            end
            abscissasOK = 0<x1 && 0<x2 && x1<x2 && (abs(x1-x2) > eps);
            ordinatesOK = 0 < y1 && y1 < 1 && 0 < y2 && y2 < 1 && y1 < y2 && abs(y1-y2) > eps;      
            switch abscissasOK + ordinatesOK,
                % NOTE default values are equivalent to a = 2, b = 1
                case 0
                    warning('RomeModel:hill','Resetting parameters to default');
                    x1 = sqrt(3)/3; x2 = sqrt(3); y1 = .25; y2 = .75;
                case 1
                    warning('RomeModel:hill','Resetting parameters to default');
                    if ~abscissasOK, 
                        x1 = sqrt(3)/3; x2 = sqrt(3);
                    else
                        y1 = .25; y2 = .75; 
                    end
                case 2
                    % This is the good case
                otherwise
                    error('RomeModel:hill','Unexpected error');
            end
            % now let's compute a and b from (x1,y1),(x2,y2)
            a = log((y1/y2)*((1-y2)/(1-y1)))/log(x1/x2);
            b = (x1^a)*((1-y1) / y1);
        else
            error('RomeModel:hill','Parameters specified in a mixed format');
        end
    otherwise 
        error('RomeModel:hill','Unexpected error');
end

if DEBUG.DEBUG_ON,
    fprintf(DEBUG.DEBUG_FD,'Parameters computed are a=%g, b=%g\n',a,b);
end

% Check that x is a numeric variable
if ~isnumeric(x), error('RomeModel:hill','non numeric input'); end

% Check that input is positive else issue a warning
if any(find(x<0)), warning('RomeModel:hill','negative input'); end

% Compute the function
y = (x.^a) ./ (x.^a + b);