function [err, time, ranks] = testTolModHOSVD(F, tolerances, trials)

time = zeros(trials, length(tolerances));
err = time;
ranks = zeros(length(tolerances), 3);

for j = 1 : trials
    
    fprintf('----- TRIAL %2d -----\n', j);
    
    for i = 1 : length(tolerances)
        
        tol = tolerances(i);
        
        tic
        T = myModifiedHOSVD(F, 'tol', tol, 'method', 1);
        time(j, i) = toc;
        err(j, i) = norm(F - full(T)) / norm(F);
        
        if j == 1
           ranks(i, :) = T.core.size;
        end
        
        fprintf('tol  = %.1e, err = %e, time = %.3f\n', ...
            tol, err(j, i), time(j, i))
        
    end
    
end

if trials > 1
    err = mean(err);
    time = mean(time);
end