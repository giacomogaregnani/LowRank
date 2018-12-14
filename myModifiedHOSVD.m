function C = myModifiedHOSVD(X, varargin)
%% function C = myModifiedHOSVD(X)
% Additional arguments
% C = myModifiedHOSVD(X, ..., 'method', {0, 1}) -- for rank based use 0 [default], for tol based use 1
% C = myModifiedHOSVD(X, ..., 'rank', R) -- Prescribe rank R [default = 5] (same for each dimension)
% C = myModifiedHOSVD(X, ..., 'oversampling', overs) -- oversample [default = 0] for range computation (R + overs)
% C = myModifiedHOSVD(X, ..., 'tol', tol) -- Prescribe tolerance [default = 1e-3] for tolerance-based computation

% Default values
method = 0;
R = 5;
overs = 0;
tol = 1e-3;

% Parse input
p = inputParser;
addOptional(p, 'rank', R);
addOptional(p, 'oversampling', overs);
addOptional(p, 'method', method);
addOptional(p, 'tol', tol);
parse(p, varargin{:}) 
p = p.Results;
ranks = p.rank * ones(1, 3);

% Initialise matrices
U = cell(3, 1);

if ~p.method
    for i = 1 : 3
        A = double(tenmat(X, i));
        U{i} = rangeFinder(A, p.rank+p.oversampling);
    end
else
    tenNorm = norm(X);
    for i = 1 : 3
        A = double(tenmat(X, i));
        U{i} = adaptiveRangeFinder(A, tenNorm * p.tol / 3);
    end
end

C = ttm(X, U, 't');

if overs > 0
    C = hosvd(C, 1, 'ranks', ranks, 'verbosity', 0, 'sequential', false);
    for i = 1 : 3
        U{i} = U{i} * C.U{i};
    end    
    C = ttensor(C.core, U);
else
    C = ttensor(C, U);
end

return