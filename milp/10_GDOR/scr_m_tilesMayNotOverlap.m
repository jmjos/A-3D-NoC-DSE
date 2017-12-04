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


for i=1:m
    %t_ix + a_i \leq h_c
    UglNo = UglNo + 1;
    A(UglNo, hcSTART + 1) = -1;
    A(UglNo, tixSTART + i) = 1;
    %b(UglNo) = -ai(i);
    b(UglNo) = 0;
    A(UglNo, aiSTART + i) = 1;
   
    %t_iy + b_i \leq h_c
    UglNo = UglNo + 1;
    A(UglNo, hcSTART + 1) = -1;
    A(UglNo, tixSTART + m+i) = 1;
    %b(UglNo) = -bi(i);
    b(UglNo) = 0;
    A(UglNo, biSTART + i) = 1;
end

for i = 1:m
    for k = 1:m-1
        if(k<i) 
            j = k;
        else
            j = k + 1;
        end
%       t_{i, z} \leq \varphi_z + \tiles_HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) =  phi(3);
        A(UglNo, tizSTART + i ) = 1;
        A(UglNo, tiles_HORISTART + (i-1)*(m-1)+k ) = - c;

%       \varphi_z &\leq t_{i, z} + \tiles_HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = - phi(3);
        A(UglNo, tizSTART + i ) = -1;
        A(UglNo, tiles_HORISTART + (i-1)*(m-1)+k ) = - c;

%       t_{j, z} \leq \varphi_z + \tiles_HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) =  phi(3);
        A(UglNo, tizSTART + j ) = 1;
        A(UglNo, tiles_HORIISTART +(i-1)*(m-1)+k ) = - c;

%       \varphi_z &\leq t_{j, z} + \tiles_HORI \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = - phi(3);
        A(UglNo, tizSTART + j ) = -1;
        A(UglNo, tiles_HORIISTART +(i-1)*(m-1)+k ) = - c;
        
%       t_{i,z} &\leq t_{j,z} - \nicefrac{1}{2} + \tiles_HORIII \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, tizSTART + i ) = 1;
        A(UglNo, tizSTART + j ) = -1;
        A(UglNo, tiles_HORIIISTART +(i-1)*(m-1)+k ) = - c;

%       t_{j,z} &\leq t_{i,z} - \nicefrac{1}{2} + \tiles_HORIV \CI, \\
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, tizSTART + i ) = -1;
        A(UglNo, tizSTART + j ) = 1;
        A(UglNo, tiles_HORIVSTART +(i-1)*(m-1)+k ) = - c;        
        
        % t_jx geq t_ix + a_i + delta + h_or1
        UglNo = UglNo + 1;
        %b(UglNo) = -ai(i) - delta;
        b(UglNo) = - delta;
        A(UglNo, aiSTART + i) = 1;
        A(UglNo, tixSTART + i) = 1;
        A(UglNo, tixSTART + j) = -1;
        A(UglNo, tiles_HORVSTART + (i-1)*(m-1)+ k) = -c;
        
        % t_ix geq t_jx + a_j + delta + h_or2
        UglNo = UglNo + 1;
        %b(UglNo) = -ai(j) - delta;
        b(UglNo) = - delta;
        A(UglNo, aiSTART + j) = 1;
        A(UglNo, tixSTART + i) = -1;
        A(UglNo, tixSTART + j) = 1;
        A(UglNo, tiles_HORVISTART + (i-1)*(m-1)+ k) = -c;
        
        % t_jy geq t_iy + b_i + delta + h_or3
        UglNo = UglNo + 1;
        %b(UglNo) = -bi(i) - delta;
        b(UglNo) = - delta;
        A(UglNo, biSTART + i) = 1;
        A(UglNo, tiySTART + i) = 1;
        A(UglNo, tiySTART + j) = -1;
        A(UglNo, tiles_HORVIISTART + (i-1)*(m-1)+ k) = -c;
         
        % t_iy geq t_jy + b_j + delta + h_or4
        UglNo = UglNo + 1;
        %b(UglNo) = -bi(j) - delta;
        b(UglNo) = - delta;
        A(UglNo, biSTART + j) = 1;
        A(UglNo, tiySTART + i) = -1;
        A(UglNo, tiySTART + j) = 1;
        A(UglNo, tiles_HORVIIISTART + (i-1)*(m-1)+ k) = -c;
        
        % hor1 + ... + hor4 leq 3
        UglNo = UglNo + 1;
        b(UglNo) = 7;
        A(UglNo, tiles_HORISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORIIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORIVSTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORVSTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORVISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORVIISTART + (i-1)*(m-1)+ k) = 1;
        A(UglNo, tiles_HORVIIISTART + (i-1)*(m-1)+ k) = 1;
    end
end