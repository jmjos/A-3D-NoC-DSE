% MIT License
% 
% Copyright (c) 2017 JM Joseph
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

%% Eingaben
addpath('I:\Program Files\IBM\ILOG\CPLEX_Studio1271\cplex\matlab\x64_win64');
%clear all
useCPLEX = true;
useSPARSE = true;
presetPositions = false;
x0given = false;
usePlotting = true;
saveSolution = false;
saveSolutionName = 'solution.mat';
OptimizationTime = 60;
options = cplexoptimset('Display', 'on', 'MaxTime', 150);


%m \geq n
m = 7;
n = 7;
l = 2;
eta = 1;
F = FV_CostMatrix(n,m,l,eta);
delta = 0.1;
phi = [0,0,0];
c = 1000;
xMax = 100;
yMax = 100;

% utilization u
% HINWEIS: Kanten zu sich selbst sind verboten.
u = zeros(n^2,1);
uPre = ones(n,n)-diag(ones(n,1));
u = uPre(:);
%eA = ones(n^2,1)-diag(n^2,);
%eA(2) = 1;
%eA(3) = 1;
% eA(4) = 1;
% eA(8) = 1;
% %eA(2) = 1;
% eA(14) = 1;

% E_A
eA = (u~=0);


maxRoutersPerTile = m-n+1;
maxTSVsPerTile = m-n+1;

% optionale Eingaben:

% maximal Länge m! 
if (presetPositions)
    rix = [1 1 3 3 1 1 3];
    riy = [1 3 1 3 1 3 1];
    riz = [1 1 1 1 2 2 2];
    tix = [];
    tiy = [];
    tiz = [];
    ai = [];
    bi = [];
    eN = [];
else
    rix = [];
    riy = [];
    riz = [];
    tix = [];
    tiy = [];
    tiz = [];
    ai = [];
    bi = [];
    eN = [];
end
% % eN, i<j (j<i automatisch)
% eN = zeros(m^2,1);
% eN(2) = 1;
% eN(8) = 1;
% eN(20) = 1;


%% Variablen namen

% varLENGTH fuer die tiles und deren groesse:
hcLENGTH = 1;
aiLENGTH = m;
biLENGTH = m;
tixLENGTH = m;
tiyLENGTH = m;
tizLENGTH = m;
rixLENGTH = m;
riyLENGTH = m;
rizLENGTH = m;
tiles_HORILENGTH    = m^2 - m;
tiles_HORIILENGTH   = m^2 - m;
tiles_HORIIILENGTH  = m^2 - m;
tiles_HORIVLENGTH   = m^2 - m;
tiles_HORVLENGTH    = m^2 - m;
tiles_HORVILENGTH   = m^2 - m;
tiles_HORVIILENGTH  = m^2 - m;
tiles_HORVIIILENGTH = m^2 - m;
tiles_HAreaXiIAlphaBetaLENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta1LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta2LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta3LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta4LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta5LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta6LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;

% varLENGTH fuer den fluss:% network edges E_N
% network edges E_N
eLENGTH = m^2;
% varLENGTH grid based topology and TSCs connect to neighbored layers
flow_HILENGTH    = m^2;
flow_HORILENGTH   = m^2;
flow_HORIILENGTH  = m^2;
% varLENGTH forbid connections between non-neighbored routers
flow_HIJORLENGTH = m*(m-1);
flow_HIJK1LENGTH = m*(m-1)*(m-2);
flow_HIJKa1LENGTH = m*(m-1)*(m-2);
flow_HIJKa2LENGTH = m*(m-1)*(m-2);
flow_HIJKa3LENGTH = m*(m-1)*(m-2);
flow_HIJKa4LENGTH = m*(m-1)*(m-2);
flow_HIJK2LENGTH = m*(m-1)*(m-2);
flow_HIJKb1LENGTH = m*(m-1)*(m-2);
flow_HIJKb2LENGTH = m*(m-1)*(m-2);
flow_HIJKb3LENGTH = m*(m-1)*(m-2);
flow_HIJKb4LENGTH = m*(m-1)*(m-2);
flow_HIJK3LENGTH = m*(m-1)*(m-2);
flow_HIJKc1LENGTH = m*(m-1)*(m-2);
flow_HIJKc2LENGTH = m*(m-1)*(m-2);
flow_HIJKc3LENGTH = m*(m-1)*(m-2);
flow_HIJKc4LENGTH = m*(m-1)*(m-2);
flow_HIJK4LENGTH = m*(m-1)*(m-2);
flow_HIJKd1LENGTH = m*(m-1)*(m-2);
flow_HIJKd2LENGTH = m*(m-1)*(m-2);
flow_HIJKd3LENGTH = m*(m-1)*(m-2);
flow_HIJKd4LENGTH = m*(m-1)*(m-2);
flow_HIJ1LENGTH = m*(m-1);
flow_HIJ2LENGTH = m*(m-1);
flow_HIJ3LENGTH = m*(m-1);
% varLENGTH routers are not self-connected
% eij = eji
%flow
fLENGTH = m^2 * sum(eA);
GammaLENGTH = m*sum(eA);
hLENGTH = m^2 * sum(eA);
tech_hILENGTH = m;
% varLENGTH cross
cross_HIJK1LENGTH = m*(m-1)*(m-2);
cross_HIJK2LENGTH = m*(m-1)*(m-2);
cross_HIJK3LENGTH = m*(m-1)*(m-2);
cross_HIJK4LENGTH = m*(m-1)*(m-2);
cross_HIJK5LENGTH = m*(m-1)*(m-2);
cross_HIJK6LENGTH = m*(m-1)*(m-2);
cross_HIJK7LENGTH = m*(m-1)*(m-2);
cross_HIJK8LENGTH = m*(m-1)*(m-2);
cross_HIJORLENGTH = m*(m-1);
% varLENGTH router_tsv
routsv_HIJLENGTH = m*(m-n);
routsv_HIJ1LENGTH = m*(m-n);
routsv_HIJ2LENGTH = m*(m-n);
routsv_HIJ3LENGTH = m*(m-n);
routsv_HIJ4LENGTH = m*(m-n);
routsv_HIJ5LENGTH = m*(m-n);
routsv_HIJ6LENGTH = m*(m-n);
routsv_hirouterLENGTH = m;
routsv_hatHJLENGTH = m;
routsv_HJKORLENGTH = m*(m-1);
routsv_tildeHJKLENGTH = m*(m-1);
routsv_tildeHJKORLENGTH = m*(m-1);
routsv_hatHIJLENGTH = m*(m-n);
routsv_hiTSVLENGTH = m;
cPeakLENGTH = 1;
cPeak_loadLENGTH = m^2;
cPeak_muLENGTH = 1;
cPeak_hmaxLENGTH = m^2;

