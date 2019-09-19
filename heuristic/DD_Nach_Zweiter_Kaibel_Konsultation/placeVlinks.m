function [ bestNetwork, bestsolution ] = placeVlinks( ComponentInLayer, componentPositions, ...
    propagationSpeed, freq, maximumDistance, numberOfVLinks,...
    applicationDigraph, componentOrder,...
    initialTemperature, cooling, maxIterations, ...
    output)
%PLACEVLINKS returns all possible pairs of Components which could get
%            a vlink between them.
%   Output is a graph with all components as vertices and all possible
%   vlink-connections as edges.
%   All weights are set to zero to state that no vlink is set yet.


possibleVertialLinksAdj = physicallyPossibleTSVs(ComponentInLayer,componentPositions, componentOrder, propagationSpeed , freq, maximumDistance);

ell =size(ComponentInLayer, 1);
n = size(componentPositions,1);


%pairGraph = graph(adjacency, cellstr(strsplit(num2str(1:n), ' ')));
% set all edge weights to zero
%pairGraph.Edges.Weight = zeros(size(pairGraph.Edges.Weight));

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
%plot network graph
% plot(intralayerGraph,'XData',componentPositions(:,1),'YData',...
%     componentPositions(:,2),'ZData',componentPositions(:,3),...
%     'NodeLabel',intralayerGraph.Nodes.Name)

possibleVerticalNetwork = graph(possibleVertialLinksAdj, ...
    cellstr(strsplit(num2str(1:length(componentPositions)), ' ')));
possibleVerticalNetwork.Edges.Weight = zeros(size(possibleVerticalNetwork.Edges.Weight));
% plot(possibleVerticalNetwork,'XData',componentPositions(:,1),'YData',...
%     componentPositions(:,2),'ZData',componentPositions(:,3),...
%     'NodeLabel',intralayerGraph.Nodes.Name)

for i=1:ell
    RouterInLayer{i} = find(componentPositions(:,3)==i)';
end
initialSolution = calcInitialSolution(possibleVerticalNetwork, RouterInLayer,...
    numberOfVLinks);

bestsolution = initialSolution;

% % % % % %%%%mmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
% % % % % networkGraph = intralayerGraph;
% % % % % edgeIndex = find(bestsolution.Edges.Weight == 1)';
% % % % % networkGraph =...
% % % % %     addedge(networkGraph, bestsolution.Edges.EndNodes(edgeIndex,1),...
% % % % %     bestsolution.Edges.EndNodes(edgeIndex,2),ones(1,length(edgeIndex)));
% % % % % plotResults(componentPositions, ones(length(componentPositions), 1), ones(length(componentPositions), 1), networkGraph)
% % % % % %%%%mMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM

%costs = calculateCosts(initialSolution);
costs = Inf;
bestCosts = costs;
globalBestCosts = bestCosts;

T = initialTemperature;
for numberOfIterations = 1: maxIterations
    if (strcmp(output, 'on'))
        disp(['In Iteration: ', num2str(numberOfIterations)])
    end
    T = cooling*T;
    
    testsolution = neigbour(bestsolution, RouterInLayer, ...
        numberOfVLinks);
    
	%calculate costs    
    networkGraph = intralayerGraph;
    edgeIndex = find(testsolution.Edges.Weight == 1)';
    networkGraph =...
        addedge(networkGraph, testsolution.Edges.EndNodes(edgeIndex,1),...
        testsolution.Edges.EndNodes(edgeIndex,2),ones(1,length(edgeIndex)));

    %add edges, which have weight 1 in the possible vertical link graph
	costs = calculateCosts(applicationDigraph, networkGraph);

