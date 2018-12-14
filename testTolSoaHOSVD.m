function [err, time, ranks] = testTolSoaHOSVD(F, input, trials)

time = zeros(trials, length(input));
err = time;
ranks = zeros(length(input), 3);

for j = 1 : trials
    fprintf('----- TRIAL %2d -----\n', j);
    for i = 1 : length(input)
        tic
        T = hosvd(F, input(i), 'verbosity', 0, 'sequential', false);
        time(j, i) = toc;
        err(j, i) = norm(full(T) - F) / norm(F);
        
        if j == 1
           ranks(i, :) = T.core.size;
        end
        
        fprintf('tol = %.1e, err = %e, time = %.3f\n', ...
            input(i), err(j, i), time(j, i))
    end
end

if trials > 1
    time = mean(time);
    err = mean(err);
end
