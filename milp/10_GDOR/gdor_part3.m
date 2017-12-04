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
                    % 1/2 + rkz leq xi + hijkxi3*c
                        % umgestellt: rkz - c*hijkxi3 leq xi -1/2
                    UglNo = UglNo + 1;
                    b(UglNo) = xi - 0.5;
                    A(UglNo, rizSTART + k)= 1;
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
                    % rkz geq xi + 1/2 - hijkxi6*c
                        % umgestellt: -rkz - c*hijkxi6 leq -xi -1/2
                    UglNo = UglNo + 1;
                    b(UglNo) = -xi - 0.5;
                    A(UglNo, rizSTART + k)= -1;
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