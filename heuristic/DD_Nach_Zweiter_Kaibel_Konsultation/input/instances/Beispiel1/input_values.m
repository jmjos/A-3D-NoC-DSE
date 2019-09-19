% BEISPIEL1

n = 30; % Anzahl der Komponenten n
m = 40; % Anzahl der Router
ell = 5; % Anzahl der Layer
NumberOfTiles = 40; % Anzahl der Tiles
fKOZ = 10; % KOZ kosten
bandwidth = 3*ones(1,m);
dmax = 0.1 * ones(1,ell);
dmax(1) = 2;
routerEnergyConsumption = ones(1,m);


% Obere rechte Hälfte der Adjazenzmatrix mit Kommunikationsgewichten u.
% Hinweise: u ist nicht unbedingt symmetrisch, auf der Diagonalen sollten Nullen stehen.

%    Eingabe      1 2 3             automatisch       1 2 3
%    hier:        0 4 5           - - - - - - - >     2 4 5
%                 0 0 6                               3 5 6

for i = 1:6
    u(i,12+i) = 2;
    u(i,18+i) = 1;
    u(6+i,29) = 1.5;
end
for i = 1:5
    u(24+i,30) = 3;
    u(i, i+1) = 4;
end
u(1,6) = 4;
for i = 1:3
    u(11+2*i,30) = 2;
end

% Positionen der Tiles

for i = 1:NumberOfTiles
    %tix(i) = 1;
    %tiy(i) = 3*i;
    riz(i) = ceil(rand*ell);
end

% Ausdehnung der Tiles

for i = 1:NumberOfTiles
    ai(i) = 2;
    bi(i) = 2;
end
    
% Links
% Da nur bidirektionale Links verwendet werden, muss dieser Adjazenzmatrix
% symmetrisch sein.
for i = 1:m
    for j = i+1:m
        eN(i,j) = ceil(rand*2)-1;
    end
end


% Router, die nicht an Tile-Startpunkten liegen

%for i = 1:(m-NumberOfTiles)
    %rix(NumberOfTiles + i) = ceil((3*i + 1)/10);
    %riy(NumberOfTiles + i) = mod(3*i + 1, 10);
%    riz(NumberOfTiles + i) = ceil(rand*ell);
%end

for layer = 1:ell
    i = 1;
    for routerinlayer = find(riz == layer)
        rix(routerinlayer) =mod(i,4);
        riy(routerinlayer) = ceil(i/4);
        i = i + 1;
    end
end