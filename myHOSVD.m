function C = myHOSVD(X, ranks)

U = cell(3, 1);

for i = 1 : 3
    Xi = double(tenmat(X, i));   
    [U{i}, ~, ~] = svd(Xi, 'econ');
    U{i} = U{i}(:, 1:ranks(i));
end

C = ttm(X, U, 't');
C = ttensor(C, U);

end