% varSTART  tiles: start indexes
hcSTART = 0;
aiSTART = hcSTART + hcLENGTH;
biSTART = aiSTART + aiLENGTH;
tixSTART = biSTART + biLENGTH;
tiySTART = tixSTART + tixLENGTH;
tizSTART = tiySTART + tiyLENGTH;
rixSTART = tizSTART + tizLENGTH;
riySTART = rixSTART + rixLENGTH;
rizSTART = riySTART + riyLENGTH;
tiles_HORISTART = rizSTART + rizLENGTH;
tiles_HORIISTART = tiles_HORISTART + tiles_HORILENGTH;
tiles_HORIIISTART = tiles_HORIISTART + tiles_HORIILENGTH;
tiles_HORIVSTART = tiles_HORIIISTART + tiles_HORIIILENGTH;
tiles_HORVSTART = tiles_HORIVSTART + tiles_HORIVLENGTH;
tiles_HORVISTART = tiles_HORVSTART + tiles_HORVLENGTH;
tiles_HORVIISTART = tiles_HORVISTART + tiles_HORVILENGTH;
tiles_HORVIIISTART = tiles_HORVIISTART + tiles_HORVIILENGTH;
tiles_HAreaXiIAlphaBetaSTART = tiles_HORVIIISTART + tiles_HORVIIILENGTH;
tiles_HAreaXiIAlphaBeta1START = tiles_HAreaXiIAlphaBetaSTART + tiles_HAreaXiIAlphaBetaLENGTH;
tiles_HAreaXiIAlphaBeta2START = tiles_HAreaXiIAlphaBeta1START + tiles_HAreaXiIAlphaBeta1LENGTH;
tiles_HAreaXiIAlphaBeta3START = tiles_HAreaXiIAlphaBeta2START + tiles_HAreaXiIAlphaBeta2LENGTH;
tiles_HAreaXiIAlphaBeta4START = tiles_HAreaXiIAlphaBeta3START + tiles_HAreaXiIAlphaBeta3LENGTH;
tiles_HAreaXiIAlphaBeta5START = tiles_HAreaXiIAlphaBeta4START + tiles_HAreaXiIAlphaBeta4LENGTH;
tiles_HAreaXiIAlphaBeta6START = tiles_HAreaXiIAlphaBeta5START + tiles_HAreaXiIAlphaBeta5LENGTH;
% varSTART fluss: start indexes:
eSTART = tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH;
flow_HISTART = eSTART + eLENGTH;
flow_HORISTART = flow_HISTART + flow_HILENGTH;
flow_HORIISTART = flow_HORISTART + flow_HORILENGTH;
flow_HIJORSTART = flow_HORIISTART + flow_HORIILENGTH;
flow_HIJK1START = flow_HIJORSTART + flow_HIJORLENGTH; 
flow_HIJKa1START = flow_HIJK1START + flow_HIJK1LENGTH;
flow_HIJKa2START = flow_HIJKa1START + flow_HIJKa1LENGTH;
flow_HIJKa3START = flow_HIJKa2START + flow_HIJKa2LENGTH;
flow_HIJKa4START = flow_HIJKa3START + flow_HIJKa3LENGTH;
flow_HIJK2START = flow_HIJKa4START + flow_HIJKa4LENGTH;  
flow_HIJKb1START = flow_HIJK2START + flow_HIJK2LENGTH;
flow_HIJKb2START = flow_HIJKb1START + flow_HIJKb1LENGTH;
flow_HIJKb3START = flow_HIJKb2START + flow_HIJKb2LENGTH;
flow_HIJKb4START = flow_HIJKb3START + flow_HIJKb3LENGTH;
flow_HIJK3START = flow_HIJKb4START + flow_HIJKb4LENGTH;
flow_HIJKc1START = flow_HIJK3START + flow_HIJK3LENGTH;
flow_HIJKc2START = flow_HIJKc1START + flow_HIJKc1LENGTH;
flow_HIJKc3START = flow_HIJKc2START + flow_HIJKc2LENGTH;
flow_HIJKc4START = flow_HIJKc3START + flow_HIJKc3LENGTH;
flow_HIJK4START = flow_HIJKc4START + flow_HIJKc4LENGTH;
flow_HIJKd1START = flow_HIJK4START + flow_HIJK4LENGTH;
flow_HIJKd2START = flow_HIJKd1START + flow_HIJKd1LENGTH;
flow_HIJKd3START = flow_HIJKd2START + flow_HIJKd2LENGTH;
flow_HIJKd4START = flow_HIJKd3START + flow_HIJKd3LENGTH;
flow_HIJ1START = flow_HIJKd4START + flow_HIJKd4LENGTH;
flow_HIJ2START = flow_HIJ1START + flow_HIJ1LENGTH;
flow_HIJ3START = flow_HIJ2START + flow_HIJ2LENGTH;
% varSTART flow
fSTART = flow_HIJ3START + flow_HIJ3LENGTH;
GammaSTART = fSTART + fLENGTH;
hSTART = GammaSTART + GammaLENGTH;
% varSTART technical constraint
tech_hISTART = hSTART + hLENGTH;
cross_HIJK1START = tech_hISTART + tech_hILENGTH;
cross_HIJK2START = cross_HIJK1START + cross_HIJK1LENGTH;
cross_HIJK3START = cross_HIJK2START + cross_HIJK2LENGTH;
cross_HIJK4START = cross_HIJK3START + cross_HIJK3LENGTH;
cross_HIJK5START = cross_HIJK4START + cross_HIJK4LENGTH;
cross_HIJK6START = cross_HIJK5START + cross_HIJK5LENGTH;
cross_HIJK7START = cross_HIJK6START + cross_HIJK6LENGTH;
cross_HIJK8START = cross_HIJK7START + cross_HIJK7LENGTH;
cross_HIJORSTART = cross_HIJK8START + cross_HIJK8LENGTH;
% varSTART router_tsv
routsv_HIJSTART = cross_HIJORSTART + cross_HIJORLENGTH;
routsv_HIJ1START = routsv_HIJSTART + routsv_HIJLENGTH;
routsv_HIJ2START = routsv_HIJ1START + routsv_HIJ1LENGTH;
routsv_HIJ3START = routsv_HIJ2START + routsv_HIJ2LENGTH;
routsv_HIJ4START = routsv_HIJ3START + routsv_HIJ3LENGTH;
routsv_HIJ5START = routsv_HIJ4START + routsv_HIJ4LENGTH;
routsv_HIJ6START = routsv_HIJ5START + routsv_HIJ5LENGTH;
routsv_hirouterSTART = routsv_HIJ6START + routsv_HIJ6LENGTH;
routsv_hatHJSTART = routsv_hirouterSTART + routsv_hirouterLENGTH;
routsv_HJKORSTART = routsv_hatHJSTART + routsv_hatHJLENGTH;
routsv_tildeHJKSTART = routsv_HJKORSTART + routsv_HJKORLENGTH;
routsv_tildeHJKORSTART = routsv_tildeHJKSTART + routsv_tildeHJKLENGTH;
routsv_hatHIJSTART = routsv_tildeHJKORSTART + routsv_tildeHJKORLENGTH;
routsv_hiTSVSTART = routsv_hatHIJSTART + routsv_hatHIJLENGTH;
cPeakSTART = routsv_hiTSVSTART + routsv_hiTSVLENGTH;
cPeak_loadSTART = cPeakSTART + cPeakLENGTH;
cPeak_muSTART = cPeak_loadSTART + cPeak_loadLENGTH;
cPeak_hmaxSTART = cPeak_muSTART + cPeak_muLENGTH;

% Anzahl der Variablen
anzahlVar = cPeak_hmaxSTART + cPeak_hmaxLENGTH;

