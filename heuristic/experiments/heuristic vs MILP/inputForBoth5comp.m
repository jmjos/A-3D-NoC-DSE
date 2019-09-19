% Variables
% for both, heuristic and MILP
n = 5;          % number of components
ell = 2;        % number of layers (heuristic)
l = ell;        % number of layers (MILP)
fKOZ = 2;       % area costs of a KOZ
fR2D = 3*ones(1,ell); % 2D-Router area costs
Cimpl = 10*ones(n, ell);    % component area costs  (heuristic)
Energy = 10* ones(n,ell);   % component energy costs  (heuristic)
Performance = 10*ones(n,ell);   % component performance  (heuristic)
ImplementationCosts = Cimpl;    % (MILP)
EnergyConsumption = Energy; % (MILP)
PerformanceValues = Performance; % (MILP)
u = zeros(n); % adjacency matrix of application digraph
u(1,2) = 1;
u(2,1) = 1;
u(3,2) = 1;
u(2,3) = 1;
u(3,4) = 1;
u(4,3) = 1;
u(4,5) = 1;
u(5,4) = 1;
% u = u(:); (only MILP)

% only heuristic - no pendant in MILP
energyR2D = 3*ones(1,ell);          % energy consumption of 2D routers
fSinglePort = fR2D / 5;             % area costs of single router port
propagationSpeed = 5*ones(1,ell);   % propagation speed
freq = ones(1,ell);                 % frequency of routers

% only MILP - no pendant in heuristic
m = 6;              % maximum number of routers
eta = 1;            % maximum aspect ratio of tiles (in (0,1))
delta = 0.1;         % minimum distance between components
phi = [0,0,0];      % unplaced components' location
c = 1000;           % large constant (c_1, ...)
xMax = 100;         % maximum chip dimensions
yMax = 100;         % maximum chip dimensions

% % Verarbeitung (MILP)
% F = FV_CostMatrix(n,m,l,eta,ImplementationCosts, fR2D, fKOZ );
% eA = (u~=0);