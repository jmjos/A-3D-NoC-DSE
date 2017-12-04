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
            end
            for xi = 2:l
                % ~d~_xi = ~s~_(xi-1) vv [case I] vv (420 - 425) vvvv
                % 6*sum(eA)*(l-1)

                % ~d~_(xi,x) geq ~s~_(xi-1,x) - (1 - hijDxi)*c - (1 - hijup)*c
                    % umgestellt: -dijxix + sij(xi-1)x + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi -1) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;

                % ~d~_(xi,y) geq ~s~_(xi-1,y) - (1 - hijDxi)*c - (1 - hijup)*c
                    % umgestellt: -dijxiy + sij(xi-1)y + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi -1) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                % ~d~_(xi,x) leq ~s~_(xi-1,x) + (1 - hijDxi)*c + (1 - hijup)*c
                    % umgestellt: dijxix - sij(xi-1)x + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi -1) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
                % ~d~_(xi,y) leq ~s~_(xi-1,y) + (1 - hijDxi)*c + (1 - hijup)*c
                    % umgestellt: dijxiy - sij(xi-1)y + c*hD + c*hUP leq 2*c
                UglNo = UglNo + 1;
                b(UglNo) = 2*c;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi -1) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = c;
            end
            for xi = 1:l-1
                % ~d~_xi = ~s~_(xi+1) v [case II] vv (426 - 431) vvvv
                % 6*sum(eA)*(l-1)

                % ~d~_(xi,x) geq ~s~_(xi+1,x) - (1 - hijDxi)*c - hijup*c
                    % umgestellt: -dijxix + sij(xi+1)x + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi +1) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                % ~d~_(xi,y) geq ~s~_(xi+1,y) - (1 - hijDxi)*c - hijup*c
                    % umgestellt: -dijxiy + sij(xi+1)y + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi) = -1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi +1) = 1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                % ~d~_(xi,x) leq ~s~_(xi+1,x) + (1 - hijDxi)*c + hijup*c
                    % umgestellt: dijxix - sij(xi+1)x + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxixSTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxixSTART + (fNo-1)*l + xi +1) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
                % ~d~_(xi,y) leq ~s~_(xi+1,y) + (1 - hijDxi)*c + hijup*c
                    % umgestellt: dijxiy - sij(xi+1)y + c*hD - c*hUP leq c
                UglNo = UglNo + 1;
                b(UglNo) = c;
                A(UglNo, gdor_dijxiySTART + (fNo-1)*l + xi) = 1;
                A(UglNo, gdor_sijxiySTART + (fNo-1)*l + xi +1) = -1;
                A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi) = c;
                A(UglNo, gdor_hijupSTART + fNo) = -c;
            end
        end
    end
end