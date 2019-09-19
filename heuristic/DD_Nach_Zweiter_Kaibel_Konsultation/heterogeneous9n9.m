% This script evaluates the 2 layer, 18 component heterogeneous example.

% Lennarts Data goes into DD_Nach_Zweiter_Kaibel_Konultation/Eingabe/ 
% Instanzen/heterogeneous/input_values.m

% HINWEISE: die optimierte Lösung ist wieder ein Zufallsexperiment (mehrfach wiederholen!)
% Änderungen an der Eingabe werden nur durch main.m wirksam.

saveas = 'heterogeneous18_conventional';

%% whitespace calculation, run main.m in advance!

% whitespace
% Fläche des Chips als Quadrat minus Fläche der Komponenten und Router
chipArea = 0;
usedArea = 0;
for i = 1:ell
    chipArea = max([chipArea, sum(rows{i}), sum(cols{i})]);
    usedArea = usedArea + sum(sum(areas{ell}));
end
chipArea = chipArea*chipArea*ell;
whitespace1 = chipArea - usedArea;

% Fläche der Tiles minus benötigte Fläche
areaOfAllTiles = sum(ai.*bi);
whitespace2 = areaOfAllTiles - usedArea;

% Textausgabe dann am Ende wegen SDP-Wasserfall


%% comparison to 9,9, small on top, big at the bottom configuration
smallComponentArea = Cimpl(1,1);
bigComponentArea = Cimpl(10,2);

AreaUpperLayer = 9*smallComponentArea + 9*fKOZ + (9*1 + 5 + 4*4 + 4*3)*fSinglePort(1);
AreaLowerLayer = 9*bigComponentArea + (9*1 + 5 + 4*4 + 4*3)*fSinglePort(2);

% obsolet, wir machen später das SDP!
chipArea2 = max([AreaUpperLayer, AreaLowerLayer]);
usedArea2 = AreaUpperLayer + AreaLowerLayer;

whitespace3 = chipArea2 - usedArea2;

% Textausgabe dann am Ende wegen SDP-Wasserfall

%% preparation for the plot
eta2 = 0.5;
areas2 = cell(1,2);
areas2{2} = [(bigComponentArea + 4*fSinglePort(2)) (bigComponentArea + 5*fSinglePort(2)) (bigComponentArea + 4*fSinglePort(2));
          (bigComponentArea + 5*fSinglePort(2)) (bigComponentArea + 6*fSinglePort(2)) (bigComponentArea + 5*fSinglePort(2));
          (bigComponentArea + 4*fSinglePort(2)) (bigComponentArea + 5*fSinglePort(2)) (bigComponentArea + 4*fSinglePort(2))];
areas2{1} = [(fKOZ + smallComponentArea + 4*fSinglePort(1)) (fKOZ + smallComponentArea + 5*fSinglePort(1)) (fKOZ + smallComponentArea + 4*fSinglePort(1));
          (fKOZ + smallComponentArea + 5*fSinglePort(1)) (fKOZ + smallComponentArea + 6*fSinglePort(1)) (fKOZ + smallComponentArea + 5*fSinglePort(1));
          (fKOZ + smallComponentArea + 4*fSinglePort(1)) (fKOZ + smallComponentArea + 5*fSinglePort(1)) (fKOZ + smallComponentArea + 4*fSinglePort(1))];
%[rows2, cols2] = minimizeRowsAndColumnsSDP(areas2, eta2);

componentOrder2 = cell(2,1);
componentOrder2{1} = [1 2 3; 4 5 6; 7 8 9];
componentOrder2{2} = [10 11 12; 13 14 15; 16 17 18];

coordiantes = zeros(18,3);
bj = zeros(18, 1);
aj = zeros(18, 1);
rows2 = cell(1,ell);
cols2 = cell(1,ell);
for layer = 1:ell
    if (useSDP)
        [rows2{layer}, cols2{layer}, ~] = minimizeRowsAndColumnsSDP( areas2{layer} , eta2);
    else
        [rows2{layer}, cols2{layer}, ~] = minimizeRowsAndColumns( areas2{layer} , eta2);
    end