% % % % % % %     plotResults(componentPositions, ones(length(componentPositions), 1), ones(length(componentPositions), 1), networkGraph)
    
    costDelta = costs - bestCosts;
    if (costDelta <= 0)
        bestsolution = testsolution;
        bestNetwork = networkGraph;
        bestCosts = costs;
        if (strcmp(output, 'on'))
            display(['        New best costs: '  num2str(costs)])
        end
    elseif (rand < exp(-costDelta/T))
        bestsolution = testsolution;
        bestNetwork = networkGraph;
        bestCosts = costs;
        if (strcmp(output, 'on'))
            display(['        New costs: '  num2str(costs)])
        end
    end
    if (globalBestCosts > bestCosts)
        globalBestSolution = bestsolution;
        globalBestNetwork = bestNetwork; % Vorsicht: bestNetwork existiert nur, weil die initialen costs auf costs=Inf gesetzt wurden.
        globalBestCosts = bestCosts;
        if (strcmp(output, 'on'))
            display(['        New global best costs: '  num2str(costs)])
        end
    end
end


end


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

function [graphObject] = calcInitialSolution(graphObject, partitions, ...
    numberOfConnections)
%calculates initial solution. takes every cut in graph. implements greedy to find matching
%draws random sample edges in this graph per cut, delets connected vertices
% repeat until terminitaion for maximum numberOfconnections or if no
% further edge can be drawn
for cut = 1:length(numberOfConnections)
    %draw random set of edges. 
    %   vLink    => edgeweight = 1
    %   no vLink => edgeweight = 0
    
    nodeIds = union(partitions{cut}, partitions{cut+1});
    subgraphOfCut = subgraph(graphObject, nodeIds);
    
    numberOfSelectedEdges = 0;
    while((size(subgraphOfCut.Edges,1) ~= 0) && (numberOfSelectedEdges < numberOfConnections(cut)))
        %get edge
        if (size(subgraphOfCut.Edges,1)~=1)%datasample fails for single edge
            selectedEdge = datasample(subgraphOfCut.Edges, 1,'Replace',false);
        else
            selectedEdge = subgraphOfCut.Edges;
        end
        %add edge to graph
        graphObject.Edges.Weight(findedge(graphObject, ...
            selectedEdge.EndNodes(1,1), ...
            selectedEdge.EndNodes(1,2))) = 1;
        %delete vertices and eges
        sourceNode = str2num(selectedEdge.EndNodes{1});
        destNode = str2num(selectedEdge.EndNodes{2});
        subgraphOfCut = subgraph(subgraphOfCut, setdiff(subgraphOfCut.Nodes.Name, [{int2str(sourceNode)}, {int2str(destNode)}]));
        
        numberOfSelectedEdges = numberOfSelectedEdges + 1;
    end
end


end

