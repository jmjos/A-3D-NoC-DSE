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
        end
    end
end