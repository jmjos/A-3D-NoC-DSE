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

%% Eingaben
clear all
n = 20;
m = 20;

% E_A
% HINWEIS: Kanten zu sich selbst sind verboten.
eA = zeros(n^2,1);

eA(2) = 1;

% E_N
% HINWEIS: Kanten zu sich selbst sind verboten.

% komplett verknüpfter Graph
eN = floor(rand(m^2,1)*1.8);
for i = 1:m
    eN((i-1)*m+i) = 0;
end

% router positions
setSize = 2*pi/(m);
rx = sin(0:setSize:2*pi-setSize);
ry = cos(0:setSize:2*pi-setSize);
rz = ones(m);

%Beispiel 1
%eA = [0 0 1 0];
%eN = [0 1 1 1 1 0 1 1 1 1 0 1 1 1 1 0];
%rx = [1 1 1 2];
%ry = [3 2 1 1];
%rz = [1 1 1 1];

% p (last placed router index)

p = 3;

eLENGTH = m^2;
fLENGTH = m^2 * sum(eA);
GammaLENGTH = m*sum(eA);
hLENGTH = m^2 * sum(eA);

eSTART = 0;
fSTART = eSTART + eLENGTH;
GammaSTART = fSTART + fLENGTH;
hSTART = GammaSTART + GammaLENGTH;

anzahlVar = hSTART + hLENGTH;
anzahlUgl = m + sum(eA)*m^2 + m^2*sum(eA);
anzahlGl = m^2 + 2*sum(eA) + sum(eA)*(m-2);

%% genereiere kostenfunktion

f= zeros(1,anzahlVar);
f(fSTART+1:fSTART+fLENGTH) = 1;


%% generiere integer variablen

intcon = [eSTART+1 : eSTART + eLENGTH, GammaSTART+1 : hSTART + hLENGTH];
%intcon = [1: anzahlVar];

%% trage richtige werte in A und b und Aeq und beq ein

A = zeros(anzahlUgl, anzahlVar);
b = zeros(anzahlUgl, 1);

Aeq = zeros(anzahlGl, anzahlVar);
beq = zeros(anzahlGl, 1);

GlNo = 0;
UglNo = 0;
  
% Eingabe in e-Variable Eingeben .
for i = 1:m
    for j = 1:m
        GlNo = GlNo +1;
        beq(GlNo) = eN((i-1)*m + j);
        Aeq(GlNo, eSTART + (i-1)*m + j) = 1;
    end
end

% Kanten von Routern zu sich selbst verbieten .
for i = 1:m
    UglNo = UglNo +1;
    b(UglNo) = 0;
    A(UglNo, eSTART + (i-1)*m + i) = 1;
end

% Flüsse nutzen nur Kanten, die auch da sind .
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo+1;
            for k = 1:m
                for l = 1:m
                    UglNo = UglNo +1;
                    b(UglNo) = eN((k-1)*m + l);
                    A(UglNo, fSTART + (fNo-1) * m^2 + (k-1)*m + l) = 1;
                end
            end
        end
    end
end

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
                            l = lloop+1;
                        else
                            l = lloop;
                        end
                        % eingehende Kanten (l,k)
                        Aeq(GlNo, fSTART + (fNo-1)* m^2 + (l-1)*m + k)= 1;
                        % ausgehende Kanten (k,l)
                        Aeq(GlNo, fSTART + (fNo-1)* m^2 + (k-1)*m + l)= -1;
                    end
                end
            end
        end
    end
end

% Hilfsvariable für acyclic flow; ist 1 wenn f_ijkl > 0
fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            for k = 1:m
                for l = 1:m
                    UglNo = UglNo +1;
                    b(UglNo) = 0;
                    A(UglNo, fSTART + (fNo-1)*m^2 + (k-1)*m + l )= 1;
                    A(UglNo, hSTART + (fNo-1)*m^2 + (k-1)*m + l )= -1;
                end
            end
        end
    end
end

% acyclic flow .

fNo = 0;
for i = 1:n
    for j = 1:n
        if (eA((i-1)*n + j) == 1)
            fNo = fNo +1;
            for k = 1:m
                for l = 1:m
                    UglNo = UglNo +1;
                    b(UglNo) = m - 1/2;
                    A(UglNo, GammaSTART + (fNo-1)*m + k )= 1;
                    A(UglNo, GammaSTART + (fNo-1)*m + l )= -1;
                    A(UglNo, hSTART + (fNo-1)*m^2 + (k-1)*m + l )= m;
                end
            end
        end
    end
end

%% setting bounds

lb = zeros(1,anzahlVar);

ub = ones(1,anzahlVar);

% ub ist m für Gammas
boundIndexes = GammaSTART + 1 : GammaSTART + GammaLENGTH;
ub(boundIndexes) = m * ones(length(boundIndexes), 1);

%upper bound der integer binary hilfsvaribalen
%notBoundIndexes = tizSTART + 1 : tizSTART + tizLENGTH;
%ub(notBoundIndexes) = l * ones(length(notBoundIndexes), 1);


%% eq constraints ausschalten
%Aeq = [];
%beq = [];

%% lin

options = optimoptions('intlinprog','MaxTime',10);
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub, options);

%ai
%bi
%solution = x(aiSTART + 1 : tizSTART + tizLENGTH)

%% plot
close all
%iterate over flows
for fNo = 1:sum(eA)
    figure(fNo)
    hold on
    %plot routers and network
    for router = 1:m
        plot3([rx(router)],[ry(router)],[rz(router)], 'k*')
    end
    for i =1:n
        for j= 1:n
            if (eA((i-1)*n + j) == 1)
                plot3([rx(i)],[ry(i)],[rz(i)], 'c*', 'MarkerSize',12)
                plot3([rx(j)],[ry(j)],[rz(j)], 'g*', 'MarkerSize',12)
            end
        end
    end
    
    %plot links in network
    for i =1: m
        for j= 1:m
            if (x(eSTART + (i-1)*m + j))
                plot3([rx(i) rx(j)],[ry(i) ry(j)],[rz(i) rz(j)], 'k')
            end
        end
    end
    
    %plot flows
    for i =1: m
        for j= 1:m
            %is there flow?
            if (x(fSTART + (fNo-1)* m^2 + (i-1)*m + j) ~= 0)
                 %plot3([rx(i) rx(j)],[ry(i) ry(j)],[rz(i) rz(j)], 'r')
                 quiver3(rx(i), ry(i), rz(i), rx(j)-rx(i), ry(j)-ry(i), rz(j)-rz(i), 'r')
                 text( mean([rx(i) rx(j)]),mean([ry(i) ry(j)]),mean([rz(i) rz(j)]), num2str(x(fSTART + (fNo-1)* m^2 + (i-1)*m + j)) );
            end
        end
    end
    
    
    hold off
end
