function C = CostMatrix(n, Cimpl, fR2D)
%COSTMATRIX adds router costs to implementation costs in each layer
C = repmat(fR2D, n, 1) + Cimpl;
end

