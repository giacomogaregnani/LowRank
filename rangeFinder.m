function Q = rangeFinder(A, l)

[~, n] = size(A);

Omega = randn(n, l);
[Q, ~] = qr(A * Omega, 0);

return