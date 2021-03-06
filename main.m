clc; clear; close all
%% Function related tensor

n = 100;
f = @(x, y, z) 1 ./ sqrt(x + y + z);
xGrid = 0.1 : 0.1 : n/10;
[X, Y, Z] = meshgrid(xGrid, xGrid, xGrid);
F = tensor(f(X, Y, Z));
clear X Y Z

% Tolerances
trials = 1;
tolerances = flip(logspace(-11, -1, 6));

% HOSVD-AR
[errTol, timeTol, ranksTol] = testTolModHOSVD(F, tolerances, trials);

% HOSVD
[errMyFunc, timeMyFunc, ranksMyFunc] = testTolHOSVD(F, tolerances, trials);

% HOSVD-TT
[errSoaFunc, timeSoaFunc, ranksSoaFunc] = testTolSoaHOSVD(F, tolerances, trials);

%% Random tensor

n = 100;
F = tensor(rand(n, n, n));
trials = 1;
ranks = 5:5:50;

% HOSVD-AR
[errModHOSVD, timeModHOSVD] = testRankModHOSVD(F, ranks, 10, trials);

% HOSVD
[errMyHOSVD, timeMyHOSVD] = testRankHOSVD(F, ranks, trials);

% HOSVD-TT
[errSoaHOSVD, timeSoaHOSVD] = testRankSoaHOSVD(F, ranks, trials);


%% Figures

saveFigures = 0;
titlefunc = @(x) ['$' num2str(x) '\times' num2str(x) '\times' num2str(x) '$ random tensor'];

% rank - err
if exist('createFigure.m')
    W = 6.7; H = 6.7;
    enhanced = 1;
    fontsizeLAB = getLatexTextSize('normalsize', 'enhanced', enhanced);
    fontsizeTICK = getLatexTextSize('small', 'enhanced', enhanced);
    fig = createFigure(W, H);
else
    figure
end
semilogy(ranks, errModHOSVD, 'k-o', 'markersize', 5)
hold on
semilogy(ranks, errMyHOSVD, 'k-s', 'markersize', 5)
semilogy(ranks, errSoaHOSVD, 'k-d', 'markersize', 5)
ylim([0.48, 0.58])
xlabel('rank', 'interpreter', 'latex')
ylabel('error', 'interpreter', 'latex')
box on
legend({'HOSVD-AR','HOSVD','HOSVD-TT'}, 'location', 'NE', 'interpreter', 'latex')
title({titlefunc(n)}, 'interpreter', 'latex')
axis square
axPos = get(gca, 'innerposition');
if exist('export_fig') && saveFigures
    export_fig(fig, '../Report/Figures/rankErrBig.eps', '-nocrop')
end

% rank - cost
if exist('createFigure.m')
    fig = createFigure(W, H);
    enhanced = 1;
    fontsizeLAB = getLatexTextSize('normalsize', 'enhanced', enhanced);
    fontsizeTICK = getLatexTextSize('small', 'enhanced', enhanced);
    W = 6.7; H = 6.7;
else
    figure
end
semilogy(ranks, timeModHOSVD, 'k-o', 'markersize', 5)
hold on
semilogy(ranks, timeMyHOSVD, 'k-s', 'markersize', 5)
semilogy(ranks, timeSoaHOSVD, 'k-d', 'markersize', 5)
% ylim([1, 1e2])
xlabel('rank', 'interpreter', 'latex')
ylabel('time', 'interpreter', 'latex')
box on
title({titlefunc(n)}, 'interpreter', 'latex')
axis square
set(gca, 'innerposition', axPos);
if exist('export_fig') && saveFigures
    export_fig(fig, '../Report/Figures/rankTimeBig.eps', '-nocrop')
end
