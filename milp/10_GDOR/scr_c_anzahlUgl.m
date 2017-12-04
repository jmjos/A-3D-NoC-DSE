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

% Abschnittsweise
anzahlUglTest = 0;

anzahlUglRIXTIX = 8*(m-n);
anzahlUglIndexSortRiTi = max(0, 2*((m-1)-(n)) );
anzahlUglRITItoPHI = 4*m;
anzahlUglaibi0 = 2*(m-n);
anzahlUglTech = anzahlUglRITItoPHI +  anzahlUglIndexSortRiTi + anzahlUglRIXTIX + anzahlUglaibi0;

anzahlUglTilesOverlap = 11*(m^2 - m) + 2*m;

anzahlUglRouDiff = 9*m*(m-1);

anzahlUglAreaTiles = 8*((maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m);
anzahlUglAreaTiles = anzahlUglAreaTiles + 4*m;

anzahlUglGridBTop = 14*m^2;
anzahlUglForbidCon = 33*m*(m-1)*(m-2) + 4*m*(m-1);
anzahlUglRouNotSelfCon = m + 2*m*(m-1);
anzahlUglFlow = 3*sum(eA)*m^2;
anzahlUglFlowetc =  anzahlUglGridBTop + anzahlUglForbidCon + anzahlUglRouNotSelfCon + anzahlUglFlow;

anzahlUglCross = 13*m*(m-1)*(m-2) + m*(m-1);
anzahlUglHIROUTER = 13*m*(m-n);
anzahlUglhatHJ = 6*m*(m-1)+ m;
anzahlUglhatHJK = 3 * m * (m-n);
anzahlUglroutersandtiles = m-n;
anzahlUglcPeak = 2*m^2;
anzahlUglgdor = 2*sum(eA) + 4*sum(eA)*l + 4*sum(eA)*l + ...
    12*sum(eA)*(l-1) + 3*m*(m-1) + 3*m*(m-1) + 3*m*(m-1) + m + ...
    3*m*(m-1) + m + 8*sum(eA)*l*(m-1) + 12*sum(eA)*(m-1)*l + ...
    12*sum(eA)*l + 2*m*l + 2*sum(eA)*(m-1)*l + sum(eA)*(m-1)*l + ...
    4*sum(eA)*m*m + 6*sum(eA)*m*m*(l-1) + sum(eA)*(m-1)*m*(l-1) + ...
    6*sum(eA)*m*m*(l-1) + sum(eA)*(m-1)*m*(l-1) + 9*sum(eA)*l + ...
    9*sum(eA)*l + 13*sum(eA)*m*(m-1)*l;
if (m<2)
    anzahlUglgdor = anzahlUglgdor - 2*m;
end

%Summe
anzahlUgl = anzahlUglTech + anzahlUglTilesOverlap + anzahlUglRouDiff + ...
    anzahlUglAreaTiles + ...
    anzahlUglFlowetc + anzahlUglCross + anzahlUglHIROUTER ...
    + anzahlUglhatHJ +anzahlUglhatHJK + anzahlUglroutersandtiles + ...
    anzahlUglcPeak + anzahlUglgdor;