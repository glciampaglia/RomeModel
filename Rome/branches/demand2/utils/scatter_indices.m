function varargout = scatter_indices(X,Y,varargin)
% SCATTER_INDICES(X,Y) Disegna uno scatter plot con i due indici
% X e Y. 
% SCATTER_INDICES(X,Y,XLAB,YLAB) Fà lo stesso etichettando gli assi con
% XLAB e YLAB 

error(nargchk(2,4,nargin),'struct');
Xlab = 'X';
Ylab = 'Y';
switch nargin
    case 3
        Xlab = varargin{1};
    case 4
        Xlab = varargin{1};
        Ylab = varargin{2};
end

figure;
scatter(X,Y);
xlabel(Xlab);
ylabel(Ylab);
if nargout > 0
    varargot = { gcf() };
end 