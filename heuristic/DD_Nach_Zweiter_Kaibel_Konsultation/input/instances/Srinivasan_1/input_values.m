n = 14;
ell = 1;
fR2D = 3*ones(1,ell);
Cimpl = [   195.580225;
            195.580225;
            195.580225;
            347.710609;
            347.710609;
            1390.87973;
            782.376841;
            195.580225;
            195.580225;
            195.580225;
            195.580225;
            195.608196;
            195.608196;
            1390.87973];        
energyR2D = 3*ones(1,ell);
Energy = 10* ones(n,ell);
Performance = 10*ones(n,ell);
u = zeros(n);

% wichtige Frage: was bedeutet die Richtung hier und wie wurde das im
% Algorithmus umgesetzt?
data = [1	2	250;
        1	4	187;
        1	8	25;
        1	10	25;
        2	3	3672;
        3	5	3672;
        4	5	100;
        5	7	380;
        6	4	500;
        6	7	3672;
        8	9	500;
        10	11	2083;
        11	14	10;
        12	13	4060;
        13	14	500]

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