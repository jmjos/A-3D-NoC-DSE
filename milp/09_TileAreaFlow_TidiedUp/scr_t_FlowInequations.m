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

disp('Flüsse nutzen nur Kanten, die auch da sind')
% Flüsse nutzen nur Kanten, die auch da sind .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            for k = 1:m
                for ll = 1:m
                    UglNo = UglNo +1;
                    %b(UglNo) = eN((k-1)*m + l);
                    b(UglNo) = 0;
                    A(UglNo, eSTART + (k-1)*m + ll) = -1;
                    A(UglNo, fSTART + (fNo-1) * m^2 + (k-1)*m + ll) = 1;
                end
            end
        end
    end
end

disp('Ueberschuss Quelle');
% Überschuss Quelle .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            GlNo = GlNo +1;
            beq(GlNo) = 1;
            for kloop = 1:(m-1)
                if (kloop >= i)
                    k = kloop+1;
                else
                    k= kloop;
                end
                % ausgehende Kanten (i,k)
                Aeq(GlNo, fSTART + (fNo-1)* m^2 + (i-1)*m + k)= 1;
                % eingehende Kanten (k,i)
                Aeq(GlNo, fSTART + (fNo-1)* m^2 + (k-1)*m + i)= -1;
            end
        end
    end
end
  
disp('Abfluss Senke')
% Abfluss Senke .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            GlNo = GlNo +1;
            beq(GlNo) = 1;
            for kloop = 1:(m-1)
                if (kloop >= j)
                    k = kloop+1;
                else
                    k= kloop;
                end
                % ausgehende Kanten (j,k)
                Aeq(GlNo, fSTART + (fNo-1)* m^2 + (j-1)*m + k)= -1;
                % eingehende Kanten (k,j)
                Aeq(GlNo, fSTART + (fNo-1)* m^2 + (k-1)*m + j)= 1;
            end
        end
    end
end

disp('Flusserhaltung')
% Flusserhaltung .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            for k = 1:m
                if (k ~= i && k~=j)
                    GlNo = GlNo +1;
                    beq(GlNo) = 0;
                    for lloop = 1:(m-1)
                        if (lloop >= k)
                            ll = lloop+1;
                        else
                            ll = lloop;
                        end
                        % eingehende Kanten (l,k)
                        Aeq(GlNo, fSTART + (fNo-1)* m^2 + (ll-1)*m + k)= 1;
                        % ausgehende Kanten (k,l)
                        Aeq(GlNo, fSTART + (fNo-1)* m^2 + (k-1)*m + ll)= -1;
                    end
                end
            end
        end
    end
end

disp('Azyklischer Fluss 1 ')
% Hilfsvariable für acyclic flow; ist 1 wenn f_ijkl > 0
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            for k = 1:m
                for ll = 1:m
                    UglNo = UglNo +1;
                    b(UglNo) = 0;
                    A(UglNo, fSTART + (fNo-1)*m^2 + (k-1)*m + ll )= 1;
                    A(UglNo, hSTART + (fNo-1)*m^2 + (k-1)*m + ll )= -1;
                end
            end
        end
    end
end

disp('Azyklischer Fluss 2')
% acyclic flow .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            for k = 1:m
                for ll = 1:m
                    UglNo = UglNo +1;
                    b(UglNo) = m - 1/2;
                    A(UglNo, GammaSTART + (fNo-1)*m + k )= 1;
                    A(UglNo, GammaSTART + (fNo-1)*m + ll )= -1;
                    A(UglNo, hSTART + (fNo-1)*m^2 + (k-1)*m + ll )= m;
                end
            end
        end
    end
end
