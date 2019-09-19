% ---------------------------------------------------------------------- %
% Ben�tigte Werte:                                                       %
% 
% key parameters: ....................... n, m, ell, NumberOfTiles, fKOZ %
% new parameters: ............. bandwidth, dmax, routerEnergyConsumption %
% router positions: ...................................... rix, riy, riz %
% tile dimensions: .............................................. ai, bi %
% Communication Costs adjacency matrix ............................... u %
% 2D-links adjacency matrix ......................................... eN %
% ---------------------------------------------------------------------- %

n = 75;
m = 75;
ell = 5;
NumberOfTiles = 75;
fKOZ = 3;

bandwidth = ones(1,m);
dmax = ones(1,ell);
dmax(1) = 10;
dmax(2) = 10;
dmax(3) = 10;
dmax(4) = 10;
dmax(5) = 10;

routerEnergyConsumption = ones(1,m);

rix = [0 2 4 6 8 0 2 4 6 8 0 2 4 6 8 ...
       0 2 4 6 8 0 2 4 6 8 0 2 4 6 8 ...
       0 2 4 6 8 0 2 4 6 8 0 2 4 6 8 ...
       0 2 4 6 8 0 2 4 6 8 0 2 4 6 8 ...
       0 2 4 6 8 0 2 4 6 8 0 2 4 6 8];
riy = [0 0 0 0 0 2 2 2 2 2 4 4 4 4 4 ...
       0 0 0 0 0 2 2 2 2 2 4 4 4 4 4 ...
       0 0 0 0 0 2 2 2 2 2 4 4 4 4 4 ...
       0 0 0 0 0 2 2 2 2 2 4 4 4 4 4 ...
       0 0 0 0 0 2 2 2 2 2 4 4 4 4 4];
riz = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ...
       2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ...
       3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 ...
       4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 ...
       5 5 5 5 5 5 5 5 5 5 5 5 5 5 5];
      
ai = [1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 ...
      1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 ...
      1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 ...
      1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 ...
      1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5];

bi = [1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 ...
      1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 ...
      1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 ...
      1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 ...
      1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5];

% u

u = zeros(n);

% edges_u = [1;
%            75];
% 
% ccomm = 2*ones(1,length(edges_u));
% 
% for i = 1:size(edges_u,2)
%     u(edges_u(1,i),edges_u(2,i)) = ccomm(i);
%     u(edges_u(2,i),edges_u(1,i)) = ccomm(i);
% end
u = 2*ones(n);
for i = 1:n
    u(i,i) = 0;
end

% eN

eN = zeros(m);
edges_N1 = [1 2 3 4 6 7 8 9  11 12 13 14 1 2 3 4  5  6  7  8  9 10;
            2 3 4 5 7 8 9 10 12 13 14 15 6 7 8 9 10 11 12 13 14 15];
edges_N2 = [16 17 18 19 21 22 23 24 26 27 28 29 16 17 18 19 20 21 22 23 24 25;
            17 18 19 20 22 23 24 25 27 28 29 30 21 22 23 24 25 26 27 28 29 30];
edges_N3 = [31 32 33 34 36 37 38 39 41 42 43 44 31 32 33 34 35 36 37 38 39 40;
            32 33 34 35 37 38 39 40 42 43 44 45 36 37 38 39 40 41 42 43 44 45];
edges_N4 = [46 47 48 49 51 52 53 54 56 57 58 59 46 47 48 49 50 51 52 53 54 55;
            47 48 49 50 52 53 54 55 57 58 59 60 51 52 53 54 55 56 57 58 59 60];
edges_N5 = [61 62 63 64 66 67 68 69 71 72 73 74 61 62 63 64 65 66 67 68 69 70;
            62 63 64 65 67 68 69 70 72 73 74 75 66 67 68 69 70 71 72 73 74 75];
edges_N = [edges_N1, edges_N2, edges_N3, edges_N4, edges_N5];
clear edges_N1 edges_N2 edges_N3 edges_N4 edges_N5
for i = 1:size(edges_N,2)
    eN(edges_N(1,i),edges_N(2,i)) = 1;
    eN(edges_N(2,i),edges_N(1,i)) = 1;
end