% ---------------------------------------------------------------------- %
% Benötigte Werte:                                                       %
% 
% key parameters: ....................... n, m, ell, NumberOfTiles, fKOZ %
% new parameters: ............. bandwidth, dmax, routerEnergyConsumption %
% router positions: ...................................... rix, riy, riz %
% tile dimensions: .............................................. ai, bi %
% Communication Costs adjacency matrix ............................... u %
% 2D-links adjacency matrix ......................................... eN %
% ---------------------------------------------------------------------- %

% Anzahl der Komponenten
n = 30;

% Anzahl der Router
m = 40;

% Anzahl der Layer
ell = 5;

% Anzahl der Tiles
NumberOfTiles = 40;

% KOZ kosten
fKOZ = 10;

% Bandbreitenlimit (= Routerkapazität ohne Datenstau)
bandwidth = 3*ones(1,m);

% Maximale 2D-Link-Länge je Layer (beeinflusst die Platzierung der
% 3D-Links)
dmax = 0.1 * ones(1,ell);
dmax(1) = 2;

% Energiekosten der Router bei Volllast
routerEnergyConsumption = ones(1,m);

% Positionen aller Router (und damit auch der 1 bis NumberOfTiles Tiles)

for i = 1:m
    rix(i) = 1;
    riy(i) = 3*i + 1;
    riz(i) = ceil(rand*ell);
end

% Ausdehnung der Tiles

for i = 1:NumberOfTiles
    ai(i) = 2;
    bi(i) = 2;
end

% Obere rechte Hälfte der Adjazenzmatrix mit Kommunikationsgewichten u.
% Hinweise: u ist symmetrisch, auf der Diagonalen sollten Nullen stehen.

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

% Links

eN = zeros(m);
for i = 1:m
    for j = i+1:m
        eN(i,j) = 1;
    end
end
eN = makeSymmetrical_nonzero(eN);