function [costs] = costFn(p, applicationGraph, intralayerGraph, possibleVerticalNetwork)
networkGraph = intralayerGraph;

%add edges
for i = 1:length(p)
    if (p(i) ==1)
        node1 = possibleVerticalNetwork.Edges.EndNodes(i, 1);
        node2 = possibleVerticalNetwork.Edges.EndNodes(i, 2);
        %addedge
        networkGraph = addedge(networkGraph,node1, node2, 1);
    end
end

costs = 0;
for edgeIndex = 1:size(applicationGraph.Edges.EndNodes,1)
    sourceNode = applicationGraph.Edges.EndNodes(edgeIndex,1);
    destNode = applicationGraph.Edges.EndNodes(edgeIndex,2);
    data = applicationGraph.Edges.Weight(edgeIndex);
    costs = costs + data * ...
        length(shortestpath(networkGraph, sourceNode, destNode));
end

end

