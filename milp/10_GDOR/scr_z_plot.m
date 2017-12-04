% MIT License
% 
% Copyright (c) 2017 JM Joseph
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

if (usePlotting)
    addpath('C:\Users\joseph\Documents\Git\3d-ia-milp\MATLAB\00_misc\export_fig');
    startX = x(tixSTART + 1: tixSTART + tixLENGTH);
    startY = x(tiySTART + 1: tiySTART + tiyLENGTH);
    startZ = x(tizSTART + 1: tizSTART + tizLENGTH);
    ai = x(aiSTART + 1: aiSTART + aiLENGTH);
    bi = x(biSTART + 1: biSTART + biLENGTH);
    %clf
    %close all

    for fNo = 1%:sum(eA)
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
        for z = 1:l
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
        for i =1: m
            %tiles vertexes
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
                'FaceAlpha', .7-(z*0.2), ...
                'EdgeColor', 'b', ...
                'FaceLighting', 'gouraud', ...
                'EdgeAlpha',.5, ...
                'LineStyle', ':', 'LineWidth', 2);
            textOffsetX = 0.2;
            textOffsetY = .3;
            textContent = ['Comp. ', num2str(i)];
            %text(x1 + textOffsetX, y1 + textOffsetY, z, textContent, ...
            %    'FontName', 'Palatino Linotype'); 
            text(mean([x1, x3]), mean([y2, y3]), z, ...
                textContent, ...
                'HorizontalAlignment', 'center',...
                'FontName', 'Palatino Linotype'); 
        end

        %plot routers and network
        for router = 1:m
            %plot routers
            plot3([x(rixSTART + router)],[x(riySTART + router)],[x(rizSTART + router)], ...
                'k.', ...
                'MarkerSize', 20, ...
                'MarkerFaceColor', [.5, .5, .5])
        end
        
        %plot links in network
        for i =1: m
            for j= 1:m
                if (x(eSTART + (i-1)*m + j) > 0.5)
                    if (x(rizSTART+i)<= x(rizSTART+j)-.5  || x(rizSTART+i)<= x(rizSTART+j)+.5 )
                        %plot 2D links
                        h1a = plot3(...
                            [x(rixSTART+i), x(rixSTART+j)],...
                            [x(riySTART+i), x(riySTART+j)],...
                            [x(rizSTART+i), x(rizSTART+j)],...
                            'LineStyle','-', ...
                            'Color', 'k', ...
                            'LineWidth', 1);
                        h1a.Color(4)=0.7; %30% transparant
                    else
                        %plot 3D links
                        h1a = plot3(...
                            [x(rixSTART+i), x(rixSTART+j)],...
                            [x(riySTART+i), x(riySTART+j)],...
                            [x(rizSTART+i), x(rizSTART+j)],...
                            'LineStyle','-', ...
                            'Color', 'r', ...
                            'LineWidth', 3);
                        %set transparency
                        h1a.Color(4) = .3;
                    end
                end
            end
        end
        
        for i =1:n
            for j= 1:n
                if (eA((i-1)*n + j) == 1 && sum(eA(1:(i-1)*n + j)~=0) == fNo) %hinterer teil schaut ob man im richtigen fluss ist
                    %plot routers which are source/destination of the flow 
                    plot3([x(rixSTART +i)],[x(riySTART + i)],...
                        [x(rizSTART + i)],...
                        'c.', 'MarkerSize',20)
                    plot3([x(rixSTART +j)],[x(riySTART + j)],...
                        [x(rizSTART + j)], ...
                        'g.', 'MarkerSize',20)
                end
            end
        end

        %plot flows
        for i =1: m
            for j= 1:m
                %is there flow?
                if (x(fSTART + (fNo-1)* m^2 + (i-1)*m + j) > 0.001)
                     %plot3([rixSTART+i rixSTART+j],[riySTART+i riySTART+j],[rizSTART+i rizSTART+j], 'r')
                     quiver3(x(rixSTART+i), x(riySTART+i), x(rizSTART+i), x(rixSTART+j)-x(rixSTART+i), x(riySTART+j)-x(riySTART+i), x(rizSTART+j)-x(rizSTART+i), 'r')
                     text( mean([x(rixSTART+i) x(rixSTART+j)]),mean([x(riySTART+i) x(riySTART+j)]),mean([x(rizSTART+i) x(rizSTART+j)]), num2str(x(fSTART + (fNo-1)* m^2 + (i-1)*m + j)) );
                end
            end
        end
        az = 16;
        el = 48;
        view(az, el);
        
        set( gca, ...
            'FontName', 'Palatino Linotype', ...
            'XGrid', 'on', ...
            'YGrid', 'on', ...
            'ZGrid', 'on', ...
            'XTick', xMin:1:ceil(xMax), ...
            'YTick', yMin:1:ceil(yMax), ...
            'ZTick', 1:1:l, ...
            ...%'Xdir', 'reverse', ...
            'Ydir', 'reverse', ...
            'Zdir', 'reverse' ...
            );
        print(fig, ['flow', num2str(fNo)], '-depsc');
        hold off
    end
   
    
end