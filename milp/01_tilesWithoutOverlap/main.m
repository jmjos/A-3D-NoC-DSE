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

m = 20;
sx = floor(10*rand(1,m))+1;
sy = floor(10*rand(1,m))+1;
delta = 0.1;
c = 1000;

anzahlVar = 4*m^2 + 1;
anzahlUgl = 5*m^2 - 3*m;


%% genereiere kostenfunktion

f= zeros(1,anzahlVar);
f(1) = 1;

%% generiere integer variablen

intcon = 4*m+2 : 4*m^2 + 1;


%% trage richtige werte in A und b ein

A = zeros(anzahlUgl, anzahlVar);
b = zeros(anzahlUgl, 1);

%A = zeros(4*m^2 + 1, 5*m^2 - 3*m);
%b = zeros(5*m^2 - 3*m, 1);

for i=1:m
    %t_ix + a_i = h_c
    A(i, 1) = -1;
    A(i, 1+i) = 1;
    b(i) = -sx(i);
   
    %t_iy + b_i = h_c
    A(m+i, 1) = -1;
    A(m+i, m+1+i) = 1;
    b(m+i) = -sy(i);
end


for i = 1:m
    for k = 1:m-1
        if(k<i) 
            j = k;
        else
            j = k + 1;
        end
        % t_jx geq t_ix + a_i + delta + h_or1
        offset = 2*m;
        b(offset + (i-1)*(m-1) + k) = -sx(i) - delta;
        A(offset + (i-1)*(m-1) + k, i+1) = 1;
        A(offset + (i-1)*(m-1) + k, j+1) = -1;
        A(offset + (i-1)*(m-1) + k, 4*m+1 + (i-1)*(m-1)+ k) = -1*c;
        % t_ix geq t_jx + a_j + delta + h_or2
        offset = 2*m + m*(m-1);
        b(offset + (i-1)*(m-1) + k) = -sx(j) - delta;
        A(offset + (i-1)*(m-1) + k, j+1) = 1;
        A(offset + (i-1)*(m-1) + k, i+1) = -1;
        A(offset + (i-1)*(m-1) + k, 4*m+1+ m*(m-1) + (i-1)*(m-1)+ k) = -1*c;
       
        % t_jy geq t_iy + b_i + delta + h_or3
        offset = 2*m+ 2* m*(m-1);
        b(offset + (i-1)*(m-1) + k) = -sy(i) - delta;
        A(offset + (i-1)*(m-1) + k, i+1+m) = 1;
        A(offset + (i-1)*(m-1) + k, j+1+m) = -1;
        A(offset + (i-1)*(m-1) + k, 4*m+1 + 2*m*(m-1) + (i-1)*(m-1)+ k) = -1*c;
        % t_iy geq t_jy + b_j + delta + h_or4
        offset = 2*m + 3* m*(m-1);
        b(offset + (i-1)*(m-1) + k) = -sy(j) - delta;
        A(offset + (i-1)*(m-1) + k, j+1+m) = 1;
        A(offset + (i-1)*(m-1) + k, i+1+m) = -1;
        A(offset + (i-1)*(m-1) + k, 4*m+1+ 3*m*(m-1) + (i-1)*(m-1)+ k) = -1*c;
        
        % hor1 + ... + hor4 leq 3
        offset = 2*m + 4* m*(m-1);
        b(offset + (i-1)*(m-1) + k) = 3;
        A(offset + (i-1)*(m-1) + k, 4*m+1 + (i-1)*(m-1)+ k) = 1;
        A(offset + (i-1)*(m-1) + k, 4*m+1+ m*(m-1) + (i-1)*(m-1)+ k) = 1;
        A(offset + (i-1)*(m-1) + k, 4*m+1 + 2*m*(m-1) + (i-1)*(m-1)+ k) = 1;
        A(offset + (i-1)*(m-1) + k, 4*m+1+ 3*m*(m-1) + (i-1)*(m-1)+ k) = 1;
        
    end
end

%% setting bounds

lb = zeros(1,4*m^2+1);
ub = ones(1,4*m^2+1);
ub(1:2*m+1) = Inf * ones(1,2*m+1);

%% eq constraints

Aeq = [];
beq = [];
%% lin


x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub)

%% plot
startX = x(2:m+1);
startY = x(m+2 : 2*m +1);

figure(1)
clf
hold on
for i =1:m
    rectangle('Position',[startX(i) startY(i) sx(i) sy(i)])
end
hold off
