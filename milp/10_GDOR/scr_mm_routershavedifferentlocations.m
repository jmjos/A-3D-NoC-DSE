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

% Routers Have Different Locations ------------------- (599 - 610) ----
% 9*m*(m-1) Ungleichungen

for i = 1:m
    for jloop= 1:(m-1)
        if (jloop<i)
            j= jloop;
        else
            j = jloop +1;
        end
        % delta + rix leq rjx + hijneq1*c
            % umgestellt: rix - rjx - c*hijneq1 leq - delta
        UglNo = UglNo + 1;
        A(UglNo, rixSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, rhdl_hijneq1START + (i-1)*(m-1) + jloop) = -c;
        b(UglNo) = -delta;
        % delta + rjx leq rix + hijneq2*c
            % umgestellt:  - rix + rjx - c*hijneq2 leq - delta
        UglNo = UglNo + 1;
        A(UglNo, rixSTART + i) = -1;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, rhdl_hijneq2START + (i-1)*(m-1) + jloop) = -c;
        b(UglNo) = -delta;
        % delta + riy leq rjy + hijneq3*c
            % umgestellt: riy - rjy - c*hijneq3 leq - delta
        UglNo = UglNo + 1;
        A(UglNo, riySTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, rhdl_hijneq3START + (i-1)*(m-1) + jloop) = -c;
        b(UglNo) = -delta;
        % delta + rjy leq riy + hijneq4*c
            % umgestellt: - riy + rjy - c*hijneq4 leq - delta
        UglNo = UglNo + 1;
        A(UglNo, riySTART + i) = -1;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, rhdl_hijneq4START + (i-1)*(m-1) + jloop) = -c;
        b(UglNo) = -delta;
        % 0.5 + riz leq rjz + hijneq5*c
            % umgestellt: riz - rjz - c*hijneq5 leq - 0.5
        UglNo = UglNo + 1;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, rhdl_hijneq5START + (i-1)*(m-1) + jloop) = -c;
        b(UglNo) = -0.5;
        % 0.5 + rjz leq riz + hijneq6*c
            % umgestellt: - riz + rjz - c*hijneq6 leq - 0.5
        UglNo = UglNo + 1;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rhdl_hijneq6START + (i-1)*(m-1) + jloop) = -c;
        b(UglNo) = -0.5;
        % riz leq phiz + hijphi*c
            % umgestellt: riz - c*hijphi leq phi(3)
        UglNo = UglNo + 1;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, rhdl_hijphiSTART + (i-1)*(m-1) + jloop) = -c;
        b(UglNo) = phi(3);
        % phiz leq riz  + hijphi*c
            % umgestellt: - riz - c*hijphi leq - phi(3)
        UglNo = UglNo + 1;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rhdl_hijphiSTART + (i-1)*(m-1) + jloop) = -c;
        b(UglNo) = -phi(3);
        % hijneq1 + ... + hijneq6 + hijphi leq 6
            % umgestellt: sum(n = 1:6)(hijneqn) + hijphi leq 6
        UglNo = UglNo + 1;
        A(UglNo, rhdl_hijneq1START + (i-1)*(m-1) + jloop) = 1;
        A(UglNo, rhdl_hijneq2START + (i-1)*(m-1) + jloop) = 1;
        A(UglNo, rhdl_hijneq3START + (i-1)*(m-1) + jloop) = 1;
        A(UglNo, rhdl_hijneq4START + (i-1)*(m-1) + jloop) = 1;
        A(UglNo, rhdl_hijneq5START + (i-1)*(m-1) + jloop) = 1;
        A(UglNo, rhdl_hijneq6START + (i-1)*(m-1) + jloop) = 1;
        A(UglNo, rhdl_hijphiSTART + (i-1)*(m-1) + jloop) = 1;
        b(UglNo) = 6;
    end
end