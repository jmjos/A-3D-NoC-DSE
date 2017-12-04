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

% hiRouter-Ungleichungen
disp('Berechung der Router per Tile')
for i = 1:m
    for j = n+1:m
        % #1
        % rjx + 0.5delta leq tix + hij*c + hij1*c
            % umgestellt: rjx - tix -c*hij - c* hij1 leq -0.5*delta
        UglNo = UglNo +1;
        b(UglNo) = -0.5*delta;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, tixSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ1START + (i-1)*(m-n) + j-n) = -c;
        
        % #2
        % tix + ai + 0.5delta leq rjx + hij*c + hij2*c
            % umgestellt: tix + ai - rjx - c*hij - c*hij2 leq - 0.5delta
        UglNo = UglNo +1;
        b(UglNo) = -0.5*delta;
        A(UglNo, tixSTART + i) = 1;
        A(UglNo, aiSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ2START + (i-1)*(m-n) + j-n) = -c;
            
        % #3
        % rjy + 0.5delta leq tiy hij*c + hij3*c
            % umgestellt: rjy - tiy - c*hij - c*hij3 leq - 0.5delta
        UglNo = UglNo +1;
        b(UglNo) = -0.5*delta;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, tiySTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ3START + (i-1)*(m-n) + j-n) = -c;
        
        % #4
        % tiy + bi + 0.5delta leq rjy + hij*c + hij4*c
            % umgestellt: tiy + bi - rjy - c*hij - c*hij4 leq - 0.5delta
        UglNo = UglNo +1;
        b(UglNo) = -0.5*delta;
        A(UglNo, tiySTART + i) = 1;
        A(UglNo, biSTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ4START + (i-1)*(m-n) + j-n) = -c;
        
        % #5
        % rjz + 0.5 leq tiz + hij*c + hij5*c
            % umgestellt: rjz - tiz - c*hij - c* hij5 leq -0.5
        UglNo = UglNo +1;
        b(UglNo) = -0.5;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, tizSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ5START + (i-1)*(m-n) + j-n) = -c;
        
        % #6
        % tiz + 0.5 leq rjz + hij*c + hij6*c
            % umgestellt: tiz -rjz - c*hij - c*hij6 leq -0.5
        UglNo = UglNo +1;
        b(UglNo) = -0.5;
        A(UglNo, tizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = -c;
        A(UglNo, routsv_HIJ6START + (i-1)*(m-n) + j-n) = -c;
        
        % #7
        % hij1 + hij2 + hij3 + hij4 + hij5 + hij6 leq 5
        UglNo = UglNo +1;
        b(UglNo) = 5;
        A(UglNo, routsv_HIJ1START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ2START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ3START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ4START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ5START + (i-1)*(m-n) + j-n) = 1;
        A(UglNo, routsv_HIJ6START + (i-1)*(m-n) + j-n) = 1;
        
        % #8
        % tix leq rjx + (1-hij)*c
            % umgestellt: tix -rjx +c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, tixSTART + i) = 1;
        A(UglNo, rixSTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
        % #9
        % rjx leq tix + ai + (1-hij)*c
            % umgestellt: rjx - tix - ai + c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, rixSTART + j) = 1;
        A(UglNo, tixSTART + i) = -1;
        A(UglNo, aiSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
            
        % #10
        % tiy leq rjy + (1-hij)*c
            % umgestellt: tiy - rjy + c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, tiySTART + i) = 1;
        A(UglNo, riySTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
        % #11
        % rjy leq tiy + bi + (1-hij)*c
            % umgestellt: rjy - tiy - bi + c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, riySTART + j) = 1;
        A(UglNo, tiySTART + i) = -1;
        A(UglNo, biSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
        % #12
        % tiz leq rjz + (1-hij)*c
            % umgestellt: tiz - rjz + c* hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, tizSTART + i) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
        % #13
        % rjz leq tiz + (1-hij)*c
            % umgestellt: rjz - tiz + c*hij leq c
        UglNo = UglNo +1;
        b(UglNo) = c;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, tizSTART + i) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = c;
        
    end
end

