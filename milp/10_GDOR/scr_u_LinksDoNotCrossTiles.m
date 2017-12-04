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

disp('Links dont cross tiles')
for i= 1:m
    for jloop=1:m-1
        for kloop=1:m-2
            if (jloop<i)
                j= jloop;
            else
                j = jloop +1;
            end
            k = kloop;
            if (k >= i && k>= j)
                k = k +2;
            elseif (k >= j || k >= i)
                k = k +1;            
            end
            if (k==i || k==j)
                k = k+1;
            end
            %disp(['i: ', num2str(i), 'j: ', num2str(j), 'k: ', num2str(k)])
            % #1
            % rix leq tkx + hijk1*c + hijor*c
                % umgestellt: rix -tkx -c*hijk1 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, rixSTART+ i) = 1;
            A(UglNo, tixSTART+ k) = -1;
            A(UglNo, cross_HIJK1START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #2
            % rjx leq tkx + hijk1*c + hijor*c
                % umgestellt: rjx -tkx -c*hijk1 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, rixSTART+ j) = 1;
            A(UglNo, tixSTART+ k) = -1;
            A(UglNo, cross_HIJK1START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #3
            % riy leq tky + hijk2*c + hijor*c
                % umgestellt: riy -tky -c*hijk2 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, riySTART+ i) = 1;
            A(UglNo, tiySTART+ k) = -1;
            A(UglNo, cross_HIJK2START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #4
            % rjy leq tky + hijk2*c + hijor*c
                % umgestellt: rjy -tky -c*hijk2 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, riySTART+ j) = 1;
            A(UglNo, tiySTART+ k) = -1;
            A(UglNo, cross_HIJK2START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #5
            % rix geq tkx + ak - hijk3*c - hijor*c
                % umgestellt: -rix +tkx +ak -c*hijk3 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, rixSTART+ i) = -1;
            A(UglNo, tixSTART+ k) = 1;
            A(UglNo, aiSTART+ k) = 1;
            A(UglNo, cross_HIJK3START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #6
            % rjx geq tkx + ak - hijk3*c - hijor*c
                % umgestellt: -rjx +tkx +ak -c*hijk3 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, rixSTART+ j) = -1;
            A(UglNo, tixSTART+ k) = 1;
            A(UglNo, aiSTART+ k) = 1;
            A(UglNo, cross_HIJK3START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #7
            % riy geq tky + bk - hijk4*c - hijor*c
                % umgestellt: -riy +tky +bk -c*hijk4 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, riySTART+ i) = -1;
            A(UglNo, tiySTART+ k) = 1;
            A(UglNo, biSTART+ k) = 1;
            A(UglNo, cross_HIJK4START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #8
            % rjy geq tky + bk - hijk4*c - hijor*c
                % umgestellt: -rjy +tky +bk -c*hijk4 -c*hijor leq 0
            UglNo = UglNo+1;
            b(UglNo) = 0;
            A(UglNo, riySTART+ j) = -1;
            A(UglNo, tiySTART+ k) = 1;
            A(UglNo, biSTART+ k) = 1;
            A(UglNo, cross_HIJK4START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #9
            % 1/2 + tkz leq rjz + hijk5*c + hijor*c
                % umgestellt: tkz -rjz -c*hijk5 -c*hijor leq -1/2
            UglNo = UglNo+1;
            b(UglNo) = -0.5;
            A(UglNo, tizSTART+ k) = 1;
            A(UglNo, rizSTART+ j) = -1;
            A(UglNo, cross_HIJK5START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % % #10
            % 1/2 + rjz leq tkz + hijk6*c + hijor*c
                % umgestellt: rjz -tkz -c*hijk6 -c*hijor leq -1/2
            UglNo = UglNo+1;
            b(UglNo) = -0.5;
            A(UglNo, rizSTART+ j) = 1;
            A(UglNo, tizSTART+ k) = -1;
            A(UglNo, cross_HIJK6START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #11
            % 1/2 + riz leq rjz + hijk7*c + hijor*c
                % umgestellt: riz -rjz -c*hijk7 -c*hijor leq -1/2
            UglNo = UglNo+1;
            b(UglNo) = -0.5;
            A(UglNo, rizSTART+ i) = 1;
            A(UglNo, rizSTART+ j) = -1;
            A(UglNo, cross_HIJK7START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #12
            % 1/2 + rjz leq riz + hijk8*c + hijor*c
                % umgestellt: rjz -riz -c*hijk8 -c*hijor leq -1/2
            UglNo = UglNo+1;
            b(UglNo) = -0.5;
            A(UglNo, rizSTART+ j) = 1;
            A(UglNo, rizSTART+ i) = -1;
            A(UglNo, cross_HIJK8START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = -c;
            A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = -c;
            % #13
            % hijk1 + ... + hijk8 leq 7
            UglNo = UglNo+1;
            b(UglNo) = 7;
            A(UglNo, cross_HIJK1START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK2START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK3START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK4START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK5START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK6START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK7START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
            A(UglNo, cross_HIJK8START+ (i-1)*(m-1)*(m-2) + (jloop-1)*(m-2) + kloop) = 1;
        end
    end
end           

for i= 1:m
    for jloop = 1:m-1
        if (jloop<i)
            j= jloop;
        else
            j = jloop +1;
        end
        % eij leq (1-hijor)*c
            % umgestellt: eij + c*hijor leq c
        UglNo = UglNo+1;
        b(UglNo) = c;
        A(UglNo, eSTART+ (i-1)*(m) + j) = 1;
        A(UglNo, cross_HIJORSTART+ (i-1)*(m-1) + jloop) = c;
            % Bemerke: bei e ist es j, bei h jloop. Mit Absicht.
    end
end