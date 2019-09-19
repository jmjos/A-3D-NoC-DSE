% each component is placed at least once
% sum_{xi in [ell]}(x_(i,xi)) geq 1 for all i in [n]
for i = 1:n
    % umgestellt: - x_(i,1) - ... - x_(i,xi) leq -1
    GlNo = GlNo + 1;
    for xi = 1:ell
        Aeq(GlNo, xSTART + (i-1)*ell + xi) = -1;
    end
    beq(GlNo) = -1;
end


% set h to size of largest layer, or larger
% sum_{i in [n]}(x_(i,xi)*c_(i,xi)) leq h for all xi in [ell]
for xi = 1:ell
    % umgestellt: c_(1,xi)*x_(1,xi) + ... + c_(n,xi)*x_(n,xi) - h leq 0
    UglNo = UglNo + 1;
    for i = 1:n
        A(UglNo, xSTART + (i-1)*ell + xi) = C(i,xi);
    end
    A(UglNo, hSTART + 1) = -1;
    b(UglNo) = 0;
end