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

disp('forbid connections between non neighbored routers');

% 33 (m*(m-1)*(m-2)) ugl
for i = 1:m
    for jloop = 1:(m-1)
        for kloop = 1:(m-2)
            if (jloop<i)
                j= jloop;
            else
                j = jloop +1;
            end
            k = kloop;
            if (k >= i && k>= j)
                k = k +2;
            elseif (k >= j || k >= i)
                k = k +1;            
            end
            if (k==i || k==j)
                k = k+1;
            end
            %Fall A (riy <= rjy ; rix = rjx)
            
            % #1
            % - hijk1*c - hijor *c leq rjy - riy
            UglNo = UglNo +1;
            %b(UglNo) = ry(j) - ry(i);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + j) = -1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #2
            % -||- leq rjx - rix
            UglNo = UglNo +1;
            %b(UglNo) = rx(j) - rx(i);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + j) = -1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #3
            % -||- leq rix - rjx
            UglNo = UglNo +1;
            %b(UglNo) = rx(i) - rx(j);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + j) = 1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #4
            % Ungleichung I
            % -||- - hA1*c leq riy - rky
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(k);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + k) = 1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKa1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #5
            % Ungleichung II
            % -||- - hA2 leq - rjy + rky
            UglNo = UglNo +1;
            %b(UglNo) = - ry(j) + ry(k);
            b(UglNo) = 0;
            A(UglNo, riySTART + j) = 1;
            A(UglNo, riySTART + k) = -1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKa2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % #6
            % Ungleichung III
            % -||- - hA3 leq rix - rkx -delta
            UglNo = UglNo +1;
            %b(UglNo) = rx(i) - rx(k) - delta;
            b(UglNo) = -delta;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + k) = 1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKa3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #7
            % Ungleichung IV
            % -||- - hA4 leq - rix + rkx -delta
            UglNo = UglNo +1;
            %b(UglNo) = -rx(i) + rx(k) -delta;
            b(UglNo) = -delta;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + k) = -1;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKa4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall B (rjy <= riy ; rix = rjx)------------------------------
            
            % - hijk2*c - hijor *c leq riy - rjy
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(j);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + j) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjx - rix
            UglNo = UglNo +1;
            %b(UglNo) = rx(j) - rx(i);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + j) = -1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rix - rjx
            UglNo = UglNo +1;
            %b(UglNo) = rx(i) - rx(j);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + j) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hB1*c leq -riy + rky
            UglNo = UglNo +1;
            %b(UglNo) = - ry(i) + ry(k);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + k) = -1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKb1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq + rjy - rky
            UglNo = UglNo +1;
            %b(UglNo) = + ry(j) - ry(k);
            b(UglNo) = 0;
            A(UglNo, riySTART + j) = -1;
            A(UglNo, riySTART + k) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKb2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq - rix + rkx -delta
            UglNo = UglNo +1;
            %b(UglNo) = - rx(i) + rx(k) - delta;
            b(UglNo) = -delta;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + k) = -1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKb3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq + rix - rkx -delta
            UglNo = UglNo +1;
            %b(UglNo) = +rx(i) - rx(k) -delta;
            b(UglNo) = -delta;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + k) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKb4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall C (rix <= rjx ; riy = rjy)------------------------------
            
            % - hijk1*c - hijor *c leq rjx - rix
            UglNo = UglNo +1;
            %b(UglNo) = rx(j) - rx(i);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + j) = -1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq riy - rjy
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(j);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + j) = 1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjy - riy
            UglNo = UglNo +1;
            %b(UglNo) = ry(j) - ry(i);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + j) = -1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hA1*c leq rix - rkx
            UglNo = UglNo +1;
            %b(UglNo) = rx(i) - rx(k);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo, rixSTART + k) = 1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKc1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq - rjx + rkx
            UglNo = UglNo +1;
            %b(UglNo) = - rx(j) + rx(k);
            b(UglNo) = 0;
            A(UglNo, rixSTART + j) = 1;
            A(UglNo, rixSTART + k) = -1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKc2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq - riy + rky -delta
            UglNo = UglNo +1;
            %b(UglNo) = - ry(i) + ry(k) - delta;
            b(UglNo) = -delta;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + k) = -1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKc3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq + riy - rky -delta
            UglNo = UglNo +1;
            %b(UglNo) = +ry(i) - ry(k) -delta;
            b(UglNo) = -delta;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + k) = 1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKc4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall D (rjx <= rix ; riy = rjy)
            
            
            % - hijk1*c - hijor *c leq -rjx + rix
            UglNo = UglNo +1;
            %b(UglNo) = -rx(j) + rx(i);
            b(UglNo) = 0;
            A(UglNo, rixSTART + j) = 1;
            A(UglNo, rixSTART + i) = -1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq riy - rjy
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(j);
            b(UglNo) = 0;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + j) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjy - riy
            UglNo = UglNo +1;
            %b(UglNo) = ry(j) - ry(i);
            b(UglNo) = 0;
            A(UglNo, riySTART + j) = -1;
            A(UglNo, riySTART + i) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hA1*c leq - rix + rkx
            UglNo = UglNo +1;
            %b(UglNo) = -rx(i) + rx(k);
            b(UglNo) = 0;
            A(UglNo, rixSTART + i) = 1;
            A(UglNo, rixSTART + k) = -1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKd1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq + rjx - rkx
            UglNo = UglNo +1;
            %b(UglNo) =  rx(j) - rx(k);
            b(UglNo) = 0;
            A(UglNo, rixSTART + j) = -1;
            A(UglNo, rixSTART + k) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKd2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq riy - rky -delta
            UglNo = UglNo +1;
            %b(UglNo) = ry(i) - ry(k) - delta;
            b(UglNo) = -delta;
            A(UglNo, riySTART + i) = -1;
            A(UglNo, riySTART + k) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKd3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq - riy + rky -delta
            UglNo = UglNo +1;
            %b(UglNo) = -ry(i) + ry(k) -delta;
            b(UglNo) = -delta;
            A(UglNo, riySTART + i) = 1;
            A(UglNo, riySTART + k) = -1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,flow_HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,flow_HIJKd4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #29
            % VerODERung von abcd1 .. abcd4
            % hijka1 + hijka2 + ... + hijka4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJKa1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKa2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKa3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKa4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #30
            % hijkb1 + hijkb2 + ... + hijkb4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJKb1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKb2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKb3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKb4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #31
            % hijkc1 + hijkc2 + ... + hijkc4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJKc1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKc2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKc3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKc4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #32
            % hijkd1 + hijkd2 + ... + hijkd4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJKd1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKd2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKd3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJKd4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #33
            % VerODERung hijk1 bis hijk4
            % hijk1 + ... +hijk4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,flow_HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,flow_HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
        end
    end
end