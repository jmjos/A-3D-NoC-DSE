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
        
        % rjz leq rkz + 1/2 + hkjplusOR*c + hkj1plus*c
            % umgestellt: rjz - rkz - c*hkjplusOR - c*hkj1plus leq 1/2 
        UglNo = UglNo + 1;
        b(UglNo) = 0.5;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rizSTART + k) = -1;
        A(UglNo, gdor_hkjplusORSTART + (k-1)*(m-1) + jloop) = -c;
        A(UglNo, gdor_hkj1plusSTART + (k-1)*(m-1) + jloop) = -c;
        % rjz geq rkz + 3/2 - (1 - hkjplusOR)*c - hkj1plus*c
            % umgestellt: - rjz + rkz + c*hkjplusOR - c*hkj1plus leq c -3/2 
        UglNo = UglNo + 1;
        b(UglNo) = c - 1.5;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, rizSTART + k) = 1;
        A(UglNo, gdor_hkjplusORSTART + (k-1)*(m-1) + jloop) = c;
        A(UglNo, gdor_hkj1plusSTART + (k-1)*(m-1) + jloop) = -c;
        % e_kj leq 0 + (1-hkj1plus) + hatHKplus
            % umgestellt: e_kj + hkj1plus - hatHKplus leq 1
        UglNo = UglNo + 1;
        b(UglNo) = 1;
        A(UglNo, eSTART + (k-1)*m + j) = 1;
        A(UglNo, gdor_hkj1plusSTART + (k-1)*(m-1) + jloop) = 1;
        A(UglNo, gdor_hatHKplusSTART + k) = -1;
        
        % "... --> hkminus = 1" vvvvvvvvvvvvvvvvvvvvvvvv (442 - 444) vvvv
        % 3*m*(m-1)
        
        % rjz leq rkz - 3/2 + hkjminusOR*c + hkj1minus*c
            % umgestellt: rjz - rkz - c*hkjminusOR - c*hkj1minus leq -3/2 
        UglNo = UglNo + 1;
        b(UglNo) = -1.5;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rizSTART + k) = -1;
        A(UglNo, gdor_hkjminusORSTART + (k-1)*(m-1) + jloop) = -c;
        A(UglNo, gdor_hkj1minusSTART + (k-1)*(m-1) + jloop) = -c;
        % rjz geq rkz - 1/2 - (1 - hkjminusOR)*c - hkj1minus*c
            % umgestellt: -rjz + rkz + c*hkjminusOR - c*hkj1minus leq c + 1/2
        UglNo = UglNo + 1;
        b(UglNo) = c + 0.5;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, rizSTART + k) = 1;
        A(UglNo, gdor_hkjminusORSTART + (k-1)*(m-1) + jloop) = c;
        A(UglNo, gdor_hkj1minusSTART + (k-1)*(m-1) + jloop) = -c;
        % e_kj leq 0 + (1 - hkj1minus) + hatHKminus
            % umgestellt: e_kj + hkj1minus - hatHKminus leq 1
        UglNo = UglNo + 1;
        b(UglNo) = 1;
        A(UglNo, eSTART + (k-1)*m + j) = 1;
        A(UglNo, gdor_hkj1minusSTART + (k-1)*(m-1) + jloop) = 1;
        A(UglNo, gdor_hatHKminusSTART + k) = -1;
        
        % "... --> hkplus = 0" vvvvvvvvvvvvvvvvvvvvvvvvv (446 - 449) vvvv
        % 3*m*(m-1) + m
        
        % rjz leq rkz + 1 + hkj2plus*c
            % umgestellt: rjz - rkz - c*hkj2plus leq 1
        UglNo = UglNo + 1;
        b(UglNo) = 1;
        A(UglNo, rizSTART + j)= 1;
        A(UglNo, rizSTART + k)= -1;
        A(UglNo, gdor_hkj2plusSTART + (k-1)*(m-1) + jloop)= -c;
        % rjz geq rkz + 1 - hkj2plus*c
            % umgestellt: -rjz - c*hkj2plus leq -1
        UglNo = UglNo + 1;
        b(UglNo) = -1;
        A(UglNo, rizSTART + j)= -1;
        A(UglNo, gdor_hkj2plusSTART + (k-1)*(m-1) + jloop)= -c;
        % e_kj geq 1 - hkj2plus
            % umgestellt: - e_kj - hkj2plus leq -1
        UglNo = UglNo + 1;
        b(UglNo) = -1;
        A(UglNo, eSTART + (k-1)*m + j)= -1;
        A(UglNo, gdor_hkj2plusSTART + (k-1)*(m-1) + jloop)= -1;
        
    end
    % sum_j(hkj2plus) leq m - 2 + (1 - hathkplus)
            % umgestellt: sum_j(hkj2plus) + hathkplus leq m - 1
    if (m >= 2)
        UglNo = UglNo + 1;
        b(UglNo) = m - 1;
        A(UglNo, gdor_hatHKplusSTART + k)= 1;
        for jloop = 1:(m-1)
            if (jloop >= k)
                j = jloop+1;
            else
                j= jloop;
            end
            A(UglNo, gdor_hkj2plusSTART + (k-1)*(m-1) + jloop)= 1;
        end 
    end
        
    for jloop = 1:(m-1)
        if (jloop >= k)
            j = jloop+1;
        else
            j= jloop;
        end
        % "... --> hkminus = 0" vvvvvvvvvvvvvvvvvvvvvvvv (450 - 453) vvvv
        % 3*m*(m-1) + m
        
        % rjz leq rkz - 1 + hkj2minus*c
            % umgestellt: rjz - rkz - c*hkj2minus leq -1
        UglNo = UglNo + 1;
        b(UglNo) = -1;
        A(UglNo, rizSTART + j)= 1;
        A(UglNo, rizSTART + k)= -1;
        A(UglNo, gdor_hkj2minusSTART + (k-1)*(m-1) + jloop)= -c;
        % rjz geq rkz - 1 - hkj2minus*c
            % umgestellt: -rjz + rkz - c*hkj2minus leq 1
        UglNo = UglNo + 1;
        b(UglNo) = 1;
        A(UglNo, rizSTART + j)= -1;
        A(UglNo, rizSTART + k)= 1;
        A(UglNo, gdor_hkj2minusSTART + (k-1)*(m-1) + jloop)= -c;
        % e_kj geq 1 - hkj2minus
            % umgestellt: - e_kj - hkj2minus leq - 1
        UglNo = UglNo + 1;
        b(UglNo) = - 1;
        A(UglNo, eSTART + (k-1)*m + j)= -1;
        A(UglNo, gdor_hkj2minusSTART + (k-1)*(m-1) + jloop)= -1;
    end
    % sum_j hkj2minus leq m - 2 + (1 - hathkminus)
        % umgestellt: sum_j hkj2minus + hathkminus leq m - 1
    if (m >= 2)
        UglNo = UglNo + 1;
        b(UglNo) = m - 1;
        A(UglNo, gdor_hatHKminusSTART + k)= 1;
        for jloop = 1:(m-1)
            if (jloop >= k)
                j = jloop+1;
            else
                j= jloop;
            end
            A(UglNo, gdor_hkj2minusSTART + (k-1)*(m-1) + jloop)= 1;
        end
    end
end