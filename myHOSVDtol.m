function C = myHOSVDtol(X, tol)

U = cell(3, 1);
normXsqd = norm(X)^2;

for i = 1 : 3
    Xi = double(tenmat(X, i));   
    [U{i}, S, ~] = svd(Xi, 'econ');
    
    % Decide where to cut for attaining the desired tolerance (based on a
    % priori error estimates)
    cumSumSingVal = cumsum((diag(S)).^2, 'reverse');
    cutidx = find(cumSumSingVal > tol^2 * normXsqd / 3, 1, 'last');
    U{i} = U{i}(:, 1:cutidx);
end

C = ttm(X, U, 't');
C = ttensor(C, U);

end