function [graphObject] = neigbour(graphObject, partitions, cutsizes)
%ziehe zufaelligen cut:
    selectedCut = datasample(1:length(partitions)-1, 1);
    nodeIds = union(partitions{selectedCut}, partitions{selectedCut+1});
    subgraphOfCut = subgraph(graphObject, nodeIds);
    
    weightZeroEdges = subgraphOfCut.Edges.EndNodes(find(subgraphOfCut.Edges.Weight == 0), :);
    if isempty(weightZeroEdges)
    else
        % waehle eine Kante mit gewicht 0 aus.
        if size(weightZeroEdges,1) == 1
             selectedEdge = weightZeroEdges;
        else
            selectedEdge = datasample(weightZeroEdges, 1,'Replace',false);
        end

        %finde alle kanten, die mit den knoten der selectedEgde verbunden sind 
        % und die in die gleichen paritionen verbinden. 
        %setze diese auf 0
        deleteEdges1 = subgraphOfCut.Edges(outedges(subgraphOfCut, selectedEdge{1}), :);
        deleteEdges2 = subgraphOfCut.Edges(outedges(subgraphOfCut, selectedEdge{2}), :);
        for i = 1:length(deleteEdges1.EndNodes(:,1))
            graphObject.Edges.Weight(findedge(graphObject, ...
                deleteEdges1.EndNodes(i,1), ...
                deleteEdges1.EndNodes(i,2))) = 0;
            subgraphOfCut.Edges.Weight(findedge(subgraphOfCut, ...
                deleteEdges1.EndNodes(i,1), ...
                deleteEdges1.EndNodes(i,2))) = 0;
        end
        for i = 1:length(deleteEdges2.EndNodes(:,1))
            graphObject.Edges.Weight(findedge(graphObject, ...
                deleteEdges2.EndNodes(i,1), ...
                deleteEdges2.EndNodes(i,2))) = 0;
            subgraphOfCut.Edges.Weight(findedge(subgraphOfCut, ...
                deleteEdges2.EndNodes(i,1), ...
                deleteEdges2.EndNodes(i,2))) = 0;
        end

        %setzte gewicht der selectedEdge auf 1
        graphObject.Edges.Weight(findedge(graphObject, ...
                    selectedEdge{1}, ...
                    selectedEdge{2})) = 1;
        subgraphOfCut.Edges.Weight(findedge(subgraphOfCut, ...
                    selectedEdge{1}, ...
                    selectedEdge{2})) = 1;

        %greedy: finde alle weiteren kanten bzw. lösche Überflüssige
        numberOfSelectedEdges = sum(subgraphOfCut.Edges.Weight);
        % es kann höchstens eine überflüssige Kante geben.
        if numberOfSelectedEdges > cutsizes(selectedCut)
            % zufällig überflüssige Kante löschen
            % erst finden
            weightOneEdges = subgraphOfCut.Edges.EndNodes(find(subgraphOfCut.Edges.Weight == 1), :);
            if isempty(weightOneEdges)
            else
                % waehle eine Kante mit gewicht 1 aus.
                if size(weightOneEdges,1) == 1
                     selectedEdge = weightOneEdges;
                else
                    selectedEdge = datasample(weightOneEdges, 1,'Replace',false);
                end
            end
            % dann löschen
            graphObject.Edges.Weight(findedge(graphObject, ...
                        selectedEdge{1}, ...
                        selectedEdge{2})) = 0;
            subgraphOfCut.Edges.Weight(findedge(subgraphOfCut, ...
                        selectedEdge{1}, ...
                        selectedEdge{2})) = 0;
            numberOfSelectedEdges = numberOfSelectedEdges - 1;
        end
        
        % Kanten dazu tun, falls zu wenige da sind:
        %loesche im subgraph alle knoten, die mit kanten mit Gewicht 1 verbunden sind
        connectedVertices = subgraphOfCut.Edges.EndNodes(find(subgraphOfCut.Edges.Weight == 1), 1);
        connectedVertices = [connectedVertices ; subgraphOfCut.Edges.EndNodes(find(subgraphOfCut.Edges.Weight == 1), 2)];
        % subgraphOfCut verstümmeln: Er hat gleich nur noch Kanten, die man
        % dazu nehmen darf, ohne die Matchingeigenschaft zu verletzten.
        % Bereits mit TSVs verknüpfte Knoten werden einfach gelöscht.
        subgraphOfCut = subgraph(subgraphOfCut, setdiff(subgraphOfCut.Nodes.Name, connectedVertices));

        while((size(subgraphOfCut.Edges,1) ~= 0) && (numberOfSelectedEdges < cutsizes(selectedCut)))    
            %get edge
            if (size(subgraphOfCut.Edges,1)~=1)%datasample fails for single edge
                selectedEdge = datasample(subgraphOfCut.Edges, 1,'Replace',false);
            else
                selectedEdge = subgraphOfCut.Edges;
            end
            %add edge to graph
            graphObject.Edges.Weight(findedge(graphObject, ...
                selectedEdge.EndNodes(1,1), ...
                selectedEdge.EndNodes(1,2))) = 1;
            %delete vertices and eges
            sourceNode = str2num(selectedEdge.EndNodes{1});
            destNode = str2num(selectedEdge.EndNodes{2});
            subgraphOfCut = subgraph(subgraphOfCut, setdiff(subgraphOfCut.Nodes.Name, [{int2str(sourceNode)}, {int2str(destNode)}]));

            numberOfSelectedEdges = numberOfSelectedEdges + 1;
        end        
    end
end


