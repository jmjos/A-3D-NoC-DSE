function [ ComponentInLayer, areaPerLayer, x ] = ...
    allocateComponentsToLayers( n, ell, ...
    fR2D, Cimpl, energyR2D, Energy,  weightPerformance, weightPower, ...
    weightArea, Performance, options, cheat, manualPlan )
%ALLOCATECOMPONENTSTOLAYERS Summary of this function goes here
%   Detailed explanation goes here

cheat = strcmp(cheat, 'manualFloorplan');


%% Verarbeitung

% Kostenmatrix modifizieren (R2D-Kosten dazurechnen)
C = CostMatrix(n, Cimpl, fR2D);
CEnergy = repmat(energyR2D, n, 1) + Energy;
CPerfEnergy = weightPerformance.*Performance + weightPower.*CEnergy;

% Variablenstarts und -längen
xLENGTH = n*ell;
hLENGTH = 1;

xSTART = 0;
hSTART = xSTART + xLENGTH;

anzahlVar = hSTART + hLENGTH;

% Ungleichungsanzahl

anzahlGl_xgeq1 = n;
anzahlUgl_hmax = ell;

anzahlUgl = anzahlUgl_hmax;
anzahlGl = anzahlGl_xgeq1;

% Variablentypen

ctype = blanks(anzahlVar);

ctype(xSTART + 1 : xSTART + xLENGTH)='I';
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

run('inequations.m')

% Kostenfunktion
%area costs
c(hSTART + 1) = weightArea;
for xi = 1:ell
    for i= 1:n
        %power and performance
        c(xSTART + (i-1)*ell + xi) = CPerfEnergy(i,xi);
    end
end


% setting bounds

run('settingBounds.m')

% solver
sostype = [];
sosind = [];
soswt = [];
x0 = [];

x = cplexmilp(c,A,b,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype, x0, options);

%% Kontrolle
assert(UglNo == anzahlUgl, 'anzahlUgl fehlerhaft.')

%% Ausgabe
areaPerLayer = zeros(1,ell);
powerPerLayer = zeros(1,ell);
perfPerLayer = zeros(1,ell);

ComponentInLayer = cell(ell,1);

for xi = 1:ell
    disp(['Layer' num2str(xi) ': '])
    fprintf('Components: ')
    for i= 1:n
        if ~cheat && (x(xSTART + (i-1)*ell + xi)==1)
            ComponentInLayer{xi} = [ComponentInLayer{xi}, i];
            fprintf('%u, ', i);
            areaPerLayer(xi) = areaPerLayer(xi) + Cimpl(i,xi);
            powerPerLayer(xi) = powerPerLayer(xi) + Energy(i,xi);
            perfPerLayer(xi) = perfPerLayer(xi) + Performance(i,xi);
        end
        if cheat && (sum(sum(manualPlan{xi} == i)) > 0)
            ComponentInLayer{xi} = [ComponentInLayer{xi}, i];
            fprintf('%u, ', i);
            areaPerLayer(xi) = areaPerLayer(xi) + Cimpl(i,xi);
            powerPerLayer(xi) = powerPerLayer(xi) + Energy(i,xi);
            perfPerLayer(xi) = perfPerLayer(xi) + Performance(i,xi);
        end
    end
    fprintf('\n')
end

fprintf('Flächenkosten pro Layer: ')
for xi = 1:ell
    if (xi ~= ell)
        fprintf('%u, ', areaPerLayer(xi));
    else
        fprintf( '%s \n', num2str(areaPerLayer(ell)));
    end
end

fprintf('Powerkosten pro Layer: ')
for xi = 1:ell
    if (xi ~= ell)
        fprintf('%u, ', powerPerLayer(xi));
    else
        fprintf( '%s \n', num2str(powerPerLayer(ell)));
    end
end

fprintf('Perforancekosten pro Layer: ')
for xi = 1:ell
    if (xi ~= ell)
        fprintf('%u, ', perfPerLayer(xi));
    else
        fprintf( '%s \n', num2str(perfPerLayer(ell)));
    end
end


end

