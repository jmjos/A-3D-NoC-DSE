n = 12;
ell = 1;
fR2D = 3*ones(1,ell);
Cimpl = [   29.992052;
            269.895612;
            269.895612;
            269.895612;
            479.785216;
            269.895612;
            1919.228481;
            269.895612;
            269.895612;
            269.895612;
            269.895612;
            1919.184672];        
energyR2D = 3*ones(1,ell);
Energy = 10* ones(n,ell);
Performance = 10*ones(n,ell);
u = zeros(n);

% wichtige Frage: was bedeutet die Richtung hier und wie wurde das im
% Algorithmus umgesetzt?
data = [1	2	38001;
        1	3	193;
        1	8	25;
        2	5	38001;
        4	1	24634;
        4	3	37958;
        6	1	38016;
        7	3	46733;
        8	9	2083;
        9	12	10;
        10	11	4060;
        11	12	500]

for i=1:size(data,1)
    u(data(i,1),data(i,2)) = data(i,3);
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