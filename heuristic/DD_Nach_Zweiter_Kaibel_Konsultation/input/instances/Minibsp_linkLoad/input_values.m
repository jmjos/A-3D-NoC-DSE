% MINIBSP_LINKLOAD

n = 3; % Anzahl der Komponenten n
m = 4; % Anzahl der Router
ell = 2; % Anzahl der Layer
NumberOfTiles =4; % Anzahl der Tiles
fKOZ = 10; % KOZ kosten
bandwidth = zeros(1, m);
bandwidth = [3 3 3 3];
dmax = ones(1,ell);
dmax(1) = 2;
routerEnergyConsumption = ones(1,m);

u = zeros(n);
ai = zeros(1,NumberOfTiles);
bi = zeros(1,NumberOfTiles);
eN = zeros(m,m);
rix = zeros(1,m);
riy = zeros(1,m);
riz = zeros(1,m);

% Positionen der Tiles

rix = [1 2 2 1];%2 2 1 2 1 2 1 2 1];
riy = [1 1 1 1];%1 1 1 1 1 1 1 1 1];
riz = [2 1 2 1];%5 1 2 2 3 3 4 4 5];

% Ausdehnung der Tiles

for i = 1:NumberOfTiles
    ai(i) = .5;
    bi(i) = .5;
end
    
% Links
% Da nur bidirektionale Links verwendet werden, muss dieser Adjazenzmatrix
% symmetrisch sein.
eN(1,3) = 1;
eN(2,4) = 1;
%eN(1, 3) = 1;
%eN(2, 10) = 1;
% eN(3, 4) = 1;
% eN(4, 5) = 1;
% eN(5, 6) = 1;
% eN(6, 7) = 1;
% eN(7, 8) = 1;
% eN(8, 9) = 1;
% eN(9, 10) = 1;

% Adjazenzmatrix mit Kommunikationsgewichten u.

u = [0 0 0; 2 0 0; 4 0 0];