% This is the "heterogenous" input file. Area values are changed accor-
% ding to holistic-noc-design/tables/SmallVSOCArea

n = 18;
ell = 2;
fR2D = [50400, 1800];
% Fläche der ADCs im oberen Layer
size1Top = 855,5625;
% Fläche der ADCs im unteren Layer
size1Bottom = 100000000;
% Fläche der CPU cores im unteren Layer
size2Bottom = 35807,4;
% Fläche der CPU cores im oberen Layer
size2Top = 1002607,4;
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

fKOZ = 1000;
%fR3Dratio = 1/2;
fSinglePort = fR2D / 5;

% propagation speed and frequency of routers
propagationSpeed = 5*ones(1,ell);
freq = ones(1,ell);

% % für input_assistant
% eN = NaN;
% NumberOfTiles = -1;
% riz = 0;
% tiz = 0;
% tix = 0;
% ai = 0;
% tiy = 0;
% bi = 0;