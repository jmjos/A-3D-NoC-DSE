function [ linkLoad ] = addPathToNetwork( visitedRouters, linkLoad, u )

for visitedRoutersIndex = 2:length(visitedRouters)
    % Quell- und Zielrouter aller Links, die traversiert
    % werden.
    linkSource = visitedRouters(visitedRoutersIndex-1);
    linkDest = visitedRouters(visitedRoutersIndex);
    % trage Last oder Energieverbrauch des Links ein.
    linkLoad(linkSource, linkDest) = ...
        linkLoad(linkSource, linkDest)  + u;
end

end

