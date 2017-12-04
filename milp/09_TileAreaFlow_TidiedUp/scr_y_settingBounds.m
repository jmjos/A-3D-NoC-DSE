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


lb = zeros(1,anzahlVar);
ub = Inf * ones(1,anzahlVar);

%lower bound der tiz in denen komponenten sind
notBoundIndexes = tizSTART + 1 : tizSTART + n;
lb(notBoundIndexes) = 1 * ones(length(notBoundIndexes), 1);

%upper bound der ungebundenen varibalen
ub = ones(1,anzahlVar);
notBoundIndexes = hcSTART + 1 : rizSTART + rizLENGTH;
ub(notBoundIndexes) = Inf * ones(length(notBoundIndexes), 1);

%tiz und riz sind durch die anzahl der layer l gebunden
notBoundIndexes = tizSTART + 1 : tizSTART + tizLENGTH;
ub(notBoundIndexes) = l * ones(length(notBoundIndexes), 1);
notBoundIndexes = rizSTART + 1 : rizSTART + tizLENGTH;
ub(notBoundIndexes) = l * ones(length(notBoundIndexes), 1);

%alle hilfsvariablen sind durch 1 gebunden, da binaer
notBoundIndexes = tiles_HORISTART + 1 : tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH;
ub(notBoundIndexes) = 1 * ones(length(notBoundIndexes), 1);

%upper bound der integer binary hilfsvaribalen
boundIndexes = eSTART + 1 : anzahlVar;
ub(boundIndexes) = 1 * ones(length(boundIndexes), 1);

%nur die gamma sind nicht durch eins gebunden
boundIndexes = GammaSTART + 1 : GammaSTART + GammaLENGTH;
ub(boundIndexes) = m * ones(length(boundIndexes), 1);

% die hirouter sind auch nicht durch eins gebunden
boundIndexes = routsv_hirouterSTART + 1 : routsv_hirouterSTART + routsv_hirouterLENGTH;
ub(boundIndexes) = m * ones(length(boundIndexes), 1);

% die routsv_hiTSVSTART sind auch nicht durch eins gebunden
boundIndexes = routsv_hiTSVSTART+ 1 : routsv_hiTSVSTART + routsv_hiTSVLENGTH;
ub(boundIndexes) = Inf * ones(length(boundIndexes), 1);

% die cPeak-Variablen sind auch nicht durch eins gebunden
boundIndexes = cPeakSTART+ 1 : cPeak_hmaxSTART + cPeak_hmaxLENGTH;
ub(boundIndexes) = Inf * ones(length(boundIndexes), 1);
