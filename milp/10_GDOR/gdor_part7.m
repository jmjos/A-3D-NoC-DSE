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
            for k = 1:m
                for llloop = 1:(m-1)
                    if (llloop >= j)
                        ll = llloop+1;
                    else
                        ll = llloop;
                    end
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
                        A(UglNo, gdor_hijklxi20START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rkz leq rlz + hijklxi23*c
                            % umgestellt: rkz - rlz - c*hijklxi23 leq -1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rizSTART + k)= 1;
                        A(UglNo, rizSTART + ll)= -1;
                        A(UglNo, gdor_hijklxi23START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rlz leq rkz + hijklxi24*c
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