end
for layer = 1:ell
    for row = 1:size(componentOrder2{layer}, 1)
        for col=1:size(componentOrder2{layer}, 2)
            %fprintf("im in layer %d, row %d, col %d\n", layer, row, col )
            
            component = componentOrder2{layer}(row,col);
            coordiantes(component, 1) = sum(cols2{2}(1:col-1));
            coordiantes(component, 2) = sum(rows2{2}(1:row-1));
            coordiantes(component, 3) = layer;
            bj(component) = rows2{layer}(row);
            aj(component) = cols2{layer}(col);
            %fprintf("Component at position %2.2f, %2.2f\n", finalCoordiantes(component, 1) , finalCoordiantes(component, 2));
            %fprintf("Component size %2.2f, %2.2f\n",  bi(component)  , ai(component) );
        end
    end
end

%aj = [sqrt(smallComponentArea)*ones(9,1),sqrt(bigComponentArea)*ones(9,1)];
%bj = [sqrt(smallComponentArea)*ones(9,1),sqrt(bigComponentArea)*ones(9,1)];

% coordiantes = zeros(18,3);
% for i = 1:3
%     for j = 1:3
%         index = 3*(i-1)+j;
%         coordiantes(index,1) = (i-1)*sqrt(bigComponentArea + 6*fSinglePort);
%         coordiantes(index,2) = (j-1)*sqrt(bigComponentArea + 6*fSinglePort);
%         coordiantes(index,3) = 1;
%         coordiantes(index+ 9,2) = (i-1)*sqrt(bigComponentArea + 6*fSinglePort);
%         coordiantes(index+ 9,2) = (j-1)*sqrt(bigComponentArea + 6*fSinglePort);
%         coordiantes(index+ 9,2) = 2;
%     end
% end

%nochmal mit Ergebnis von SDP!
chipArea2 = max([sum(rows2{1})*sum(cols2{1}), sum(rows2{2})*sum(cols2{2})]);
usedArea2 = AreaUpperLayer + AreaLowerLayer;

whitespace3 = chipArea2 - usedArea2;

% Netzwerk
network = digraph(zeros(18),cellstr(strsplit(num2str(1:18), ' ')));
% 2d-connections in lower layer
% 10 -- 11 -- 12
%  i     i     i
% 13 -- 14 -- 15
%  i     i     i
% 16 -- 17 -- 18
% x
   startnodes = [10,11,13,14,16,17];
   endnodes = [11,12,14,15,17,18];
   network = network.addedge([startnodes,endnodes],[endnodes,startnodes], 1);
% y
   startnodes = [10,13,11,14,12,15];
   endnodes = [13,16,14,17,15,18];
   network = network.addedge([startnodes,endnodes],[endnodes,startnodes], 1);
% 3d-connections (unidirectional)
    startnodes = [1,2,3,4,5,6,7,8,9];
    endnodes = startnodes + 9;
    network = network.addedge(startnodes, endnodes, 1 );

%% Hop-Distance and max link bandwidth

% hop distance
fprintf("hop distance: ");
completeDistance2 = 0;
numberofConnections2 = 0;
for i = 1:n
    for j = i+1:n
        if (u(i,j)~=0)
            completeDistance2 = completeDistance2 + u(i,j)*(length(shortestpath(network, num2str(i), num2str(j)))-1);
            numberofConnections2 = numberofConnections2 + 1;
        end
        if (u(j,i)~=0)
            completeDistance2 = completeDistance2 + u(j,i)*(length(shortestpath(network, num2str(j), num2str(i))) -1); 
            numberofConnections2 = numberofConnections2 + 1;
        end
    end
end
fprintf(" %2.2f\n", completeDistance2/numberofConnections2);

