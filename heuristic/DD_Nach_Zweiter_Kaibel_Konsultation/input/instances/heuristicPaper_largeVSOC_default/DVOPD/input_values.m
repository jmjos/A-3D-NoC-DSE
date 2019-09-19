% This example has no area values. It is designed to test the TSV-placing
% subproblem. Application digraph comes from a Sahu paper.

ell = 2;
d = (0.1)*ones(1,ell-1);

% DVOPD (as taken from that figure in that paper)
n = 32;

ComponentInLayer = cell(ell,1);
componentPositions = -ones(n,3);
componentOrder = cell(2,1);

componentOrder{1} = [1 7 8 10; 16 22 23 25; 3 5 11 14; 18 20 26 29];
componentOrder{2} = [31 2 6 9; 17 21 24 4; 15 12 13 19; 30 27 28 32];

ComponentInLayer{1} = componentOrder{1}(:)';
ComponentInLayer{2} = componentOrder{2}(:)';

for layer = 1:ell
    for row = 1:size(componentOrder{layer},1)
        for column = 1:size(componentOrder{layer},2)
            componentPositions(componentOrder{layer}(row,column),:) = [row-1, column-1, layer];
        end
    end
end  

u = zeros(n);
% wichtige Frage: was bedeutet die Richtung hier und wie wurde das im
% Algorithmus umgesetzt?
data = [
    1 2 70;
    2 3 362;
    3 4 362;
    4 5 362;
    4 15 49;
    5 6 357;
    6 7 353;
    7 8 300;
    8 9 313;
    8 10 500;
    9 10 313;
    10 9 94;
    11 6 16;
    11 9 16;
    11 12 16;
    11 32 540;
    12 13 157;
    13 14 16;
    14 11 16;
    14 12 16;
    15 5 27;
    16 17 70;
    17 18 362;
    18 19 362;
    19 20 362;
    19 30 49;
    20 21 357;
    21 22 353;
    22 23 300;
    23 24 313;
    23 25 500;
    24 25 313;
    25 24 94;
    26 21 16;
    26 24 16;
    26 27 16;
    26 32 540;
    27 28 157;
    28 29 16;
    29 26 16;
    29 27 16;
    30 20 27;
    31 1 126;
    31 16 126];

for i=1:size(data,1)
    u(data(i,1),data(i,2)) = data(i,3);
end

% for plot:
Cimpl = 0.75*ones(n,ell);
fR2D = zeros(1,ell);
fKOZ = 0;
fSinglePort = fR2D / 5;

% propagation speed and frequency of routers (dont matter at all)
propagationSpeed = 5*ones(1,ell);
freq = ones(1,ell);