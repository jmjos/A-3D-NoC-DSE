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

clear all
%m \geq n
m = 4;
n = 2;
l = 1;
eta = .2;
F = FV_CostMatrix(n,m,l,eta);
delta = 0.1;
phi = [0,0,0];
c = 1000;


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

hcLENGTH = 1;
aiLENGTH = m;
biLENGTH = m;
tixLENGTH = m;
tiyLENGTH = m;
tizLENGTH = m;
rixLENGTH = m;
riyLENGTH = m;
rizLENGTH = m;
HORILENGTH    = m^2 - m;
HORIILENGTH   = m^2 - m;
HORIIILENGTH  = m^2 - m;
HORIVLENGTH   = m^2 - m;
HORVLENGTH    = m^2 - m;
HORVILENGTH   = m^2 - m;
HORVIILENGTH  = m^2 - m;
HORVIIILENGTH = m^2 - m;
HAreaXiIAlphaBetaLENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
HAreaXiIAlphaBeta1LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
HAreaXiIAlphaBeta2LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
HAreaXiIAlphaBeta3LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
HAreaXiIAlphaBeta4LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
HAreaXiIAlphaBeta5LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
HAreaXiIAlphaBeta6LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;



hcSTART = 0;
aiSTART = hcSTART + hcLENGTH;
biSTART = aiSTART + aiLENGTH;
tixSTART = biSTART + biLENGTH;
tiySTART = tixSTART + tixLENGTH;
tizSTART = tiySTART + tiyLENGTH;
rixSTART = tizSTART + tizLENGTH;
riySTART = rixSTART + rixLENGTH;
rizSTART = riySTART + riyLENGTH;
HORISTART = rizSTART + rizLENGTH;
HORIISTART = HORISTART + HORILENGTH;
HORIIISTART = HORIISTART + HORIILENGTH;
HORIVSTART = HORIIISTART + HORIIILENGTH;
HORVSTART = HORIVSTART + HORIVLENGTH;
HORVISTART = HORVSTART + HORVLENGTH;
HORVIISTART = HORVISTART + HORVILENGTH;
HORVIIISTART = HORVIISTART + HORVIILENGTH;
HAreaXiIAlphaBetaSTART = HORVIIISTART + HORVIIILENGTH;
HAreaXiIAlphaBeta1START = HAreaXiIAlphaBetaSTART + HAreaXiIAlphaBetaLENGTH;
HAreaXiIAlphaBeta2START = HAreaXiIAlphaBeta1START + HAreaXiIAlphaBeta1LENGTH;
HAreaXiIAlphaBeta3START = HAreaXiIAlphaBeta2START + HAreaXiIAlphaBeta2LENGTH;
HAreaXiIAlphaBeta4START = HAreaXiIAlphaBeta3START + HAreaXiIAlphaBeta3LENGTH;
HAreaXiIAlphaBeta5START = HAreaXiIAlphaBeta4START + HAreaXiIAlphaBeta4LENGTH;
HAreaXiIAlphaBeta6START = HAreaXiIAlphaBeta5START + HAreaXiIAlphaBeta5LENGTH;

anzahlVar = HAreaXiIAlphaBeta6START + HAreaXiIAlphaBeta6LENGTH;
anzahlUglTilesOverlap = 11*(m^2 - m) + 2*m;
anzahlUglAreaTiles = 8*((maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m);
anzahlUglAreaTiles = anzahlUglAreaTiles + 4*m;
anzahlUgl = anzahlUglTilesOverlap + anzahlUglAreaTiles;

anzahlGl = 3*m;
%% genereiere kostenfunktion

f= zeros(1,anzahlVar);
f(1) = 1;


%% generiere integer variablen

% nicht integer sind: tix, tiy, rix, riy, ai, bi, hc

intcon = [tizSTART + 1 : tizSTART + tizLENGTH, ...
    rizSTART + 1: rizSTART + rizLENGTH, ...
    HORISTART + 1 : anzahlVar];

%% trage richtige werte in A und b ein
tic
A = zeros(anzahlUgl, anzahlVar);
b = zeros(anzahlUgl, 1);

Aeq = zeros(anzahlGl, anzahlVar);
beq = zeros(anzahlGl, 1);

UglNo = 0;
GlNo = 0;

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
%       t_{i, z} \leq \varphi_z + \HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) =  phi(3);
        A(UglNo, tizSTART + i ) = 1;
        A(UglNo, HORISTART + (i-1)*(m-1)+k ) = - c;

%       \varphi_z &\leq t_{i, z} + \HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = - phi(3);
        A(UglNo, tizSTART + i ) = -1;
        A(UglNo, HORISTART + (i-1)*(m-1)+k ) = - c;

%       t_{j, z} \leq \varphi_z + \HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) =  phi(3);
        A(UglNo, tizSTART + j ) = 1;
        A(UglNo, HORIISTART +(i-1)*(m-1)+k ) = - c;

%       \varphi_z &\leq t_{j, z} + \HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = - phi(3);
        A(UglNo, tizSTART + j ) = -1;
        A(UglNo, HORIISTART +(i-1)*(m-1)+k ) = - c;
        
%       t_{i,z} &\leq t_{j,z} - \nicefrac{1}{2} + \HORIII \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, tizSTART + i ) = 1;
        A(UglNo, tizSTART + j ) = -1;
        A(UglNo, HORIIISTART +(i-1)*(m-1)+k ) = - c;

