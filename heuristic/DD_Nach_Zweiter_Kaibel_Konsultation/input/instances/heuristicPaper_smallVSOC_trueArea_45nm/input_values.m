% This is the "heterogenous" input file. Area values are changed accor-
% ding to holistic-noc-design/tables/SmallVSOCArea

n = 18;
ell = 2;
% Router Größen:
%  - gegebene Werte [3150, 1800] gelten für 3D-Router. 1/5 davon ist KOZ,
%  1/5 davon 3D-Anschluss-Fläche (--> 0,6*[.,.] = fR2D)
fR2D = 0.6*[3150, 1800];
% Fläche der ADCs im oberen Layer
size1Top = 53.47265625;
% Fläche der ADCs im unteren Layer
size1Bottom = 100000000;
% Fläche der CPU cores im unteren Layer
size2Bottom = 35807.4;
% Fläche der CPU cores im oberen Layer
size2Top = 62662.95;
Cimpl = [ size1Top*ones(9,1), size1Bottom*ones(9,1); 
          size2Top*ones(9,1), size2Bottom*ones(9,1)];        
energyR2D = 3*ones(1,ell);
Energy = 10* ones(n,ell);
Performance = 10*ones(n,ell);
u = zeros(n);

% Kommunikation von oben nach unten
load1 = 50;
for i = 1:9
    u(i, i+9) = load1;
end

% Kommunikation unten voll verknüpft
load2 = 10;
for i = 1:9
    for j = 1:9
        if i ~= j
            u(i+9,j+9) = load2;
        end
    end
end

% fKOZ = 1/5 * 3150, weil 3150 die 3D-Router-Fläche inkl. KOZ für 45nm ist.
fKOZ = 0.2 * 3150;
% fR3D(45nm) = 3150 - fKOZ, fR2D(45nm) = fR3D - 3150/5, fR3D = fR2D + fSinglePort.
% --> fR3D = 0.8 * 3150, fR2D = 0.75 * fR3D, fSinglePort = fR3D - fR2D
% --> fSinglePort = 4/3 * fR2D - fR2D
% --> following line:
fSinglePort = fR2D / 3;

% propagation speed and frequency of routers (obsolete, I hope)
% propagationSpeed = 5*ones(1,ell);
% freq = ones(1,ell);
propagationSpeed = 0*ones(1,ell);
freq = 0*ones(1,ell);

% % für input_assistant
% eN = NaN;
% NumberOfTiles = -1;
% riz = 0;
% tiz = 0;
% tix = 0;
% ai = 0;
% tiy = 0;
% bi = 0;

u = u/ mean(mean(u)); % this was added after the RD-table was done. It 
% serves its purpose in the urand-comparison.