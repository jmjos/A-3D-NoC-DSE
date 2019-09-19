% This example has no area values. It is designed to test the TSV-placing
% subproblem. Application digraph comes from a Sahu paper.

ell = 2;
d = (0.1)*ones(1,ell-1);

% VOPD (as taken from that figure in that paper)
n = 16;

ComponentInLayer = cell(ell,1);
componentPositions = -ones(n,3);
componentOrder = cell(2,1);

componentOrder{1} = [1 2 3 4; 8 9 12 13];
componentOrder{2} = [7 6 5 16; 10 11 15 14];

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
    4 16 49;
    5 6 357;
    6 7 353;
    7 8 300;
    8 9 313;
    8 10 500;
    9 10 313;
    10 9 94;
    11 12 16;
    12 6 16;
    12 9 16;
    12 13 16;
    13 14 157;
    14 15 16;
    15 11 16;
    15 13 16;
    16 5 27];

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