clc; clear; close all
%% Test range finder

% Test matrix
% n = 200;
% f = @(x, y, z) 1 ./ sqrt(x + y + z);
% 
% xGrid = 0.1 : 0.1 : n/10;
% [X, Y, Z] = meshgrid(xGrid, xGrid, xGrid);
% F = tensor(f(X, Y, Z));

F = tensor(rand(200, 200, 200));

ranks = 5:5:100;
errStandard = zeros(size(ranks));
errModified = errStandard;
timeStandard = errStandard;
timeModified = errStandard;

for i = 1 : length(ranks)
    
    r = ranks(i);
    
    tic
    Tmod = mHOSVD(F, 'tol', 1, 'rank', r, 'oversampling', 10, 'method', 'rank');
    timeModified(i) = toc;
    
    tic
    T = hosvd(F, 1, 'ranks', [r, r, r], 'verbosity', 0, 'sequential', false);
    timeStandard(i) = toc;
    
    errStandard(i) = norm(F - full(T)) / norm(F);
    errModified(i) = norm(F - full(Tmod)) / norm(F);
    fprintf('rank = %d\nstandard HOSVD = %e, time = %.3f\nmodified HOSVD = %e, time = %.3f\n', ...
        r, errStandard(i), timeStandard(i), errModified(i), timeModified(i))
    
end

semilogy(ranks, errStandard, 'k--o')
hold on
semilogy(ranks, errModified, 'k-o')
legend('hosvd', 'mhosvd')

figure
plot(ranks, timeStandard, 'k--o')
hold on
plot(ranks, timeModified, 'k-o')
legend('hosvd', 'mhosvd')