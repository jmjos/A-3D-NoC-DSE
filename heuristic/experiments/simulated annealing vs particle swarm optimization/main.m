%% Initialization: lese Eingabe ein
clear all;
useInputAssistant = false;
useSDP = true;
saveas = 'test';

% Zum Beispiel: Beispiel1, Minibsp_linkLoad, Vorlage
if (isunix)
    otherFolder = '../DD_Nach_Zweiter_Kaibel_Konsultation/Eingabe/Instanzen/DVOPD'; 
else
    otherFolder = '../DD_Nach_Zweiter_Kaibel_Konsultation/Eingabe/Instanzen/DVOPD';
end
inputExamplePath ='input_values.m'; % 'inputForBoth.m';
% Paths
currentDir = pwd;
if (isunix)
    addpath([currentDir, '/functions'])
else
    addpath([currentDir, '\functions'])
end


% Eingabe Applikationsgraph und Mapping
if useInputAssistant
    if (isunix)
        run('Eingabe/input_assistant.m')
    else
        run('Eingabe\input_assistant.m')
    end
else
    if (isunix)
        run([otherFolder,'/',inputExamplePath])
    else
        run([otherFolder,'\',inputExamplePath])
    end
end

addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio128\cplex\matlab\x64_win64');
addpath('C:\Program Files\Mosek\8\toolbox\r2014a');
addpath('C:\Program Files\export_fig');
addpath('..\DD_Nach_Zweiter_Kaibel_Konsultation');

%% graphen erstellen

possibleVertialLinksAdj = physicallyPossibleTSVs(ComponentInLayer,componentPositions, componentOrder, propagationSpeed , freq, d);

%this adjacency matrix yields connections in 2D per layer following mesh
%topology
horizontalLinksAdj = zeros(length(componentPositions));
%add ones for neigbours per layer
for layer = 1:ell
   [numRows, numCols] = size(componentOrder{layer});
   %add y directional links
   for row = 1:numRows - 1
       for col = 1:numCols
           horizontalLinksAdj(componentOrder{layer}(row, col), ...
               componentOrder{layer}(row+1, col)) = 1;
           horizontalLinksAdj(componentOrder{layer}(row+1, col),...
               componentOrder{layer}(row, col)) = 1;
       end
   end
   
   %add x directional links
   for row = 1:numRows
       for col = 1:numCols - 1
           horizontalLinksAdj(componentOrder{layer}(row, col),...
               componentOrder{layer}(row, col+1)) = 1;
           horizontalLinksAdj(componentOrder{layer}(row, col+1),...
               componentOrder{layer}(row, col)) = 1;
       end
   end
end
intralayerGraph  = graph(horizontalLinksAdj, cellstr(strsplit(num2str(1:length(componentPositions)), ' ')));



possibleVerticalNetwork = graph(possibleVertialLinksAdj, ...
    cellstr(strsplit(num2str(1:length(componentPositions)), ' ')));
possibleVerticalNetwork.Edges.Weight = zeros(size(possibleVerticalNetwork.Edges.Weight));

applicationGraph = digraph(u,cellstr(strsplit(num2str(1:n), ' ')));

%% PSO

PSOmax = 20;

for TSVcount = 1:16
    fprintf("tsv count: %i ... ", TSVcount)
    tic
    globalCostsComplete = [];
    for iterationsMeaurements = 1:PSOmax
        fprintf("%i, ", iterationsMeaurements)
        TSVpositions = length(possibleVerticalNetwork.Edges.Weight);
        additionalRandomParticleCount = 2;
        particleCount = ceil(TSVpositions/TSVcount)+additionalRandomParticleCount;

        maxIter = 150;
        particles = zeros(particleCount, TSVpositions);
        for i = 1:ceil(TSVpositions/TSVcount)
             for j = (i * TSVcount)- TSVcount+1:(i * TSVcount)
                 jj = mod(j-1,TSVpositions)+1;
                 particles(i, jj) = 1;
             end
        end
        for i = ceil(TSVpositions/TSVcount)+1:particleCount
            initalfilled = randsample(1:TSVpositions,TSVcount, false);
            for j = 1:TSVcount
                particles(i, initalfilled(j)) = 1;
            end
        end

        pGlobal = zeros(1,TSVpositions);
        pGlobalCosts = Inf;
        pLocal = zeros(particleCount, TSVpositions);
        pLocalCosts = Inf*ones(particleCount,1);

        %inital costs:
        for i = 1:particleCount
            pLocal(i,:) = particles(i,:);
            costs =  costFn(particles(i,:), applicationGraph, intralayerGraph, possibleVerticalNetwork);
            pLocalCosts(i) = costs;
            if (costs <= pGlobalCosts)
                pGlobal = particles(i,:);
                pGlobalCosts = costs;
            end
        end


        for iter = 1:maxIter
            %update all particle positions
%             disp(particles)
            for particleIndex = 1:particleCount
                particles(particleIndex, :) = ...
                    neighourFunction(particles(particleIndex, :),...
                    pLocal(particleIndex, :),pGlobal);
            end

            %update pLocal and pGlobal
            for particleIndex = 1:particleCount
                costs = costFn(particles(particleIndex,:), applicationGraph, intralayerGraph, possibleVerticalNetwork);
                if (costs <= pLocalCosts(particleIndex))
                    pLocal(particleIndex, :) = particles(particleIndex,:);
                    pLocalCosts(particleIndex) = costs;
                end
                if (costs < pGlobalCosts)
                    pGlobal = particles(particleIndex,:);
                    pGlobalCosts = costs;
%                     fprintf("new global best with costs %2.2f after %2.2f\n", costs, pGlobalCosts); 
%                     disp(pGlobal)
                end
            end

%             fprintf("iteration %2.0f\n", iter);

        end
        globalCostsComplete = [globalCostsComplete, pGlobalCosts];

%         fprintf("best costs: %2.2f\n", pGlobalCosts);
%         disp(pGlobal)
        
    end
    tElapsed = toc;
    fprintf("\nmean costs %2.2f\n", mean(globalCostsComplete));
    fprintf("std costs %2.2f\n", std(globalCostsComplete));
    fprintf("av time per PSO %2.2f\n", tElapsed/PSOmax);
end