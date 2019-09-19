%% Initialization: lese Eingabe ein

useInputAssistant = false;
useSDP = true;
saveas = 'notimportant';

% issue: in input data: propagation speed and frequency are obselete, d as
% 1xell-1 vector has to be defined

% Zum Beispiel: Beispiel1, Minibsp_linkLoad, Vorlage
if (isunix)
    otherFolder = 'Eingabe/Instanzen/mar_19'; % '../EE_Heuristik_Und_MILP';
else
    otherFolder = 'Eingabe/Instanzen/heuristicPaper_largeVSOC_new_urand';
end
inputExamplePath ='input_values.m'; % 'inputForBoth.m';
% Paths
currentDir = pwd;
if (isunix)
    addpath([currentDir, '/functions'])
else
    addpath([currentDir, '\functions'])
end

% ==== === === === PARAMETERS (gl, hf!) === === === === === === === === ==
% What are my parameters?
% - Step 1: maximum optimization time (doesn't trigger in known cases)
%           4 cost function wheighs (main.m, section Comp. Lay. Ass.)
weightArea = 1;
weightPower = 1;
weightPerformance = 1;
weightCommunication = 1000;
OptimizationTime = 600;
% - Step 2: SA iteration number, SA initial temperature, SA cooling
%           factor, maximum aspect ratio of a tile (main.m, sec. floor pl.)
%           useSDP (main.m, above)
FPmaxIterations = 200;
FPinitalTemperature =30;
FPcooling = 0.98;
eta = 0.4;
% - Step 3: no parameters if i'm not mistaken (area and comm weights??)
cheatcode = 'none' % 'tsvmax': place all TSVs. 'none': default.
% 'manualFloorplan': take floorplan from 'manualFloorplan'-variable (works
% like componentOrder) instead of doing step 1 and 2.
% performing SA.
% weightArea and weightCommunication (see step 1)
% - Step 4: SA iteration number, SA initial temperature, SA cooling factor
%           (main.m, section router platzieren fuer 3D), RD-length
PRmaxIter = 250;
PRcooling = 0.97;
PRinitialTemp = 1000;
% for RD-length d, see below (line 71)
% - Step 5: no parameters

% ==== === === === === === === === === === === === === === === === === ===

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

d = 100*ones(1,ell-1);
d = 1*d;

if ~(exist('manualFloorplan'))
    manualFloorplan = cell(1, ell);
end

%% Component Layer Assignement (Step 1)

completeTime = tic;
CLATime = tic;

fprintf('\n\n------------------\n Zuordnung von Komponenten zu Layern (Step 1):\n');

%gewichte der Kostenfunktion
% moved to top
%weightArea = 1;moved to top
%weightPower = 1;moved to top
%weightPerformance = 1;moved to top
%weightCommunication = 1;moved to top

%OptimizationTime = 600;moved to top
options = cplexoptimset('Display', 'off', 'MaxTime', OptimizationTime);

[ComponentInLayer, areaPerLayer, x] = allocateComponentsToLayers(n, ...
    ell, fR2D, Cimpl, energyR2D, Energy,...
    weightPerformance, weightPower, weightArea, Performance, ...
    options, cheatcode, manualFloorplan);

CLAelapsedTime = toc(CLATime);
%% floor planning of components and vLinks (Step 2)

fprintf('\n\n-----------------------\n 2D floor planning per layer (Step 2):\n');

FPTime = tic;

%lengthly calculation to get all relevant positions of components, routers
componentPositions = -ones(n,3);
componentOrder = cell(ell,1);
fillRouterIndex = n;
for layer=1:ell
    display(['Layer: ', num2str(layer)]);
    output = 'rare'; %on, off, rare
    %FPmaxIterations = 10;moved to top
    %FPinitalTemperature =30;moved to top
    %FPcooling = 0.98;moved to top
    %eta = 0.4;moved to top
    [positions, order, ~, rows, cols] = ...
        positionsOfComponents_SA...
        (ComponentInLayer{layer}, ...
        Cimpl(ComponentInLayer{layer}, layer), fR2D(layer),...
        digraph(u(ComponentInLayer{layer}, ComponentInLayer{layer})), eta,...
        weightArea, weightCommunication, ...
        FPmaxIterations, FPinitalTemperature, FPcooling, ...
        output, useSDP, (layer-1)/ell, 1/(FPmaxIterations*ell), ...
        cheatcode, manualFloorplan{layer});
    localIndex=1;
    componentOrder{layer} = zeros(size(order));
    for component=ComponentInLayer{layer}
        componentOrder{layer}(find(order==localIndex))=component;
        componentPositions(component, :) = [positions(localIndex, :), layer];
        localIndex= localIndex+1;
    end
    %delete 0-rows and cols
    componentOrder{layer}(find(any(componentOrder{layer}')==0), :) = [];
    componentOrder{layer}(:,find(any(componentOrder{layer})==0)) = [];
    %add additional routers for mesh topology
    fillrouterIndexes = find(componentOrder{layer}(:)==0);
    fillRouters = fillRouterIndex + 1 :fillRouterIndex + length(fillrouterIndexes);
    componentOrder{layer}(fillrouterIndexes) = fillRouters;
    
    %add positions of new inserted routers into component positions
    newRouterLocations = -1*ones(length(fillrouterIndexes),2);
    for i = fillRouters - fillRouterIndex
        [newRouterLocations(i,1),newRouterLocations(i,2)] = find(componentOrder{layer} == i+ fillRouterIndex);
    end
    coordinates = -ones(length(fillrouterIndexes), 2);
    for comp = fillRouters-fillRouterIndex
        coordinates(comp, :) = [sum(rows(1:newRouterLocations(comp,1)-1)), ...
            sum(cols(1:newRouterLocations(comp,2)-1))];
    end
    for comp = fillRouters-fillRouterIndex
        componentPositions(comp+fillRouterIndex,:) = [coordinates(comp, :), layer];
    end
  
    fillRouterIndex = fillRouterIndex + length(fillrouterIndexes);
end

FPelapsedTime = toc(FPTime);
%% number of vLinks (Step 3)
fprintf('\n\n-----------------------\n Optimierung der VLinks (Step 3):\n');
% was sind die kooridnaten jeder oberen linken ecke der componenten

NVLTime = tic;
outsideMeasurements = sqrt(x(end)); %last position of solution vector x
[numberOfVLinks, costs] = numberVerticalLinksFn(ell, n, u, ComponentInLayer, ...
    outsideMeasurements, areaPerLayer, fSinglePort, weightArea, ...
    weightCommunication, fKOZ, fR2D, componentPositions, componentOrder, ...
    propagationSpeed, freq, d, cheatcode);

NVLelapsedTime = toc(NVLTime);
%% router plazieren fuer 3D (Step 4)
fprintf('\n\n-----------------------\n Place Routers (Step 4):\n');

PRTime = tic;

%PRmaxIter = 1; moved to top
%PRcooling = 0.97; moved to top
%PRinitialTemp = 1000; moved to top

[networkGraph, interLayerGraph] = placeVlinks( ComponentInLayer, componentPositions, ...
    propagationSpeed, freq, d, numberOfVLinks ,...
    digraph(u,cellstr(strsplit(num2str(1:n), ' '))), componentOrder,...
    PRinitialTemp, PRcooling, PRmaxIter, 'on');
PRelapsedTime = toc(PRTime);
%% Legaliaztion (Step 5)
fprintf('\n\n-----------------------\n Legalize solution (Step 5):\n');

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

save test.mat
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
    if (useSDP)
        [rows{layer}, cols{layer}, ~] = minimizeRowsAndColumnsSDP( areas{layer} , eta);
    else
        [rows{layer}, cols{layer}, ~] = minimizeRowsAndColumns( areas{layer} , eta);
    end
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
completeElapsedtime = toc(completeTime);

fprintf("----------------\nTiming:\n----------------\n");
fprintf("\t Comp. Layer Assignement     %4.2f sec.\n", CLAelapsedTime);
fprintf("\t Floor planning              %4.2f sec.\n", FPelapsedTime);
fprintf("\t number vlinks               %4.2f sec.\n", NVLelapsedTime);
fprintf("\t place routers               %4.2f sec.\n", PRelapsedTime);
fprintf("\t legalize                    %4.2f sec.\n", LegElapsedTime);
fprintf("                               ----------\n");
fprintf("\t whole time                  %4.2f sec.\n", completeElapsedtime);
%fprintf("\t Comp. Layer Assignement \n %f2 sec.\n", CLAelapsedTime);

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

fprintf("average (hop distance x data load): ");
completeDistance = 0;
numberofConnections = 0;
for i = 1:n
    for j = i+1:n
        if (u(i,j)~=0)
            completeDistance = completeDistance + u(i,j)* ...
                (length(shortestpath(networkGraph, num2str(i), ...
                num2str(j)))-1);
            numberofConnections = numberofConnections + 1;
        end
        if (u(j,i)~=0)
            completeDistance = completeDistance + u(j,i)* ...
                (length(shortestpath(networkGraph, num2str(j), ...
                num2str(i))) -1); 
            numberofConnections = numberofConnections + 1;
        end
    end
end
fprintf(" %2.2f\n", completeDistance/numberofConnections);

fprintf("summed (hop distance x data load): ");
completeDistance = 0;
numberofConnections = 0;
for i = 1:n
    for j = i+1:n
        if (u(i,j)~=0)
            completeDistance = completeDistance + u(i,j)* ...
                (length(shortestpath(networkGraph, num2str(i), ...
                num2str(j)))-1);
            numberofConnections = numberofConnections + 1;
        end
        if (u(j,i)~=0)
            completeDistance = completeDistance + u(j,i)* ...
                (length(shortestpath(networkGraph, num2str(j), ...
                num2str(i))) -1); 
            numberofConnections = numberofConnections + 1;
        end
    end
end
fprintf(" %2.2f\n", completeDistance);

fprintf("maximum link load: ");
m = height(networkGraph.Nodes);
bandwidthCounterOptimized = zeros(m);
for i = 1:n
    for j = i+1:n
        if (u(i,j)~=0)
            workingPath = shortestpath(networkGraph, num2str(i), num2str(j));
            for k = 1:(length(workingPath)-1)
                node1 = workingPath(k);
                node2 = workingPath(k+1);
                node1 = str2num(node1{1});
                node2 = str2num(node2{1});
                bandwidthCounterOptimized(node1,node2) = bandwidthCounterOptimized(node1,node2) + u(i,j);
            end
        end
        if (u(j,i)~=0)
            workingPath = shortestpath(networkGraph, num2str(j), num2str(i));
            for k = 1:(length(workingPath)-1)
                node1 = workingPath(k);
                node2 = workingPath(k+1);
                node1 = str2num(node1{1});
                node2 = str2num(node2{1});
                bandwidthCounterOptimized(node1,node2) = bandwidthCounterOptimized(node1,node2) + u(j,i);
            end
        end
    end
end
maximumLinkLoadOptimized = max(max(bandwidthCounterOptimized));
maximumLinksOptimized = find(bandwidthCounterOptimized == maximumLinkLoadOptimized);
% find gives single numbers, find the two again!
maximumLinksOptimized = [maximumLinksOptimized, zeros(length(maximumLinksOptimized),1)];
for i= 1:length(maximumLinksOptimized)
    maximumLinksOptimized(i,:) = [mod((i-1),m)+1,floor((i-1)/m)+1];
end
fprintf(" %2.2f\n", maximumLinkLoadOptimized);

fprintf("Longest RD-length");
longestRDLength = 0;
for edge = 1:size(interLayerGraph.Edges)
    if interLayerGraph.Edges.Weight(edge) == 1
        nodes = interLayerGraph.Edges.EndNodes(edge,:);
        RDLength = abs(sum(sum(componentPositions( ...
            str2num(nodes{1}), 1:2) - componentPositions( ...
            str2num(nodes{2}), 1:2))));
        if RDLength > longestRDLength
            longestRDLength = RDLength;
        end
    end
end
fprintf(" %2.2f\n", longestRDLength);

fprintf("Area of all tiles: ");
fprintf(" %2.2f\n", sum(ai.*bi));
fprintf("Area of largest layer times ell: ");
maxLayerArea = 0;
for i = 1:ell
    if currentMaxX(i)*currentMaxY(i)>maxLayerArea 
        maxLayerArea = currentMaxX(i)*currentMaxY(i);
    end
end
fprintf(" %2.2f\n", ell*maxLayerArea);
fprintf("Area of largest square layer times ell: ");
maxSLayerArea = 0;
for i = 1:ell
    if currentMaxX(i)*currentMaxX(i)>maxSLayerArea 
        maxSLayerArea = currentMaxX(i)*currentMaxX(i);
    end
end
for i = 1:ell
    if currentMaxY(i)*currentMaxY(i)>maxSLayerArea 
        maxSLayerArea = currentMaxY(i)*currentMaxY(i);
    end
end
fprintf(" %2.2f\n", ell*maxSLayerArea);
fprintf("Used Area: ");
totalArea = 0;
for i = 1:ell
    totalArea = totalArea + sum(sum(areas{i}));
end
fprintf(" %2.2f\n", totalArea);
fprintf("White Space (inside all tiles): ");
fprintf(" %2.2f\n", sum(ai.*bi) - totalArea);
fprintf("White Space (compared to largest layer area): ");
fprintf(" %2.2f\n", ell*maxLayerArea - totalArea);
fprintf("White Space (compared to largest square layer area): ");
fprintf(" %2.2f\n", ell*maxSLayerArea - totalArea);

run('savesolutionforMILP.m')

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

plotResults(componentPositions, aiNeeded,biNeeded, networkGraph, saveas)
applicationDigraph = digraph(u);
plotResultsShowApplication(componentPositions, aiNeeded,biNeeded, ...
    networkGraph, applicationDigraph, saveas)
save([saveas, '.mat'])
