function [] = plotResults(componentPositions, ai, bi, networkGraph, saveasName)
    
    startX = componentPositions(:,1);
    startY = componentPositions(:,2);
    startZ = componentPositions(:,3);
    routerX = startX;
    routerY = startY;
    routerZ = startZ;
    numberOfTiles = length(startX);
    ell = max(startZ);
       
    fig = figure(2);
    hold on

    layerOffset =0;

    %size of chip
    xMin = min(startX) - layerOffset;
    xMax = max(startX +ai) + layerOffset;
    yMin = min(startY) - layerOffset;
    yMax = max(startY + bi) + layerOffset;
    zMin = min(startZ);
    zMax = max(startZ);

    axisOffset = 2;
    axis([xMin-axisOffset xMax+axisOffset...
        yMin-axisOffset yMax+axisOffset...
        zMin-.002 zMax]);

    %plot layers
    layerTextOffset = layerOffset + .5;
    for z = 1:max(startZ)
        %aiMax = max(ai(startZ == z));
        %biMax = max(bi(startZ == z));
        %xMax = max(startX(startZ == z))+layerOffset+aiMax;
        %xMin = min(startX(startZ == z))-layerOffset;
        %yMax = max(startY(startZ == z))+layerOffset+biMax;
        %yMin = min(startY(startZ == z))-layerOffset;
        fill3( [xMin xMin xMax xMax], [yMin yMax yMax yMin], [z z z z],...
            [.6, .6, .6], ...
            'FaceAlpha', .1, ...
            'FaceLighting', 'gouraud', ...
            'EdgeColor', 'none', ...
            'EdgeAlpha',.5, ...
            'LineStyle', ':', 'LineWidth', 2);
        layerText = ['Layer ', num2str(z)];
        text( xMax + layerTextOffset, mean([yMin, yMax]),...
            z, layerText, ...
            'HorizontalAlignment', 'left',...
            'FontName', 'Palatino Linotype');
    end

    %plot tiles
    for i =1:numberOfTiles
        %tiles vertexes
        %fprintf("Component at position %2.2f, %2.2f\n", startX(i) ,startY(i));
        %fprintf("Component size %2.2f, %2.2f\n",  bi(i)  , ai(i) );
        x1 = startX(i);
        x2 = startX(i)+ai(i);
        x3 = startX(i)+ai(i);
        x4 = startX(i);
        y1 = startY(i);
        y2 = startY(i);
        y3 = startY(i)+bi(i);
        y4 = startY(i)+bi(i);
        z = startZ(i)-.001;
        %plotting edges of tiles
        %plot3( [x1 x2 x3 x4 x1], [y1 y2 y3 y4 y1], [z z z z z], 'b:' )
        %ploting fill of tiles
        fill3( [x1 x2 x3 x4], [y1 y2 y3 y4], [z z z z],...
            'k',... 
            'FaceAlpha', .6-((ell-z)/ell*.6),...%.7-(z*0.2), ...
            'EdgeColor', 'b', ...
            'FaceLighting', 'gouraud', ...
            'EdgeAlpha',.5, ...
            'LineStyle', ':', 'LineWidth', 2);
        textOffsetX = 0.2;
        textOffsetY = .3;
        textContent = ['Tile ', num2str(i)];
        %text(x1 + textOffsetX, y1 + textOffsetY, z, textContent, ...
        %    'FontName', 'Palatino Linotype'); 
        text(mean([x1, x3]), mean([y2, y3]), z, ...
            textContent, ...
            'HorizontalAlignment', 'center',...
            'FontName', 'Palatino Linotype'); 
    end

    %plot routers and network
    for router = 1:numberOfTiles
        %plot routers
        plot3([routerX(router)],[routerY(router)],[routerZ(router)], ...
            'k.', ...
            'MarkerSize', 20, ...
            'MarkerFaceColor', [.5, .5, .5])
    end

    %plot links in network
    for edgeIndex = 1:length(networkGraph.Edges.EndNodes)
        source = str2num(networkGraph.Edges.EndNodes{edgeIndex, 1});
        dest = str2num(networkGraph.Edges.EndNodes{edgeIndex, 2});
        %plot 2D link
        if (componentPositions(source,3) == componentPositions(dest,3))
            h1a = plot3(...
                        [componentPositions(source,1), componentPositions(dest,1)],...
                        [componentPositions(source,2), componentPositions(dest,2)],...
                        [componentPositions(source,3), componentPositions(dest,3)],...
                        'LineStyle','-', ...
                        'Color', 'k', ...
                        'LineWidth', 1);
                    h1a.Color(4)=0.7; %30% transparant
        else
        %plot TSV
            h1a = plot3(...
                        [componentPositions(source,1), componentPositions(dest,1)],...
                        [componentPositions(source,2), componentPositions(dest,2)],...
                        [componentPositions(source,3), componentPositions(dest,3)],...
                        'LineStyle','-', ...
                        'Color', 'r', ...
                        'LineWidth', 3);
                    %set transparency
                    h1a.Color(4) = .3;
        end
    end



%         for i =1:n
%             for j= 1:n
%                 if (eA((i-1)*n + j) == 1 && sum(eA(1:(i-1)*n + j)~=0) == fNo) %hinterer teil schaut ob man im richtigen fluss ist
%                     %plot routers which are source/destination of the flow 
%                     plot3([x(rixSTART +i)],[x(riySTART + i)],...
%                         [x(rizSTART + i)],...
%                         'c.', 'MarkerSize',20)
%                     plot3([x(rixSTART +j)],[x(riySTART + j)],...
%                         [x(rizSTART + j)], ...
%                         'g.', 'MarkerSize',20)
%                 end
%             end
%         end
% 
%         %plot flows
%         for i =1: m
%             for j= 1:m
%                 %is there flow?
%                 if (x(fSTART + (fNo-1)* m^2 + (i-1)*m + j) > 0.001)
%                      %plot3([rixSTART+i rixSTART+j],[riySTART+i riySTART+j],[rizSTART+i rizSTART+j], 'r')
%                      quiver3(x(rixSTART+i), x(riySTART+i), x(rizSTART+i), x(rixSTART+j)-x(rixSTART+i), x(riySTART+j)-x(riySTART+i), x(rizSTART+j)-x(rizSTART+i), 'r')
%                      text( mean([x(rixSTART+i) x(rixSTART+j)]),mean([x(riySTART+i) x(riySTART+j)]),mean([x(rizSTART+i) x(rizSTART+j)]), num2str(x(fSTART + (fNo-1)* m^2 + (i-1)*m + j)) );
%                 end
%             end
%         end
    az = 18;
    el = 45;
    view(az, el);

    set( gca, ...
        'FontName', 'Palatino Linotype', ...
        'XGrid', 'on', ...
        'YGrid', 'on', ...
        'ZGrid', 'on', ...
        'XTick', floor(xMin):5:ceil(xMax), ...
        'YTick', floor(yMin):5:ceil(yMax), ...
        'ZTick', 0:1:ell, ...
        ...%'Xdir', 'reverse', ...
        'Ydir', 'reverse', ...
        'Zdir', 'reverse' ...
        );
    set(gcf, 'Position', [0, 0, 700, 700])
    set(gcf,'color','white')
%    export_fig [saveasName, '.png'] -transparent -m5
    hold off
end
