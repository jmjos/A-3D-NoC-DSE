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


% Test 0 (anzahl 9)
% Testidee: drei Tiles vorplatzieren, zwei in gleicher Ebene über Eck, ein
% drittes über einem anderen.

for i = 1:length(tix)
    % tix = tix
    GlNo = GlNo+1;
    beq(GlNo)= tix(i);
    Aeq(GlNo, tixSTART + i ) = 1;
end
for i = 1:length(tiy)
    % tiy = tiy
    GlNo = GlNo+1;
    beq(GlNo)= tiy(i);
    Aeq(GlNo, tiySTART + i ) = 1;
end
for i = 1:length(tiz)
    % tiz = tiz
    GlNo = GlNo+1;
    beq(GlNo)= tiz(i);
    Aeq(GlNo, tizSTART + i ) = 1;
end
for i = 1:length(rix)    
    % rix = rix
    GlNo = GlNo+1;
    beq(GlNo)= rix(i);
    Aeq(GlNo, rixSTART + i ) = 1;
end
for i = 1:length(riy)
    % riy = riy
    GlNo = GlNo+1;
    beq(GlNo)= riy(i);
    Aeq(GlNo, riySTART + i ) = 1;
end
for i = 1:length(riz)
    % riz = riz
    GlNo = GlNo+1;
    beq(GlNo)= riz(i);
    Aeq(GlNo, rizSTART + i ) = 1;
end
for i = 1:length(ai)
    % ai = ai
    GlNo = GlNo+1;
    beq(GlNo)= ai(i);
    Aeq(GlNo, aiSTART + i ) = 1;
end
for i = 1:length(bi)
    % bi = bi
    GlNo = GlNo+1;
    beq(GlNo)= bi(i);
    Aeq(GlNo, biSTART + i ) = 1;
    end
for i = 1:sqrt(length(eN))
    for j=1:sqrt(length(eN))
        if (i<= j)
            % eij = eij
            GlNo = GlNo+1;
            beq(GlNo)= eN((i-1)*m + j);
            Aeq(GlNo, eSTART + (i-1)*m + j) = 1;

            % eij = eji
            GlNo = GlNo+1;
            beq(GlNo)= eN((i-1)*m + j);
            Aeq(GlNo, eSTART + (j-1)*m + i) = 1;
        end
    end
end

% % Test 1 (anzahl 1)
% % Testidee: Es muss ein Tile mehr geben, als es Komponenten gibt. Die
% % Technical Constraint, die Router und Tiles gleich macht wird hier
% % getestet
% % r(n+1) ~= phi
% UglNo=UglNo+1;
% b(UglNo)= -0.5;
% A(UglNo, tizSTART+n+1)= -1;

% Test 2 (anzahl 9)
% Testidee: Zwei Tiles diagonal platzieren und Fluss verlangen. Erwartung:
% ein dritter Router wird gesetzt, um die Verbindung zu ermöglichen.
% % t1x = 1
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tixSTART+1) = 1;
% 
% % t2x = 20
% GlNo = GlNo +1;
% beq(GlNo) = 1.5;
% Aeq(GlNo, tixSTART+2) = 1;
% 
% % t1y = 1
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tiySTART+1) = 1;
% 
% % t2y = 20
% GlNo = GlNo +1;
% beq(GlNo) = 20;
% Aeq(GlNo, tiySTART+2) = 1;
% 
% % t1z = 2
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tizSTART+1) = 1;
% 
% % t2z = 1
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tizSTART+2) = 1;
% 
% % t3z = 1
% GlNo = GlNo +1;
% beq(GlNo) = 1;
% Aeq(GlNo, tizSTART+3) = 1;
% % t3x= 0.5
% GlNo = GlNo +1;
% beq(GlNo) = 0.5;
% Aeq(GlNo, tixSTART+3) = 1;
% 
% % t3y = 10
% GlNo = GlNo +1;
% beq(GlNo) = 10;
% Aeq(GlNo, tiySTART+3) = 1;

% Test 3 (anzahl ?)
% Testidee: drei Tiles in drei Ebenen, das untere und das obere sollen
% durch einen möglichst kurzen Fluss verbunden werden. 2 TSVs. Das mittlere
% würde von den beiden TSVs durchstoßen werden. Frage: können Router in die
% Mitte von Tiles platziert werden?

% Test 3 wurde noch nicht implementiert