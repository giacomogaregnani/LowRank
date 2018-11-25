function C = mHOSVD(X, varargin)
%% function C = mHOSVD(X)
% Additional arguments
% C = mHOSVD(X, 'rank', R) -- Approximation of rank R
% C = mHOSVD(X, 'tol', tol) -- tolerance tol in the approximate range
% computation
% C = mHOSVD(X, 'oversampling', overs) -- oversample the range (R + overs)
% C = mHOSVD(X, 'method', {'tol', 'rank'}) -- tol or rank based approx of
% the range
% OR ANY COMBINATION OF THE ABOVE INPUTS

% Default values
method = 'rank';
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

U = cell(3, 1);
ranks = p.rank * ones(1, 3);

if strcmp(p.method, 'rank')
    for i = 1 : 3
        A = tenmat(X, i);
        U{i} = rangeFinder(A.data, p.rank+p.oversampling);
    end
elseif strcmp(p.method, 'tol')
    for i = 1 : 3
        A = tenmat(X, i);
        U{i} = rangeFinder2(A.data, p.tol, p.rank);
    end
end

C = ttm(ttm(ttm(X, U{1}', 1), U{2}', 2), U{3}', 3);

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