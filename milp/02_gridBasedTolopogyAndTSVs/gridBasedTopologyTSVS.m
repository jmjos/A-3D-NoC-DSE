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
m = 5;
l = 5;
%rx = repmat([1:4], 1, 12);
%ry = repmat([ones(1,4) 2*ones(1,4) 3*ones(1,4) 4*ones(1,4)],1,3);
%rz = [ones(1,16) 2*ones(1,16)  3*ones(1,16)];
%rx = [1 2 1 2 3 1 2 1 2 3]
%ry = [1 1 2 2 2 1 1 2 2 2]
%rz = [1 1 1 1 1 2 2 2 2 2]
rx = [1 1 1 1 2]
ry = [3 2 1 1 1]
rz = [1 1 1 2 1]
c = 1000;
delta = .1;

% network edges E_N
eLENGTH = m^2;
% grid based topology and TSCs connect to neighbored layers
HILENGTH    = m^2;
HORILENGTH   = m^2;
HORIILENGTH  = m^2;
% forbid connections between non-neighbored routers
HIJORLENGTH = m*(m-1);
HIJK1LENGTH = m*(m-1)*(m-2);
HIJKa1LENGTH = m*(m-1)*(m-2);
HIJKa2LENGTH = m*(m-1)*(m-2);
HIJKa3LENGTH = m*(m-1)*(m-2);
HIJKa4LENGTH = m*(m-1)*(m-2);
HIJK2LENGTH = m*(m-1)*(m-2);
HIJKb1LENGTH = m*(m-1)*(m-2);
HIJKb2LENGTH = m*(m-1)*(m-2);
HIJKb3LENGTH = m*(m-1)*(m-2);
HIJKb4LENGTH = m*(m-1)*(m-2);
HIJK3LENGTH = m*(m-1)*(m-2);
HIJKc1LENGTH = m*(m-1)*(m-2);
HIJKc2LENGTH = m*(m-1)*(m-2);
HIJKc3LENGTH = m*(m-1)*(m-2);
HIJKc4LENGTH = m*(m-1)*(m-2);
HIJK4LENGTH = m*(m-1)*(m-2);
HIJKd1LENGTH = m*(m-1)*(m-2);
HIJKd2LENGTH = m*(m-1)*(m-2);
HIJKd3LENGTH = m*(m-1)*(m-2);
HIJKd4LENGTH = m*(m-1)*(m-2);
HIJ1LENGTH = m*(m-1);
HIJ2LENGTH = m*(m-1);
HIJ3LENGTH = m*(m-1);
% routers are not self-connected
% eij = eji

eSTART = 0;
HISTART = eSTART + eLENGTH;
HORISTART = HISTART + HILENGTH;
HORIISTART = HORISTART + HORILENGTH;
HIJORSTART = HORIISTART + HORIILENGTH;
HIJK1START = HIJORSTART + HIJORLENGTH; 
HIJKa1START = HIJK1START + HIJK1LENGTH;
HIJKa2START = HIJKa1START + HIJKa1LENGTH;
HIJKa3START = HIJKa2START + HIJKa2LENGTH;
HIJKa4START = HIJKa3START + HIJKa3LENGTH;
HIJK2START = HIJKa4START + HIJKa4LENGTH;  
HIJKb1START = HIJK2START + HIJK2LENGTH;
HIJKb2START = HIJKb1START + HIJKb1LENGTH;
HIJKb3START = HIJKb2START + HIJKb2LENGTH;
HIJKb4START = HIJKb3START + HIJKb3LENGTH;
HIJK3START = HIJKb4START + HIJKb4LENGTH;
HIJKc1START = HIJK3START + HIJK3LENGTH;
HIJKc2START = HIJKc1START + HIJKc1LENGTH;
HIJKc3START = HIJKc2START + HIJKc2LENGTH;
HIJKc4START = HIJKc3START + HIJKc3LENGTH;
HIJK4START = HIJKc4START + HIJKc4LENGTH;
HIJKd1START = HIJK4START + HIJK4LENGTH;
HIJKd2START = HIJKd1START + HIJKd1LENGTH;
HIJKd3START = HIJKd2START + HIJKd2LENGTH;
HIJKd4START = HIJKd3START + HIJKd3LENGTH;
HIJ1START = HIJKd4START + HIJKd4LENGTH;
HIJ2START = HIJ1START + HIJ1LENGTH;
HIJ3START = HIJ2START + HIJ2LENGTH;

anzahlVar = HIJ3START + HIJ3LENGTH;
anzahlUgl = 14 * m ^2 + 33*m*(m-1)*(m-2) + 4*m*(m-1) + m + 2*m*(m-1);
%% genereiere kostenfunktion

