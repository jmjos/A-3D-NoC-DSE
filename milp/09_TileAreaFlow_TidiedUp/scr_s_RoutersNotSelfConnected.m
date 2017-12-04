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

disp('eij is symmetrical');

for i = 1:m
    % e ii leq 0
    UglNo = UglNo +1;
    b(UglNo) = 0;
    A(UglNo, eSTART + (i-1)*m + i)=1;
end

% e_ij = eji
for i = 1:m
    for jloop= 1:(m-1)
        if (jloop<i)
            j= jloop;
        else
            j = jloop +1;
        end
        % e_ij - e_ji leq 0
        UglNo = UglNo +1;
        b(UglNo) = 0;
        A(UglNo, eSTART + (i-1)*m + j)= 1;
        A(UglNo, eSTART + (j-1)*m + i)= -1;
        
        % e_ji - e_ij leq 0
        UglNo = UglNo +1;
        b(UglNo) = 0;
        A(UglNo, eSTART + (i-1)*m + j)= 1;
        A(UglNo, eSTART + (j-1)*m + i)= -1;
    end
end