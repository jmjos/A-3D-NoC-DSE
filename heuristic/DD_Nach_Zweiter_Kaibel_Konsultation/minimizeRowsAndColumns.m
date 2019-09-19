function [ rows, cols, x ] = minimizeRowsAndColumns( area, eta )
%MINIMIZEROWSANDCOLUMNS Summary of this function goes here
% minimizes rows and columns for a given tile size
%   Input values:  area:       matrix of size n, n. contains RHS of 
%                              linearization inequation of area values
%                              of every tile
%                  eta:        aspect ratio
%   Return values: rows, cols: vector of length n with row and column
%                              widths
%                  x:          ilp solution

OptimizationTime = 600;
options = cplexoptimset('Display', 'off', 'MaxTime', OptimizationTime);

oldn = size(area,1);

% eliminate zero-rows and zero-columns

zerorows = find(any(area,2)== 0);
zerocols = find(any(area,1)== 0);

area(zerorows, :) = [];
area(:, zerocols) = [];

[m,n] = size(area);

% Variablenstarts und -längen
rLENGTH = m;
cLENGTH = n;
hLENGTH = 1;

rSTART = 0;
cSTART = rSTART + rLENGTH;
hSTART = cSTART + cLENGTH;

anzahlVar = hSTART + hLENGTH;

% Ungleichungsanzahl

anzahlGl = 0;
anzahlUgl = m*n + m+n + 2;


% Variablentypen

ctype = blanks(anzahlVar);

ctype(rSTART + 1 : rSTART + rLENGTH)='C';
ctype(cSTART + 1 : cSTART + cLENGTH)='C';
ctype(hSTART + 1 : hSTART + hLENGTH)='C';

% Initialisierung

A = sparse(anzahlUgl, anzahlVar);
b = zeros(anzahlUgl, 1);
Aeq = sparse(anzahlGl, anzahlVar);
beq = zeros(anzahlGl, 1);
c = zeros(1,anzahlVar);

UglNo = 0;
GlNo = 0;

% Ungleichungen

for i = 1:m
    for j = 1:n

        % aspect ratio 1
        % r_i geq eta * c_j
        % -r_i + eta*c_j leq 0
        UglNo = UglNo + 1;
        A(UglNo, rSTART + i) = -1;
        A(UglNo, cSTART + j) = eta;
        b(UglNo) = 0;

        % aspect ratio 2
        % c_j geq eta*r_i
        % eta*r_i -c_j leq 0
        UglNo = UglNo + 1;
        A(UglNo, rSTART + i) = eta;
        A(UglNo, cSTART + j) = -1;
        b(UglNo) = 0;

        % linearization of area calculation
        % r_i + c_j geq area_ij
        % -r_i -c_j leq -area_ij
        UglNo = UglNo + 1;
        A(UglNo, rSTART + i) = -1;
        A(UglNo, cSTART + j) = -1;
        b(UglNo) = -sqrt(area(i,j) ...
        ./ eta) - sqrt(area(i,j) .* eta); % -area(i,j);
    end
end

% h geq max(sum_{i=1}^m(r_i), sum_{i=1}^n(c_i) )

% 1. h geq sum_{i=1}^m(r_i)
% -h + r_1 + ... + r_m leq 0
UglNo = UglNo + 1;
A(UglNo, hSTART + 1) = -1;
for i = 1:m
    A(UglNo, rSTART + i) = 1;
end
b(UglNo) = 0;

% 2. h geq sum_{i=1}^n(c_i)
% -h + c_1 + ... + c_n leq 0
UglNo = UglNo + 1;
A(UglNo, hSTART + 1) = -1;
for i = 1:n
    A(UglNo, cSTART + i) = 1;
end
b(UglNo) = 0;

% Kostenfunktion
% minimiere h
c(hSTART + 1) = 1;

% setting bounds

% LOWER BOUNDS
% set all lower bounds to zero
lb = zeros(1,anzahlVar);

% UPPER BOUNDS
%initialize upper bounds as non-bound
ub = Inf * ones(1,anzahlVar);

% solver
sostype = [];
sosind = [];
soswt = [];
x0 = [];

x = cplexmilp(c,A,b,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype, x0, options);

rows = x(rSTART + 1 : rSTART + rLENGTH);
cols = x(cSTART + 1 : cSTART + cLENGTH);

% insert zeros from zerorows and zerocols
rows = [rows;zeros(oldn-m,1)];
cols = [cols;zeros(oldn-n,1)];

end
