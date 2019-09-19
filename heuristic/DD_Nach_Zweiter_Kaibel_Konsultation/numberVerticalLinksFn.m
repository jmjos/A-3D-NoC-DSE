function [ bestConfiguration, bestCosts ] = numberVerticalLinksFn( ...
    ell,n, u, ComponentInLayer, outsideMeasurements, areaPerLayer, ...
    fSinglePort, weightArea, weightCommunication, fKOZ, fR2D, ...
    componentPositionsGlobal, componentOrder, propagationSpeed, freq, ...
    d, command)
%NUMBERVERTICALLINKSFN Summary of this function goes here
%   Detailed explanation goes here


%das hier basiert auf der annahme, dass man so viele TSVs bauen kann,
%wie man minimal komponenten in einem der beiden layer hat. das ist nicht
%richtig. in wirklichkeit benoetig man ein largest maximal matching auf dem
%graphen der moelgichen TSV implementierungen (aus technologie modell).
% maxNumberOfVlinks = zeros(1,ell-1);
% for layerinterspace = 1:ell-1
%     maxNumberOfVlinks(layerinterspace) = min(numel(ComponentInLayer{layerinterspace}),...
%         numel(ComponentInLayer{layerinterspace + 1}));
% end

%implementierung mit largest maximual matching.
numberOfRouters = length(componentPositionsGlobal);
possibleVertialLinksAdj = physicallyPossibleTSVs(ComponentInLayer,componentPositionsGlobal, componentOrder, propagationSpeed , freq, d);
maxNumberOfVlinks = zeros(1,ell-1);
for interspace = 1:ell-1
    %componenten im layer darueber und darunter
    componentAbove = componentOrder{interspace}(:)';
    componentBelow = componentOrder{interspace+1}(:)';
    
    % subgraph des layerinterspace
    % setze alle Kanten auf null, die nicht zum layerinterspace gehoeren
    otherComponents = setdiff(1:numberOfRouters, union(componentAbove, componentBelow));
    interlayerAdj = possibleVertialLinksAdj;
    interlayerAdj(otherComponents, :) = 0;
    interlayerAdj(:, otherComponents) = 0;
    
    %mit zusaetlicher quelle und senke s und t
    interlayerAdjWithSandT = zeros(numberOfRouters+2, numberOfRouters+2);
    interlayerAdjWithSandT([1:numberOfRouters], [1:numberOfRouters]) = interlayerAdj;
    %verbinde s mit layer above
    interlayerAdjWithSandT(numberOfRouters+1, componentAbove) = 1;
    interlayerAdjWithSandT(componentAbove, numberOfRouters+1) = 1;
    %verbinde t mit layer below
    interlayerAdjWithSandT(componentBelow, numberOfRouters+2) = 1;
    interlayerAdjWithSandT(numberOfRouters+2, componentBelow) = 1;
    
    
    % maxflow
    G = graph(interlayerAdjWithSandT);
    maxNumberOfVlinks(interspace) = maxflow(G, numberOfRouters+1, numberOfRouters+2);
end

