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


% cPeak = sum_{m^2} (hmax)
    % umgestellt: cPeak - sum = 0
GlNo = GlNo + 1;
beq(GlNo) = 0;
Aeq(GlNo, cPeakSTART + 1) = 1;
for i = 1:m^2
    Aeq(GlNo, cPeak_hmaxSTART + i)= -1;    
end

% mu = sum_(m^2)(load) / sum_(m^2)(eij)
    % umgestellt: mu = n^2-n
GlNo = GlNo + 1;
beq(GlNo) = n^2-n;
Aeq(GlNo, cPeak_muSTART + 1) = 1;

for i = 1:m^2
    % load = sum_(EA)(u*f^eA_eN)
        % umgestellt: load - sum = 0
    GlNo = GlNo + 1;
    beq(GlNo) = 0;
    Aeq(GlNo, cPeak_loadSTART + i) = 1;
    fNo = 0;
    for ii = 1:n
        for j = 1:n
            if (eA((ii-1)*n + j) == 1)
                fNo = fNo+1;
                Aeq(GlNo, fSTART + (fNo-1) * m^2 + i) = -u( (ii-1)*n + j );
            end
        end
    end
    
    % hmax geq 0
        % umgestellt: -hmax leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, cPeak_hmaxSTART + i) = -1;

    % hmax geq load - mu
        % umgestellt: load - mu - hmax leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, cPeak_loadSTART + i) = 1;
    A(UglNo, cPeak_muSTART + i) = -1;
    A(UglNo, cPeak_hmaxSTART + i) = -1;
end    