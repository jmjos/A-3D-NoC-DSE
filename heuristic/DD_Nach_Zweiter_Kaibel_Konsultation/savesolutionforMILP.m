%n = n;
l = ell;
fKOZ = fKOZ;
fR2D = fR2D;
ImplementationCosts = Cimpl;
PerformanceValues = Performance;
EnergyConsumption = Energy;
%u = u;
rix = componentPositions(:,1)';
riy = componentPositions(:,2)';
riz = componentPositions(:,3)';
%ai = ai;
%bi = bi;
% Adjazenzmatrix des networks, dann aber als Spaltenvektor

eN = full(adjacency(networkGraph));

eN = eN(:);
m = length(rix);

save('../10_GDOR/heuristicOutput.mat', ...
    ...% Output only
    'rix', 'riy', 'riz', 'ai', 'bi', 'eN','m' ...
    ...% Input, too
    ...%,'n','l','eta','fKOZ', 'fR2D', 'ImplementationCosts',...
    ...% 'PerformanceValues', 'EnergyConsumption', 'u' ...
    );

% F, u=(:), eA sollten in MILP-main nach load ausgeführt werden