% Anzahl der Ungleichungen
anzahlUglRIXTIX = 8*(m-n);
anzahlUglIndexSortRiTi = max(0, 2*((m-1)-(n)) );
anzahlUglRITItoPHI = 4*m;
anzahlUglaibi0 = 2*(m-n);
anzahlUglTech = anzahlUglRITItoPHI +  anzahlUglIndexSortRiTi + anzahlUglRIXTIX + anzahlUglaibi0;
anzahlUglTilesOverlap = 11*(m^2 - m) + 2*m;
anzahlUglAreaTiles = 8*((maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m);
anzahlUglAreaTiles = anzahlUglAreaTiles + 4*m;
anzahlUglFlow =  14 * m ^2 + 33*m*(m-1)*(m-2) + 4*m*(m-1) + m + 2*m*(m-1)+m + sum(eA)*m^2 + m^2*sum(eA) + m^2*sum(eA);
anzahlUglCross = 13*m*(m-1)*(m-2) + m*(m-1);
anzahlUglHIROUTER = 13*m*(m-n);
anzahlUglhatHJ = 6*m*(m-1)+ m;
anzahlUglhatHJK = 3 * m * (m-n);
anzahlUglroutersandtiles = m-n;
anzahlUglcPeak = 2*m^2;
anzahlUgl = anzahlUglTech + anzahlUglTilesOverlap + anzahlUglAreaTiles + ...
    anzahlUglFlow + anzahlUglCross + anzahlUglHIROUTER ...
    + anzahlUglhatHJ +anzahlUglhatHJK + anzahlUglroutersandtiles + ...
    anzahlUglcPeak;

% Anzahl der Gleichungen
anzahlGlRIXTIX = 3*n;
anzahlGlFlow = m^2 + 2*sum(eA) + sum(eA)*(m-2);
anzahlManuelleEingabe = length(tix) + length(tiy) + length(tiz) + ... 
    length(rix) + length(riy) + length(riz) + length(ai) + length(bi) ...
    + 2*(sqrt(length(eN))*(sqrt(length(eN))-1)/2 + sqrt(length(eN)));
anzahlTESTGLEICHUNGEN = 0; %TESTGLEICHUNGEN ANZAHL
anzahlGlHIROUTER = m;
anzahlGlHITSV = m;
anzahlGlEingabe_einlesen = 8*m + 2*(m*(m-1)/2 + m);
anzahlGlcPeak = m^2 + 2;
anzahlGl = anzahlGlRIXTIX+ anzahlGlFlow + anzahlTESTGLEICHUNGEN + ...
    anzahlGlEingabe_einlesen + anzahlGlHIROUTER + anzahlGlHITSV + ...
    + anzahlGlcPeak;

%% generiere kostenfunktion (wir minimieren)
f= zeros(1,anzahlVar);

%f(tizSTART+1)=1;
% Möglichst hohe Layer
%f(rizSTART+1:rizSTART+rizLENGTH)=-1;

%generiert ein Quadarat (cAREA)
f(hcSTART+ 1) = 1;

%aus dem flow:
%f(eSTART + 1 : eSTART + eLENGTH) = 1; % möglichst wenige Kanten
%f(fSTART+1:fSTART+fLENGTH) = 1; % möglichst kurze Flüsse

%utilization (cUTIL)
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            f(fSTART + (fNo-1) * m^2 + (1-1)*m + 1:fSTART + (fNo-1) * m^2 + (m-1)*m + m)= u((i-1)*n + j);
        end
    end
end
        

%peak loads (cPEAK)
f(cPeakSTART + 1) = 1;


%% generiere integer variablen

% nicht integer sind: tix, tiy, rix, riy, ai, bi, hc

if (~useCPLEX)
intcon = [tizSTART + 1 : tizSTART + tizLENGTH, ...
    rizSTART + 1: rizSTART + rizLENGTH, ...
    tiles_HORISTART + 1 : tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH, ...
    eSTART + 1 : fSTART, ...
    GammaSTART + 1 : GammaSTART + GammaLENGTH,...
    hSTART + 1 : hSTART + hLENGTH,...
    tech_hISTART+1 : tech_hISTART + tech_hILENGTH, ...
    cross_HIJK1START+1: cross_HIJORSTART+ cross_HIJORLENGTH, ...
    routsv_HIJSTART+1: routsv_hirouterSTART + routsv_hirouterLENGTH, ...
    routsv_hatHJSTART+1: routsv_tildeHJKORSTART + routsv_tildeHJKORLENGTH, ...
    routsv_hatHIJSTART+1 :  routsv_hatHIJSTART + routsv_hatHIJLENGTH, ... 
    routsv_hiTSVSTART+1 : routsv_hiTSVSTART+routsv_hiTSVLENGTH];
else
    ctype = blanks(anzahlVar);
    % by default: all continuous
    ctype(:) = 'C';
    %integer variables
    ctype(tizSTART + 1 : tizSTART + tizLENGTH) = 'I';
    ctype(rizSTART + 1: rizSTART + rizLENGTH) = 'I';
    ctype(GammaSTART + 1 : GammaSTART + GammaLENGTH) = 'I';
    %binary variables
    ctype(tiles_HORISTART + 1 : tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH)='B';
    ctype(eSTART + 1 : fSTART)='B';
    ctype(hSTART + 1 : hSTART + hLENGTH)='B';
    ctype(tech_hISTART+1 : tech_hISTART + tech_hILENGTH)='B';
    ctype(cross_HIJK1START+1: cross_HIJORSTART+ cross_HIJORLENGTH)='B';
    ctype(routsv_HIJSTART+1: routsv_HIJ6START + routsv_HIJ6LENGTH)='B';
    ctype(routsv_hirouterSTART+1: routsv_hirouterSTART + routsv_hirouterLENGTH)='I';
    ctype(routsv_hatHJSTART+1: routsv_tildeHJKORSTART + routsv_tildeHJKORLENGTH)='B';
    ctype(routsv_hatHIJSTART+1 :  routsv_hatHIJSTART + routsv_hatHIJLENGTH) = 'B';
    ctype(routsv_hiTSVSTART+1 : routsv_hiTSVSTART+routsv_hiTSVLENGTH) = 'I'; 
end

%% trage richtige werte in A und b ein
tic
if (~useSPARSE)
    A = zeros(anzahlUgl, anzahlVar);
else
    A = sparse(anzahlUgl, anzahlVar);
end
b = zeros(anzahlUgl, 1);

Aeq = zeros(anzahlGl, anzahlVar);
beq = zeros(anzahlGl, 1);

UglNo = 0;
GlNo = 0;

%Testgleichungen
%--------------------------------------------------------------------------

% Test 0 (anzahl 9)
% Testidee: drei Tiles vorplatzieren, zwei in gleicher Ebene über Eck, ein
% drittes über einem anderen.

for i = 1:length(tix)
    % tix = tix
    GlNo = GlNo+1;
    beq(GlNo)= tix(i);
    Aeq(GlNo, tixSTART + i ) = 1;
end
for i = 1:length(tiy)
    % tiy = tiy
    GlNo = GlNo+1;
    beq(GlNo)= tiy(i);
    Aeq(GlNo, tiySTART + i ) = 1;
end
for i = 1:length(tiz)
    % tiz = tiz
    GlNo = GlNo+1;
    beq(GlNo)= tiz(i);
    Aeq(GlNo, tizSTART + i ) = 1;
end
for i = 1:length(rix)    
    % rix = rix
    GlNo = GlNo+1;
    beq(GlNo)= rix(i);
    Aeq(GlNo, rixSTART + i ) = 1;
end
for i = 1:length(riy)
    % riy = riy
    GlNo = GlNo+1;
    beq(GlNo)= riy(i);
    Aeq(GlNo, riySTART + i ) = 1;
end
for i = 1:length(riz)
    % riz = riz
    GlNo = GlNo+1;
    beq(GlNo)= riz(i);
    Aeq(GlNo, rizSTART + i ) = 1;
end
for i = 1:length(ai)
    % ai = ai
    GlNo = GlNo+1;
    beq(GlNo)= ai(i);
    Aeq(GlNo, aiSTART + i ) = 1;
end
for i = 1:length(bi)
    % bi = bi
    GlNo = GlNo+1;
    beq(GlNo)= bi(i);
    Aeq(GlNo, biSTART + i ) = 1;
    end
for i = 1:sqrt(length(eN))
    for j=1:sqrt(length(eN))
        if (i<= j)
            % eij = eij
            GlNo = GlNo+1;
            beq(GlNo)= eN((i-1)*m + j);
            Aeq(GlNo, eSTART + (i-1)*m + j) = 1;

            % eij = eji
            GlNo = GlNo+1;
            beq(GlNo)= eN((i-1)*m + j);
            Aeq(GlNo, eSTART + (j-1)*m + i) = 1;
        end
    end
end

% % Test 1 (anzahl 1)
% % Testidee: Es muss ein Tile mehr geben, als es Komponenten gibt. Die
% % Technical Constraint, die Router und Tiles gleich macht wird hier
% % getestet
% % r(n+1) ~= phi
% UglNo=UglNo+1;
% b(UglNo)= -0.5;
% A(UglNo, tizSTART+n+1)= -1;

% Test 2 (anzahl 9)
% Testidee: Zwei Tiles diagonal platzieren und Fluss verlangen. Erwartung:
% ein dritter Router wird gesetzt, um die Verbindung zu ermöglichen.
% % t1x = 1
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tixSTART+1) = 1;
% 
% % t2x = 20
% GlNo = GlNo +1;
% beq(GlNo) = 1.5;
% Aeq(GlNo, tixSTART+2) = 1;
% 
% % t1y = 1
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tiySTART+1) = 1;
% 
% % t2y = 20
% GlNo = GlNo +1;
% beq(GlNo) = 20;
% Aeq(GlNo, tiySTART+2) = 1;
% 
% % t1z = 2
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tizSTART+1) = 1;
% 
% % t2z = 1
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tizSTART+2) = 1;
% 
% % t3z = 1
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tizSTART+3) = 1;
% % t3x= 0.5
% GlNo = GlNo +1;
% beq(GlNo) = 0.5;
% Aeq(GlNo, tixSTART+3) = 1;
% 
% % t3y = 10
% GlNo = GlNo +1;
% beq(GlNo) = 10;
% Aeq(GlNo, tiySTART+3) = 1;

% Test 3 (anzahl ?)
% Testidee: drei Tiles in drei Ebenen, das untere und das obere sollen
% durch einen möglichst kurzen Fluss verbunden werden. 2 TSVs. Das mittlere
% würde von den beiden TSVs durchstoßen werden. Frage: können Router in die
% Mitte von Tiles platziert werden?

% Test 3 wurde noch nicht implementiert

% technische Constraints: 
%--------------------------------------------------------------------------
% Komponenten und Router haben gleiche Indexe
% si(xyz) = ri(xyz)

% IndexesRouterTiles

% RIXTIX Gleichheit (1:n)
% Bemerkung: Diese Gleichungen gibts im Paper (noch) nicht und sie 
% landen vielleicht woanders als in den Technical Constr.
disp('Gleichheit von ri und ti für i von 1 bis n')
% ti{x,y,z} = ri{x,y,z}
for i = 1:n
    %tix = rix
    GlNo = GlNo +1;
    beq(GlNo) = 0;
    Aeq(GlNo, rixSTART + i) = 1;
    Aeq(GlNo, tixSTART + i) = -1;
    
    %tiy = riy
    GlNo = GlNo + 1;
    beq(GlNo) = 0;
    Aeq(GlNo, riySTART + i) = 1;
    Aeq(GlNo, tiySTART + i) = -1;

    %tiz = riz
    GlNo = GlNo + 1;
    beq(GlNo) = 0;
    Aeq(GlNo, rizSTART + i) = 1;
    Aeq(GlNo, tizSTART + i) = -1;
end

% RIXTIX-Ungleichungen(n+1:m)
disp('Gleichheit von ri und ti für i von n+1 bis m')
for i=n+1:m
    % tiz leq phi + tech_hI*c
    UglNo = UglNo +1;
    b(UglNo)= phi(3);
    A(UglNo,tizSTART+i)=1;
    A(UglNo,tech_hISTART+i)=-c;
    
    % phi leq tiz + tech_hI*c
    UglNo = UglNo +1;
    b(UglNo)= -phi(3);
    A(UglNo,tizSTART+i)= -1;
    A(UglNo,tech_hISTART+i)=-c;

    % tix leq rix + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,rixSTART+i)= -1;
    A(UglNo,tixSTART+i)= 1;
    A(UglNo,tech_hISTART+i)= c;
    
    % rix leq tix + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,rixSTART+i)= 1;
    A(UglNo,tixSTART+i)= -1;
    A(UglNo,tech_hISTART+i)= c;
    
    % tiy leq riy + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,riySTART+i)= -1;
    A(UglNo,tiySTART+i)= 1;
    A(UglNo,tech_hISTART+i)= c;

    % riy leq tiy + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,riySTART+i)= 1;
    A(UglNo,tiySTART+i)= -1;
    A(UglNo,tech_hISTART+i)= c;
    
    % tiz leq riz + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,rizSTART+i)= -1;
    A(UglNo,tizSTART+i)= 1;
    A(UglNo,tech_hISTART+i)= c;
    
    % riz leq tiz + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,rizSTART+i)= 1;
    A(UglNo,tizSTART+i)= -1;
    A(UglNo,tech_hISTART+i)= c;
end

% IndexSortRiTi
for i= n+1:m-1
    %Router mit Layer 0 stehen am Ende
    % r(i+1)z leq riz*c
    UglNo = UglNo +1;
    b(UglNo)=0;
    A(UglNo, rizSTART + i+1)= 1;
    A(UglNo, rizSTART + i)= -c;
    
    %Tiles mit Layer 0 stehen am Ende
    % t(i+1)z leq tiz*c
    UglNo = UglNo +1;
    b(UglNo)=0;
    A(UglNo, tizSTART + i+1)= 1;
    A(UglNo, tizSTART + i)= -c;
