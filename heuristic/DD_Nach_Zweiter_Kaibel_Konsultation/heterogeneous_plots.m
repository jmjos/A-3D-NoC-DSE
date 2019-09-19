% choose colors
color1 = 'y';
color2 = 'k';

% plot heuristics picture
load('heterogeneous18_heuristic_luckyShot.mat')
figNum = 1;
plotResults_modified(componentPositions, aiNeeded,biNeeded, networkGraph, saveas, color1, color2, figNum)


% plot convetnional picture
load('heterogeneous18_conventional.mat')
figNum = 2;
plotResults_modified(componentPositions, aj,bj, network, saveas, color1, color2, figNum)
