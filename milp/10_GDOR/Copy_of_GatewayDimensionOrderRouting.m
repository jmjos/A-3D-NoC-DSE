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


% (Un-)Gleichungen:

% Anzahl: 2*sum(eA) + 4*sum(eA)*l + 4*sum(eA)*l + 12*sum(eA)*l + 3*m*(m-1) + 3*m*(m-1) + 3*m*(m-1) + m +  3*m*(m-1) + m + 8*sum(eA)*l*(m-1) + 12*sum(eA)*(m-1)*l + 12*sum(eA)*l + 2*m*l + 2*sum(eA)*(m-1)*l + sum(eA)*(m-1)*l + 3*sum(eA)*m*m + 6*sum(eA)*m*m*(l-1) + sum(eA)*(m-1)*m*(l-1) + 6*sum(eA)*m*m*(l-1) + sum(eA)*(m-1)*m*(l-1) + 9*sum(eA)*l + 9*sum(eA)*l + 13*sum(eA)*m*(m-1)*l

fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            
            % hijup festlegen vvvvvvvvvvvvvvvvvvvvvvvvvvv (406, 407) vvvv
            % 2*sum(eA)
            
            % siz geq sjz - (1 - hijup)*c
                % umgestellt: rjz - riz + c*hijup leq c
            UglNo = UglNo + 1;
            b(UglNo) = c;
            A(UglNo, rizSTART + j) = 1;
            A(UglNo, rizSTART + i) = -1;
            A(UglNo, gdor_hijupSTART + fNo) = c;
            % siz leq sjz - 1/2 + hijup*c
                % umgestellt: riz - rjz - c*hijup leq - 1/2
            UglNo = UglNo + 1;
            b(UglNo) = -0.5;
            A(UglNo, rizSTART + i) = 1;
            A(UglNo, rizSTART + j) = -1;
            A(UglNo, gdor_hijupSTART + fNo) = -c;
                
            for xi = 1:l
                % "... --> hijDxi = 0" vvvvvvvvvvvvvvvvv (411 - 414) vvvv
                % 4*sum(eA)*l
                
                % xi leq siz + (1 - hijup)*c + (1 - hijDxi)*c
                    % umgestellt: -riz + c*hijup + c* hijDxi leq 2*c - xi
                UglNo = UglNo + 1;
                b(UglNo) = 2*c - xi;
                A(UglNo, rizSTART + i) = -1;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                
                % sjz + 1 leq xi + (1 - hijup)*c + (1 - hijDxi)*c
                    % umgestellt: rjz +c*hijup + c*hijDxi leq xi + 2*c -1
                UglNo = UglNo + 1;
                b(UglNo) = xi + 2*c - 1;
                A(UglNo, rizSTART + j) = 1;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                % xi leq sjz - 1 + hijup*c + (1 - hijDxi)*c
                    % umgestellt: -rjz - c*hijup + c*hijDxi leq -xi -1 +c
                UglNo = UglNo + 1;
                b(UglNo) = -xi - 1 + c;
                A(UglNo, rizSTART + j) = -1;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                % siz leq xi + hijup*c + (1 - hijDxi)*c
                    % umgestellt: riz -c*hijup + c* hijDxi leq xi +c
                UglNo = UglNo + 1;
                b(UglNo) = xi + c;
                A(UglNo, rizSTART + i) = 1;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                
                % "... --> hijDxi = 1" vvvvvvvvvvvvvvvvv (416 - 419) vvvv
                % 4*sum(eA)*l
                
                % xi leq sjz + hijxiOR1*c + (1 - hijup)*c + hijDxi*c
                    % umgestellt: -rjz -c*hijxiOR1 +c*hijup -c*hijDxi leq -xi +c
                UglNo = UglNo + 1;
                b(UglNo) = -xi + c;
                A(UglNo, rizSTART + j) = -1;
                A(UglNo, gdor_hijxiOR1START + (fNo-1)*l + xi) = -c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = -c;
                % siz + 1 leq xi + (1 - hijxiOR1)*c + (1 - hijup)*c + hijDxi * c
                    % umgestellt: riz + c*hijxiOR1 + c*hijup - c*hijDxi leq xi -1 + 2*c
                UglNo = UglNo + 1;
                b(UglNo) = xi - 1 + 2*c;
                A(UglNo, rizSTART + i) = 1;
                A(UglNo, gdor_hijxiOR1START + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = -c;
                % xi leq siz - 1 + hijxiOR2*c + hijup*c  + hijDxi*c
                    % umgestellt: -riz - c*hijxiOR2 - c*hijup - c*hijDxi leq -xi -1
                UglNo = UglNo + 1;
                b(UglNo) = -xi - 1;
                A(UglNo, rizSTART + i) = -1;
                A(UglNo, gdor_hijxiOR2START + (fNo-1)*l + xi) = -c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = -c;
                % sjz leq xi + (1 - hijxiOR2)*c + hijup*c + hijDxi*c
                    % umgestellt: rjz + c*hijxiOR2 - c*hijup - c*hijDxi leq xi +c
                UglNo = UglNo + 1;
                b(UglNo) = xi + c;
                A(UglNo, rizSTART + j) = 1;
                A(UglNo, gdor_hijxiOR2START + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = -c;
                
                % ~d~_xi = ~s~_(xi-1) vv [case I] vv (420 - 425) vvvv
                % 6*sum(eA)*l

                % ~d~_(xi,x) geq ~s~_(xi-1,x) - (1 - hijDxi)*c - (1 - hijup)*c
                    % umgestellt: -dx + sx + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;

                % ~d~_(xi,y) geq ~s~_(xi-1,y) - (1 - hijDxi)*c - (1 - hijup)*c
                    % umgestellt: -dy + sy + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                % ~d~_(xi,z) geq ~s~_(xi-1,z) - (1 - hijDxi)*c - (1 - hijup)*c
                    % umgestellt: -dz + sz + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxizSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxizSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                % ~d~_(xi,x) leq ~s~_(xi-1,x) + (1 - hijDxi)*c + (1 - hijup)*c
                    % umgestellt: dx - sx + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                % ~d~_(xi,y) leq ~s~_(xi-1,y) + (1 - hijDxi)*c + (1 - hijup)*c
                    % umgestellt: dy - sy + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                % ~d~_(xi,z) leq ~s~_(xi-1,z) + (1 - hijDxi)*c + (1 - hijup)*c
                    % umgestellt: dz - sz + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxizSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxizSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;

                % ~d~_xi = ~s~_(xi+1) v [case II] vv (426 - 431) vvvv
                % 6*sum(eA)*l

                % ~d~_(xi,x) geq ~s~_(xi+1,x) - (1 - hijDxi)*c - hijup*c
                    % umgestellt: -dx + sx + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                % ~d~_(xi,y) geq ~s~_(xi+1,y) - (1 - hijDxi)*c - hijup*c
                    % umgestellt: -dy + sy + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                % ~d~_(xi,z) geq ~s~_(xi+1,z) - (1 - hijDxi)*c - hijup*c
                    % umgestellt: -dz + sz + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxizSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxizSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                % ~d~_(xi,x) leq ~s~_(xi+1,x) + (1 - hijDxi)*c + hijup*c
                    % umgestellt: dx - sx + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                % ~d~_(xi,y) leq ~s~_(xi+1,y) + (1 - hijDxi)*c + hijup*c
                    % umgestellt: dy - sy + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                % ~d~_(xi,z) leq ~s~_(xi+1,z) + (1 - hijDxi)*c + hijup*c
                    % umgestellt: dz - sz + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxizSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxizSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
            end
        end
    end
end

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




fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            for xi = 1:l
                for kloop = 1:(m - 1)
                    % ~d~ hat TSV in richtige Richtung , Case I vvv (459 - 465) vvvv
                    % 7*sum(eA)*l*(m-1)
                    
                    % 1/2 + rkx leq ~d~ijxix + hijkxi1*c
                        % umgestellt: rkx - dijxix - c*hijkxi1 leq -1/2
                    UglNo = UglNo + 1;
                    b(UglNo) = - 0.5;
                    A(UglNo, rixSTART + k)= 1;
                    A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_hijkxi1START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= -c;
                    % 1/2 + rky leq ~d~ijxiy + hijkxi2*c
                        % umgestellt: rky - dijxiy - c*hijkxi2 leq -1/2
                    UglNo = UglNo + 1;
                    b(UglNo) = - 0.5;
                    A(UglNo, riySTART + k)= 1;
                    A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_hijkxi2START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= -c;
                    % 1/2 + rkz leq ~d~ijxiz + hijkxi3*c
                        % umgestellt: rkz - dijxiz - c*hijkxi3 leq -1/2
                    UglNo = UglNo + 1;
                    b(UglNo) = - 0.5;
                    A(UglNo, rizSTART + k)= 1;
                    A(UglNo, gdor_dijxizSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_hijkxi3START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= -c;
                    % rkx geq ~d~ijxix + 1/2 - hijkxi4*c
                        % umgestellt: -rkx + dijxix - c*hijkxi4 leq -1/2
                    UglNo = UglNo + 1;
                    b(UglNo) = - 0.5;
                    A(UglNo, rixSTART + k)= -1;
                    A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi4START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= -c;
                    % rky geq ~d~ijxiy + 1/2 - hijkxi5*c
                        % umgestellt: -rky + dijxiy - c*hijkxi5 leq -1/2
                    UglNo = UglNo + 1;
                    b(UglNo) = - 0.5;
                    A(UglNo, riySTART + k)= -1;
                    A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi5START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= -c;
                    % rkz geq ~d~ijxiz + 1/2 - hijkxi6*c
                        % umgestellt: -rkz + dijxiz - c*hijkxi6 leq -1/2
                    UglNo = UglNo + 1;
                    b(UglNo) = - 0.5;
                    A(UglNo, rizSTART + k)= -1;
                    A(UglNo, gdor_dijxizSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi6START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= -c;
                    % hijkxi1 + ... + hijkxi6 + hijup + hijDxi + (1 - hatHKminus) leq 8
                        % umgestellt: hijkxi1 + ... + hijkxi6 + hijup + hijDxi - hatHKminus leq 7 
                    UglNo = UglNo + 1;
                    b(UglNo) = 7;
                    A(UglNo, gdor_hijkxi1START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi2START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi3START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi4START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi5START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi6START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijupSTART + fNo)= 1;
                    A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_hatHKminusSTART + k)= -1;
                    
                    % Case II vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv (468) vvvvvvvvvv
                    % sum(eA)*l*(m-1)
                    
                    % hijkxi1 + ... + hijkxi6 + (1 - hijup) + hijDxi + (1 - hatHKplus) leq 8 
                        % umgestellt: hijkxi1 + ... hijkxi6 - hijup + hijDxi - hatHKplus leq 6 
                    UglNo = UglNo + 1;
                    b(UglNo) = 6;
                    A(UglNo, gdor_hijkxi1START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi2START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi3START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi4START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi5START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijkxi6START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    A(UglNo, gdor_hijupSTART + fNo)= -1;
                    A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_hatHKplusSTART + k)= -1;
                end
            end
        end
    end
end

fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            for iotaloop = 1:(m-1)
                if (iotaloop >= j)
                    iota = iotaloop+1;
                else
                    iota = iotaloop;
                end
                for xi = 1:l
                    % 6 dist-Ungl für dist(r_(iota,x),~s~ijxix) vvv (478) vvvv
                    % 6*sum(eA)*(m-1)*l
                    
                    % distrx geq riotax - sijxix
                        % umgestellt: -distrx + riotax - sijxix leq 0
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distrxSTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= -1;
                    A(UglNo, rixSTART + iota)= 1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= -1;
                    % distrx geq sijxix - riotax
                        % umgestellt: -distrx - riotax + sijxix leq 0
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distrxSTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= -1;
                    A(UglNo, rixSTART + iota)= -1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= 1;
                    % riotax leq sijxix + (1 - haleqb)*c
                        % umgestellt: riotax - sijxix + c*haleqb leq c
                    UglNo = UglNo + 1;
                    b(UglNo) = c;
                    A(UglNo, rixSTART + iota)= 1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_haleqbSTART + 0*sum(eA)*l*(m-1) + (fNo-1)*l*(m-1) + (iotaloop-1)*l + xi)= -c;
                    % sijxix leq riotax + haleqb*c
                        % umgestellt: -riotax + sijxix - c*haleqb*c leq 0 
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, rixSTART + iota)= -1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_haleqbSTART + 0*sum(eA)*l*(m-1) + (fNo-1)*l*(m-1) + (iotaloop-1)*l + xi)= -c;
                    % distrx leq riotax - sijxix + haleqb*c
                        % umgestellt: distrx - riotax + sijxix - c*haleqb leq 0 
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distrxSTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= 1;
                    A(UglNo, rixSTART + iota)= -1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_haleqbSTART + 0*sum(eA)*l*(m-1) + (fNo-1)*l*(m-1) + (iotaloop-1)*l + xi)= -c;
                    % distrx leq sijxix - riotax + (1 - haleqb)*c
                        % umgestellt: distrx + riotax - sijxix + c*haleqb leq c 
                    UglNo = UglNo + 1;
                    b(UglNo) = c;
                    A(UglNo, gdor_distrxSTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= 1;
                    A(UglNo, rixSTART + iota)= 1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_haleqbSTART + 0*sum(eA)*l*(m-1) + (fNo-1)*l*(m-1) + (iotaloop-1)*l + xi)= c;
                    
                    % 6 dist-Ungl für dist(r_(iota,y),~s~ijxiy) vvv (479) vvvv
                    % 6*sum(eA)*(m-1)*l
                    
                    % distry geq riotay - sijxiy
                        % umgestellt: -distry + riotay - sijxiy leq 0
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distrySTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= -1;
                    A(UglNo, riySTART + iota)= 1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= -1;
                    % distry geq sijxiy - riotay
                        % umgestellt: -distry - riotay + sijxiy leq 0
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distrySTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= -1;
                    A(UglNo, riySTART + iota)= -1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= 1;
                    % riotay leq sijxiy + (1 - haleqb)*c
                        % umgestellt: riotay - sijxiy + c*haleqb leq c 
                    UglNo = UglNo + 1;
                    b(UglNo) = c;
                    A(UglNo, riySTART + iota)= 1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_haleqbSTART + 1*sum(eA)*l*(m-1) + (fNo-1)*l*(m-1) + (iotaloop-1)*l + xi)= c;
                    % sijxiy leq riotay + haleqb*c
                        % umgestellt: -riotay + sijxiy - c*haleqb leq 0
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, riySTART + iota)= -1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_haleqbSTART + 1*sum(eA)*l*(m-1) + (fNo-1)*l*(m-1) + (iotaloop-1)*l + xi)= -c;
                    % distry leq riotay - sijxiy + haleqb*c
                        % umgestellt: distry - riotay + sijxiy - c*haleqb leq 0  
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distrySTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= 1;
                    A(UglNo, riySTART + iota)= -1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_haleqbSTART + 1*sum(eA)*l*(m-1) + (fNo-1)*l*(m-1) + (iotaloop-1)*l + xi)= -c;
                    % distry leq sijxiy - riotay + (1 - haleqb)*c
                        % umgestellt: distry + riotay - sijxiy + c*haleqb leq c  
                    UglNo = UglNo + 1;
                    b(UglNo) = c;
                    A(UglNo, gdor_distrySTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= 1;
                    A(UglNo, riySTART + iota)= 1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_haleqbSTART + 1*sum(eA)*l*(m-1) + (fNo-1)*l*(m-1) + (iotaloop-1)*l + xi)= c;
                end
            end
            for xi = 1:l
                % 6 dist-Ungl für dist(~d~ijxix,~s~ijxix) vvv (480) vvvv
                % 6*sum(eA)*l
                
                % distdx geq dijxix - sijxix
                    % umgestellt: -distdx + dijxix - sijxix leq 0 
                UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distdxSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= -1;
                % distdx geq sijxix - dijxix
                    % umgestellt: -distdx - dijxix + sijxix leq 0
                UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distdxSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= 1;
                % dijxix leq sijxix + (1 - haleqb)*c
                    % umgestellt: dijxix - sijxix + c*haleqb leq c 
                UglNo = UglNo + 1;
                    b(UglNo) = c;
                    A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_haleqbSTART + 2*sum(eA)*l*(m-1) + 0*sum(eA)*l + (fNo-1)*l + xi)= c;
                % sijxix leq dijxix + haleqb*c
                    % umgestellt: -dijxix + sijxix - c*haleqb leq 0
                UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_haleqbSTART + 2*sum(eA)*l*(m-1) + 0*sum(eA)*l + (fNo-1)*l + xi)= -c;
                % distdx leq dijxix - sijxix + haleqb*c
                    % umgestellt: distdx - dijxix + sijxix - c*haleqb leq 0 
                UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distdxSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_haleqbSTART + 2*sum(eA)*l*(m-1) + 0*sum(eA)*l + (fNo-1)*l + xi)= -c;
                % distdx leq sijxix - dijxix + (1 - haleqb)*c
                    % umgestellt: distdx + dijxix - sijxix + c*haleqb leq c 
                UglNo = UglNo + 1;
                    b(UglNo) = c;
                    A(UglNo, gdor_distdxSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_haleqbSTART + 2*sum(eA)*l*(m-1) + 0*sum(eA)*l + (fNo-1)*l + xi)= c;
                
                % 6 dist-Ungl für dist(~d~ijxix,~s~ijxix) vvv (481) vvvv
                % 6*sum(eA)*l
                
                % distdy geq dijxiy - sijxiy
                    % umgestellt: -distdy + dijxiy - sijxiy leq 0
                UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distdySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= -1;
                % distdy geq sijxiy - dijxiy
                    % umgestellt: -distdy - dijxiy + sijxiy leq 0
                UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distdySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= 1;
                % dijxiy leq sijxiy + (1 - haleqb)*c
                    % umgestellt: dijxiy - sijxiy + c* haleqb leq c 
                UglNo = UglNo + 1;
                    b(UglNo) = c;
                    A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_haleqbSTART + 2*sum(eA)*l*(m-1) + 1*sum(eA)*l + (fNo-1)*l + xi)= c;
                % sijxiy leq dijxiy + haleqb*c
                    % umgestellt: - dijxiy + sijxiy - c*haleqb leq 0
                UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_haleqbSTART + 2*sum(eA)*l*(m-1) + 1*sum(eA)*l + (fNo-1)*l + xi)= -c;
                % distdy leq dijxiy - sijxiy + haleqb*c
                    % umgestellt: distdy - dijxiy + sijxiy - c*haleqb leq 0 
                UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distdySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_haleqbSTART + 2*sum(eA)*l*(m-1) + 1*sum(eA)*l + (fNo-1)*l + xi)= -c;
                % distdy leq sijxiy - dijxiy + (1 - haleqb)*c
                    % umgestellt: distdy + dijxiy - sijxiy + c*haleqb leq c 
                UglNo = UglNo + 1;
                    b(UglNo) = c;
                    A(UglNo, gdor_distdySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= -1;
                    A(UglNo, gdor_haleqbSTART + 2*sum(eA)*l*(m-1) + 1*sum(eA)*l + (fNo-1)*l + xi)= c;
                
            end
            for iotaloop = 1:(m-1)
                if (iotaloop >= j)
                    iota = iotaloop+1;
                else
                    iota = iotaloop;
                end
            end
        end
    end
end

% Model of logic term (469) vvvvvvvv (483 - 486) vvvv
% 2*m*l + 2*sum(eA)*(m-1)*l

for iota = 1:m
    for xi = 1:l
        % riotaz geq xi + 1/2 - hiotaxiOR1*c - hiotaxi1*c
            % umgestellt: -riotaz - c*hiotaxiOR1 - c*hiotaxi1 leq -xi - 1/2              
        UglNo = UglNo + 1;
        b(UglNo) = - 0.5 -xi;
        A(UglNo, rizSTART + iota)= -1;
        A(UglNo, gdor_hiotaxiOR1START + (iota-1)*l + xi)= -c;
        A(UglNo, gdor_hiotaxi1START + (iota-1)*l + xi)= -c;
        % riotaz leq xi - 1/2 + (1 - hiotaxiOR1)*c + hiotaxi1*c
            % umgestellt: riotaz + c*hiotaxiOR1 + c*hiotaxi1 leq 2*c + xi - 1/2 
        UglNo = UglNo + 1;
        b(UglNo) = 2*c + xi - 0.5;
        A(UglNo, rizSTART + iota)= 1;
        A(UglNo, gdor_hiotaxiOR1START + (iota-1)*l + xi)= c;
        A(UglNo, gdor_hiotaxi1START + (iota-1)*l + xi)= c;
    end
end

fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            for iotaloop = 1:(m-1)
                if (iotaloop >= j)
                    iota = iotaloop+1;
                else
                    iota = iotaloop;
                end
                for xi = 1:l
                    % distrx + distry geq distdx + distdy - hijiotaxi2*c
                        % umgestellt: - distrx - distry + distdx + distdy - c*hijiotaxi2 leq 0 
                    UglNo = UglNo + 1;
                    b(UglNo) = 0;
                    A(UglNo, gdor_distrxSTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi )= -1;
                    A(UglNo, gdor_distrySTART + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= -1;
                    A(UglNo, gdor_distdxSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_distdySTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_hijiotaxi2START + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= -c;                    
                    % hatHIOTAminus + hiotaxi1 + hijDxi + hijup + hijiotaxi2 leq 4
                        % umgestellt: bleibt gleich.
                    UglNo = UglNo + 1;
                    b(UglNo) = 4;
                    A(UglNo, gdor_hatHKminusSTART + iota)= 1;
                    A(UglNo, gdor_hiotaxi1START + (iota-1)*l + xi)= 1;
                    A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_hijupSTART + fNo)= 1;
                    A(UglNo, gdor_hijiotaxi2START + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= 1;
                    
                    % Model of logic term (487) vvvvvvvvvvvvvv (488) vvvv
                    % sum(eA)*(m-1)*l
                    
                    % hatHIOTAplus + hiotaxi1 + hijDxi + (1 - hijup) + hijiotaxi2 leq 4 
                        % umgestellt: hatHIOTAplus + hiotaxi1 + hijDxi - hijup + hijiiotaxi2 leq 3 
                    UglNo = UglNo + 1;
                    b(UglNo) = 3;
                    A(UglNo, gdor_hatHKplusSTART + iota)= 1;
                    A(UglNo, gdor_hiotaxi1START + (iota-1)*l + xi)= 1;
                    A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi)= 1;
                    A(UglNo, gdor_hijupSTART + fNo)= -1;
                    A(UglNo, gdor_hijiotaxi2START + (fNo-1)*(m-1)*l + (iotaloop-1)*l + xi)= 1;
                    
                end
            end
        end
    end
end
            
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            for k = 1:m
                for ll = 1:m
                    
                    % "... --> fijkl = 0" Case I und II vvvvvvv (491 - 493) vvvv
                    % 3*sum(eA)*m*m
                    
                    % rkz leq rlz + 1/2 + hijklOR*c + hijkl*c
                        % umgestellt: rkz - rlz - c*hijklOR - c*hijkl leq 1/2 
                    UglNo = UglNo + 1;
                    b(UglNo) = 0.5;
                    A(UglNo, rizSTART + k)= 1;
                    A(UglNo, rizSTART + ll)= -1;
                    A(UglNo, gdor_hijklORSTART + (fNo-1)*m^2 + (k-1)*m + ll)= -c;
                    A(UglNo, gdor_hijklSTART + (fNo-1)*m^2 + (k-1)*m + ll)= -c;
                    % rllz + 3/2 leq rkz + (1 - hijklOR)*c + hijkl*c
                        % umgestellt: rllz - rkz + c*hijklOR - c*hijkl leq c - 3/2 
                    UglNo = UglNo + 1;
                    b(UglNo) = c - 1.5;
                    A(UglNo, rizSTART + ll)= 1;
                    A(UglNo, rizSTART + k)= -1;
                    A(UglNo, gdor_hijklORSTART + (fNo-1)*m^2 + (k-1)*m + ll)= c;
                    A(UglNo, gdor_hijklSTART + (fNo-1)*m^2 + (k-1)*m + ll)= -c;
                    % fijkll + hijup + e_kll + hijkl leq 3
                        % umgestellt: bleibt gleich.
                    UglNo = UglNo + 1;
                    b(UglNo) = 3;
                    A(UglNo, fSTART + (fNo-1) * m^2 + (k-1)*m + ll)= 1;
                    A(UglNo, gdor_hijupSTART + fNo)= 1;
                    A(UglNo, eSTART + (k-1)*m + ll)= 1;
                    A(UglNo, gdor_hijklSTART + (fNo-1)*m^2 + (k-1)*m + ll)= 1;
                    
                    for xi = 1:(l-1)
                        % "... --> fijkl = 1" Case I vvvvvvvvvv (497 - 503) vvvv
                        % 6*sum(eA)*m*m*(l-1) + sum(eA)*(m-1)*m*(l-1)
                        
                        % 1/2 + rlx leq sij(xi+1)x + hijklxi1*c
                            % umgestellt: rlx - sij(xi+1)x - c*hijklxi1 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rixSTART + ll)= 1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + (xi + 1))= -1;
                        A(UglNo, gdor_hijklxi1START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rly leq sij(xi+1)y + hijklxi2*c
                            % umgestellt: rly - sij(xi+1)y - c*hijklxi2 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, riySTART + ll)= 1;
                        A(UglNo, gdor_sijxiySTART + (fNo-1)*l + (xi + 1))= -1;
                        A(UglNo, gdor_hijklxi2START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rlz leq sij(xi+1)z + hijklxi3*c
                            % umgestellt: rlz - sij(xi+1)z - c*hijklxi3 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rizSTART + ll)= 1;
                        A(UglNo, gdor_sijxizSTART + (fNo-1)*l + (xi + 1))= -1;
                        A(UglNo, gdor_hijklxi3START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi+1)x leq rlx + hijklxi4*c
                            % umgestellt: - rlx + sij(xi+1)x - c*hijklxi4 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rixSTART + ll)= -1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + (xi + 1))= 1;
                        A(UglNo, gdor_hijklxi4START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi+1)y leq rly + hijklxi5*c
                            % umgestellt: - rly + sij(xi+1)y - c*hijklxi5 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, riySTART + ll)= -1;
                        A(UglNo, gdor_sijxiySTART + (fNo-1)*l + (xi + 1))= 1;
                        A(UglNo, gdor_hijklxi5START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi+1)z leq rlz + hijklxi6*c
                            % umgestellt: - rlz + sij(xi+1)z - c*hijklxi6 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rizSTART + ll)= -1;
                        A(UglNo, gdor_sijxizSTART + (fNo-1)*l + (xi + 1))= 1;
                        A(UglNo, gdor_hijklxi6START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                    end
                end
            end
            for kloop = 1:(m-1) % die hijkxi1..6 sind nicht für k==j definiert...
                if (kloop >= j)
                    k = kloop+1;
                else
                    k = kloop;
                end
                for ll = 1:m
                    for xi = 1:(l-1)                        
                        % hijup + hijDxi + (1 - fijkl) + hijklxi1 + ... + hijklxi6 + hijkxi1 + ... + hijkxi6 leq 14 
                            % umgestellt: hijup + hijDxi - fijkl + hijklxi1 + ... + hijklxi6 + hijkxi1 + ... + hijk6 leq 13            
                        UglNo = UglNo + 1;
                        b(UglNo) = 13;
                        A(UglNo, gdor_hijupSTART + fNo)= 1;
                        A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi)= 1;
                        A(UglNo, fSTART + (fNo-1)*m^2 + (k-1)*m + ll)= -1;
                        A(UglNo, gdor_hijklxi1START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi2START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi3START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi4START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi5START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi6START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi1START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi2START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi3START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi4START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi5START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi6START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    end
                end
            end
            for k = 1:m
                for ll = 1:m
                    for xi = 2:l
                        % "... --> fijkl = 1" Case II vvvvvvvvvvvvv (506 - 512) vvvv
                        % 6*sum(eA)*m*m*(l-1) + sum(eA)*(m-1)*m*(l-1)
                        
                        % 1/2 + rlx leq sij(xi-1)x + hijklxi7*c
                            % umgestellt: rlx - sij(xi-1)x - c*hijklxi7 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rixSTART + ll)= 1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + (xi - 1))= -1;
                        A(UglNo, gdor_hijklxi7START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rly leq sij(xi-1)y + hijklxi8*c
                            % umgestellt: rly - sij(xi-1)y - c*hijklxi8 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, riySTART + ll)= 1;
                        A(UglNo, gdor_sijxiySTART + (fNo-1)*l + (xi - 1))= -1;
                        A(UglNo, gdor_hijklxi8START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rlz leq sij(xi-1)z + hijklxi9*c
                            % umgestellt: rlz - sij(xi-1)z - c*hijklxi9 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rizSTART + ll)= 1;
                        A(UglNo, gdor_sijxizSTART + (fNo-1)*l + (xi - 1))= -1;
                        A(UglNo, gdor_hijklxi9START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi-1)x leq rlx + hijklxi10*c
                            % umgestellt: - rlx + sij(xi-1)x - c*hijklxi10 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rixSTART + ll)= -1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + (xi - 1))= 1;
                        A(UglNo, gdor_hijklxi10START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi-1)y leq rly + hijklxi11*c
                            % umgestellt: - rly + sij(xi-1)y - c*hijklxi11 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, riySTART + ll)= -1;
                        A(UglNo, gdor_sijxiySTART + (fNo-1)*l + (xi - 1))= 1;
                        A(UglNo, gdor_hijklxi11START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi-1)z leq rlz + hijklxi12*c
                            % umgestellt: - rlz + sij(xi-1)z - c*hijklxi12 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rizSTART + ll)= -1;
                        A(UglNo, gdor_sijxizSTART + (fNo-1)*l + (xi - 1))= 1;
                        A(UglNo, gdor_hijklxi12START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                    end
                end
            end
            for kloop = 1:(m-1) % die hijkxi1..6 sind nicht für k==j definiert...
                if (kloop >= j)
                    k = kloop+1;
                else
                    k = kloop;
                end
                for ll = 1:m
                    for xi = 2:l
                        % (1 - hijup) + hijDxi + (1 - fijkl) + hijklxi7 + ... + hijklxi12 + hijkxi1 + ... + hijkxi6 leq 14 
                            % umgestellt: -hijup + hijDxi - fijkl +hijklxi7 + ... + hijklxi12 + hijkxi1 + ... + hijkxi6 leq 12         
                        UglNo = UglNo + 1;
                        b(UglNo) = 12;
                        A(UglNo, gdor_hijupSTART + fNo)= -1;
                        A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi)= 1;
                        A(UglNo, fSTART + (fNo-1)*m^2 + (k-1)*m + ll)= -1;
                        A(UglNo, gdor_hijklxi7START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi8START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi9START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi10START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi11START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi12START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi1START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi2START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi3START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi4START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi5START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi6START + (fNo-1)*(m-1)*l + (kloop-1)*l + xi)= 1;
                    end
                end
            end
            for xi = 1:l
                % "source = ~s_{siz}~" vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv (515 - 523) vvvv
                % 9*sum(eA)*l
                
                % siz + 1/2 leq xi + hijxi1*c
                    % umgestellt: siz - c*hijxi1 leq xi - 1/2
                UglNo = UglNo + 1;
                b(UglNo) = xi - 0.5;
                A(UglNo, rizSTART + i)= 1;
                A(UglNo, gdor_hijxi1START + (fNo-1)*l + xi)= -c;
                % xi + 1/2 leq siz + hijxi2*c
                    % umgestellt: - siz - c* hijxi2 leq - xi - 1/2
                UglNo = UglNo + 1;
                b(UglNo) = -xi - 0.5;
                A(UglNo, rizSTART + i)= -1;
                A(UglNo, gdor_hijxi2START + (fNo-1)*l + xi)= -c;
                % sijxix leq six + hijxi3*c
                    % umgestellt: - six + sijxix - c*hijxi3 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, rixSTART + i)= -1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi3START + (fNo-1)*l + xi)= -c;
                % sijxiy leq siy + hijxi3*c
                    % umgestellt: - siy + sijxiy - c*hijxi3 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, riySTART + i)= -1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi3START + (fNo-1)*l + xi)= -c;
                % sijxiz leq siz + hijxi3*c
                    % umgestellt: - siz + sijxiz - c*hijxi3 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, rizSTART + i)= -1;
                A(UglNo,gdor_sijxizSTART + (fNo-1)*l + xi )= 1;
                A(UglNo, gdor_hijxi3START + (fNo-1)*l + xi)= -c;
                % six leq sijxix + hijxi3*c
                    % umgestellt: six leq - sijxix - c*hijxi3 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, rixSTART + i)= 1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= -1;
                A(UglNo, gdor_hijxi3START + (fNo-1)*l + xi)= -c;
                % siy leq sijxiy + hijxi3*c
                    % umgestellt: siy leq - sijxiy - c*hijxi3 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, riySTART + i)= 1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi)= -1;
                A(UglNo, gdor_hijxi3START + (fNo-1)*l + xi)= -c;
                % siz leq sijxiz + hijxi3*c
                    % umgestellt: siz - sijxiz - c*hijxi3 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, rizSTART + i)= 1;
                A(UglNo, gdor_sijxizSTART + (fNo-1)*l + xi)= -1;
                A(UglNo, gdor_hijxi3START + (fNo-1)*l + xi)= -c;
                % hijxi1 + hijxi2 + hijxi3 leq 2
                    % umgestellt: bleibt gleich.
                UglNo = UglNo + 1;
                b(UglNo) = 2;
                A(UglNo, gdor_hijxi1START + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi2START + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi3START + (fNo-1)*l + xi)= 1;
                
                % "destination = ~d_{sjz}~" vvvvvvvvvvvvvvvvvvvvvvvvvv (524 - 532) vvvv
                % 9*sum(eA)*l
                
                % sjz + 1/2 leq xi + hijxi4*c
                    % umgestellt: sjz - c*hijxi4 leq xi - 1/2
                UglNo = UglNo + 1;
                b(UglNo) = xi - 0.5;
                A(UglNo, rizSTART + j)= 1;
                A(UglNo, gdor_hijxi4START + (fNo-1)*l + xi)= -c;
                % xi + 1/2 leq sjz + hijxi5*c
                    % umgestellt: - sjz - c*hijxi5 leq - xi - 1/2
                UglNo = UglNo + 1;
                b(UglNo) = -xi - 0.5;
                A(UglNo, rizSTART + j)= -1;
                A(UglNo, gdor_hijxi5START + (fNo-1)*l + xi)= -c;
                % dijxix leq sjx + hijxi6*c
                    % umgestellt: - sjx + dijxix - c*hijxi6 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, rixSTART + j)= -1;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi6START + (fNo-1)*l + xi)= -c;
                % dijxiy leq sjy + hijxi6*c
                    % umgestellt: - sjy + dijxiy - c*hijxi6 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, riySTART + j)= -1;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi6START + (fNo-1)*l + xi)= -c;
                % dijxiz leq sjz + hijxi6*c
                    % umgestellt: - sjz + dijxiz - c*hijxi6 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, rizSTART + j)= -1;
                A(UglNo, gdor_dijxizSTART + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi6START + (fNo-1)*l + xi)= -c;
                % sjx leq dijxix + hijxi6*c
                    % umgestellt: sjx - dijxix - c*hijxi6 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, rixSTART + j)= 1;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi)= -1;
                A(UglNo, gdor_hijxi6START + (fNo-1)*l + xi)= -c;
                % sjy leq dijxiy + hijxi6*c
                    % umgestellt: sjy - dijxiy - c*hijxi6 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, riySTART + j)= 1;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= -1;
                A(UglNo, gdor_hijxi6START + (fNo-1)*l + xi)= -c;
                % sjz leq dijxiz + hijxi6*c
                    % umgestellt: sjz - dijxiz - c*hijxi6 leq 0
                UglNo = UglNo + 1;
                b(UglNo) = 0;
                A(UglNo, rizSTART + j)= 1;
                A(UglNo, gdor_dijxizSTART + (fNo-1)*l + xi)= -1;
                A(UglNo, gdor_hijxi6START + (fNo-1)*l + xi)= -c;
                % hijxi4 + hijxi5 + hijxi6 leq 2
                    % umgestellt: bleibt so.
                UglNo = UglNo + 1;
                b(UglNo) = 2;
                A(UglNo, gdor_hijxi4START + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi5START + (fNo-1)*l + xi)= 1;
                A(UglNo, gdor_hijxi6START + (fNo-1)*l + xi)= 1;
            end
        end
    end
