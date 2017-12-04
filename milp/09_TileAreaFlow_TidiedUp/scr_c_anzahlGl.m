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

anzahlGlRIXTIX = 3*n;
anzahlGlFlow = m^2 + 2*sum(eA) + sum(eA)*(m-2);
anzahlManuelleEingabe = length(tix) + length(tiy) + length(tiz) + ... 
    length(rix) + length(riy) + length(riz) + length(ai) + length(bi) ...
    + 2*(sqrt(length(eN))*(sqrt(length(eN))-1)/2 + sqrt(length(eN)));
anzahlTESTGLEICHUNGEN = 0; %TESTGLEICHUNGEN ANZAHL
anzahlGlHIROUTER = m;
anzahlGlHITSV = m;
anzahlGlEingabe_einlesen = 8*m + 2*(m*(m-1)/2 + m);
anzahlGlcPeak = m^2 + 2;
anzahlGl = anzahlGlRIXTIX+ anzahlGlFlow + anzahlTESTGLEICHUNGEN + ...
    anzahlGlEingabe_einlesen + anzahlGlHIROUTER + anzahlGlHITSV + ...
    + anzahlGlcPeak;