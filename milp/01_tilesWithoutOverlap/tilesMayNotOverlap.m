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

m = 3;
l = 2;
ai = floor(10*rand(1,m))+1;
bi = floor(10*rand(1,m))+1;
delta = 0.1;
phi = [0,0,0];
c = 1000;

hcLENGTH = 1;
tixLENGTH = m;
tiyLENGTH = m;
tizLENGTH = m;
HORILENGTH    = m^2 - m;
HORIILENGTH   = m^2 - m;
HORIIILENGTH  = m^2 - m;
HORIVLENGTH   = m^2 - m;
HORVLENGTH    = m^2 - m;
HORVILENGTH   = m^2 - m;
HORVIILENGTH  = m^2 - m;
HORVIIILENGTH = m^2 - m;

hcSTART = 0;
tixSTART = hcSTART + hcLENGTH;
tiySTART = tixSTART + tixLENGTH;
tizSTART = tiySTART + tiyLENGTH;
HORISTART = tizSTART + tizLENGTH;
HORIISTART = HORISTART + HORILENGTH;
HORIIISTART = HORIISTART + HORIILENGTH;
HORIVSTART = HORIIISTART + HORIIILENGTH;
HORVSTART = HORIVSTART + HORIVLENGTH;
HORVISTART = HORVSTART + HORVLENGTH;
HORVIISTART = HORVISTART + HORVILENGTH;
HORVIIISTART = HORVIISTART + HORVIILENGTH;

anzahlVar = HORVIIISTART + HORVIIILENGTH;
anzahlUgl = 11*(m^2 - m) + 2*m;



%% genereiere kostenfunktion

f= zeros(1,anzahlVar);
f(1) = 1;


%% generiere integer variablen

intcon = tizSTART + 1 : HORVIIISTART + HORVIIILENGTH;

%% trage richtige werte in A und b ein

A = zeros(anzahlUgl, anzahlVar);
b = zeros(anzahlUgl, 1);



UglNo = 0;
for i=1:m
    %t_ix + a_i \leq h_c
    UglNo = UglNo + 1;
    A(UglNo, hcSTART + 1) = -1;
    A(UglNo, tixSTART + i) = 1;
    b(UglNo) = -ai(i);
   
    %t_iy + b_i \leq h_c
    UglNo = UglNo + 1;
    A(UglNo, hcSTART + 1) = -1;
    A(UglNo, tixSTART + m+i) = 1;
    b(UglNo) = -bi(i);
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
        b(UglNo) = -ai(i) - delta;
        A(UglNo, tixSTART + i) = 1;
        A(UglNo, tixSTART + j) = -1;
        A(UglNo, HORVSTART + (i-1)*(m-1)+ k) = -c;
        % t_ix geq t_jx + a_j + delta + h_or2
        UglNo = UglNo + 1;
        b(UglNo) = -ai(j) - delta;
        A(UglNo, tixSTART + i) = -1;
        A(UglNo, tixSTART + j) = 1;
        A(UglNo, HORVISTART + (i-1)*(m-1)+ k) = -c;
        
        % t_jy geq t_iy + b_i + delta + h_or3
        UglNo = UglNo + 1;
        b(UglNo) = -bi(i) - delta;
        A(UglNo, tiySTART + i) = 1;
        A(UglNo, tiySTART + j) = -1;
        A(UglNo, HORVIISTART + (i-1)*(m-1)+ k) = -c;
         
        % t_iy geq t_jy + b_j + delta + h_or4
        UglNo = UglNo + 1;
        b(UglNo) = -bi(j) - delta;
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

%% setting bounds

lb = zeros(1,anzahlVar);
notBoundIndexes = tizSTART + 1 : tizSTART + tizLENGTH;
lb(notBoundIndexes) = 1 * ones(length(notBoundIndexes), 1);


ub = ones(1,anzahlVar);
notBoundIndexes = hcSTART + 1 : tizSTART + tizLENGTH;
ub(notBoundIndexes) = Inf * ones(length(notBoundIndexes), 1);

notBoundIndexes = tizSTART + 1 : tizSTART + tizLENGTH;
ub(notBoundIndexes) = l * ones(length(notBoundIndexes), 1);


%% eq constraints

Aeq = [];
beq = [];
%% lin

options = optimoptions('intlinprog','MaxTime',60);
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub, options);

ai
bi
solution = x(tixSTART + 1 : tizSTART + tizLENGTH)

%% plot
startX = x(tixSTART + 1: tixSTART + tixLENGTH);
startY = x(tiySTART + 1: tiySTART + tiyLENGTH);
startZ = x(tizSTART + 1: tizSTART + tizLENGTH);

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
   
    %rectangle('Position',[startX(i) startY(i) sx(i) sy(i)])
end
hold off