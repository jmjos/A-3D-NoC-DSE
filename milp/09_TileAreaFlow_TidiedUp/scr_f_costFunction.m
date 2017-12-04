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

f= zeros(1,anzahlVar);

%f(tizSTART+1)=1;
% Möglichst hohe Layer
%f(rizSTART+1:rizSTART+rizLENGTH)=-1;

%generiert ein Quadarat (cAREA)
f(hcSTART+ 1) = 1;

%aus dem flow:
%f(eSTART + 1 : eSTART + eLENGTH) = 1; % möglichst wenige Kanten
%f(fSTART+1:fSTART+fLENGTH) = 1; % möglichst kurze Flüsse

%utilization (cUTIL)
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            f(fSTART + (fNo-1) * m^2 + (1-1)*m + 1:fSTART + (fNo-1) * m^2 + (m-1)*m + m)= u((i-1)*n + j);
        end
    end
end
        

%peak loads (cPEAK)
f(cPeakSTART + 1) = 1;
