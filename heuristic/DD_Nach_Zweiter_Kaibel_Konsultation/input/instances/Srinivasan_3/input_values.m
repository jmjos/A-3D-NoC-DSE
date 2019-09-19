n = 13;
ell = 1;
fR2D = 3*ones(1,ell);
Cimpl = [   270.6025;
            270.569601;
            270.6025;
            270.569601;
            270.569601;
            481.012624;
            481.012624;
            30.063289;
            270.6025;
            270.569601;
            270.6025;
            270.569601;
            1924.138225];        
energyR2D = 3*ones(1,ell);
Energy = 10* ones(n,ell);
Performance = 10*ones(n,ell);
u = zeros(n);

% wichtige Frage: was bedeutet die Richtung hier und wie wurde das im
% Algorithmus umgesetzt?
data = [1	2	2083;
        1	3	4060;
        1	9	25;
        2	5	1000;
        3	4	500;
        4	5	1000;
        5	6	870;
        6	7	150;
        6	8	180;
        9	10	2083;
        10	13	10;
        11	12	4060;
        12	13	500]

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