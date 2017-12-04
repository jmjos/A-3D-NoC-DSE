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