end

fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            for k = 1:m
                for ll = 1:(m - 1)
                    for xi = 1:l
                        % 2D-DOR-modellieren vvvvvvvvvvvvvvvvvvvvvvvvvv (537 - 551) vvvv
                        % 13*sum(eA)*m*(m-1)*l
                        
                        % 1/2 + xi leq rkz + hijklxi19*c
                            % umgestellt: -rkz - c*hijklxi19 leq -xi -1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = -xi - 0.5;
                        A(UglNo, rizSTART + k)= -1;
                        A(UglNo, gdor_hijklxi19START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rkz leq xi + hijklxi20*c
                            % umgestellt: rkz - c*hijklxi20 leq xi - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = xi - 0.5;
                        A(UglNo, rizSTART + k)= 1;
                        A(UglNo, gdor_hijklxi20START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -1;
                        % 1/2 + rkz leq rlz + hijklxi23*c
                            % umgestellt: rkz - rlz - c*hijklxi23 leq -1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rizSTART + k)= 1;
                        A(UglNo, rizSTART + ll)= -1;
                        A(UglNo, gdor_hijklxi23START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 rlz leq rkz + hijklxi24*c
                            % umgestellt: -rkz + rlz - c*hijklxi24 leq -1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rizSTART + k)= -1;
                        A(UglNo, rizSTART + ll)= 1;
                        A(UglNo, gdor_hijklxi24START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % sijxix leq rkx + hijklxi25*c
                            % umgestellt: -rkx + sijxix - c*hijkilxi25 leq 0 
                        UglNo = UglNo + 1;
                        b(UglNo) = 0;
                        A(UglNo, rixSTART + k)= -1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi25START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % rkx leq sijxix + hijklxi25*c
                            % umgestellt: rkx - sijxix - c*hijkilxi25 leq 0 
                        UglNo = UglNo + 1;
                        b(UglNo) = 0;
                        A(UglNo, rixSTART + k)= 1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi)= -1;
                        A(UglNo, gdor_hijklxi25START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % rkx leq rlx + hijklxi25*c
                            % umgestellt: rkx - rlx - c*hijkilxi25 leq 0 
                        UglNo = UglNo + 1;
                        b(UglNo) = 0;
                        A(UglNo, rixSTART + k)= 1;
                        A(UglNo, rixSTART + ll)= -1;
                        A(UglNo, gdor_hijklxi25START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % rlx leq rkx + hijklxi25*c
                            % umgestellt: - rkx + rlx - c*hijkilxi25 leq 0 
                        UglNo = UglNo + 1;
                        b(UglNo) = 0;
                        A(UglNo, rixSTART + k)= -1;
                        A(UglNo, rixSTART + ll)= 1;
                        A(UglNo, gdor_hijklxi25START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % dijxiy leq rky + hijklxi26*c
                            % umgestellt: - rky + dijxiy - c*hijklxi26 leq 0 
                        UglNo = UglNo + 1;
                        b(UglNo) = 0;
                        A(UglNo, riySTART + k)= -1;
                        A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi26START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % rky leq dijxiy + hijklxi26*c
                            % umgestellt: rky - dijxiy - c*hijklxi26 leq 0 
                        UglNo = UglNo + 1;
                        b(UglNo) = 0;
                        A(UglNo, riySTART + k)= 1;
                        A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi)= -1;
                        A(UglNo, gdor_hijklxi26START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % rky leq rly + hijklxi26*c
                            % umgestellt: rky - rly - c*hijkilxi26 leq 0 
                        UglNo = UglNo + 1;
                        b(UglNo) = 0;
                        A(UglNo, riySTART + k)= 1;
                        A(UglNo, riySTART + ll)= -1;
                        A(UglNo, gdor_hijklxi26START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % rly leq rky + hijklxi26*c
                            % umgestellt: - rky + rly - c*hijkilxi26 leq 0 
                        UglNo = UglNo + 1;
                        b(UglNo) = 0;
                        A(UglNo, riySTART + k)= -1;
                        A(UglNo, riySTART + ll)= 1;
                        A(UglNo, gdor_hijklxi26START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % hijklxi19 + hijklxi20 + hijklxi23 + hijklxi24 + hijklxi25 + hijklxi26 + fijkl + e_kl leq 7
                            % umgestellt: bleibt so.
                        UglNo = UglNo + 1;
                        b(UglNo) = 7;
                        A(UglNo, gdor_hijklxi19START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi20START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi23START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi24START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi25START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi26START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, fSTART + (fNo-1)*m^2 + (k-1)*m + ll)= 1;
                        A(UglNo, eSTART + (k-1)*m + ll)= 1;
                    end
                end
            end
        end
    end
end