if (~ strcmp(command, 'tsvmax')) 
    bestCosts = Inf;
    bestConfiguration = zeros(size(maxNumberOfVlinks));

    % old lines 17-41
    % % is the summed sized of the largest layer
    % numberOfComponents = zeros(1,ell);
    % for layer = 1:ell
    %     numberOfComponents(layer) = numel(ComponentInLayer{layer});
    % end
    % xPositions = - ones(1,n);
    % yPositions = - ones(1,n);
    % %place these components into the area per layer
    % for layer = 1:ell
    %     gridSize = ceil(sqrt(numberOfComponents(layer)))^2; % can be done faster
    %     spacing = outsideMeasurements/sqrt(gridSize);
    %     %placing
    %     componentIndex = 1;
    %     for gridIndexY = 1:sqrt(gridSize)
    %         for gridIndexX = 1:sqrt(gridSize)
    %             if (componentIndex <= numberOfComponents(layer))
    %                 xPositions(ComponentInLayer{layer}(componentIndex)) = (gridIndexX - 1) * spacing;
    %                 yPositions(ComponentInLayer{layer}(componentIndex)) = (gridIndexY - 1) * spacing;
    %                 componentIndex = componentIndex+1;
    %             end
    %         end
    %     end    
    % end
    % clear gridIndexY gridIndexX componentIndex gridSize spacing

    % take xPositions and yPositions directly from data
    xPositions = componentPositionsGlobal(:,1)';
    yPositions = componentPositionsGlobal(:,2)';


    % wie viel will jede komponente nach oben und nach unten kommunizieren?
    % (entspricht Modified Application Graph)
    communicationUpward = zeros(1,n);
    communicationDownwards = zeros(1,n);
    for layer=1:ell
        above = [];
        for aboveIndexes = 1:layer - 1
            above = [above, ComponentInLayer{aboveIndexes}];
        end
        below = [];
        for aboveIndexes = layer + 1:ell
            below = [below, ComponentInLayer{aboveIndexes}];
        end

            % Summe ueber i=component, j=alle Komponenten above/below von u_ij
            % + u_ji
        for component = ComponentInLayer{layer}
            communicationUpward(component)=sum(u(component, above)) ...
                + sum(u(above, component));
            communicationDownwards(component)=sum(u(component, below)) ...
                + sum(u(below, component));
        end
    end
    clear above below

    layerOfComponent = -ones(1,n);
    for layer = 1:ell
        for component = ComponentInLayer{layer}
            layerOfComponent(component) = layer;
        end
    end

    %TMP (Hop Distance Estimation ?!?)
    % Kommunikation in Abhängigkeit von der Anzahl an Vlinks nach ob und nach
    % unten berechnen.
    averageComm = zeros(1,10);
    averageCommNb= zeros(1,10);

    communicationPerVlinkNumberAbove = -ones(ell-1, max(maxNumberOfVlinks));
    for layerInterspace = 1:ell - 1
        for vLinkLimit = 1:maxNumberOfVlinks(layerInterspace)
            [ xPosVlink, yPosVlink ] = VlinkPositionsPerLimit( ...
                outsideMeasurements, vLinkLimit);

            % components above
            componentsAbove = find(layerOfComponent == layerInterspace);
            componentPosition = [xPositions(componentsAbove); yPositions(componentsAbove)];
            vLinkPos = [ xPosVlink; yPosVlink ];
            for componentLocalIndex =1 : size(componentsAbove,2)
                distances = sum(abs(repmat(componentPosition(:,componentLocalIndex), 1, size(vLinkPos, 2)) - vLinkPos));
                [~, vLinkIndex] = min(distances);
                if (communicationPerVlinkNumberAbove(layerInterspace, vLinkLimit)== -1)
                    communicationPerVlinkNumberAbove(layerInterspace, vLinkLimit) = 0;
                end
                communicationPerVlinkNumberAbove(layerInterspace, vLinkLimit)...
                    = communicationPerVlinkNumberAbove(layerInterspace, vLinkLimit)...
                    + distances(vLinkIndex) * communicationDownwards(componentsAbove(componentLocalIndex));
            end  
        end
    end



    communicationPerVlinkNumberBelow = -ones(ell-1, max(maxNumberOfVlinks));
    for layerInterspace = 1:ell - 1
        for vLinkLimit = 1:maxNumberOfVlinks(layerInterspace)
            [ xPosVlink, yPosVlink ] = VlinkPositionsPerLimit( ...
                outsideMeasurements, vLinkLimit);

            % components above
            componentsBelow = find(layerOfComponent == layerInterspace + 1);
            componentPosition = [xPositions(componentsBelow); yPositions(componentsBelow)];
            vLinkPos = [ xPosVlink; yPosVlink ];
            for componentLocalIndex =1 : size(componentsBelow,2)
                distances = sum(abs(repmat(componentPosition(:,componentLocalIndex), 1, size(vLinkPos, 2)) - vLinkPos));
                [~, vLinkIndex] = min(distances);
                if (communicationPerVlinkNumberBelow(layerInterspace, vLinkLimit)== -1)
                    communicationPerVlinkNumberBelow(layerInterspace, vLinkLimit) = 0;
                end
                communicationPerVlinkNumberBelow(layerInterspace, vLinkLimit)...
                    = communicationPerVlinkNumberBelow(layerInterspace, vLinkLimit)...
                    + distances(vLinkIndex) * communicationUpward(componentsBelow(componentLocalIndex));
            end       
        end
    end

    disp(maxNumberOfVlinks);
    disp(prod(maxNumberOfVlinks) - 1);

    for configurationNb = 0: prod(maxNumberOfVlinks) - 1
        if ~mod(configurationNb, 100000)
            disp(configurationNb)
        end
        % calculate configuration
        configNb = configurationNb;
        factor = prod(maxNumberOfVlinks);
        configuration = zeros(1,ell-1);
        for layerinterspace = 1:ell-1
            factor = factor/maxNumberOfVlinks(layerinterspace);
            configuration (layerinterspace) = fix(configNb / factor) + 1;
            configNb = rem(configNb,factor);
        end

        % was sind die kooridnaten der vlinks nach oben und nach unten
        costs = 0;
        for layerinterspace = 1:ell-1
            costs = costs + communicationPerVlinkNumberBelow(...
                layerinterspace, configuration(layerinterspace)) + ...
                communicationPerVlinkNumberAbove(...
                layerinterspace, configuration(layerinterspace));
            assert(communicationPerVlinkNumberBelow(...
                layerinterspace, configuration(layerinterspace)) ~= -1, 'sad');
            assert(communicationPerVlinkNumberAbove(...
                layerinterspace, configuration(layerinterspace)) ~= -1, 'sad');
        end


    %     [ xPos, yPos, zPos ] = VlinkPositions( outsideMeasurements, configuration, ell , n);
    %     costs = 0;
    %     % calculate communication costs
    %     for component = 1:n
    %         componentPosition = [xPositions(component); yPositions(component)];
    %         componentLayer = layerOfComponent(component);
    %         if (componentLayer ~= 1)
    %             %above
    %             VlinkAbovePositions = [xPos(zPos==componentLayer-1); yPos(zPos==componentLayer-1)];
    %             distances = sum(abs(repmat(componentPosition, 1, size(VlinkAbovePositions, 2)) - VlinkAbovePositions));
    %             [~, vLinkIndex] = min(distances);
    %             costs = costs + distances(vLinkIndex) * communicationUpward(component);
    %         end
    %         
    %         if (componentLayer ~= ell)
    %             %below
    %             VlinkBelowPositions = [xPos(zPos==componentLayer); yPos(zPos==componentLayer)];
    %             distances = sum(abs(repmat(componentPosition, 1, size(VlinkBelowPositions, 2)) - VlinkBelowPositions));
    %             [~, vLinkIndex] = min(distances);
    %             costs = costs + distances(vLinkIndex) * communicationDownwards(component);
    %         end
    %     end


        % add weight
        costs = weightCommunication * costs;

        % calculate area costs
        VRouterLinksinLayer = [configuration, 0]+  [0, configuration];
        costs = costs + weightArea*fKOZ*sum(configuration) + ...
            weightArea*fSinglePort*VRouterLinksinLayer'; % KOY und 2* R3Dratio pro vlink  

        % update best costs
        if (costs < bestCosts)
            bestCosts = costs;
            bestConfiguration = configuration;
        end

    end
end

if (strcmp(command, 'tsvmax'))
    bestConfiguration = maxNumberOfVlinks;
    bestCosts = -1;
end

fprintf('VLinks pro Layerinterspace: ')
for xi = 1:ell-1
    if (xi ~= ell-1)
        fprintf('%u, ', bestConfiguration(xi));
    else
        fprintf( '%u \n', bestConfiguration(xi));
    end
end

fprintf('Kosten der VLinks: %u \n', bestCosts);
end

