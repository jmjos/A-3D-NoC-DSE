n = 80;
ell = 4;
fR2D = 3*ones(1,ell);
Cimpl = 10*ones(n, ell);
energyR2D = 3*ones(1,ell);
Energy = 10* ones(n,ell);
Performance = 10*ones(n,ell);
u = ones(n) - eye(n);

fKOZ = 2;
%fR3Dratio = 1/2;
fSinglePort = fR2D / 5;

% propagation speed and frequency of routers
propagationSpeed = 5*ones(1,ell);
freq = ones(1,ell);

% % für input_assistant
% eN = NaN;
% NumberOfTiles = -1;
% riz = 0;
% tiz = 0;
% tix = 0;
% ai = 0;
% tiy = 0;
% bi = 0;