end
    
% RItoPHI
%  alle router in ebene 0 muessen in phi sein. d.h. 
%   r_{i,x} \leq r_{i,z}*C
%   r_{i,y} \leq r_{i,z}*C
%  fuer alle $i \in [m]$, C = xmax+ymax+l
for i= 1:m
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, rixSTART + i) = 1;
    A(UglNo, rizSTART + i) = -(xMax + yMax + l);
    
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, riySTART + i) = 1;
    A(UglNo, rizSTART + i) = -(xMax + yMax + l);
end

% TItoPHI
% das gleiche für Tiles (tiles in Ebene 0 müssen in phi sein)
for i= 1:m
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, tixSTART + i) = 1;
    A(UglNo, tizSTART + i) = -(xMax + yMax + l);
    
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, tiySTART + i) = 1;
    A(UglNo, tizSTART + i) = -(xMax + yMax + l);
end

for i = n+1:m
    % ai leq tiz*xmax
        % umgestellt: ai -xmax*tiz leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, aiSTART + i) = 1;
    A(UglNo, tizSTART + i) = -xMax;

    % bi leq tiz*ymax
        % umgestellt: bi -ymax*tiz leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, biSTART + i) = 1;
    A(UglNo, tizSTART + i) = -yMax;
end

% Tiles may not overlap constraints
%--------------------------------------------------------------------------

for i=1:m
    %t_ix + a_i \leq h_c
    UglNo = UglNo + 1;
    A(UglNo, hcSTART + 1) = -1;
    A(UglNo, tixSTART + i) = 1;
    %b(UglNo) = -ai(i);
    b(UglNo) = 0;
    A(UglNo, aiSTART + i) = 1;
   
    %t_iy + b_i \leq h_c
    UglNo = UglNo + 1;
    A(UglNo, hcSTART + 1) = -1;
    A(UglNo, tixSTART + m+i) = 1;
    %b(UglNo) = -bi(i);
    b(UglNo) = 0;
    A(UglNo, biSTART + i) = 1;
end

for i = 1:m
    for k = 1:m-1
        if(k<i) 
            j = k;
        else
            j = k + 1;
        end
%       t_{i, z} \leq \varphi_z + \tiles_HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) =  phi(3);
        A(UglNo, tizSTART + i ) = 1;
        A(UglNo, tiles_HORISTART + (i-1)*(m-1)+k ) = - c;

%       \varphi_z &\leq t_{i, z} + \tiles_HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = - phi(3);
        A(UglNo, tizSTART + i ) = -1;
        A(UglNo, tiles_HORISTART + (i-1)*(m-1)+k ) = - c;

%       t_{j, z} \leq \varphi_z + \tiles_HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) =  phi(3);
        A(UglNo, tizSTART + j ) = 1;
        A(UglNo, tiles_HORIISTART +(i-1)*(m-1)+k ) = - c;

%       \varphi_z &\leq t_{j, z} + \tiles_HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = - phi(3);
        A(UglNo, tizSTART + j ) = -1;
        A(UglNo, tiles_HORIISTART +(i-1)*(m-1)+k ) = - c;
        
%       t_{i,z} &\leq t_{j,z} - \nicefrac{1}{2} + \tiles_HORIII \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, tizSTART + i ) = 1;
        A(UglNo, tizSTART + j ) = -1;
        A(UglNo, tiles_HORIIISTART +(i-1)*(m-1)+k ) = - c;

%       t_{j,z} &\leq t_{i,z} - \nicefrac{1}{2} + \tiles_HORIV \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, tizSTART + i ) = -1;
        A(UglNo, tizSTART + j ) = 1;
        A(UglNo, tiles_HORIVSTART +(i-1)*(m-1)+k ) = - c;        
        
        % t_jx geq t_ix + a_i + delta + h_or1
        UglNo = UglNo + 1;
        %b(UglNo) = -ai(i) - delta;
        b(UglNo) = - delta;
        A(UglNo, aiSTART + i) = 1;
        A(UglNo, tixSTART + i) = 1;
        A(UglNo, tixSTART + j) = -1;
        A(UglNo, tiles_HORVSTART + (i-1)*(m-1)+ k) = -c;
        
        % t_ix geq t_jx + a_j + delta + h_or2
        UglNo = UglNo + 1;
        %b(UglNo) = -ai(j) - delta;
        b(UglNo) = - delta;
        A(UglNo, aiSTART + j) = 1;
        A(UglNo, tixSTART + i) = -1;
        A(UglNo, tixSTART + j) = 1;
        A(UglNo, tiles_HORVISTART + (i-1)*(m-1)+ k) = -c;
        
        % t_jy geq t_iy + b_i + delta + h_or3
        UglNo = UglNo + 1;
        %b(UglNo) = -bi(i) - delta;
        b(UglNo) = - delta;
        A(UglNo, biSTART + i) = 1;
        A(UglNo, tiySTART + i) = 1;
        A(UglNo, tiySTART + j) = -1;
        A(UglNo, tiles_HORVIISTART + (i-1)*(m-1)+ k) = -c;
         
        % t_iy geq t_jy + b_j + delta + h_or4
        UglNo = UglNo + 1;
        %b(UglNo) = -bi(j) - delta;
        b(UglNo) = - delta;
        A(UglNo, biSTART + j) = 1;
        A(UglNo, tiySTART + i) = -1;
        A(UglNo, tiySTART + j) = 1;
        A(UglNo, tiles_HORVIIISTART + (i-1)*(m-1)+ k) = -c;
        
        % hor1 + ... + hor4 leq 3
        UglNo = UglNo + 1;
        b(UglNo) = 7;
        A(UglNo, tiles_HORISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORIIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORIVSTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORVSTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORVISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORVIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORVIIISTART + (i-1)*(m-1)+ k) = 1;
    end
end