for i = 1:n
    % #1.1
    % hirouter = sum_{j=n+1}^{m}(hij) + 1
        % umgestellt: sum - hirouter = -1
    GlNo = GlNo +1;
    beq(GlNo) = -1;
    Aeq(GlNo, routsv_hirouterSTART + i) = -1;
    for j=n+1:m
        Aeq(GlNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = 1;
    end
end
for i = n+1:m
    % #1.2
    % hirouter = sum_{j=n+1}^{m}(hij)
        % umgestellt: sum - hirouter = 0
    GlNo = GlNo +1;
    beq(GlNo) = 0;
    Aeq(GlNo, routsv_hirouterSTART + i) = -1;
    for j=n+1:m
        Aeq(GlNo, routsv_HIJSTART + (i-1)*(m-n) + j-n) = 1;
    end
end

% hj-Dach-Ungleichungen
disp('Berechnung der TSVs per tile')
for j=1:m
    for kloop = 1:(m-1)
        if (kloop<j)
            k = kloop;
        else
            k = kloop +1;
        end
        % #1
        % rjz leq rkz + hjkor*c + hdachj*c
            % umgstellt: rjz - rkz - c*hjkor - c*hdachj leq 0
        UglNo = UglNo + 1;
        b(UglNo) = 0;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rizSTART + k) = -1;
        A(UglNo, routsv_HJKORSTART + (j-1)*(m-1) + kloop) = -c;
        A(UglNo, routsv_hatHJSTART + j) = -c;
        % #2
        % rkz leq rjz + hjkor*c + hdachj*c
            % umgestellt: rkz - rjz - c*hjkor - c*hdachj leq 0
        UglNo = UglNo + 1;
        b(UglNo) = 0;
        A(UglNo, rizSTART + k) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, routsv_HJKORSTART + (j-1)*(m-1) + kloop) = -c;
        A(UglNo, routsv_hatHJSTART + j) = -c;
        % #3
        % ejk leq 0 + (1-hjkor)*c + hdachj*c
            % umgestellt: ejk + c*hjkor - c*hdachj leq c
        UglNo = UglNo + 1;
        b(UglNo) = c;
        A(UglNo, eSTART + (j-1)*m + k) = 1;
        A(UglNo, routsv_HJKORSTART + (j-1)*(m-1) + kloop) = c;
        A(UglNo, routsv_hatHJSTART + j) = -c;
        % #4
        % 1 leq ejk + hjktilde*c
            % umgestellt: -ejk - c*hjktilde leq -1
        UglNo = UglNo + 1;
        b(UglNo) = -1;
        A(UglNo, eSTART + (j-1)*m + k) = -1;
        A(UglNo, routsv_tildeHJKSTART + (j-1)*(m-1) + kloop) = -c;
        % #5
        % rjz leq rkz - .5 + hjkortilde*c + hjktilde*c
            % umgestellt: rjz - rkz -c*hjkortilde - c*hjktilde leq - 0.5
        UglNo = UglNo + 1;
        b(UglNo) = -0.5;
        A(UglNo, rizSTART + j) = 1;
        A(UglNo, rizSTART + k) = -1;
        A(UglNo, routsv_tildeHJKORSTART + (j-1)*(m-1) + kloop) = -c;
        A(UglNo, routsv_tildeHJKSTART + (j-1)*(m-1) + kloop) = -c;
        % #6
        % rkz leq rjz - .5 + (1- hjkortilde)*c + hjktilde*c
            % umgestellt: rkz - rjz + c*hjkortilde - c*hjktilde leq -0.5 +c
        UglNo = UglNo + 1;
        b(UglNo) = -0.5 + c;
        A(UglNo, rizSTART + k) = 1;
        A(UglNo, rizSTART + j) = -1;
        A(UglNo, routsv_tildeHJKORSTART + (j-1)*(m-1) + kloop) = c;
        A(UglNo, routsv_tildeHJKSTART + (j-1)*(m-1) + kloop) = -c;
    end
end

for j = 1:m
    % #7
    % sum_k(hjktilde) leq m-2+(1- hdachj)
        % umgestellt: sum_k(hjktilde) + hdachj leq m-1
    UglNo = UglNo + 1;
    b(UglNo) = m-1;
    A(UglNo, routsv_hatHJSTART + j) = 1;
    for kloop = 1:(m-1)
        A(UglNo, routsv_tildeHJKSTART + (j-1)*(m-1) + kloop) = 1;
    end
end


for i= 1:m
    for jloop = 1:m-n
        j = jloop + n;
        % (1 - hdachij) + hij + hhatj leq 2
        % - hdachij + hij + hhatj leq 1
        UglNo = UglNo + 1;
        b(UglNo) = 1;
        A(UglNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = -1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + jloop) = 1; %jloop da m*(m-n) lang
        A(UglNo, routsv_hatHJSTART + j) = 1;
        
        % hdachij - hhatj leq 0
        UglNo = UglNo + 1;
        b(UglNo) = 0;
        A(UglNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = 1;
        A(UglNo, routsv_hatHJSTART + j) = -1;
        
        % hdachij - hij leq 0
        UglNo = UglNo + 1;
        b(UglNo) = 0;
        A(UglNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = 1;
        A(UglNo, routsv_HIJSTART + (i-1)*(m-n) + jloop) = -1;
    end
end

% hiTSV setzen
for i = 1:n
    %hiTSV = hdachii + sum_{j \in [n+1, ..., m]} hdachij
    %  hiTSV - hdachii - sum_{j \in [n+1, ..., m]} hdachij = 0
    GlNo = GlNo +1;
    beq(GlNo) = 0;
    Aeq(GlNo, routsv_hiTSVSTART + i) = 1;
    Aeq(GlNo, routsv_hatHJSTART + i) = -1;
    for jloop = 1: m-n
        Aeq(GlNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = -1;
    end
end

for i = n+1:m
    %hiTSV = sum_{j \in [n+1, ..., m]} hdachij
    %  hiTSV - sum_{j \in [n+1, ..., m]} hdachij = 0
    GlNo = GlNo +1;
    beq(GlNo) = 0;
    Aeq(GlNo, routsv_hiTSVSTART + i) = 1;
    for jloop = 1: m-n
        Aeq(GlNo, routsv_hatHIJSTART + (i-1)*(m-n) + jloop) = -1;
    end
end