f= zeros(1,anzahlVar);
f(eSTART + 1 : eSTART + eLENGTH) = -1;


%% generiere integer variablen

intcon = eSTART + 1 : anzahlVar;

%% trage richtige werte in A und b ein

A = zeros(anzahlUgl, anzahlVar);
b = zeros(anzahlUgl, 1);

UglNo = 0;
GlNo = 0;

% grid based topology and TSVs between neighbored layers
% 14 * m^2 Ungl 
for i = 1:m
    for j = 1:m
        % #1
        % -hij*c + eij*c  leq c - r_iz + r_jz
        UglNo = UglNo + 1;
        b(UglNo) = c - rz(i) + rz(j);
        A(UglNo, HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #2
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        b(UglNo) = c + rz(i) - rz(j);
        A(UglNo, HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #3
        % wie die erste, z und x tauschen, - HOR1*c
        UglNo = UglNo + 1;
        b(UglNo) = c - rx(i) + rx(j);
        A(UglNo, HORISTART + (i-1)*m + j) = -c ;
        A(UglNo, HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #4
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        b(UglNo) = c + rx(i) - rx(j);
        A(UglNo, HORISTART + (i-1)*m + j) = -c ;
        A(UglNo, HISTART + (i-1)*m + j) = -c ;
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #5
        % wie die erste, z und y tauschen, (1- HOR1*c)
        UglNo = UglNo + 1;
        b(UglNo) = 2*c - ry(i) + ry(j);
        A(UglNo, HORISTART + (i-1)*m + j) = c; 
        A(UglNo, HISTART + (i-1)*m + j) = -c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #6
        % r_i und r_j tauschen
        UglNo = UglNo + 1;
        b(UglNo) = 2*c + ry(i) - ry(j);
        A(UglNo, HORISTART + (i-1)*m + j) = c; 
        A(UglNo, HISTART + (i-1)*m + j) = -c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #7
        % - hijOR2*c + hij1 * c + e_ij * c leq r_iz - r_jz -1 + 2*c
        UglNo = UglNo + 1;
        b(UglNo) = 2*c + rz(i) - rz(j) -1;
        A(UglNo, HORIISTART + (i-1)*m + j) = -c; 
        A(UglNo, HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #8
        % - hijOR2*c + hij1 * c + e_ij * c leq r_jz - r_iz +1 + 2*c
        UglNo = UglNo + 1;
        b(UglNo) = 2*c - rz(i) + rz(j) +1;
        A(UglNo, HORIISTART + (i-1)*m + j) = -c; 
        A(UglNo, HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #9
        % hijOR2*c + hij1*c + e_ij*c leq r_iz - rjz +1 + 3*c
        UglNo = UglNo + 1;
        b(UglNo) = 3*c + rz(i) - rz(j) +1;
        A(UglNo, HORIISTART + (i-1)*m + j) = c; 
        A(UglNo, HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;        
        
        % #10
        % hijOR2*c + hij1*c + e_ij*c leq -r_iz + rjz -1 + 3*c
        UglNo = UglNo + 1;
        b(UglNo) = 3*c - rz(i) + rz(j) -1;
        A(UglNo, HORIISTART + (i-1)*m + j) = c; 
        A(UglNo, HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #11
        % hij1*c + e_ij*c leq rjx - rix + 2*c
        UglNo = UglNo + 1;
        b(UglNo) = 2*c - rx(i) + rx(j);
        A(UglNo, HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #12
        % ri und rj tauschen
        UglNo = UglNo + 1;
        b(UglNo) = 2*c + rx(i) - rx(j);
        A(UglNo, HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
        
        % #13
        % ri und rj und rx und ry tauschen
        UglNo = UglNo + 1;
        b(UglNo) = 2*c - ry(i) + ry(j);
        A(UglNo, HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
             
        % #14
        % ri und rj tauschen
        UglNo = UglNo + 1;
        b(UglNo) = 2*c + ry(i) - ry(j);
        A(UglNo, HISTART + (i-1)*m + j) = c; 
        A(UglNo, eSTART + (i-1)*m + j) = c;
    end
end

% Modul 1 bis 4, forbid connections between non neighbored routers
% 33 (m*(m-1)*(m-2)) ugl
for i = 1:m
    for jloop = 1:(m-1)
        for kloop = 1:(m-2)
            if (jloop<i)
                j= jloop;
            else
                j = jloop +1;
            end
            k = kloop;
            if (k == i)
                k = k +1;
            end
            if (k == j)
                k = k +1;            
                if (k == i)
                k = k +1;
                end
            end
            
            %Fall A (riy <= rjy ; rix = rjx)
            
            % #1
            % - hijk1*c - hijor *c leq rjy - riy
            UglNo = UglNo +1;
            b(UglNo) = ry(j) - ry(i);
            A(UglNo,HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #2
            % -||- leq rjx - rix
            UglNo = UglNo +1;
            b(UglNo) = rx(j) - rx(i);
            A(UglNo,HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #3
            % -||- leq rix - rjx
            UglNo = UglNo +1;
            b(UglNo) = rx(i) - rx(j);
            A(UglNo,HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % #4
            % Ungleichung I
            % -||- - hA1*c leq riy - rky
            UglNo = UglNo +1;
            b(UglNo) = ry(i) - ry(k);
            A(UglNo,HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKa1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #5
            % Ungleichung II
            % -||- - hA2 leq - rjy + rky
            UglNo = UglNo +1;
            b(UglNo) = - ry(j) + ry(k);
            A(UglNo,HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKa2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % #6
            % Ungleichung III
            % -||- - hA3 leq rix - rkx -delta
            UglNo = UglNo +1;
            b(UglNo) = rx(i) - rx(k) - delta;
            A(UglNo,HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKa3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #7
            % Ungleichung IV
            % -||- - hA4 leq - rix + rkx -delta
            UglNo = UglNo +1;
            b(UglNo) = -rx(i) + rx(k) -delta;
            A(UglNo,HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKa4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall B (rjy <= riy ; rix = rjx)------------------------------
            
            % - hijk2*c - hijor *c leq riy - rjy
            UglNo = UglNo +1;
            b(UglNo) = ry(i) - ry(j);
            A(UglNo,HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjx - rix
            UglNo = UglNo +1;
            b(UglNo) = rx(j) - rx(i);
            A(UglNo,HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rix - rjx
            UglNo = UglNo +1;
            b(UglNo) = rx(i) - rx(j);
            A(UglNo,HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hB1*c leq -riy + rky
            UglNo = UglNo +1;
            b(UglNo) = - ry(i) + ry(k);
            A(UglNo,HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKb1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq + rjy - rky
            UglNo = UglNo +1;
            b(UglNo) = + ry(j) - ry(k);
            A(UglNo,HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKb2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq - rix + rkx -delta
            UglNo = UglNo +1;
            b(UglNo) = - rx(i) + rx(k) - delta;
            A(UglNo,HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKb3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq + rix - rkx -delta
            UglNo = UglNo +1;
            b(UglNo) = +rx(i) - rx(k) -delta;
            A(UglNo,HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKb4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall C (rix <= rjx ; riy = rjy)------------------------------
            
            % - hijk1*c - hijor *c leq rjx - rix
            UglNo = UglNo +1;
            b(UglNo) = rx(j) - rx(i);
            A(UglNo,HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq riy - rjy
            UglNo = UglNo +1;
            b(UglNo) = ry(i) - ry(j);
            A(UglNo,HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjy - riy
            UglNo = UglNo +1;
            b(UglNo) = ry(j) - ry(i);
            A(UglNo,HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hA1*c leq rix - rkx
            UglNo = UglNo +1;
            b(UglNo) = rx(i) - rx(k);
            A(UglNo,HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKc1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq - rjx + rkx
            UglNo = UglNo +1;
            b(UglNo) = - rx(j) + rx(k);
            A(UglNo,HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKc2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq - riy + rky -delta
            UglNo = UglNo +1;
            b(UglNo) = - ry(i) + ry(k) - delta;
            A(UglNo,HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKc3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq + riy - rky -delta
            UglNo = UglNo +1;
            b(UglNo) = +ry(i) - ry(k) -delta;
            A(UglNo,HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKc4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            %Fall D (rjx <= rix ; riy = rjy)
            
            
            % - hijk1*c - hijor *c leq -rjx + rix
            UglNo = UglNo +1;
            b(UglNo) = -rx(j) + rx(i);
            A(UglNo,HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq riy - rjy
            UglNo = UglNo +1;
            b(UglNo) = ry(i) - ry(j);
            A(UglNo,HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            
            % -||- leq rjy - riy
            UglNo = UglNo +1;
            b(UglNo) = ry(j) - ry(i);
            A(UglNo,HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
                        
            % Ungleichung I
            % -||- - hA1*c leq - rix + rkx
            UglNo = UglNo +1;
            b(UglNo) = -rx(i) + rx(k);
            A(UglNo,HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKd1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % Ungleichung II
            % -||- - hA2 leq + rjx - rkx
            UglNo = UglNo +1;
            b(UglNo) =  rx(j) - rx(k);
            A(UglNo,HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKd2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung III
            % -||- - hA3 leq riy - rky -delta
            UglNo = UglNo +1;
            b(UglNo) = ry(i) - ry(k) - delta;
            A(UglNo,HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKd3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            
            % Ungleichung IV
            % -||- - hA4 leq - riy + rky -delta
            UglNo = UglNo +1;
            b(UglNo) = -ry(i) + ry(k) -delta;
            A(UglNo,HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            A(UglNo,HIJORSTART + (i-1)*(m-1) + jloop ) = -c;
            A(UglNo,HIJKd4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = -c;
            
            % #29
            % VerODERung von abcd1 .. abcd4
            % hijka1 + hijka2 + ... + hijka4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,HIJKa1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKa2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKa3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKa4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #30
            % hijkb1 + hijkb2 + ... + hijkb4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,HIJKb1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKb2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKb3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKb4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #31
            % hijkc1 + hijkc2 + ... + hijkc4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,HIJKc1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKc2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKc3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKc4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #32
            % hijkd1 + hijkd2 + ... + hijkd4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,HIJKd1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKd2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKd3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJKd4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
            % #33
            % VerODERung hijk1 bis hijk4
            % hijk1 + ... +hijk4 leq 3
            UglNo = UglNo +1;
            b(UglNo) = 3;
            A(UglNo,HIJK1START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJK2START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJK3START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            A(UglNo,HIJK4START + (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop ) = 1;
            
        end
    end
end

% Modul 5, forbid connections between non neighbored routers
% 3* m* (m-1) Ugl
for i = 1:m
    for jloop = 1:(m-1)
        if (jloop<i)
            j= jloop;
        else
            j = jloop +1;
        end
        % module 5
        % #1
        % eij - hij1*c + hijOR*c leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, eSTART + (i-1)*m + j ) = 1 ;
        A(UglNo, HIJ1START + (i-1)*(m-1) + jloop ) = -c ;
        A(UglNo, HIJORSTART + (i-1)*(m-1) + jloop ) = c ;
        
        % #2
        % - hij2*c + hijOR*c leq rz(j) - rz(i) -1/2 +c
        UglNo = UglNo +1;
        b(UglNo) = rz(j) - rz(i) -1/2 + c;
        A(UglNo, HIJ2START + (i-1)*(m-1) + jloop ) = -c ;
        A(UglNo, HIJORSTART + (i-1)*(m-1) + jloop ) = c ;
        
        % #3
        % - hij3*c + hijOR*c leq rz(i) - rz(j) -1/2 +c
        UglNo = UglNo +1;
        b(UglNo) = rz(i) - rz(j) -1/2 + c;
        A(UglNo, HIJ3START + (i-1)*(m-1) + jloop ) = -c ;
        A(UglNo, HIJORSTART + (i-1)*(m-1) + jloop ) = c ;
        
        % #4
        % hij1 +hij2 + hij3 leq 2
        UglNo = UglNo +1;
        b(UglNo) = 2;
        A(UglNo, HIJ1START + (i-1)*(m-1) + jloop ) = 1 ;
        A(UglNo, HIJ2START + (i-1)*(m-1) + jloop ) = 1 ;
        A(UglNo, HIJ3START + (i-1)*(m-1) + jloop ) = 1 ;
    end
end

% routers are not self-connected
for i = 1:m
    % e ii leq 0
    UglNo = UglNo +1;
    b(UglNo) = 0;
    A(UglNo, eSTART + (i-1)*m + i)=1;
end

% e_ij = eji
for i = 1:m
    for jloop= 1:(m-1)
        if (jloop<i)
            j= jloop;
        else
            j = jloop +1;
        end
        % e_ij - e_ji leq 0
        UglNo = UglNo +1;
        b(UglNo) = 0;
        A(UglNo, eSTART + (i-1)*m + j)= 1;
        A(UglNo, eSTART + (j-1)*m + i)= -1;
        
        % e_ji - e_ij leq 0
        UglNo = UglNo +1;
        b(UglNo) = 0;
        A(UglNo, eSTART + (i-1)*m + j)= 1;
        A(UglNo, eSTART + (j-1)*m + i)= -1;
    end
end

            
%% setting bounds

lb = zeros(1,anzahlVar);

%upper bound der integer binary hilfsvaribalen
notBoundIndexes = eSTART + 1 : anzahlVar;
ub(notBoundIndexes) = 1 * ones(length(notBoundIndexes), 1);


%% eq constraints

Aeq = [];
beq = [];

%% lin

options = optimoptions('intlinprog','MaxTime',120);
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub, options);

%% plot
figure(1)
clf
hold on
for i =1: m
    plot3([rx(i)],[ry(i)],[rz(i)], '*')
    for j= 1:m
        if (x(eSTART + (i-1)*m + j))
            plot3([rx(i) rx(j)],[ry(i) ry(j)],[rz(i) rz(j)])
        end
    end
end
hold off