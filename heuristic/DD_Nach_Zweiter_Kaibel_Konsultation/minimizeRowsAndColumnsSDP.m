
function [ rows, cols, x ] = minimizeRowsAndColumnsSDP( area, eta )
addpath('C:\Program Files\Mosek\8\toolbox\r2014a');
%SDP_MINIMIZEROWSANDCOLUMNS Summary of this function goes here
% minimizes rows and columns for a given tile size
%   Input values:  area:       matrix of size s, s. contains area values
%   Return values: rows:       vector of length n with row widths
%                  cols:       vector of length m with column widths
%                  x:          sdp solution
% There also is a documentation sheet called 'SDP_minRowsAndColumns'

% mosek documentation: 
% https://docs.mosek.com/8.1/toolbox/tutorial-sdo-shared.html

% eliminate zero-rows and zero-columns

zerorows = find(any(area,2)== 0);
zerocols = find(any(area,1)== 0);

area(zerorows, :) = [];
area(:, zerocols) = [];

[n,m] = size(area);

[r, res] = mosekopt('symbcon');

% set objective "min x"minimize

% set coefficient c_j of x_j ( here: j = 1 )
prob.c         = [1];

% set coefficient matrices C_j of X_j for j = { 1, ..., m*n }

% vector of dimensions of the matrices C_j
prob.bardim    = repmat(2, 1, m*n);

% index sets which say 'In C_j at position (k,l) this value is stored'
prob.barc.subj = [];
prob.barc.subk = [];
prob.barc.subl = [];
prob.barc.val  = [];

% set constraints

% set bounds of the constraints
prob.blc = [2*sqrt(reshape(transpose(area),[],1)'), zeros(1, 2*n*m-n-m+2), sqrt(eta)*sqrt(reshape(transpose(area),[],1)'),sqrt(eta)*sqrt(reshape(transpose(area),[],1)')];
prob.buc = [2*sqrt(reshape(transpose(area),[],1)'), zeros(1, 2*n*m-n-m), inf, inf, inf*ones(1, 2*m*n)];

% set coefficient a_ij of x_j in the i-th inequation
% for i = { 1, ..., 3*n*m-n-m+2 }, j = 1
% (all zero but a_(3*m*n-n-m+1,1) = 1 and (3*m*n-n-m+2,1) = 1
prob.a = sparse([3*m*n-n-m+1,3*m*n-n-m+2], [1,1], [1,1], 5*n*m-n-m+2, 1);

% set coefficient A_ij of X_j in the i-th inequation
% for i = { 1, ..., 3*n*m-n-m+2 }, j = { 1, ..., m*n }
subj = [];
for i = 1:n
    for j = 1:m
        subj = [subj, m*(i-1)+j];
    end 
end 
for i = 1:n
    for j = 2:m
        subj = [subj, m*(i-1)+1, m*(i-1)+j];
    end 
end 
for i = 2:n
    for j = 1:m
        subj = [subj, j, m*(i-1)+j];
    end 
end 

for i = 1:n
    j = 1;
    subj = [subj, m*(i-1)+j];
end
subj = [subj, 1:m];
for i = 1:n
    for j = 1:m
        subj = [subj, m*(i-1)+1];
    end
end
for i = 1:n
    for j = 1:m
        subj = [subj, j];
    end
end

% ( again we have index sets which say 'In A_ij at position (k,l) this value
% is stored' )
prob.bara.subi = [1:(m*n) sort([(n*m+1):(3*n*m-n-m) (n*m+1):(3*n*m-n-m)]) repmat(3*n*m-n-m+1, 1, n) repmat(3*n*m-n-m+2, 1, m) (3*n*m-n-m+3):(5*n*m-n-m+2)];
prob.bara.subj = subj; 
prob.bara.subk = [repmat(2, 1, n*m), ones(1,2*n*(m-1)), repmat(2, 1, 2*(n-1)*m) ones(1,n) 2*ones(1,m)  ones(1,m*n) 2*ones(1,m*n)];
prob.bara.subl = [ones(1,n*m), ones(1,2*n*(m-1)), repmat(2, 1, 2*(n-1)*m) ones(1,n) 2*ones(1,m) ones(1,m*n) 2*ones(1,m*n)];
prob.bara.val  = [ones(1,n*m), repmat([1, -1], 1, n*(m-1)), repmat([1, -1], 1, (n-1)*m), -ones(1,n) -ones(1,m) ones(1,2*m*n)];

% minimize

[~, res] = mosekopt('minimize info echo(0)', prob); 

% get the objective value and the vectors with row and column width

x = res.sol.itr.xx; 

rows = [];
for i = 1:n
    rows = [rows, res.sol.itr.barx(3*m*(i-1)+1)];
end 

cols = [];
for j = 1:m
    cols = [cols, res.sol.itr.barx(3*j)];
end 
rows = rows';
cols = cols';