for i = 1:m
    for xi = 1:l
        for beta = 1:maxTSVsPerTile+1
            for alpha = 1:maxRoutersPerTile+1
                %tiz - hkram1 leq 1/2 + xi
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 + xi;
                A(UglNo, tizSTART + i) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta1START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                
                % -tiz + -hkram2 leq -1/2 -xi
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - xi;
                A(UglNo, tizSTART + i) = -1;
                A(UglNo, tiles_HAreaXiIAlphaBeta2START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                
                % hirouter - hkram3 leq -1/2 + (alpha-1)
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 + alpha-1; % - hirouter(i);
                A(UglNo, routsv_hirouterSTART + i) = 1; 
                A(UglNo, tiles_HAreaXiIAlphaBeta3START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % -hirouter - hkram4 leq -1/2 -(alpha-1)
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - alpha+1; % + hirouter(i);
                A(UglNo, routsv_hirouterSTART + i) = -1; 
                A(UglNo, tiles_HAreaXiIAlphaBeta4START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % hiTSV - hkram5 leq -1/2 + (beta-1)
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 +beta-1; % - hiTSV(i);
                A(UglNo, routsv_hiTSVSTART + i) = +1; 
                A(UglNo, tiles_HAreaXiIAlphaBeta5START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                                
                % -hiTSV - hkram6 leq -1/2 -(beta-1)
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - beta+1; % + hiTSV(i);
                A(UglNo, routsv_hiTSVSTART + i) = -1; 
                A(UglNo, tiles_HAreaXiIAlphaBeta6START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % hkram1 + hkram2 + ... + hkram6 + (1- hkram0) leq 6
                UglNo = UglNo + 1;
                b(UglNo) = 5;
                A(UglNo, tiles_HAreaXiIAlphaBeta1START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta2START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta3START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta4START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta5START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta6START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -1;
                
                % hkram0 - tiz leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, tizSTART + i) = -1;
                A(UglNo, tiles_HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;                
            end
        end
    end
end

for i = 1:m
    % sum_{[l],[m-n+1],[m-m+1]} hkram0 leq 1
    UglNo = UglNo + 1;
    b(UglNo) = 1;
    for xi = 1:l
        for beta = 1:maxTSVsPerTile+1
            for alpha = 1:maxRoutersPerTile+1
                A( UglNo, tiles_HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
            end
        end
    end
end

%area constraint per tile
for i = 1:m
    % -ai - bi + sum_{[l],[m-n+1],[m-m+1]} hkram0 f(...)  leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, aiSTART + i)= -1;
    A(UglNo, biSTART + i)= -1;
    for xi = 1:l
        for beta = 1:maxTSVsPerTile+1
            for alpha = 1:maxRoutersPerTile+1
                A( UglNo, tiles_HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = F(alpha, beta, xi, i);
            end
        end
    end
end

%aspect ratio einhalten
for i = 1:m
    %a_i geq eta b_i
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, aiSTART + i) = -1;
    A(UglNo, biSTART + i) = eta;
    
    %a_i leq eta^-1 b_i
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, aiSTART + i) = 1;
    A(UglNo, biSTART + i) = -1/eta;
end


%flow ineq
disp('Generating grid based topology and TSVs between neighbored layers')
% grid based topology and TSVs between neighbored layers
% 14 * m^2 Ungl 
for i = 1:m
    for j = 1:m
        % #1
        % -hij*c + eij*c  leq c - r_iz + r_jz
        UglNo = UglNo + 1;
        %b(UglNo) = c - rz(i) + rz(j);
        b(UglNo) = c;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #2
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = c + rz(i) - rz(j);
        b(UglNo) = c;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #3
        % wie die erste, z und x tauschen, - flow_HOR1*c
        UglNo = UglNo + 1;
        %b(UglNo) = c - rx(i) + rx(j);
        b(UglNo) = c;
        A(UglNo, rixSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, flow_HORISTART + (i-1)*m + j) = -c ;
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #4
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = c + rx(i) - rx(j);
        b(UglNo) = c;
        A(UglNo, rixSTART + i) = -1;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, flow_HORISTART + (i-1)*m + j) = -c ;
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #5
        % wie die erste, z und y tauschen, (1- flow_HOR1*c)
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c - ry(i) + ry(j);
        b(UglNo) = 2*c;
        A(UglNo, riySTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, flow_HORISTART + (i-1)*m + j) = c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #6
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c + ry(i) - ry(j);
        b(UglNo) = 2*c;
        A(UglNo, riySTART + i) = -1;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, flow_HORISTART + (i-1)*m + j) = c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #7
        % - hijOR2*c + hij1 * c + e_ij * c leq r_iz - r_jz -1 + 2*c
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c + rz(i) - rz(j) -1;
        b(UglNo) = 2*c - 1;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, flow_HORIISTART + (i-1)*m + j) = -c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #8
        % - hijOR2*c + hij1 * c + e_ij * c leq r_jz - r_iz +1 + 2*c
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c - rz(i) + rz(j) +1;
        b(UglNo) = 2*c + 1;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, flow_HORIISTART + (i-1)*m + j) = -c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #9
        % hijOR2*c + hij1*c + e_ij*c leq r_iz - rjz +1 + 3*c
        UglNo = UglNo + 1;
        %b(UglNo) = 3*c + rz(i) - rz(j) +1;
        b(UglNo) = 3*c + 1;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, flow_HORIISTART + (i-1)*m + j) = c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;        
        
        % #10
        % hijOR2*c + hij1*c + e_ij*c leq -r_iz + rjz -1 + 3*c
        UglNo = UglNo + 1;
        %b(UglNo) = 3*c - rz(i) + rz(j) -1;
        b(UglNo) = 3*c - 1;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, flow_HORIISTART + (i-1)*m + j) = c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #11
        % hij1*c + e_ij*c leq rjx - rix + 2*c
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c - rx(i) + rx(j);
        b(UglNo) = 2*c;
        A(UglNo, rixSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #12
        % ri und rj tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c + rx(i) - rx(j);
        b(UglNo) = 2*c;
        A(UglNo, rixSTART + i) = -1;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #13
        % ri und rj und rx und ry tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c - ry(i) + ry(j);
        b(UglNo) = 2*c;
        A(UglNo, riySTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
             
        % #14
        % ri und rj tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c + ry(i) - ry(j);
        b(UglNo) = 2*c;
        A(UglNo, riySTART + i) = -1;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
    end
end

disp('forbid connections between non neighbored routers');
% Modul 1 bis 4, forbid connections between non neighbored routers
% 33 (m*(m-1)*(m-2)) ugl
for i = 1:m
    for jloop = 1:(m-1)
        for kloop = 1:(m-2)
            if (jloop<i)
                j= jloop;
            else
                j = jloop +1;
            end
            k = kloop;
            if (k >= i && k>= j)
                k = k +2;
            elseif (k >= j || k >= i)
                k = k +1;            
            end
            if (k==i || k==j)
                k = k+1;
            end
            %Fall A (riy <= rjy ; rix = rjx)
            
            % #1
            % - hijk1*c - hijor *c leq rjy - riy
            UglNo = UglNo +1;
            %b(UglNo) = ry(j) - ry(i);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + j) = -1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #2
            % -||- leq rjx - rix
            UglNo = UglNo +1;
            %b(UglNo) = rx(j) - rx(i);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + j) = -1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #3
            % -||- leq rix - rjx
            UglNo = UglNo +1;
            %b(UglNo) = rx(i) - rx(j);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + j) = 1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #4
            % Ungleichung I
            % -||- - hA1*c leq riy - rky
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(k);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + k) = 1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKa1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #5
            % Ungleichung II
            % -||- - hA2 leq - rjy + rky
            UglNo = UglNo +1;
            %b(UglNo) = - ry(j) + ry(k);
            b(UglNo) = 0;
            A(UglNo, riySTART + j) = 1;
            A(UglNo, riySTART + k) = -1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKa2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % #6
            % Ungleichung III
            % -||- - hA3 leq rix - rkx -delta
            UglNo = UglNo +1;
            %b(UglNo) = rx(i) - rx(k) - delta;
            b(UglNo) = -delta;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + k) = 1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKa3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #7
            % Ungleichung IV
            % -||- - hA4 leq - rix + rkx -delta
            UglNo = UglNo +1;
            %b(UglNo) = -rx(i) + rx(k) -delta;
            b(UglNo) = -delta;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + k) = -1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKa4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall B (rjy <= riy ; rix = rjx)------------------------------
            
            % - hijk2*c - hijor *c leq riy - rjy
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(j);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + j) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjx - rix
            UglNo = UglNo +1;
            %b(UglNo) = rx(j) - rx(i);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + j) = -1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rix - rjx
            UglNo = UglNo +1;
            %b(UglNo) = rx(i) - rx(j);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + j) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hB1*c leq -riy + rky
            UglNo = UglNo +1;
            %b(UglNo) = - ry(i) + ry(k);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + k) = -1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKb1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq + rjy - rky
            UglNo = UglNo +1;
            %b(UglNo) = + ry(j) - ry(k);
            b(UglNo) = 0;
            A(UglNo, riySTART + j) = -1;
            A(UglNo, riySTART + k) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKb2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq - rix + rkx -delta
            UglNo = UglNo +1;
            %b(UglNo) = - rx(i) + rx(k) - delta;
            b(UglNo) = -delta;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + k) = -1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKb3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq + rix - rkx -delta
            UglNo = UglNo +1;
            %b(UglNo) = +rx(i) - rx(k) -delta;
            b(UglNo) = -delta;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + k) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKb4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall C (rix <= rjx ; riy = rjy)------------------------------
            
            % - hijk1*c - hijor *c leq rjx - rix
            UglNo = UglNo +1;
            %b(UglNo) = rx(j) - rx(i);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + j) = -1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq riy - rjy
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(j);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + j) = 1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjy - riy
            UglNo = UglNo +1;
            %b(UglNo) = ry(j) - ry(i);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + j) = -1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hA1*c leq rix - rkx
            UglNo = UglNo +1;
            %b(UglNo) = rx(i) - rx(k);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + k) = 1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKc1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq - rjx + rkx
            UglNo = UglNo +1;
            %b(UglNo) = - rx(j) + rx(k);
            b(UglNo) = 0;
            A(UglNo, rixSTART + j) = 1;
            A(UglNo, rixSTART + k) = -1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKc2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq - riy + rky -delta
            UglNo = UglNo +1;
            %b(UglNo) = - ry(i) + ry(k) - delta;
            b(UglNo) = -delta;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + k) = -1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKc3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq + riy - rky -delta
            UglNo = UglNo +1;
            %b(UglNo) = +ry(i) - ry(k) -delta;
            b(UglNo) = -delta;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + k) = 1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKc4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall D (rjx <= rix ; riy = rjy)
            
            
            % - hijk1*c - hijor *c leq -rjx + rix
            UglNo = UglNo +1;
            %b(UglNo) = -rx(j) + rx(i);
            b(UglNo) = 0;
            A(UglNo, rixSTART + j) = 1;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq riy - rjy
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(j);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + j) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjy - riy
            UglNo = UglNo +1;
            %b(UglNo) = ry(j) - ry(i);
            b(UglNo) = 0;
            A(UglNo, riySTART + j) = -1;
            A(UglNo, riySTART + i) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hA1*c leq - rix + rkx
            UglNo = UglNo +1;
            %b(UglNo) = -rx(i) + rx(k);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + k) = -1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKd1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq + rjx - rkx
            UglNo = UglNo +1;
            %b(UglNo) =  rx(j) - rx(k);
            b(UglNo) = 0;
            A(UglNo, rixSTART + j) = -1;
            A(UglNo, rixSTART + k) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKd2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq riy - rky -delta
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(k) - delta;
            b(UglNo) = -delta;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + k) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKd3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq - riy + rky -delta
            UglNo = UglNo +1;
            %b(UglNo) = -ry(i) + ry(k) -delta;
            b(UglNo) = -delta;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + k) = -1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKd4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #29
            % VerODERung von abcd1 .. abcd4
            % hijka1 + hijka2 + ... + hijka4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJKa1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKa2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKa3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKa4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #30
            % hijkb1 + hijkb2 + ... + hijkb4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJKb1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKb2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKb3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKb4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #31
            % hijkc1 + hijkc2 + ... + hijkc4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJKc1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKc2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKc3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKc4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #32
            % hijkd1 + hijkd2 + ... + hijkd4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJKd1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKd2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKd3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKd4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #33
            % VerODERung hijk1 bis hijk4
            % hijk1 + ... +hijk4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
        end
    end
end

