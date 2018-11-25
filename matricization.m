function M = matricization(X, mu)

d = ndims(X);
sizes = size(X);
sOne = sizes(mu);
sOther = prod(sizes([1:mu-1,mu+1:d]));

M = permute(X, [mu, 1:mu-1, mu+1:d]);
M = reshape(M, sOne, sOther);

return