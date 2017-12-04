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

function [ F ] = FV_CostMatrix( n,m,l,eta )
%COSTMATRIX Summary of this function goes here
%   Detailed explanation goes here

%n = 3;
%m = 5;
%l = 2;
maxRoutersPerTile = m-n+1;
maxTSVsPerTile = m-n+1;
%eta = 2;
fKOZ = 10;
fR2D = zeros(l);
fR2D = floor(10*rand(l,1))+1;
ImplementationCosts = zeros(n,l);
ImplementationCosts = floor(10*rand(n,l))+1;


%% init F
F = zeros(maxRoutersPerTile+1, maxTSVsPerTile+1,l,m);

for i = 1:m
    for xi = 1:l
        for beta = 1:maxTSVsPerTile+1
            for alpha = 1:maxRoutersPerTile+1
                if(i>n)
                    % ohne impl costs
                    F(alpha, beta, xi, i) = (alpha-1) * fR2D(xi) + fKOZ * (beta-1);
                else
                    % mit impl costs
                    F(alpha, beta, xi, i) = ImplementationCosts(i,xi) + (alpha-1) * fR2D(xi) + fKOZ * (beta-1);
                end
                
            end
        end
    end
end
F = sqrt(1/eta) * sqrt(eta) * sqrt(F);

end

