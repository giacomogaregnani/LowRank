function Q = adaptiveRangeFinder(A, epl)

maxit = min(min(size(A)), 1000);
k = 10;
[m, n] = size(A);
Omega = randn(n, k);
Y = A * Omega;
Q = [];
epl = epl / (10 * sqrt(2 / pi));
j = 0;

err = max(vecnorm(Y(:, j+1:j+k)));
IminusQQt = speye(m);

while err > epl && j < maxit

    j = j+1;
    
    Y(:, j) = IminusQQt * Y(:, j);
    q = Y(:, j) / norm(Y(:, j));
    Q = [Q q];
    IminusQQt = speye(m) - Q * Q';
    Y(:, j+k) = IminusQQt * A * randn(n, 1);
    Y(:, j+1:j+k-1) = Y(:, j+1:j+k-1) - q * (q' * Y(:, j+1:j+k-1));
    err = max(vecnorm(Y(:, j+1:j+k)));

end

return