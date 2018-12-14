function [err, time] = testRankModHOSVD(F, ranks, oversampling, trials)

for j = 1 : trials
    
    fprintf('----- TRIAL %2d -----\n', j);
    
    for i = 1 : length(ranks)
        
        r = ranks(i);
        
        tic
        Tmod = myModifiedHOSVD(F, 'rank', r, 'oversampling', oversampling, 'method', 0);
        time(j, i) = toc;
        err(j, i) = norm(F - full(Tmod)) / norm(F);
        
        fprintf('rank = %2d, err = %e, time = %.3f\n', ...
            r, err(j, i), time(j, i))
        
    end
    
end

if trials > 1
    err = mean(err);
    time = mean(time);
end