disp('genrating Modul 5, forbid connections between non neighbored routers')
% Modul 5, forbid connections between non neighbored routers
% 3* m* (m-1) Ugl
for i = 1:m
    for jloop = 1:(m-1)
        if (jloop<i)
            j= jloop;
        else
            j = jloop +1;
        end
        % module 5
        % #1
        % eij - hij1*c + hijOR*c leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, eSTART + (i-1)*m + j ) = 1 ;
        A(UglNo, flow_HIJ1START + (i-1)*(m-1) + jloop ) = -c ;
        A(UglNo, flow_HIJORSTART + (i-1)*(m-1) + jloop ) = c ;
        
        % #2
        % - hij2*c + hijOR*c leq rz(j) - rz(i) -1/2 +c
        UglNo = UglNo +1;
        %b(UglNo) = rz(j) - rz(i) -1/2 + c;
        b(UglNo) = -1/2 + c;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, flow_HIJ2START + (i-1)*(m-1) + jloop ) = -c ;
        A(UglNo, flow_HIJORSTART + (i-1)*(m-1) + jloop ) = c ;
        
        % #3
        % - hij3*c + hijOR*c leq rz(i) - rz(j) -1/2 +c
        UglNo = UglNo +1;
        %b(UglNo) = rz(i) - rz(j) -1/2 + c;
        b(UglNo) = -1/2 + c;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, flow_HIJ3START + (i-1)*(m-1) + jloop ) = -c ;
        A(UglNo, flow_HIJORSTART + (i-1)*(m-1) + jloop ) = c ;
        
        % #4
        % hij1 +hij2 + hij3 leq 2
        UglNo = UglNo +1;
        b(UglNo) = 2;
        A(UglNo, flow_HIJ1START + (i-1)*(m-1) + jloop ) = 1 ;
        A(UglNo, flow_HIJ2START + (i-1)*(m-1) + jloop ) = 1 ;
        A(UglNo, flow_HIJ3START + (i-1)*(m-1) + jloop ) = 1 ;
    end
end

disp('routers are not self-connected');
% routers are not self-connected
for i = 1:m
    % e ii leq 0
    UglNo = UglNo +1;
    b(UglNo) = 0;
    A(UglNo, eSTART + (i-1)*m + i)=1;
end

% e_ij = eji
for i = 1:m
    for jloop= 1:(m-1)
        if (jloop<i)
            j= jloop;
        else
            j = jloop +1;
        end
        % e_ij - e_ji leq 0
        UglNo = UglNo +1;
        b(UglNo) = 0;
        A(UglNo, eSTART + (i-1)*m + j)= 1;
        A(UglNo, eSTART + (j-1)*m + i)= -1;
        
        % e_ji - e_ij leq 0
        UglNo = UglNo +1;
        b(UglNo) = 0;
        A(UglNo, eSTART + (i-1)*m + j)= 1;
        A(UglNo, eSTART + (j-1)*m + i)= -1;
    end
end

disp('Kanten von Routern zu sich selbst verbieten')
% Kanten von Routern zu sich selbst verbieten .
for i = 1:m
    UglNo = UglNo +1;
    b(UglNo) = 0;
    A(UglNo, eSTART + (i-1)*m + i) = 1;
end

disp('Flüsse nutzen nur Kanten, die auch da sind')
% Flüsse nutzen nur Kanten, die auch da sind .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            for k = 1:m
                for ll = 1:m
                    UglNo = UglNo +1;
                    %b(UglNo) = eN((k-1)*m + l);
                    b(UglNo) = 0;
                    A(UglNo, eSTART + (k-1)*m + ll) = -1;
                    A(UglNo, fSTART + (fNo-1) * m^2 + (k-1)*m + ll) = 1;
                end
            end
        end
    end
end

disp('Ueberschuss Quelle');
% Überschuss Quelle .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            GlNo = GlNo +1;
            beq(GlNo) = 1;
            for kloop = 1:(m-1)
                if (kloop >= i)
                    k = kloop+1;
                else
                    k= kloop;
                end
                % ausgehende Kanten (i,k)
                Aeq(GlNo, fSTART + (fNo-1)* m^2 + (i-1)*m + k)= 1;
                % eingehende Kanten (k,i)
                Aeq(GlNo, fSTART + (fNo-1)* m^2 + (k-1)*m + i)= -1;
            end
        end
    end
end
  
disp('Abfluss Senke')
% Abfluss Senke .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            GlNo = GlNo +1;
            beq(GlNo) = 1;
            for kloop = 1:(m-1)
                if (kloop >= j)
                    k = kloop+1;
                else
                    k= kloop;
                end
                % ausgehende Kanten (j,k)
                Aeq(GlNo, fSTART + (fNo-1)* m^2 + (j-1)*m + k)= -1;
                % eingehende Kanten (k,j)
                Aeq(GlNo, fSTART + (fNo-1)* m^2 + (k-1)*m + j)= 1;
            end
        end
    end
end

disp('Flusserhaltung')
% Flusserhaltung .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            for k = 1:m
                if (k ~= i && k~=j)
                    GlNo = GlNo +1;
                    beq(GlNo) = 0;
                    for lloop = 1:(m-1)
                        if (lloop >= k)
                            ll = lloop+1;
                        else
                            ll = lloop;
                        end
                        % eingehende Kanten (l,k)
                        Aeq(GlNo, fSTART + (fNo-1)* m^2 + (ll-1)*m + k)= 1;
                        % ausgehende Kanten (k,l)
                        Aeq(GlNo, fSTART + (fNo-1)* m^2 + (k-1)*m + ll)= -1;
                    end
                end
            end
        end
    end
end

disp('Azyklischer Fluss 1 ')
% Hilfsvariable für acyclic flow; ist 1 wenn f_ijkl > 0
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            for k = 1:m
                for ll = 1:m
                    UglNo = UglNo +1;
                    b(UglNo) = 0;
                    A(UglNo, fSTART + (fNo-1)*m^2 + (k-1)*m + ll )= 1;
                    A(UglNo, hSTART + (fNo-1)*m^2 + (k-1)*m + ll )= -1;
                end
            end
        end
    end
end

disp('Azyklischer Fluss 2')
% acyclic flow .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            for k = 1:m
                for ll = 1:m
                    UglNo = UglNo +1;
                    b(UglNo) = m - 1/2;
                    A(UglNo, GammaSTART + (fNo-1)*m + k )= 1;
                    A(UglNo, GammaSTART + (fNo-1)*m + ll )= -1;
                    A(UglNo, hSTART + (fNo-1)*m^2 + (k-1)*m + ll )= m;
                end
            end
        end
    end
end