% max link bandwidth
% for optimized problem
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

% the same thing again for unoptimized problem
bandwidthCounterUnoptimized = zeros(18);
for i = 1:n
    for j = i+1:n
        if (u(i,j)~=0)
            workingPath = shortestpath(network, num2str(i), num2str(j));
            for k = 1:(length(workingPath)-1)
                node1 = workingPath(k);
                node2 = workingPath(k+1);
                node1 = str2num(node1{1});
                node2 = str2num(node2{1});
                bandwidthCounterUnoptimized(node1,node2) = bandwidthCounterUnoptimized(node1,node2) + u(i,j);
            end
        end
        if (u(j,i)~=0)
            workingPath = shortestpath(network, num2str(j), num2str(i));
            for k = 1:(length(workingPath)-1)
                node1 = workingPath(k);
                node2 = workingPath(k+1);
                node1 = str2num(node1{1});
                node2 = str2num(node2{1});
                bandwidthCounterUnoptimized(node1,node2) = bandwidthCounterUnoptimized(node1,node2) + u(j,i);
            end
        end
    end
end
maximumLinkLoadUnoptimized = max(max(bandwidthCounterUnoptimized));
maximumLinksUnoptimized = find(bandwidthCounterUnoptimized == maximumLinkLoadUnoptimized);
% find gives single numbers, find the two again!
maximumLinksUnoptimized = [maximumLinksUnoptimized, zeros(length(maximumLinksUnoptimized),1)];
for i= 1:length(maximumLinksUnoptimized)
    maximumLinksUnoptimized(i,:) = [mod((i-1),18)+1,floor((i-1)/18)+1];
end

%% plot for second configuration

%just some graph stuff:
componentPositions = coordiantes;
disp('Done.');
close all
plot(network,'XData',componentPositions(:,1),'YData',...
    componentPositions(:,2),'ZData',componentPositions(:,3),...
    'NodeLabel',network.Nodes.Name)

fprintf("size of layers:\n")
currentMaxX = zeros(ell,1);
currentMaxY = zeros(ell,1);
for layer = 1:ell
    layerComponents = find(coordiantes(:,3)==layer);
    currentMaxX(layer) = max(coordiantes(layerComponents, 1) + aj(layerComponents));
    currentMaxY(layer) = max(coordiantes(layerComponents, 2) + bj(layerComponents));
    fprintf("   in layer %d: %2.2f\n", layer, currentMaxX(layer)*currentMaxY(layer));
end

% Textausgaben hinter SDP, wegen der SDP-Textausgabe
fprintf(['\n\nOPTIMIERTE LÖSUNG:\n', ...
    'Fläche des größten Layers (Quadrat): %6.2f\n',...
    'gesamte Chipfläche (Quadrat):        %6.2f\n',...
    'genutzte Fläche (Komp, Router, KOZ): %6.2f\n',...
    'Whitespace:                          %6.2f\n',...
    'summierter Datenfluss aller Links:   %6.2f\n',...
    'größter Datenfluss auf einem Link:   %6.2f\n'],...
    chipArea, chipArea*2, usedArea,...
        whitespace1, completeDistance, maximumLinkLoadOptimized);

fprintf(['\n\n9 PLUS 9 LÖSUNG:\n', ...
    'Fläche des größten Layers (Quadrat): %6.2f\n',...
    'gesamte Chipfläche (Quadrat):        %6.2f\n',...
    'genutzte Fläche (Komp, Router, KOZ): %6.2f\n',...
    'Whitespace:                          %6.2f\n',...
    'summierter Datenfluss aller Links:   %6.2f\n',...
    'größter Datenfluss auf einem Link:   %6.2f\n'],...
    chipArea2, chipArea2*2, usedArea2, whitespace3, ...
    completeDistance2, maximumLinkLoadUnoptimized);

run('savesolutionforMILP.m')

plotResults(componentPositions, aj,bj, network, saveas)
save([saveas, '.mat'])
