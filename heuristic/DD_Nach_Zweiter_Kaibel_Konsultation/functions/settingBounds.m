% LOWER BOUNDS

% set all lower bounds to zero
lb = zeros(1,anzahlVar);

% UPPER BOUNDS

%initialize upper bounds as non-bound
ub = Inf * ones(1,anzahlVar);

ub(xSTART + 1 : xSTART + xLENGTH) = 1;
ub(hSTART + 1 : hSTART + hLENGTH) = Inf;