% Links don't cross tiles
% -------------------------------------------------------------------------
disp('Links dont cross tiles')
for i= 1:m
    for jloop=1:m-1
        for kloop=1:m-2
            if (jloop<i)
                j= jloop;
            else
                j = jloop +1;
            end
            k = kloop;
            if (k >= i && k>= j)
                k = k +2;
            elseif (k >= j || k >= i)
                k = k +1;            
            end
            if (k==i || k==j)
                k = k+1;
            end
            %disp(['i: ', num2str(i), 'j: ', num2str(j), 'k: ', num2str(k)])
            % #1
            % rix leq tkx + hijk1*c + hijor*c
                % umgestellt: rix -tkx -c*hijk1 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, rixSTART+ i) = 1;
            A(UglNo, tixSTART+ k) = -1;
            A(UglNo, cross_HIJK1START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #2
            % rjx leq tkx + hijk1*c + hijor*c
                % umgestellt: rjx -tkx -c*hijk1 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, rixSTART+ j) = 1;
            A(UglNo, tixSTART+ k) = -1;
            A(UglNo, cross_HIJK1START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #3
            % riy leq tky + hijk2*c + hijor*c
                % umgestellt: riy -tky -c*hijk2 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, riySTART+ i) = 1;
            A(UglNo, tiySTART+ k) = -1;
            A(UglNo, cross_HIJK2START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #4
            % rjy leq tky + hijk2*c + hijor*c
                % umgestellt: rjy -tky -c*hijk2 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, riySTART+ j) = 1;
            A(UglNo, tiySTART+ k) = -1;
            A(UglNo, cross_HIJK2START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #5
            % rix geq tkx + ak - hijk3*c - hijor*c
                % umgestellt: -rix +tkx +ak -c*hijk3 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, rixSTART+ i) = -1;
            A(UglNo, tixSTART+ k) = 1;
            A(UglNo, aiSTART+ k) = 1;
            A(UglNo, cross_HIJK3START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #6
            % rjx geq tkx + ak - hijk3*c - hijor*c
                % umgestellt: -rjx +tkx +ak -c*hijk3 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, rixSTART+ j) = -1;
            A(UglNo, tixSTART+ k) = 1;
            A(UglNo, aiSTART+ k) = 1;
            A(UglNo, cross_HIJK3START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #7
            % riy geq tky + bk - hijk4*c - hijor*c
                % umgestellt: -riy +tky +bk -c*hijk4 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, riySTART+ i) = -1;
            A(UglNo, tiySTART+ k) = 1;
            A(UglNo, biSTART+ k) = 1;
            A(UglNo, cross_HIJK4START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #8
            % rjy geq tky + bk - hijk4*c - hijor*c
                % umgestellt: -rjy +tky +bk -c*hijk4 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, riySTART+ j) = -1;
            A(UglNo, tiySTART+ k) = 1;
            A(UglNo, biSTART+ k) = 1;
            A(UglNo, cross_HIJK4START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #9
            % 1/2 + tkz leq rjz + hijk5*c + hijor*c
                % umgestellt: tkz -rjz -c*hijk5 -c*hijor leq -1/2
            UglNo = UglNo+1;
            b(UglNo) = -0.5;
            A(UglNo, tizSTART+ k) = 1;
            A(UglNo, rizSTART+ j) = -1;
            A(UglNo, cross_HIJK5START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % % #10
            % 1/2 + rjz leq tkz + hijk6*c + hijor*c
                % umgestellt: rjz -tkz -c*hijk6 -c*hijor leq -1/2
            UglNo = UglNo+1;
            b(UglNo) = -0.5;
            A(UglNo, rizSTART+ j) = 1;
            A(UglNo, tizSTART+ k) = -1;
            A(UglNo, cross_HIJK6START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #11
            % 1/2 + riz leq rjz + hijk7*c + hijor*c
                % umgestellt: riz -rjz -c*hijk7 -c*hijor leq -1/2
            UglNo = UglNo+1;
            b(UglNo) = -0.5;
            A(UglNo, rizSTART+ i) = 1;
            A(UglNo, rizSTART+ j) = -1;
            A(UglNo, cross_HIJK7START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #12
            % 1/2 + rjz leq riz + hijk8*c + hijor*c
                % umgestellt: rjz -riz -c*hijk8 -c*hijor leq -1/2
            UglNo = UglNo+1;
            b(UglNo) = -0.5;
            A(UglNo, rizSTART+ j) = 1;
            A(UglNo, rizSTART+ i) = -1;
            A(UglNo, cross_HIJK8START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #13
            % hijk1 + ... + hijk8 leq 7
            UglNo = UglNo+1;
            b(UglNo) = 7;
            A(UglNo, cross_HIJK1START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK2START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK3START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK4START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK5START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK6START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK7START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK8START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
        end
    end
end           

for i= 1:m
    for jloop = 1:m-1
        if (jloop<i)
            j= jloop;
        else
            j = jloop +1;
        end
        % eij leq (1-hijor)*c
            % umgestellt: eij + c*hijor leq c
        UglNo = UglNo+1;
        b(UglNo) = c;
        A(UglNo, eSTART+ (i-1)*(m) + j) = 1;
        A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = c;
            % Bemerke: bei e ist es j, bei h jloop. Mit Absicht.
    end
end

% hiRouter, hiTSV berechnen
%-------------------------------------------------------------------------

% hiRouter-Ungleichungen
disp('Berechung der Router per Tile')
for i = 1:m
    for j = n+1:m
        % #1
        % rjx + 0.5delta leq tix + hij*c + hij1*c
            % umgestellt: rjx - tix -c*hij - c* hij1 leq -0.5*delta
        UglNo = UglNo +1;
        b(UglNo) = -0.5*delta;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, tixSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ1START + (i-1)*(m-n) + j-n) = -c;
        
        % #2
        % tix + ai + 0.5delta leq rjx + hij*c + hij2*c
            % umgestellt: tix + ai - rjx - c*hij - c*hij2 leq - 0.5delta
        UglNo = UglNo +1;
        b(UglNo) = -0.5*delta;
        A(UglNo, tixSTART + i) = 1;
        A(UglNo, aiSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ2START + (i-1)*(m-n) + j-n) = -c;
            
        % #3
        % rjy + 0.5delta leq tiy hij*c + hij3*c
            % umgestellt: rjy - tiy - c*hij - c*hij3 leq - 0.5delta
        UglNo = UglNo +1;
        b(UglNo) = -0.5*delta;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, tiySTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ3START + (i-1)*(m-n) + j-n) = -c;
        
        % #4
        % tiy + bi + 0.5delta leq rjy + hij*c + hij4*c
            % umgestellt: tiy + bi - rjy - c*hij - c*hij4 leq - 0.5delta
        UglNo = UglNo +1;
        b(UglNo) = -0.5*delta;
        A(UglNo, tiySTART + i) = 1;
        A(UglNo, biSTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ4START + (i-1)*(m-n) + j-n) = -c;
        
        % #5
        % rjz + 0.5 leq tiz + hij*c + hij5*c
            % umgestellt: rjz - tiz - c*hij - c* hij5 leq -0.5
        UglNo = UglNo +1;
        b(UglNo) = -0.5;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, tizSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ5START + (i-1)*(m-n) + j-n) = -c;
        
        % #6
        % tiz + 0.5 leq rjz + hij*c + hij6*c
            % umgestellt: tiz -rjz - c*hij - c*hij6 leq -0.5
        UglNo = UglNo +1;
        b(UglNo) = -0.5;
        A(UglNo, tizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ6START + (i-1)*(m-n) + j-n) = -c;
        
        % #7
        % hij1 + hij2 + hij3 + hij4 + hij5 + hij6 leq 5
        UglNo = UglNo +1;
        b(UglNo) = 5;
        A(UglNo, routsv_HIJ1START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ2START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ3START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ4START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ5START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ6START + (i-1)*(m-n) + j-n) = 1;
        
        % #8
        % tix leq rjx + (1-hij)*c
            % umgestellt: tix -rjx +c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, tixSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
        % #9
        % rjx leq tix + ai + (1-hij)*c
            % umgestellt: rjx - tix - ai + c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, tixSTART + i) = -1;
        A(UglNo, aiSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
            
        % #10
        % tiy leq rjy + (1-hij)*c
            % umgestellt: tiy - rjy + c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, tiySTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
        % #11
        % rjy leq tiy + bi + (1-hij)*c
            % umgestellt: rjy - tiy - bi + c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, tiySTART + i) = -1;
        A(UglNo, biSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
        % #12
        % tiz leq rjz + (1-hij)*c
            % umgestellt: tiz - rjz + c* hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, tizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
        % #13
        % rjz leq tiz + (1-hij)*c
            % umgestellt: rjz - tiz + c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, tizSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
    end
end

for i = 1:n
    % #1.1
    % hirouter = sum_{j=n+1}^{m}(hij) + 1
        % umgestellt: sum - hirouter = -1
    GlNo = GlNo +1;
    beq(GlNo) = -1;
    Aeq(GlNo, routsv_hirouterSTART + i) = -1;
    for j=n+1:m
        Aeq(GlNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = 1;
    end
end
for i = n+1:m
    % #1.2
    % hirouter = sum_{j=n+1}^{m}(hij)
        % umgestellt: sum - hirouter = 0
    GlNo = GlNo +1;
    beq(GlNo) = 0;
    Aeq(GlNo, routsv_hirouterSTART + i) = -1;
    for j=n+1:m
        Aeq(GlNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = 1;
    end
end

% hj-Dach-Ungleichungen
disp('Berechnung der TSVs per tile')
for j=1:m
    for kloop = 1:(m-1)
        if (kloop<j)
            k = kloop;
        else
            k = kloop +1;
        end
        % #1
        % rjz leq rkz + hjkor*c + hdachj*c
            % umgstellt: rjz - rkz - c*hjkor - c*hdachj leq 0
        UglNo = UglNo + 1;
        b(UglNo) = 0;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rizSTART + k) = -1;
        A(UglNo, routsv_HJKORSTART + (j-1)*(m-1) + kloop) = -c;
        A(UglNo, routsv_hatHJSTART + j) = -c;
        % #2
        % rkz leq rjz + hjkor*c + hdachj*c
            % umgestellt: rkz - rjz - c*hjkor - c*hdachj leq 0
        UglNo = UglNo + 1;
        b(UglNo) = 0;
        A(UglNo, rizSTART + k) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, routsv_HJKORSTART + (j-1)*(m-1) + kloop) = -c;
        A(UglNo, routsv_hatHJSTART + j) = -c;
        % #3
        % ejk leq 0 + (1-hjkor)*c + hdachj*c
            % umgestellt: ejk + c*hjkor - c*hdachj leq c
        UglNo = UglNo + 1;
        b(UglNo) = c;
        A(UglNo, eSTART + (j-1)*m + k) = 1;
        A(UglNo, routsv_HJKORSTART + (j-1)*(m-1) + kloop) = c;
        A(UglNo, routsv_hatHJSTART + j) = -c;
        % #4
        % 1 leq ejk + hjktilde*c
            % umgestellt: -ejk - c*hjktilde leq -1
        UglNo = UglNo + 1;
        b(UglNo) = -1;
        A(UglNo, eSTART + (j-1)*m + k) = -1;
        A(UglNo, routsv_tildeHJKSTART + (j-1)*(m-1) + kloop) = -c;
        % #5
        % rjz leq rkz - .5 + hjkortilde*c + hjktilde*c
            % umgestellt: rjz - rkz -c*hjkortilde - c*hjktilde leq - 0.5
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rizSTART + k) = -1;
        A(UglNo, routsv_tildeHJKORSTART + (j-1)*(m-1) + kloop) = -c;
        A(UglNo, routsv_tildeHJKSTART + (j-1)*(m-1) + kloop) = -c;
        % #6
        % rkz leq rjz - .5 + (1- hjkortilde)*c + hjktilde*c
            % umgestellt: rkz - rjz + c*hjkortilde - c*hjktilde leq -0.5 +c
        UglNo = UglNo + 1;
        b(UglNo) = -0.5 + c;
        A(UglNo, rizSTART + k) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, routsv_tildeHJKORSTART + (j-1)*(m-1) + kloop) = c;
        A(UglNo, routsv_tildeHJKSTART + (j-1)*(m-1) + kloop) = -c;
    end
end

for j = 1:m
    % #7
    % sum_k(hjktilde) leq m-2+(1- hdachj)
        % umgestellt: sum_k(hjktilde) + hdachj leq m-1
    UglNo = UglNo + 1;
    b(UglNo) = m-1;
    A(UglNo, routsv_hatHJSTART + j) = 1;
    for kloop = 1:(m-1)
        A(UglNo, routsv_tildeHJKSTART + (j-1)*(m-1) + kloop) = 1;
    end
end


for i= 1:m
    for jloop = 1:m-n
        j = jloop + n;
        % (1 - hdachij) + hij + hhatj leq 2
        % - hdachij + hij + hhatj leq 1
        UglNo = UglNo + 1;
        b(UglNo) = 1;
        A(UglNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + jloop) = 1; %jloop da m*(m-n) lang
        A(UglNo, routsv_hatHJSTART + j) = 1;
        
        % hdachij - hhatj leq 0
        UglNo = UglNo + 1;
        b(UglNo) = 0;
        A(UglNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = 1;
        A(UglNo, routsv_hatHJSTART + j) = -1;
        
        % hdachij - hij leq 0
        UglNo = UglNo + 1;
        b(UglNo) = 0;
        A(UglNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = 1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + jloop) = -1;
    end
end

% hiTSV setzen
for i = 1:n
    %hiTSV = hdachii + sum_{j \in [n+1, ..., m]} hdachij
    %  hiTSV - hdachii - sum_{j \in [n+1, ..., m]} hdachij = 0
    GlNo = GlNo +1;
    beq(GlNo) = 0;
    Aeq(GlNo, routsv_hiTSVSTART + i) = 1;
    Aeq(GlNo, routsv_hatHJSTART + i) = -1;
    for jloop = 1: m-n
        Aeq(GlNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = -1;
    end
end

for i = n+1:m
    %hiTSV = sum_{j \in [n+1, ..., m]} hdachij
    %  hiTSV - sum_{j \in [n+1, ..., m]} hdachij = 0
    GlNo = GlNo +1;
    beq(GlNo) = 0;
    Aeq(GlNo, routsv_hiTSVSTART + i) = 1;
    for jloop = 1: m-n
        Aeq(GlNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = -1;
    end
end

% routers and tiles
% ------------------------------------------------------------------------

for jloop = 1:m-n
    j = jloop + n;
    % sum_i(routsv_hij) geq 1
        % umgestellt: sum_i(-routsv_hij) leq -1
    UglNo = UglNo + 1;
    b(UglNo) = -1;
    for i = 1:m
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + jloop) = -1;
    end
end

% cPeak
% ------------------------------------------------------------------------

% cPeak = sum_{m^2} (hmax)
    % umgestellt: cPeak - sum = 0
GlNo = GlNo + 1;
beq(GlNo) = 0;
Aeq(GlNo, cPeakSTART + 1) = 1;
for i = 1:m^2
    Aeq(GlNo, cPeak_hmaxSTART + i)= -1;    
end

% mu = sum_(m^2)(load) / sum_(m^2)(eij)
    % umgestellt: mu = n^2-n
GlNo = GlNo + 1;
beq(GlNo) = n^2-n;
Aeq(GlNo, cPeak_muSTART + 1) = 1;

for i = 1:m^2
    % load = sum_(EA)(u*f^eA_eN)
        % umgestellt: load - sum = 0
    GlNo = GlNo + 1;
    beq(GlNo) = 0;
    Aeq(GlNo, cPeak_loadSTART + i) = 1;
    fNo = 0;
    for ii = 1:n
        for j = 1:n
            if (eA((ii-1)*n + j) == 1)
                fNo = fNo+1;
                Aeq(GlNo, fSTART + (fNo-1) * m^2 + i) = -u( (ii-1)*n + j );
            end
        end
    end
    
    % hmax geq 0
        % umgestellt: -hmax leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, cPeak_hmaxSTART + i) = -1;

    % hmax geq load - mu
        % umgestellt: load - mu - hmax leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, cPeak_loadSTART + i) = 1;
    A(UglNo, cPeak_muSTART + i) = -1;
    A(UglNo, cPeak_hmaxSTART + i) = -1;
end    

toc           
%% setting bounds

lb = zeros(1,anzahlVar);
ub = Inf * ones(1,anzahlVar);

%lower bound der tiz in denen komponenten sind
notBoundIndexes = tizSTART + 1 : tizSTART + n;
lb(notBoundIndexes) = 1 * ones(length(notBoundIndexes), 1);

%upper bound der ungebundenen varibalen
ub = ones(1,anzahlVar);
notBoundIndexes = hcSTART + 1 : rizSTART + rizLENGTH;
ub(notBoundIndexes) = Inf * ones(length(notBoundIndexes), 1);

%tiz und riz sind durch die anzahl der layer l gebunden
notBoundIndexes = tizSTART + 1 : tizSTART + tizLENGTH;
ub(notBoundIndexes) = l * ones(length(notBoundIndexes), 1);
notBoundIndexes = rizSTART + 1 : rizSTART + tizLENGTH;
ub(notBoundIndexes) = l * ones(length(notBoundIndexes), 1);

%alle hilfsvariablen sind durch 1 gebunden, da binaer
notBoundIndexes = tiles_HORISTART + 1 : tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH;
ub(notBoundIndexes) = 1 * ones(length(notBoundIndexes), 1);

%upper bound der integer binary hilfsvaribalen
boundIndexes = eSTART + 1 : anzahlVar;
ub(boundIndexes) = 1 * ones(length(boundIndexes), 1);

%nur die gamma sind nicht durch eins gebunden
boundIndexes = GammaSTART + 1 : GammaSTART + GammaLENGTH;
ub(boundIndexes) = m * ones(length(boundIndexes), 1);

% die hirouter sind auch nicht durch eins gebunden
boundIndexes = routsv_hirouterSTART + 1 : routsv_hirouterSTART + routsv_hirouterLENGTH;
ub(boundIndexes) = m * ones(length(boundIndexes), 1);

% die routsv_hiTSVSTART sind auch nicht durch eins gebunden
boundIndexes = routsv_hiTSVSTART+ 1 : routsv_hiTSVSTART + routsv_hiTSVLENGTH;
ub(boundIndexes) = Inf * ones(length(boundIndexes), 1);

% die cPeak-Variablen sind auch nicht durch eins gebunden
boundIndexes = cPeakSTART+ 1 : cPeak_hmaxSTART + cPeak_hmaxLENGTH;
ub(boundIndexes) = Inf * ones(length(boundIndexes), 1);


%% lin

if(~useCPLEX)
options = optimoptions('intlinprog','MaxTime',OptimizationTime);
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub, options);
else
    sostype = [];
    sosind = [];
    soswt = [];
    if(~x0given)
        x0 = [];
    end
    x = cplexmilp(f,A,b,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype, x0, options);
