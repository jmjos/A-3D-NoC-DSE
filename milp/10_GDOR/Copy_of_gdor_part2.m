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

for k = 1:m
    for jloop = 1:(m-1)
        if (jloop >= k)
            j = jloop+1;
        else
            j= jloop;
        end
        % "... --> hkplus = 1" vvvvvvvvvvvvvvvvvvvvvvvvv (438 - 440) vvvv
        % 3*m*(m-1)
        
        % rjz leq rkz + 1/2 + hkjplusOR*c + hatHKplus*c
            % umgestellt: rjz - rkz - c*hkjplusOR - c*hatHKplus leq 1/2 
        UglNo = UglNo + 1;
        b(UglNo) = 0.5;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rizSTART + k) = -1;
        A(UglNo, gdor_hkjplusORSTART + (k-1)*(m-1) + jloop) = -c;
        A(UglNo, gdor_hatHKplusSTART + k) = -c;
        % rjz geq rkz + 3/2 - hkjplusOR*c - hatHKplus*c
            % umgestellt: - rjz + rkz - c*hkjplusOR - c*hatHKplus leq -3/2 
        UglNo = UglNo + 1;
        b(UglNo) = 0.5;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, rizSTART + k) = 1;
        A(UglNo, gdor_hkjplusORSTART + (k-1)*(m-1) + jloop) = -c;
        A(UglNo, gdor_hatHKplusSTART + k) = -c;
        % e_kj leq 0 + (1- hkjplusOR)*c - hatHKplus*c
            % umgestellt: e_kj + c*hkjplusOR + c*hatHKplus leq 2*c
        UglNo = UglNo + 1;
        b(UglNo) = 2*c;
        A(UglNo, eSTART + (k-1)*m + j) = 1;
        A(UglNo, gdor_hkjplusORSTART + (k-1)*(m-1) + jloop) = c;
        A(UglNo, gdor_hatHKplusSTART + k) = c;
        
        % "... --> hkminus = 1" vvvvvvvvvvvvvvvvvvvvvvvv (442 - 444) vvvv
        % 3*m*(m-1)
        
        % rjz leq rkz - 1/2 + hkjminusOR*c + hatHKminus*c
            % umgestellt: rjz - rkz - c*hkjminusOR - c* hatHKminus leq -1/2 
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rizSTART + k) = -1;
        A(UglNo, gdor_hkjminusORSTART + (k-1)*(m-1) + jloop) = -c;
        A(UglNo, gdor_hatHKminusSTART + k) = -c;
        % rjz geq rkz - 3/2 - hkjminusOR*c - hatHKminus*c
            % umgestellt: -rjz + rkz - c*hkjminusOR - c*hatHKminus leq 3/2
        UglNo = UglNo + 1;
        b(UglNo) = 1.5;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, rizSTART + k) = 1;
        A(UglNo, gdor_hkjminusORSTART + (k-1)*(m-1) + jloop) = -c;
        A(UglNo, gdor_hatHKminusSTART + k) = -c;
        % e_kj leq 0 + (1 - hkjminusOR)*c + hatHKminus*c
            % umgestellt: e_kj + c*hkjminusOR - c* hatHKminus leq c
        UglNo = UglNo + 1;
        b(UglNo) = c;
        A(UglNo, eSTART + (k-1)*m + j) = 1;
        A(UglNo, gdor_hkjminusORSTART + (k-1)*(m-1) + jloop) = c;
        A(UglNo, gdor_hatHKminusSTART + k) = -c;
        
        % "... --> hkplus = 0" vvvvvvvvvvvvvvvvvvvvvvvvv (446 - 449) vvvv
        % 3*m*(m-1) + m
        
        % rjz leq rkz + 1 + hkjplus*c + (1 - hatHKplus)*c
            % umgestellt: rjz - rkz - c*hkjplus + c*hatHKplus leq 1 + c
        UglNo = UglNo + 1;
        b(UglNo) = 1 + c;
        A(UglNo, rizSTART + j)= 1;
        A(UglNo, rizSTART + k)= -1;
        A(UglNo, gdor_hkjplusSTART + (k-1)*(m-1) + jloop)= -c;
        A(UglNo, gdor_hatHKplusSTART + k) = c;
        % rjz geq rkz + 1 - hkjplus*c - (1 - hatHKplus)*c
            % umgestellt: -rjz - c*hkjplus + c*hatHKplus leq -1 + c
        UglNo = UglNo + 1;
        b(UglNo) = -1 + c;
        A(UglNo, rizSTART + j)= -1;
        A(UglNo, gdor_hkjplusSTART + (k-1)*(m-1) + jloop)= -c;
        A(UglNo, gdor_hatHKplusSTART + k)= c;
        % e_kj geq 1 - hkjplus*c - (1 - hatHKplus)*c
            % umgestellt: - e_kj - c*hkjplus + c*hatHKplus leq -1 + c
        UglNo = UglNo + 1;
        b(UglNo) = -1 + c;
        A(UglNo, eSTART + (k-1)*m + j)= -1;
        A(UglNo, gdor_hkjplusSTART + (k-1)*(m-1) + jloop)= -c;
        A(UglNo, gdor_hatHKplusSTART + k)= c;
        
    end
    % sum_j(hkjplus) leq m - 2
            % umgestellt: bleibt so.
    UglNo = UglNo + 1;
    b(UglNo) = m - 2;
    for jloop = 1:(m-1)
        if (jloop >= k)
            j = jloop+1;
        else
            j= jloop;
        end
        A(UglNo, gdor_hkjplusSTART + (k-1)*(m-1) + jloop)= 1;
    end 
        
    for jloop = 1:(m-1)
        if (jloop >= k)
            j = jloop+1;
        else
            j= jloop;
        end
        % "... --> hkminus = 0" vvvvvvvvvvvvvvvvvvvvvvvv (450 - 453) vvvv
        % 3*m*(m-1) + m
        
        % rjz leq rkz - 1 + hkjminus*c + (1 - hatHKminus)*c
            % umgestellt: rjz - rkz - c*hkjminus + c*hatHKminus leq -1 + c
        UglNo = UglNo + 1;
        b(UglNo) = -1 + c;
        A(UglNo, rizSTART + j)= 1;
        A(UglNo, rizSTART + k)= -1;
        A(UglNo, gdor_hkjminusSTART + (k-1)*(m-1) + jloop)= -c;
        A(UglNo, gdor_hatHKminusSTART + k)= c;
        % rjz geq rkz - 1 - hkjminus*c - (1 - hatHKminus)*c
            % umgestellt: -rjz + rkz - c*hkjminus + c*hatHKminus leq 1 + c
        UglNo = UglNo + 1;
        b(UglNo) = 1 + c;
        A(UglNo, rizSTART + j)= -1;
        A(UglNo, rizSTART + k)= 1;
        A(UglNo, gdor_hkjminusSTART + (k-1)*(m-1) + jloop)= -c;
        A(UglNo, gdor_hatHKminusSTART + (k-1)*(m-1) + jloop)= c;
        % e_kj geq 1 - hkjminus*c - (1 - hatHKminus)*c
            % umgestellt: - e_kj - c*hkjminus + c*hatHKminus leq -1 +c
        UglNo = UglNo + 1;
        b(UglNo) = -1 + c;
        A(UglNo, eSTART + (k-1)*m + j)= -1;
        A(UglNo, gdor_hkjminusSTART + (k-1)*(m-1) + jloop)= -c;
        A(UglNo, gdor_hatHKminusSTART + k)= c;
    end
    % sum_j hkjminus leq m - 2
        % umgestellt: bleibt so.
    UglNo = UglNo + 1;
    b(UglNo) = m - 2;
    for jloop = 1:(m-1)
        if (jloop >= k)
            j = jloop+1;
        else
            j= jloop;
        end
        A(UglNo, gdor_hkjminusSTART + (k-1)*(m-1) + jloop)= 1;
    end
end