% This is the "heterogenous" input file with urand

% TODO: change application digraph.

n = 18;
ell = 2;
fR2D = 3*ones(1,ell);
% Fläche der kleinen Komponenten im oberen Layer
size1Top = 25;
% Fläche der kleinen Komponenten im unteren Layer
size1Bottom = 100000000;
% Fläche der großen Komponenten im unteren Layer
size2Bottom = 100;
% Fläche der großen Komponenten im oberen Layer
size2Top = 130;
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

fKOZ = 2;
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