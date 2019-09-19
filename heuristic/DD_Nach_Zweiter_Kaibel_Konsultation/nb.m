function [graphObject] = nb(graphObject, partitions, cutsizes)
    %ziehe zufaelligen cut:
    selectedCut = datasample(1:length(partitions)-1, 1);
    selectedCut = 1;
    nodeIds = union(partitions{selectedCut}, partitions{selectedCut+1});
    subgraphOfCut = subgraph(graphObject, nodeIds);

    % waehle eine Kante mit gewicht 0 aus.
    selectedEdge = datasample(subgraphOfCut.Edges.EndNodes(find(subgraphOfCut.Edges.Weight == 0), :), 1,'Replace',false)
    
    
    selectedEdge = subgraphOfCut.Edges.EndNodes(33, :)% 20 41

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

    %greedy: finde alle weiteren kanten
    numberOfSelectedEdges = sum(subgraphOfCut.Edges.Weight);
    %loesche im subgraph alle knoten, die mit kanten mit 1 verbunden sind
    connectedVertices = subgraphOfCut.Edges.EndNodes(find(subgraphOfCut.Edges.Weight == 1), 1);
    connectedVertices = [connectedVertices ; subgraphOfCut.Edges.EndNodes(find(subgraphOfCut.Edges.Weight == 1), 2)];
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


