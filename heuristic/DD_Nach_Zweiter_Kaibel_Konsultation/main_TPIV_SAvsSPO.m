% this whole thing is copy-paste-edited from main.m (18.10.2018)
% then it got elements from ../PSOVergleich/main.m for the evaluation (19.10.2018)
%% Initialization: lese Eingabe ein

%numberOfVLinks = 4; see TSVcount
% Skip the legalization + plotting part: plotting = 0
% For Professorenmodus: plotting = 1
plotting = 0;

% VOPD or DVOPD?
inputInstance = 'DVOPD';

if (isunix)
    otherFolder = ['Eingabe/Instanzen/', inputInstance];
else
    otherFolder = ['Eingabe/Instanzen/', inputInstance];
end
inputExamplePath ='input_values.m';
% Paths
currentDir = pwd;
if (isunix)
    addpath([currentDir, '/functions'])
else
    addpath([currentDir, '\functions'])
end

% Eingabe Applikationsgraph
if (isunix)
    run([otherFolder,'/',inputExamplePath])
else
    run([otherFolder,'\',inputExamplePath])
end

%% router plazieren fuer 3D

PSOmax = 20;

for TSVcount = 1:8
    fprintf("tsv count: %i ... ", TSVcount)
    tic
    globalCostsComplete = [];
    for iterationsMeaurements = 1:PSOmax
        fprintf("%i, ", iterationsMeaurements)
        %TSVpositions = length(possibleVerticalNetwork.Edges.Weight);
        %fprintf('\n\n-----------------------\n Place Routers:\n');

        %PRTime = tic;

        PRmaxIter = 500;
        PRcooling = 0.97;
        PRinitialTemp = 1000;

        [networkGraph, interLayerGraph] = placeVlinks( ComponentInLayer, componentPositions, ...
            propagationSpeed, freq, d, TSVcount ,...
            digraph(u,cellstr(strsplit(num2str(1:n), ' '))), componentOrder,...
            PRinitialTemp, PRcooling, PRmaxIter, 'off');
        pGlobalCosts = calculateCosts(digraph(u,cellstr(strsplit(num2str(1:n), ' '))), networkGraph);
        %PRelapsedTime = toc(PRTime);
        
%         fprintf("%i, ", iterationsMeaurements)
%         TSVpositions = length(possibleVerticalNetwork.Edges.Weight);
%         additionalRandomParticleCount = 2;
%         particleCount = ceil(TSVpositions/TSVcount)+additionalRandomParticleCount;
% 
%         maxIter = 150;
%         particles = zeros(particleCount, TSVpositions);
%         for i = 1:ceil(TSVpositions/TSVcount)
%              for j = (i * TSVcount)- TSVcount+1:(i * TSVcount)
%                  jj = mod(j-1,TSVpositions)+1;
%                  particles(i, jj) = 1;
%              end
%         end
%         for i = ceil(TSVpositions/TSVcount)+1:particleCount
%             initalfilled = randsample(1:TSVpositions,TSVcount, false);
%             for j = 1:TSVcount
%                 particles(i, initalfilled(j)) = 1;
%             end
%         end
% 
%         pGlobal = zeros(1,TSVpositions);
%         pGlobalCosts = Inf;
%         pLocal = zeros(particleCount, TSVpositions);
%         pLocalCosts = Inf*ones(particleCount,1);
% 
%         %inital costs:
%         for i = 1:particleCount
%             pLocal(i,:) = particles(i,:);
%             costs =  costFn(particles(i,:), applicationGraph, intralayerGraph, possibleVerticalNetwork);
%             pLocalCosts(i) = costs;
%             if (costs <= pGlobalCosts)
%                 pGlobal = particles(i,:);
%                 pGlobalCosts = costs;
%             end
%         end
% 
% 
%         for iter = 1:maxIter
%             %update all particle positions
% %             disp(particles)
%             for particleIndex = 1:particleCount
%                 particles(particleIndex, :) = ...
%                     neighourFunction(particles(particleIndex, :),...
%                     pLocal(particleIndex, :),pGlobal);
%             end
% 
%             %update pLocal and pGlobal
%             for particleIndex = 1:particleCount
%                 costs = costFn(particles(particleIndex,:), applicationGraph, intralayerGraph, possibleVerticalNetwork);
%                 if (costs <= pLocalCosts(particleIndex))
%                     pLocal(particleIndex, :) = particles(particleIndex,:);
%                     pLocalCosts(particleIndex) = costs;
%                 end
%                 if (costs < pGlobalCosts)
%                     pGlobal = particles(particleIndex,:);
%                     pGlobalCosts = costs;
% %                     fprintf("new global best with costs %2.2f after %2.2f\n", costs, pGlobalCosts); 
% %                     disp(pGlobal)
%                 end
%             end
% 
% %             fprintf("iteration %2.0f\n", iter);
% 
%         end
        globalCostsComplete = [globalCostsComplete, pGlobalCosts];

%         fprintf("best costs: %2.2f\n", pGlobalCosts);
%         disp(pGlobal)
        
    end
    tElapsed = toc;
    fprintf("\nmean costs %2.2f\n", mean(globalCostsComplete));
    fprintf("std costs %2.2f\n", std(globalCostsComplete));
    fprintf("av time per SA %2.2f\n", tElapsed/PSOmax);
end

fprintf("\n Beachte: Cooling factor was changed from 0.97 to 0.995");
if plotting
    %% Legaliaztion
    fprintf('\n\n-----------------------\n Legalize solution:\n');

    LegTime = tic;

    %just run position component again with modified weight matrix

    %add KOZ and 3d costs or routers
    %modify Cimpl, add 2D on "empty" tiles
    %run optimization which is part of the positions of Components SA.
    areas = cell(ell,1);
    for layer = 1:ell
        %generate area matrix
        areas{layer} =zeros(size(componentOrder{layer}));
        %add component sizes
        for component = ComponentInLayer{layer}
            index = find(componentOrder{layer} == component);
            areas{layer}(index)= areas{layer}(index)...
                + Cimpl(component, layer);
        end
        %add router costs (node degree)
        for index = 1:numel(componentOrder{layer})
            routerIndex = componentOrder{layer}(index);
            areas{layer}(index) = areas{layer}(index) + ...
                ((1 + degree(networkGraph, findnode(networkGraph, routerIndex)))...
                * fSinglePort(layer));
        end
    end

    for i=1:ell
        RouterInLayer{i} = find(componentPositions(:,3)==i)';
    end
    %iterate all vertical links. add in upper layer koz
    edgeIndexes = find(interLayerGraph.Edges.Weight == 1)';
    for edgeIndex = edgeIndexes
        [sIn, sOut] = findedge(interLayerGraph, edgeIndex);
        for layer = 1:ell
            if(any(RouterInLayer{layer} == sIn))
                sInLayer = layer;
            end
            if(any(RouterInLayer{layer} == sOut))
                sOutLayer = layer;
            end
        end
        if (sInLayer < sOutLayer)
            %sIn bekommt KOZ
            index = find(componentOrder{sInLayer} == sIn);
            areas{sInLayer}(index) = areas{sInLayer}(index) + fKOZ;
        else
            %sOut bekommt KOZ
            index = find(componentOrder{sOutLayer} == sOut);
            areas{sOutLayer}(index) = areas{sOutLayer}(index) + fKOZ;
        end
    end
        %add koz: if link downwards: add koz


    %     edgeIndex = find(testsolution.Edges.Weight == 1)';
    %     networkGraph =...
    %         addedge(networkGraph, testsolution.Edges.EndNodes(edgeIndex,1),...
    %         testsolution.Edges.EndNodes(edgeIndex,2),ones(1,length(edgeIndex)));

    finalCoordiantes = zeros(size(componentPositions));
    bi = zeros(size(componentPositions, 1), 1);
    ai = zeros(size(componentPositions, 1), 1);
    rows = cell(1,ell);
    cols = cell(1,ell);
    for layer = 1:ell
    %     if (useSDP)
    %         [rows{layer}, cols{layer}, ~] = minimizeRowsAndColumnsSDP( areas{layer} , eta);
    %     else
    %         [rows{layer}, cols{layer}, ~] = minimizeRowsAndColumns( areas{layer} , eta);
    %     end
        rows{layer} = ones(1,size(componentOrder{layer},1));
        cols{layer} = ones(1,size(componentOrder{layer},2));
        for row = 1:size(componentOrder{layer}, 1)
            for col=1:size(componentOrder{layer}, 2)
                %fprintf("im in layer %d, row %d, col %d\n", layer, row, col )

                component = componentOrder{layer}(row,col);
                finalCoordiantes(component, 1) = sum(cols{layer}(1:col-1));
                finalCoordiantes(component, 2) = sum(rows{layer}(1:row-1));
                finalCoordiantes(component, 3) = layer;
                bi(component) = rows{layer}(row);
                ai(component) =  cols{layer}(col);
                %fprintf("Component at position %2.2f, %2.2f\n", finalCoordiantes(component, 1) , finalCoordiantes(component, 2));
                %fprintf("Component size %2.2f, %2.2f\n",  bi(component)  , ai(component) );
            end
        end
    end

    LegElapsedTime = toc(LegTime);

    fprintf("----------------\nTiming:\n----------------\n");
    %fprintf("\t place routers               %4.2f sec.\n", PRelapsedTime);
    fprintf("\t legalize                    %4.2f sec.\n", LegElapsedTime);

    %% Plotting
    %just some graph stuff:
    componentPositions = finalCoordiantes;
    disp('Done.');
    close all
    plot(networkGraph,'XData',componentPositions(:,1),'YData',...
        componentPositions(:,2),'ZData',componentPositions(:,3),...
        'NodeLabel',networkGraph.Nodes.Name)

    fprintf("size of layers:\n")
    currentMaxX = zeros(ell,1);
    currentMaxY = zeros(ell,1);
    for layer = 1:ell
        layerComponents = find(finalCoordiantes(:,3)==layer);
        currentMaxX(layer) = max(finalCoordiantes(layerComponents, 1) + ai(layerComponents));
        currentMaxY(layer) = max(finalCoordiantes(layerComponents, 2) + bi(layerComponents));
        fprintf("   in layer %d: %2.2f\n", layer, currentMaxX(layer)*currentMaxY(layer));
    end

    fprintf("hop distance: ");
    completeDistance = 0;
    numberofConnections = 0;
    for i = 1:n
        for j = i+1:n
            if (u(i,j)~=0)
                completeDistance = completeDistance + u(i,j)*(length(shortestpath(networkGraph, num2str(i), num2str(j)))-1);
                numberofConnections = numberofConnections + 1;
            end
            if (u(j,i)~=0)
                completeDistance = completeDistance + u(j,i)*(length(shortestpath(networkGraph, num2str(j), num2str(i))) -1); 
                numberofConnections = numberofConnections + 1;
            end
        end
    end
    fprintf(" %2.2f\n", completeDistance/numberofConnections);

    % show only needed area, not complete tile area
    aiNeeded = zeros(size(ai));
    biNeeded = zeros(size(bi));
    neededTileArea = zeros(size(ai));
    for layer = 1:ell
        for component = componentOrder{layer}(:)'
            tileposition = find(component == componentOrder{layer});
            neededTileArea(component) = areas{layer}(tileposition);
            % aspectRatio = ai(component)/bi(component);
            aiNeeded(component) = sqrt((ai(component)/bi(component))*neededTileArea(component));
            biNeeded(component) = sqrt((bi(component)/ai(component))*neededTileArea(component));
        end
    end

    saveas = 'pleasedont';
    plotResults(componentPositions, aiNeeded,biNeeded, networkGraph, saveas)
end

%% Calculate Costs
function [costs] = calculateCosts(applicationDigraph, networkGraph)
    % iterate alle edges in the application graph
    % search shortest path between these nodes in the network graph
    % increase costs: costs are data send (weight of application graph)
    % multiplied with path length
    costs = 0;
    for edgeIndex = 1:size(applicationDigraph.Edges.EndNodes,1)
        sourceNode = applicationDigraph.Edges.EndNodes(edgeIndex,1);
        destNode = applicationDigraph.Edges.EndNodes(edgeIndex,2);
        data = applicationDigraph.Edges.Weight(edgeIndex);
        costs = costs + data * ...
            length(shortestpath(networkGraph, sourceNode, destNode));
    end
end
