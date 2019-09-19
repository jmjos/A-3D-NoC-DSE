% Variables
% for both, heuristic and MILP
n = 1000;          % number of components
ell = 3;        % number of layers (heuristic)
l = ell;        % number of layers (MILP)
fKOZ = 2;       % area costs of a KOZ
fR2D = 2*rand(1,ell) + 1; % 2D-Router area costs
Cimpl = 7*rand(n, ell) + 3;    % component area costs  (heuristic)
Energy = 9* rand(n,ell) + 1;   % component energy costs  (heuristic)
Performance = 5 * rand(n,ell) + 5;   % component performance  (heuristic)
ImplementationCosts = Cimpl;    % (MILP)
EnergyConsumption = Energy; % (MILP)
PerformanceValues = Performance; % (MILP)
u = zeros(n); % adjacency matrix of application digraph
% ensure connectivity
for i = 1: n-1
    u(i,i+1) = 1;
end
% random application graph
connectionPropability = .05; % 5 percent

for i = 1:n
    for j = 1:n
        if rand < connectionPropability
            u(i,j) = 1;
        end
    end
end
% u = u(:); (only MILP)

% only heuristic - no pendant in MILP
energyR2D = 2*rand(1,ell) + 1;          % energy consumption of 2D routers
fSinglePort = fR2D / 5;             % area costs of single router port
propagationSpeed = 4*rand(1,ell) + 1;   % propagation speed
freq = ones(1,ell);                 % frequency of routers

% % only MILP - no pendant in heuristic
% m = 60;              % maximum number of routers
% eta = 0.1;            % minimum aspect ratio of tiles (in (0,1])
% delta = 0.001;         % minimum distance between components
% phi = [0,0,0];      % unplaced components' location
% c = 1000;           % large constant (c_1, ...)
% xMax = 100;         % maximum chip dimensions
% yMax = 100;         % maximum chip dimensions

% % Verarbeitung (MILP)
% F = FV_CostMatrix(n,m,l,eta,ImplementationCosts, fR2D, fKOZ );
% eA = (u~=0);