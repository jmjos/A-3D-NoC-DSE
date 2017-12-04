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

disp('Generating grid based topology and TSVs between neighbored layers')

% 14 * m^2 Ungl 
for i = 1:m
    for j = 1:m
        % #1
        % -hij*c + eij*c  leq c - r_iz + r_jz
        UglNo = UglNo + 1;
        %b(UglNo) = c - rz(i) + rz(j);
        b(UglNo) = c;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #2
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = c + rz(i) - rz(j);
        b(UglNo) = c;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #3
        % wie die erste, z und x tauschen, - flow_HOR1*c
        UglNo = UglNo + 1;
        %b(UglNo) = c - rx(i) + rx(j);
        b(UglNo) = c;
        A(UglNo, rixSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, flow_HORISTART + (i-1)*m + j) = -c ;
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #4
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = c + rx(i) - rx(j);
        b(UglNo) = c;
        A(UglNo, rixSTART + i) = -1;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, flow_HORISTART + (i-1)*m + j) = -c ;
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #5
        % wie die erste, z und y tauschen, (1- flow_HOR1*c)
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c - ry(i) + ry(j);
        b(UglNo) = 2*c;
        A(UglNo, riySTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, flow_HORISTART + (i-1)*m + j) = c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #6
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c + ry(i) - ry(j);
        b(UglNo) = 2*c;
        A(UglNo, riySTART + i) = -1;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, flow_HORISTART + (i-1)*m + j) = c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = -c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #7
        % - hijOR2*c + hij1 * c + e_ij * c leq r_iz - r_jz -1 + 2*c
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c + rz(i) - rz(j) -1;
        b(UglNo) = 2*c - 1;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, flow_HORIISTART + (i-1)*m + j) = -c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #8
        % - hijOR2*c + hij1 * c + e_ij * c leq r_jz - r_iz +1 + 2*c
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c - rz(i) + rz(j) +1;
        b(UglNo) = 2*c + 1;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, flow_HORIISTART + (i-1)*m + j) = -c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #9
        % hijOR2*c + hij1*c + e_ij*c leq r_iz - rjz +1 + 3*c
        UglNo = UglNo + 1;
        %b(UglNo) = 3*c + rz(i) - rz(j) +1;
        b(UglNo) = 3*c + 1;
        A(UglNo, rizSTART + i) = -1;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, flow_HORIISTART + (i-1)*m + j) = c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;        
        
        % #10
        % hijOR2*c + hij1*c + e_ij*c leq -r_iz + rjz -1 + 3*c
        UglNo = UglNo + 1;
        %b(UglNo) = 3*c - rz(i) + rz(j) -1;
        b(UglNo) = 3*c - 1;
        A(UglNo, rizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, flow_HORIISTART + (i-1)*m + j) = c; 
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #11
        % hij1*c + e_ij*c leq rjx - rix + 2*c
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c - rx(i) + rx(j);
        b(UglNo) = 2*c;
        A(UglNo, rixSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #12
        % ri und rj tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c + rx(i) - rx(j);
        b(UglNo) = 2*c;
        A(UglNo, rixSTART + i) = -1;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #13
        % ri und rj und rx und ry tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c - ry(i) + ry(j);
        b(UglNo) = 2*c;
        A(UglNo, riySTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
             
        % #14
        % ri und rj tauschen
        UglNo = UglNo + 1;
        %b(UglNo) = 2*c + ry(i) - ry(j);
        b(UglNo) = 2*c;
        A(UglNo, riySTART + i) = -1;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, flow_HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
    end
end