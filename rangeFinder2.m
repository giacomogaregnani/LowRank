function Q = rangeFinder2(A, epl, r)

[m, n] = size(A);
Omega = randn(n, r);
Y = A * Omega;
Q = zeros(m, 1);
epl = epl / (10 * sqrt(2 / pi));
j = 0;

err = max(vecnorm(Y(:, j+1:j+r)));

while err > epl

    j = j+1;
    
    Y(:, j) = (speye(m) - Q * Q') * Y(:, j);
    Q(:, j) =  Y(:, j) / norm(Y(:, j));
    Y(:, j+r) = (speye(m) - Q * Q') * A * randn(n, 1);
    
    for i = j+1 : j+r-1 % Vectorise?
       Y(:, i) = Y(:, i) - Q(:, j) * dot(Q(:, j), Y(:, i)); 
    end
    
    err = max(vecnorm(Y(:, j+1:j+r)));
         
end

return