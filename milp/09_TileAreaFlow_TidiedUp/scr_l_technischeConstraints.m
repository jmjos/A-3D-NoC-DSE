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

% Komponenten und Router haben gleiche Indexe
% si(xyz) = ri(xyz)

% IndexesRouterTiles

% RIXTIX Gleichheit (1:n)
% Bemerkung: Diese Gleichungen gibts im Paper (noch) nicht und sie 
% landen vielleicht woanders als in den Technical Constr.
disp('Gleichheit von ri und ti für i von 1 bis n')
% ti{x,y,z} = ri{x,y,z}
for i = 1:n
    %tix = rix
    GlNo = GlNo +1;
    beq(GlNo) = 0;
    Aeq(GlNo, rixSTART + i) = 1;
    Aeq(GlNo, tixSTART + i) = -1;
    
    %tiy = riy
    GlNo = GlNo + 1;
    beq(GlNo) = 0;
    Aeq(GlNo, riySTART + i) = 1;
    Aeq(GlNo, tiySTART + i) = -1;

    %tiz = riz
    GlNo = GlNo + 1;
    beq(GlNo) = 0;
    Aeq(GlNo, rizSTART + i) = 1;
    Aeq(GlNo, tizSTART + i) = -1;
end

% RIXTIX-Ungleichungen(n+1:m)
disp('Gleichheit von ri und ti für i von n+1 bis m')
for i=n+1:m
    % tiz leq phi + tech_hI*c
    UglNo = UglNo +1;
    b(UglNo)= phi(3);
    A(UglNo,tizSTART+i)=1;
    A(UglNo,tech_hISTART+i)=-c;
    
    % phi leq tiz + tech_hI*c
    UglNo = UglNo +1;
    b(UglNo)= -phi(3);
    A(UglNo,tizSTART+i)= -1;
    A(UglNo,tech_hISTART+i)=-c;

    % tix leq rix + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,rixSTART+i)= -1;
    A(UglNo,tixSTART+i)= 1;
    A(UglNo,tech_hISTART+i)= c;
    
    % rix leq tix + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,rixSTART+i)= 1;
    A(UglNo,tixSTART+i)= -1;
    A(UglNo,tech_hISTART+i)= c;
    
    % tiy leq riy + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,riySTART+i)= -1;
    A(UglNo,tiySTART+i)= 1;
    A(UglNo,tech_hISTART+i)= c;

    % riy leq tiy + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,riySTART+i)= 1;
    A(UglNo,tiySTART+i)= -1;
    A(UglNo,tech_hISTART+i)= c;
    
    % tiz leq riz + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,rizSTART+i)= -1;
    A(UglNo,tizSTART+i)= 1;
    A(UglNo,tech_hISTART+i)= c;
    
    % riz leq tiz + (1 - tech_hI)*c
    UglNo = UglNo +1;
    b(UglNo)= c;
    A(UglNo,rizSTART+i)= 1;
    A(UglNo,tizSTART+i)= -1;
    A(UglNo,tech_hISTART+i)= c;
end

% IndexSortRiTi
for i= n+1:m-1
    %Router mit Layer 0 stehen am Ende
    % r(i+1)z leq riz*c
    UglNo = UglNo +1;
    b(UglNo)=0;
    A(UglNo, rizSTART + i+1)= 1;
    A(UglNo, rizSTART + i)= -c;
    
    %Tiles mit Layer 0 stehen am Ende
    % t(i+1)z leq tiz*c
    UglNo = UglNo +1;
    b(UglNo)=0;
    A(UglNo, tizSTART + i+1)= 1;
    A(UglNo, tizSTART + i)= -c;
end
    
% RItoPHI
%  alle router in ebene 0 muessen in phi sein. d.h. 
%   r_{i,x} \leq r_{i,z}*C
%   r_{i,y} \leq r_{i,z}*C
%  fuer alle $i \in [m]$, C = xmax+ymax+l
for i= 1:m
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, rixSTART + i) = 1;
    A(UglNo, rizSTART + i) = -(xMax + yMax + l);
    
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, riySTART + i) = 1;
    A(UglNo, rizSTART + i) = -(xMax + yMax + l);
end

% TItoPHI
% das gleiche für Tiles (tiles in Ebene 0 müssen in phi sein)
for i= 1:m
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, tixSTART + i) = 1;
    A(UglNo, tizSTART + i) = -(xMax + yMax + l);
    
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, tiySTART + i) = 1;
    A(UglNo, tizSTART + i) = -(xMax + yMax + l);
end

for i = n+1:m
    % ai leq tiz*xmax
        % umgestellt: ai -xmax*tiz leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, aiSTART + i) = 1;
    A(UglNo, tizSTART + i) = -xMax;

    % bi leq tiz*ymax
        % umgestellt: bi -ymax*tiz leq 0
    UglNo = UglNo + 1;
    b(UglNo) = 0;
    A(UglNo, biSTART + i) = 1;
    A(UglNo, tizSTART + i) = -yMax;
end
