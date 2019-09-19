function [ xPos, yPos ] = VlinkPositionsPerLimit( ...
    outsideMeasurements, VlinkLimit)
%VLINKPOSITIONS Summary of this function goes here
%   Detailed explanation goes here

% was sind die kooridnaten jeder oberen linken ecke der componenten
 %last position of solution vector x
    % is the summed sized of the largest layer
xPos = - ones(1,VlinkLimit);
yPos = - ones(1,VlinkLimit);
% The smaller of the two connected layer-indices
%place these components into the area per layer
vlinkIndex = 1;

gridSize = ceil(sqrt(VlinkLimit)); % length of one side of the grid
spacing = outsideMeasurements/gridSize;

%placement
places = sort(randsample(gridSize^2, VlinkLimit))-1;

for i = 1:length(places)
    place = places(i);
    % Division mit Rest
    gridIndexX = floor(place/gridSize);
    gridIndexY = place - gridIndexX*gridSize;
    xPos(i) = gridIndexX * spacing;
    yPos(i) = gridIndexY * spacing;
end

%alter Code:
% here, the vlinks weren't placed randomly, but one next to the other until
% all were placed. The rest of the square space remained empty, which
% wasn't that cool.
% placing
% vlinkIndexlocal = 1;
% for gridIndexY = 1:gridSize
%     for gridIndexX = 1:gridSize
%         if (vlinkIndexlocal <= VlinkLimit)
%             xPos(vlinkIndex) = (gridIndexX - 1) * spacing;
%             yPos(vlinkIndex) = (gridIndexY - 1) * spacing;
%             vlinkIndex = vlinkIndex+1;
%             vlinkIndexlocal = vlinkIndexlocal+1;
%         end
%     end
% end    
% ende des alten Codes

end