%       t_{j,z} &\leq t_{i,z} - \nicefrac{1}{2} + \HORIV \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, tizSTART + i ) = -1;
        A(UglNo, tizSTART + j ) = 1;
        A(UglNo, HORIVSTART +(i-1)*(m-1)+k ) = - c;        
        
        % t_jx geq t_ix + a_i + delta + h_or1
        UglNo = UglNo + 1;
        %b(UglNo) = -ai(i) - delta;
        b(UglNo) = - delta;
        A(UglNo, aiSTART + i) = 1;
        A(UglNo, tixSTART + i) = 1;
        A(UglNo, tixSTART + j) = -1;
        A(UglNo, HORVSTART + (i-1)*(m-1)+ k) = -c;
        
        % t_ix geq t_jx + a_j + delta + h_or2
        UglNo = UglNo + 1;
        %b(UglNo) = -ai(j) - delta;
        b(UglNo) = - delta;
        A(UglNo, aiSTART + j) = 1;
        A(UglNo, tixSTART + i) = -1;
        A(UglNo, tixSTART + j) = 1;
        A(UglNo, HORVISTART + (i-1)*(m-1)+ k) = -c;
        
        % t_jy geq t_iy + b_i + delta + h_or3
        UglNo = UglNo + 1;
        %b(UglNo) = -bi(i) - delta;
        b(UglNo) = - delta;
        A(UglNo, biSTART + i) = 1;
        A(UglNo, tiySTART + i) = 1;
        A(UglNo, tiySTART + j) = -1;
        A(UglNo, HORVIISTART + (i-1)*(m-1)+ k) = -c;
         
        % t_iy geq t_jy + b_j + delta + h_or4
        UglNo = UglNo + 1;
        %b(UglNo) = -bi(j) - delta;
        b(UglNo) = - delta;
        A(UglNo, biSTART + j) = 1;
        A(UglNo, tiySTART + i) = -1;
        A(UglNo, tiySTART + j) = 1;
        A(UglNo, HORVIIISTART + (i-1)*(m-1)+ k) = -c;
        
        % hor1 + ... + hor4 leq 3
        UglNo = UglNo + 1;
        b(UglNo) = 7;
        A(UglNo, HORISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, HORIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, HORIIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, HORIVSTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, HORVSTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, HORVISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, HORVIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, HORVIIISTART + (i-1)*(m-1)+ k) = 1;
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
                A(UglNo, HAreaXiIAlphaBeta1START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                
                % -tiz + -hkram2 leq -1/2 -xi
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - xi;
                A(UglNo, tizSTART + i) = -1;
                A(UglNo, HAreaXiIAlphaBeta2START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                
                % hirouter - hkram3 leq -1/2 + alpha
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 + alpha - hirouter(i);
                %A(UglNo, hirouterSTART + i) = 1; 
                A(UglNo, HAreaXiIAlphaBeta3START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % -hirouter - hkram4 leq -1/2 -alpha
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - alpha + hirouter(i);
                %A(UglNo, hirouterSTART + i) = -1; 
                A(UglNo, HAreaXiIAlphaBeta4START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % hiTSV - hkram5 leq -1/2 + beta
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 +beta - hiTSV(i);
                %A(UglNo, hiTSVSTART + i) = +1; 
                A(UglNo, HAreaXiIAlphaBeta5START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                                
                % -hiTSV - hkram6 leq -1/2 -beta
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - beta + hiTSV(i);
                %A(UglNo, hiTSVSTART + i) = -1; 
                A(UglNo, HAreaXiIAlphaBeta6START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % hkram1 + hkram2 + ... + hkram6 + (1- hkram0) leq 6
                UglNo = UglNo + 1;
                b(UglNo) = 5;
                A(UglNo, HAreaXiIAlphaBeta1START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, HAreaXiIAlphaBeta2START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, HAreaXiIAlphaBeta3START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, HAreaXiIAlphaBeta4START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, HAreaXiIAlphaBeta5START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, HAreaXiIAlphaBeta6START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -1;
                
                % hkram0 - tiz leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, tizSTART + i) = -1;
                A(UglNo, HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;                
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
                A( UglNo, HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
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
                A( UglNo, HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = F(alpha, beta, xi, i);
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

disp('Gleichheit von ri und ti in allen dimenisonen')
% ti{x,y,z} = ri{x,y,z}
for i = 1:m
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
toc           
%% setting bounds

lb = zeros(1,anzahlVar);

%lower bound der tiz
notBoundIndexes = tizSTART + 1 : tizSTART + tizLENGTH;
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
notBoundIndexes = HORISTART + 1 : anzahlVar;
ub(notBoundIndexes) = 1 * ones(length(notBoundIndexes), 1);


%% lin

options = optimoptions('intlinprog','MaxTime',45);
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub, options);

solution = x(aiSTART + 1 : tizSTART + tizLENGTH)

%% plot
startX = x(tixSTART + 1: tixSTART + tixLENGTH);
startY = x(tiySTART + 1: tiySTART + tiyLENGTH);
startZ = x(tizSTART + 1: tizSTART + tizLENGTH);
ai = x(aiSTART + 1: aiSTART + aiLENGTH);
bi = x(biSTART + 1: biSTART + biLENGTH);

figure(1)
clf
hold on
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
hold off