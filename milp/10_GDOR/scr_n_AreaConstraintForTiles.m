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

for i = 1:m
    for xi = 1:l
        for beta = 1:maxTSVsPerTile+1
            for alpha = 1:maxRoutersPerTile+1
                %tiz - hkram1 leq 1/2 + xi
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 + xi;
                A(UglNo, tizSTART + i) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta1START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                
                % -tiz + -hkram2 leq -1/2 -xi
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - xi;
                A(UglNo, tizSTART + i) = -1;
                A(UglNo, tiles_HAreaXiIAlphaBeta2START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                
                % hirouter - hkram3 leq -1/2 + (alpha-1)
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 + alpha-1; % - hirouter(i);
                A(UglNo, routsv_hirouterSTART + i) = 1; 
                A(UglNo, tiles_HAreaXiIAlphaBeta3START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % -hirouter - hkram4 leq -1/2 -(alpha-1)
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - alpha+1; % + hirouter(i);
                A(UglNo, routsv_hirouterSTART + i) = -1; 
                A(UglNo, tiles_HAreaXiIAlphaBeta4START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % hiTSV - hkram5 leq -1/2 + (beta-1)
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 +beta-1; % - hiTSV(i);
                A(UglNo, routsv_hiTSVSTART + i) = +1; 
                A(UglNo, tiles_HAreaXiIAlphaBeta5START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                                
                % -hiTSV - hkram6 leq -1/2 -(beta-1)
                UglNo = UglNo + 1;
                b(UglNo) = -1/2 - beta+1; % + hiTSV(i);
                A(UglNo, routsv_hiTSVSTART + i) = -1; 
                A(UglNo, tiles_HAreaXiIAlphaBeta6START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -c;
                                
                % hkram1 + hkram2 + ... + hkram6 + (1- hkram0) leq 6
                UglNo = UglNo + 1;
                b(UglNo) = 5;
                A(UglNo, tiles_HAreaXiIAlphaBeta1START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta2START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta3START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta4START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta5START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBeta6START + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
                A(UglNo, tiles_HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = -1;
                
                % hkram0 - tiz leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, tizSTART + i) = -1;
                A(UglNo, tiles_HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;                
            end
        end
    end
end

for i = 1:m
    % sum_{[l],[m-n+1],[m-m+1]} hkram0 leq 1
    UglNo = UglNo + 1;
    b(UglNo) = 1;
    for xi = 1:l
        for beta = 1:maxTSVsPerTile+1
            for alpha = 1:maxRoutersPerTile+1
                A( UglNo, tiles_HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = 1;
            end
        end
    end
end

for i = 1:m
    % -ai - bi + sum_{[l],[m-n+1],[m-m+1]} hkram0 f(...)  leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, aiSTART + i)= -1;
    A(UglNo, biSTART + i)= -1;
    for xi = 1:l
        for beta = 1:maxTSVsPerTile+1
            for alpha = 1:maxRoutersPerTile+1
                A( UglNo, tiles_HAreaXiIAlphaBetaSTART + (i-1)* (l*(maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (xi-1)* ((maxTSVsPerTile+1)*(maxRoutersPerTile+1)) + (beta-1)*(maxRoutersPerTile+1) + alpha) = F(alpha, beta, xi, i);
            end
        end
    end
end