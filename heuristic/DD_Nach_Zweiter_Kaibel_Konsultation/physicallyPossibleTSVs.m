function [possibleVertialLinksAdj] = physicallyPossibleTSVs(ComponentInLayer,componentPositions, componentOrder, propagationSpeed , freq, d)

% In die Adiazenzmatrix wird 1 eingetragen, wenn der Abstand zwischen zwei
% routern so klein ist, dass es moeglich waere, einen TSV zu bauen.
ell =size(ComponentInLayer, 1);
n = size(componentPositions,1);
possibleVertialLinksAdj = zeros(n);
% generate Vlink graph
for interspace = 1:ell-1
    for componentAbove = componentOrder{interspace}(:)'
        for componentBelow = componentOrder{interspace+1}(:)'
            
            %simple model with numbers from physical model
            if (sum(abs(componentPositions(componentAbove, 1:2)-...
                    componentPositions(componentBelow, 1:2))) <d(interspace))
            
            
            % are the two components in reach of each other?
            % formula: take s = 2D manhattan-distance of both components
            %               v1, v2 = propagationSpeed of the layers
            %               f1, f2 = clock frequency of the layers, freq
            %    calculate: t = 1/max(f1, f2)
            %         test: s/max(v1,v2) <= t
            %               if true: both components are in reach
            %                        --> connect them in the graph
% %             if (sum(abs(componentPositions(componentAbove, 1:2)-...
% %                     componentPositions(componentBelow, 1:2)))/max(...
% %                     propagationSpeed(interspace), 1* propagationSpeed(...
% %                     interspace+1)) <= 1/max(freq(interspace), freq(interspace + 1)))
                % connest both components in Graph
                possibleVertialLinksAdj(componentAbove,componentBelow) = 1;
                possibleVertialLinksAdj(componentBelow,componentAbove) = 1;
            end
        end
        
    end
end



end

