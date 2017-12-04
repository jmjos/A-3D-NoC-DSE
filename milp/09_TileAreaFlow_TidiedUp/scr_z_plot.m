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
    startX = x(tixSTART + 1: tixSTART + tixLENGTH);
    startY = x(tiySTART + 1: tiySTART + tiyLENGTH);
    startZ = x(tizSTART + 1: tizSTART + tizLENGTH);
    ai = x(aiSTART + 1: aiSTART + aiLENGTH);
    bi = x(biSTART + 1: biSTART + biLENGTH);
    %clf
    %close all

    for fNo = 1%:sum(eA)
        figure(2)
        hold on

        %plot tiles
        for i =1: m
            x1 = startX(i);
            x2 = startX(i)+ai(i);
            x3 = startX(i)+ai(i);
            x4 = startX(i);
            y1 = startY(i);
            y2 = startY(i);
            y3 = startY(i)+bi(i);
            y4 = startY(i)+bi(i);
            z = startZ(i);   
            plot3( [x1 x2 x3 x4 x1], [y1 y2 y3 y4 y1], [z z z z z] )
        end

        %plot routers and network
        for router = 1:m
            plot3([x(rixSTART + router)],[x(riySTART + router)],[x(rizSTART + router)], 'k*')
        end
        for i =1:n
            for j= 1:n
                if (eA((i-1)*n + j) == 1 && sum(eA(1:(i-1)*n + j)~=0) == fNo) %hinterer teil schaut ob man im richtigen fluss ist
                    plot3([x(rixSTART +i)],[x(riySTART + i)],[x(rizSTART + i)], 'c*', 'MarkerSize',12)
                    plot3([x(rixSTART +j)],[x(riySTART + j)],[x(rizSTART + j)], 'g*', 'MarkerSize',12)
                end
            end
        end

        %plot links in network
        for i =1: m
            for j= 1:m
                if (x(eSTART + (i-1)*m + j) > 0.5)
                     plot3([x(rixSTART+i), x(rixSTART+j)],[x(riySTART+i), x(riySTART+j)],[x(rizSTART+i), x(rizSTART+j)], 'k')
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
        hold off
    end
    
end