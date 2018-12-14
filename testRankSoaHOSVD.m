function [err, time] = testRankSoaHOSVD(F, ranks, trials)

time = zeros(trials, length(ranks));
err = time;
resRanks = zeros(length(ranks), 3);

for j = 1 : trials
    fprintf('----- TRIAL %2d -----\n', j);
    for i = 1 : length(ranks)
        tic
        T = hosvd(F, 1, 'ranks', ranks(i) * ones(1, 3), 'verbosity', 0, 'sequential', false);
        time(j, i) = toc;
        err(j, i) = norm(full(T) - F) / norm(F);

        fprintf('rank = %2d, err = %e, time = %.3f\n', ...
            ranks(i), err(j, i), time(j, i))

    end
end

if trials > 1
    time = mean(time);
    err = mean(err);
end
