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

%clear all

addpath('I:\Program Files\IBM\ILOG\CPLEX_Studio1271\cplex\matlab\x64_win64');
useCPLEX = false;
useSPARSE = true;
OptimizationTime = 60;
options = cplexoptimset('Display', 'on', 'MaxTime', 600);

OptimizationTime = 600;

%m \geq n
m = 5;
n = 3;
l = 3;
eta = 1;
%F = FV_CostMatrix(n,m,l,eta);
delta = 0.1;
phi = [0,0,0];
c = 1000;
xMax = 100;
yMax = 100;
eN = zeros(m^2,1);

% bitte m 
rix = [1 1 1 1.5 1.5];
riy = [1 1 1 1.5 1.5];
riz = [1 2 3 1 2];
tix = [1 1 1 0 0];
tiy = [1 1 1 0 0];
tiz = [1 2 3 0 0];
ai = [0.8 0.8 0.8 0 0];
bi = [0.8 0.8 0.8 0 0];
% eN, i<j (j<i automatisch)
eN(2) = 1;
eN(8) = 1;
eN(20) = 1;

% E_A
% HINWEIS: Kanten zu sich selbst sind verboten.
eA = zeros(n^2,1);
eA(2) = 1;

%eA(3) = 1;
%eA(4) = 1;
%eA(7) = 1;
%eA(2) = 1;
%eA(14) = 1;

maxRoutersPerTile = m-n+1;
maxTSVsPerTile = m-n+1;

%sind noch manuell gesetzt. muessen berechnet werden!
% Aufgrund der Indezierung in der Kostenmatrix F gilt, dass index 1 mit 0
% routern korresponiert. D.h. wenn die variable hirouter 1 ist, ist in dem
% tile kein router. Gleiches gilt für die tsvs
routersPerTile = 1;
TSVsPerTile = 0;
hirouter = (routersPerTile + 1) * ones(1,m);%floor(maxRoutersPerTile*rand(1,m))+1;
hiTSV = (TSVsPerTile + 1) * ones(1,m);%floor(maxTSVsPerTile*rand(1,m))+1;

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
% Anzahl der Variablen
anzahlVar = routsv_hiTSVSTART + routsv_hiTSVLENGTH;

% Anzahl der Ungleichungen

anzahlUglHIROUTER = 13*m*(m-n);
anzahlUglhatHJ = 6*m*(m-1)+ m;
anzahlUglhatHJK = 3 * m * (m-n);
anzahlUgl = anzahlUglHIROUTER + anzahlUglhatHJ +anzahlUglhatHJK;

% Anzahl der Gleichungen

anzahlGlHIROUTER = m;
anzahlGlHITSV = m;
anzahlGlEingabe_einlesen = 8*m + 2*(m*(m-1)/2 + m);
anzahlGl = anzahlGlEingabe_einlesen + anzahlGlHIROUTER + anzahlGlHITSV;

%% genereiere kostenfunktion
f= zeros(1,anzahlVar);

% Möglichst hohe Layer
%f(rizSTART+1:rizSTART+rizLENGTH)=-1;

%generiert ein Quadarat
f(hcSTART+ 1) = 1;

%aus dem flow:
f(eSTART + 1 : eSTART + eLENGTH) = 1;
f(fSTART+1:fSTART+fLENGTH) = 1;

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
    % by default: all continous
    ctype(:) = 'C';
    %integer varaibles
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

% Eingabe einlesen
for i = 1:m
    % tix = tix
    GlNo = GlNo+1;
    beq(GlNo)= tix(i);
    Aeq(GlNo, tixSTART + i ) = 1;
    
    % tiy = tiy
    GlNo = GlNo+1;
    beq(GlNo)= tiy(i);
    Aeq(GlNo, tiySTART + i ) = 1;

    % tiz = tiz
    GlNo = GlNo+1;
    beq(GlNo)= tiz(i);
    Aeq(GlNo, tizSTART + i ) = 1;

    % rix = rix
    GlNo = GlNo+1;
    beq(GlNo)= rix(i);
    Aeq(GlNo, rixSTART + i ) = 1;

    % riy = riy
    GlNo = GlNo+1;
    beq(GlNo)= riy(i);
    Aeq(GlNo, riySTART + i ) = 1;

    % riz = riz
    GlNo = GlNo+1;
    beq(GlNo)= riz(i);
    Aeq(GlNo, rizSTART + i ) = 1;

    % ai = ai
    GlNo = GlNo+1;
    beq(GlNo)= ai(i);
    Aeq(GlNo, aiSTART + i ) = 1;

    % bi = bi
    GlNo = GlNo+1;
    beq(GlNo)= bi(i);
    Aeq(GlNo, biSTART + i ) = 1;
    
    for j=1:m
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



%% lin

if(~useCPLEX)
    options = optimoptions('intlinprog','MaxTime',OptimizationTime);
    x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub, options);
else
    sostype = [];
    sosind = [];
    soswt = [];
    x0 = [];
    x = cplexmilp(f,A,b,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype, x0, options);
end

%solution = x(aiSTART + 1 : tizSTART + tizLENGTH)

%% plot
startX = x(tixSTART + 1: tixSTART + tixLENGTH);
startY = x(tiySTART + 1: tiySTART + tiyLENGTH);
startZ = x(tizSTART + 1: tizSTART + tizLENGTH);
ai = x(aiSTART + 1: aiSTART + aiLENGTH);
bi = x(biSTART + 1: biSTART + biLENGTH);
clf
close all

for fNo = 1:sum(eA)
    figure(fNo)
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