end
if (saveSolution)
    save(saveSolutionName, 'x');
end
%solution = x(aiSTART + 1 : tizSTART + tizLENGTH)

%% plot
if (usePlotting)
    startX = x(tixSTART + 1: tixSTART + tixLENGTH);
    startY = x(tiySTART + 1: tiySTART + tiyLENGTH);
    startZ = x(tizSTART + 1: tizSTART + tizLENGTH);
    ai = x(aiSTART + 1: aiSTART + aiLENGTH);
    bi = x(biSTART + 1: biSTART + biLENGTH);
    %clf
    %close all

    for fNo = 1%:sum(eA)
        figure(2)
        hold on

        %plot tiles
        for i =1: m
            x1 = startX(i);
            x2 = startX(i)+ai(i);
            x3 = startX(i)+ai(i);
            x4 = startX(i);
            y1 = startY(i);
            y2 = startY(i);
            y3 = startY(i)+bi(i);
            y4 = startY(i)+bi(i);
            z = startZ(i);   
            plot3( [x1 x2 x3 x4 x1], [y1 y2 y3 y4 y1], [z z z z z] )
        end

        %plot routers and network
        for router = 1:m
            plot3([x(rixSTART + router)],[x(riySTART + router)],[x(rizSTART + router)], 'k*')
        end
        for i =1:n
            for j= 1:n
                if (eA((i-1)*n + j) == 1 && sum(eA(1:(i-1)*n + j)~=0) == fNo) %hinterer teil schaut ob man im richtigen fluss ist
                    plot3([x(rixSTART +i)],[x(riySTART + i)],[x(rizSTART + i)], 'c*', 'MarkerSize',12)
                    plot3([x(rixSTART +j)],[x(riySTART + j)],[x(rizSTART + j)], 'g*', 'MarkerSize',12)
                end
            end
        end

        %plot links in network
        for i =1: m
            for j= 1:m
                if (x(eSTART + (i-1)*m + j) > 0.5)
                     plot3([x(rixSTART+i), x(rixSTART+j)],[x(riySTART+i), x(riySTART+j)],[x(rizSTART+i), x(rizSTART+j)], 'k')
                end
            end
        end

        %plot flows
        for i =1: m
            for j= 1:m
                %is there flow?
                if (x(fSTART + (fNo-1)* m^2 + (i-1)*m + j) > 0.001)
                     %plot3([rixSTART+i rixSTART+j],[riySTART+i riySTART+j],[rizSTART+i rizSTART+j], 'r')
                     quiver3(x(rixSTART+i), x(riySTART+i), x(rizSTART+i), x(rixSTART+j)-x(rixSTART+i), x(riySTART+j)-x(riySTART+i), x(rizSTART+j)-x(rizSTART+i), 'r')
                     text( mean([x(rixSTART+i) x(rixSTART+j)]),mean([x(riySTART+i) x(riySTART+j)]),mean([x(rizSTART+i) x(rizSTART+j)]), num2str(x(fSTART + (fNo-1)* m^2 + (i-1)*m + j)) );
                end
            end
        end
        hold off
    end
    
end