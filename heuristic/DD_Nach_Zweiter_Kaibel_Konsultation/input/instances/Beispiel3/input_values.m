
% Beispiel3 %
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

% Ein ähnlich großes, aber bedeutend spannenderes Beispiel als Beispiel 2.

%% TECHNOLOGY MODEL 
n = 72;
m = 86;
ell = 5;
NumberOfTiles = 72;
fKOZ = 3;

% 2D-Routerkosten je layer ( ell - Vektor)
fR2D = [5 5 5 3 3];
fR3Dratio = + 1/5; % Verhaltnis (fR3D/fR2D - 1)
fSinglePort = fR3Dratio * fR2D;

assert(numel(fR2D) == ell, 'number of layers and router costs mismatch');
energyR2D = [5 5 5 3 3];
assert(numel(energyR2D) == ell, 'number of layers and router energy mismatch');

bandwidth = 35*ones(1,m);
dmax = ones(1,ell);
dmax(1) =  90; % Längester 2D-Link:  90
dmax(2) = 180; %                    180
dmax(3) = 135; %                    135
dmax(4) = 240; %                    240
dmax(5) = 144; %                    144

routerEnergyConsumption = ones(1,m);

% Implementierungskosten ( n x ell - Matrix)
Cimpl = CostGenerationCoprime( 7, n,ell );
assert(numel(Cimpl) == ell*n, 'number of layers*components and costs mismatch');
Performance = -1.* CostGenerationCoprime( 11, n,ell );;
assert(numel(Performance) == ell*n, 'number of layers*components and performance mismatch');
Energy = CostGenerationCoprime( 13, n,ell ); ;
assert(numel(Energy) == ell*n, 'number of layers*components and energy mismatch');

% propagation speed and frequency of routers
propagationSpeed = 5*ones(1,5);
freq = ones(1,5);

rix = [ 92 182 272 2 92 182 272 2 92 182 272 2 92 182 272 ...
       32 122 302 182 242 2 2 122 302 62 242 152 2 122 272 181 32 242 ...
       92 137 182 92 137 182 92 137 182 137 272 317 272 317 ...
       2 92 272 92 92 2 182 182 ...
       2 146 218 290 2 146 2 146 290 2 146 218 2 74 218 290 74 ...
       32 182 58 58 152 182 58 302 122 272 ...
       92 272 ...
       146 218];
riy = [2 2 2 92 92 92 92 182 182 182 182 272 272 272 272 ...
       2 2 2 32 32 62 122 122 122 152 152 182 242 242 242 272 302 302 ...
       182 182 182 227 227 227 272 272 272 47 2 2 47 47 ...
       2 2 2 122 182 242 242 302 ...
       2 2 2 2 62 62 122 122 122 182 182 182 242 242 242 242 302 ...
       62 122 152 238 238 238 242 242 302 302 ...
       242 242 ...
       242 302];
riz = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ...
       2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ...
       3 3 3 3 3 3 3 3 3 3 3 3 3 3 ...
       4 4 4 4 4 4 4 4 ...
       5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 ...
       2 2 2 2 2 2 2 2 2 2 ...
       4 4 ...
       5 5];
      
ai = [86 86 86 86 86 86 86 86 86 86 86 86 86 86 86 ...
      56 56 56 56 56 116 56 116 56 56 56 56 116 56 56 56 56 116 ...
      41 41 41 41 41 41 41 41 41 41 41 41 41 41 ...
      86 176 86 176 176 176 176 176 ...
      140 68 68 68 68 212 68 140 68 140 68 68 68 68 68 68 140];

bi = [86 86 86 86 86 86 86 86 86 86 86 86 86 86 86 ...
      56 116 116 56 56 56 116 56 116 56 56 56 56 116 56 56 56 56 ...
      41 41 41 41 41 41 41 41 41 41 41 41 41 41 ...
      236 116 236 56 56 116 56 56 ...
      56 56 56 56 56 56 56 56 56 56 116 56 116 56 116 116 56];


%% APPLICATION MODEL
  % Kommunikation in u eintragen

% Initialisierung
u = zeros(n);

% Jeder kommuniziert mit jedem defVal Daten.
defVal = 0;
u = defVal*ones(n);
for i = 1:n
    u(i,i) = 0;
end

