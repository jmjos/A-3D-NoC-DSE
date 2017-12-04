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
                for ll = 1:m
                    
                    % "... --> fijkl = 0" Case I und II vvvvvvv (491 - 494) vvvv
                    % 4*sum(eA)*m*m
                    
                    % rkz + 1/2 leq rlz + 1 + hijklOR*c + hijkl*c
                        % umgestellt: rkz - rlz - c*hijklOR - c*hijkl leq 1/2 
                    UglNo = UglNo + 1;
                    b(UglNo) = 0.5;
                    A(UglNo, rizSTART + k)= 1;
                    A(UglNo, rizSTART + ll)= -1;
                    A(UglNo, gdor_hijklORSTART + (fNo-1)*m^2 + (k-1)*m + ll)= -c;
                    A(UglNo, gdor_hijklSTART + (fNo-1)*m^2 + (k-1)*m + ll)= -c;
                    % rllz + 1 + 1/2 leq rkz + (1 - hijklOR)*c + hijkl*c
                        % umgestellt: rllz - rkz + c*hijklOR - c*hijkl leq c - 3/2 
                    UglNo = UglNo + 1;
                    b(UglNo) = c - 1.5;
                    A(UglNo, rizSTART + ll)= 1;
                    A(UglNo, rizSTART + k)= -1;
                    A(UglNo, gdor_hijklORSTART + (fNo-1)*m^2 + (k-1)*m + ll)= c;
                    A(UglNo, gdor_hijklSTART + (fNo-1)*m^2 + (k-1)*m + ll)= -c;
                    % fijllk + hijup + e_kll + hijkl leq 3
                        % umgestellt: bleibt gleich.
                    UglNo = UglNo + 1;
                    b(UglNo) = 3;
                    A(UglNo, fSTART + (fNo-1) * m^2 + (ll-1)*m + k)= 1;
                    A(UglNo, gdor_hijupSTART + fNo)= 1;
                    A(UglNo, eSTART + (k-1)*m + ll)= 1;
                    A(UglNo, gdor_hijklSTART + (fNo-1)*m^2 + (k-1)*m + ll)= 1;
                    % fijkll + (1 - hijup) + e_kll + hijkl leq 3
                        % umgestellt: fijkll - hijup + e_kl + hijkl leq 2
                    UglNo = UglNo + 1;
                    b(UglNo) = 2;
                    A(UglNo, fSTART + (fNo-1) * m^2 + (k-1)*m + ll)= 1;
                    A(UglNo, gdor_hijupSTART + fNo)= -1;
                    A(UglNo, eSTART + (k-1)*m + ll)= 1;
                    A(UglNo, gdor_hijklSTART + (fNo-1)*m^2 + (k-1)*m + ll)= 1;
                    
                    for xi = 1:(l-1)
                        % "... --> fijkl = 1" Case I vvvvvvvvvv (497 - 503) vvvv
                        % 6*sum(eA)*m*m*(l-1) + sum(eA)*(m-1)*m*(l-1)
                        
                        % 1/2 + rlx leq sij(xi-1)x + hijklxi1*c
                            % umgestellt: rlx - sij(xi-1)x - c*hijklxi1 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rixSTART + ll)= 1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + (xi - 1))= -1;
                        A(UglNo, gdor_hijklxi1START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rly leq sij(xi-1)y + hijklxi2*c
                            % umgestellt: rly - sij(xi-1)y - c*hijklxi2 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, riySTART + ll)= 1;
                        A(UglNo, gdor_sijxiySTART + (fNo-1)*l + (xi - 1))= -1;
                        A(UglNo, gdor_hijklxi2START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rlz leq xi - 1 + hijklxi3*c
                            % umgestellt: rlz - c*hijklxi3 leq xi - 1 - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = xi - 1 - 0.5;
                        A(UglNo, rizSTART + ll)= 1;
                        A(UglNo, gdor_hijklxi3START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi-1)x leq rlx + hijklxi4*c
                            % umgestellt: - rlx + sij(xi-1)x - c*hijklxi4 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rixSTART + ll)= -1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + (xi - 1))= 1;
                        A(UglNo, gdor_hijklxi4START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi-1)y leq rly + hijklxi5*c
                            % umgestellt: - rly + sij(xi-1)y - c*hijklxi5 leq - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, riySTART + ll)= -1;
                        A(UglNo, gdor_sijxiySTART + (fNo-1)*l + (xi - 1))= 1;
                        A(UglNo, gdor_hijklxi5START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + xi - 1 leq rlz + hijklxi6*c
                            % umgestellt: - rlz - c*hijklxi6 leq -xi + 1 - 1/2 
                        UglNo = UglNo + 1;
                        b(UglNo) = -xi + 1 - 0.5;
                        A(UglNo, rizSTART + ll)= -1;
                        A(UglNo, gdor_hijklxi6START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                    end
                end
            end
            for kloop = 1:(m-1) % die hijkxi1..6 sind nicht f�r k==j definiert...
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
                        % "... --> fijlk = 1" Case II vvvvvvvvvvvvv (506 - 512) vvvv
                        % 6*sum(eA)*m*m*(l-1) + sum(eA)*(m-1)*m*(l-1)
                        
                        % 1/2 + rkx leq sij(xi+1)x + hijklxi7*c
                            % umgestellt: rkx - sij(xi+1)x - c*hijklxi7 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rixSTART + k)= 1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + (xi + 1))= -1;
                        A(UglNo, gdor_hijklxi7START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rky leq sij(xi+1)y + hijklxi8*c
                            % umgestellt: rky - sij(xi+1)y - c*hijklxi8 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, riySTART + k)= 1;
                        A(UglNo, gdor_sijxiySTART + (fNo-1)*l + (xi + 1))= -1;
                        A(UglNo, gdor_hijklxi8START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + rkz leq xi + 1 + hijklxi9*c
                            % umgestellt: rkz - c*hijklxi9 leq xi + 1 - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = xi + 1 - 0.5;
                        A(UglNo, rizSTART + k)= 1;
                        A(UglNo, gdor_hijklxi9START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi+1)x leq rkx + hijklxi10*c
                            % umgestellt: - rkx + sij(xi+1)x - c*hijklxi10 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, rixSTART + k)= -1;
                        A(UglNo, gdor_sijxixSTART + (fNo-1)*l + (xi + 1))= 1;
                        A(UglNo, gdor_hijklxi10START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + sij(xi+1)y leq rky + hijklxi11*c
                            % umgestellt: - rky + sij(xi+1)y - c*hijklxi11 leq - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - 0.5;
                        A(UglNo, riySTART + k)= -1;
                        A(UglNo, gdor_sijxiySTART + (fNo-1)*l + (xi + 1))= 1;
                        A(UglNo, gdor_hijklxi11START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                        % 1/2 + xi + 1 leq rkz + hijklxi12*c
                            % umgestellt: - rkz - c*hijklxi12 leq -xi - 1 - 1/2
                        UglNo = UglNo + 1;
                        b(UglNo) = - xi - 1 - 0.5;
                        A(UglNo, rizSTART + k)= -1;
                        A(UglNo, gdor_hijklxi12START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= -c;
                    end
                end
            end
            for k = 1:m 
                for llloop = 1:(m-1)  % die hijlxi1..6 sind nicht f�r l==j definiert...
                    if (llloop >= j)
                        ll = llloop+1;
                    else
                        ll = llloop;
                    end
                    for xi = 2:l
                        % (1 - hijup) + hijDxi + (1 - fijlk) + hijklxi7 + ... + hijklxi12 + hijllxi1 + ... + hijllxi6 leq 14 
                            % umgestellt: -hijup + hijDxi - fijlk +hijklxi7 + ... + hijklxi12 + hijllxi1 + ... + hijllxi6 leq 12         
                        UglNo = UglNo + 1;
                        b(UglNo) = 12;
                        A(UglNo, gdor_hijupSTART + fNo)= -1;
                        A(UglNo, gdor_hijDxiSTART + (fNo-1)*l + xi)= 1;
                        A(UglNo, fSTART + (fNo-1)*m^2 + (ll-1)*m + k)= -1;
                        A(UglNo, gdor_hijklxi7START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi8START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi9START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi10START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi11START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijklxi12START + (fNo-1)*m^2*l + (k-1)*m*l + (ll-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi1START + (fNo-1)*(m-1)*l + (llloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi2START + (fNo-1)*(m-1)*l + (llloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi3START + (fNo-1)*(m-1)*l + (llloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi4START + (fNo-1)*(m-1)*l + (llloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi5START + (fNo-1)*(m-1)*l + (llloop-1)*l + xi)= 1;
                        A(UglNo, gdor_hijkxi6START + (fNo-1)*(m-1)*l + (llloop-1)*l + xi)= 1;
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
                % xi leq siz + hijxi3*c
                    % umgestellt: - siz - c*hijxi3 leq -xi
                UglNo = UglNo + 1;
                b(UglNo) = -xi;
                A(UglNo, rizSTART + i)= -1;
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
                % siz leq xi + hijxi3*c
                    % umgestellt: siz - c*hijxi3 leq xi
                UglNo = UglNo + 1;
                b(UglNo) = xi;
                A(UglNo, rizSTART + i)= 1;
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
                % xi leq sjz + hijxi6*c
                    % umgestellt: - sjz - c*hijxi6 leq -xi
                UglNo = UglNo + 1;
                b(UglNo) = -xi;
                A(UglNo, rizSTART + j)= -1;
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
                % sjz leq xi + hijxi6*c
                    % umgestellt: sjz - c*hijxi6 leq xi
                UglNo = UglNo + 1;
                b(UglNo) = xi;
                A(UglNo, rizSTART + j)= 1;
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