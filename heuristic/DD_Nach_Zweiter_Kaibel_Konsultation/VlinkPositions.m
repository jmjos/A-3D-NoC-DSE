function [ xPos, yPos, zPos ] = VlinkPositions( outsideMeasurements, numberOfVlinks, ell , n)
%VLINKPOSITIONS Summary of this function goes here
%   Detailed explanation goes here

% was sind die kooridnaten jeder oberen linken ecke der componenten
 %last position of solution vector x
    % is the summed sized of the largest layer
xPos = - ones(1,n);
yPos = - ones(1,n);
zPos = - ones(1,n); % The smaller of the two connected layer-indices
%place these components into the area per layer
vlinkIndex = 1;
for layerinterspace = 1:ell-1
    gridSize = ceil(sqrt(numberOfVlinks(layerinterspace)))^2; % can be done faster
    spacing = outsideMeasurements/sqrt(gridSize);
    %placing
    vlinkIndexlocal = 1;
    for gridIndexY = 1:sqrt(gridSize)
        for gridIndexX = 1:sqrt(gridSize)
            if (vlinkIndexlocal <= numberOfVlinks(layerinterspace))
                xPos(vlinkIndex) = (gridIndexX - 1) * spacing;
                yPos(vlinkIndex) = (gridIndexY - 1) * spacing;
                zPos(vlinkIndex) = layerinterspace;
                vlinkIndex = vlinkIndex+1;
                vlinkIndexlocal = vlinkIndexlocal+1;
            end
        end
    end    
end


end