u(1, 16) = 4;
u(3, 7) = 4;
u(72, 9) = 4;
u(2, 3) = 4;
u(5,48) = 4;
u(38, 5) = 4;
u(68, 65) = 4;
u(64, 69) = 4;
u(34, 35) = 4;
u(45, 47) = 4;

% Layer 1 enthält Tasks 1 bis 15
edges_u1 = [ ;
             ];
ccomm1   = [ ];
% Layer 2 enthält Tasks 16 bis 33
edges_u2 = [ ;
             ];
ccomm2   = [ ];
% Layer 3 enthält Tasks 34 bis 47
edges_u3 = [ ;
             ];
ccomm3   = [ ];
% Layer 4 enthält Tasks 48 bis 55
edges_u4 = [ ;
             ];
ccomm4   = [ ];
% Layer 5 enthält Tasks 56 bis 72
edges_u5 = [ ;
             ];
ccomm5   = [ ];

edges_u12 = [ ;
             ];
ccomm12   = [ ];

edges_u13 = [ ;
             ];
ccomm13   = [ ];

edges_u14 = [ ;
             ];
ccomm14   = [ ];

edges_u15 = [ ;
             ];
ccomm15   = [ ];

edges_u23 = [ ;
             ];
ccomm23   = [ ];

edges_u24 = [ ;
             ];
ccomm24   = [ ];

edges_u25 = [ ;
             ];
ccomm25   = [ ];

edges_u34 = [ ;
             ];
ccomm34   = [ ];

edges_u35 = [ ;
             ];
ccomm35   = [ ];

edges_u45 = [ ;
             ];
ccomm45   = [ ];

edges_u = [edges_u1, edges_u2, edges_u3, edges_u4, edges_u5, ...
           edges_u12, edges_u13, edges_u14, edges_u15, ...
           edges_u23, edges_u24, edges_u25, ...
           edges_u34, edges_u35, edges_u45];
ccomm = [ccomm1, ccomm2, ccomm3, ccomm4, ccomm5, ...
         ccomm12, ccomm13, ccomm14, ccomm15, ...
         ccomm23, ccomm24, ccomm25, ...
         ccomm34, ccomm35, ccomm45];
clear edges_u1 edges_u2 edges_u3 edges_u4 edges_u5 edges_u12 edges_u13 ...
    edges_u14 edges_u15 edges_u23 edges_u24 edges_u25 edges_u34 ...
    edges_u35 edges_u45 ccomm1 ccomm2 ccomm3 ccomm4 ccomm5 ccomm12 ...
    ccomm13 ccomm14 ccomm15 ccomm23 ccomm24 ccomm25 ccomm34 ccomm35 ccomm45

for i = 1:size(edges_u,2)
    u(edges_u(1,i),edges_u(2,i)) = ccomm(i);
    u(edges_u(2,i),edges_u(1,i)) = ccomm(i);
end

% eN

eN = zeros(m);
edges_N1 = [1 2 4 5 6 8  9 10 12 13 14 1 2 3 4 5  6  7  8  9 10 11;
            2 3 5 6 7 9 10 11 13 14 15 5 6 7 8 9 10 11 12 13 14 15];
edges_N2 = [16 16 17 17 18 19 19 20 21 21 22 22 23 23 24 24 25 26 27 28 29 29 29 30 30 31 32 33 75 76 76 77;
            17 73 18 23 24 74 20 26 73 22 23 28 74 29 74 80 75 33 77 79 79 30 81 80 82 78 81 82 76 77 79 78];
edges_N3 = [34 34 35 35 35 36 37 37 38 38 39 40 41 43 44 44 45 46;
            35 37 36 38 43 39 38 40 39 41 42 41 42 46 45 46 47 47];
edges_N4 = [48 48 49 49 50 51 52 53 54 54 54;
            49 53 50 51 84 52 83 83 83 84 55];
edges_N5 = [56 56 57 57 58 60 60 61 62 62 63 63 64 65 65 66 66 67 68 69 69 70 70 72;
            57 60 58 61 59 61 62 63 63 65 64 66 71 66 68 85 67 70 69 85 72 71 86 86];
edges_N = [edges_N1, edges_N2, edges_N3, edges_N4, edges_N5];
clear edges_N1 edges_N2 edges_N3 edges_N4 edges_N5
for i = 1:size(edges_N,2)
    eN(edges_N(1,i),edges_N(2,i)) = 1;
    eN(edges_N(2,i),edges_N(1,i)) = 1;
end