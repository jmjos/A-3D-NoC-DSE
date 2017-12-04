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

% nicht integer sind: tix, tiy, rix, riy, ai, bi, hc

if (~useCPLEX)
intcon = [tizSTART + 1 : tizSTART + tizLENGTH, ...
    rizSTART + 1: rizSTART + rizLENGTH, ...
    tiles_HORISTART + 1 : tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH, ...
    eSTART + 1 : fSTART, ...
    GammaSTART + 1 : GammaSTART + GammaLENGTH,...
    hSTART + 1 : hSTART + hLENGTH,...
    tech_hISTART+1 : tech_hISTART + tech_hILENGTH, ...
    cross_HIJK1START+1: cross_HIJORSTART+ cross_HIJORLENGTH, ...
    routsv_HIJSTART+1: routsv_hirouterSTART + routsv_hirouterLENGTH, ...
    routsv_hatHJSTART+1: routsv_tildeHJKORSTART + routsv_tildeHJKORLENGTH, ...
    routsv_hatHIJSTART+1 :  routsv_hatHIJSTART + routsv_hatHIJLENGTH, ... 
    routsv_hiTSVSTART+1 : routsv_hiTSVSTART+routsv_hiTSVLENGTH, ...
    gdor_hijupSTART + 1 : gdor_hijxiOR2START + gdor_hijxiOR2LENGTH, ...
    gdor_dijxizSTART + 1 : gdor_dijxizSTART + gdor_dijxizLENGTH, ...
    gdor_sijxizSTART + 1 : gdor_sijxizSTART + gdor_sijxizLENGTH, ...
    gdor_hatHKplusSTART + 1 : gdor_hijkxi6START + gdor_hijkxi6LENGTH, ...
    gdor_haleqbSTART + 1 : gdor_hijxi6START + gdor_hijxi6LENGTH,...
    rhdl_hijneq1START + 1 : rhdl_hijphiSTART + rhdl_hijphiLENGTH];
else
    ctype = blanks(anzahlVar);
    % by default: all continuous
    ctype(:) = 'C';
    %integer variables
    ctype(tizSTART + 1 : tizSTART + tizLENGTH) = 'I';
    ctype(rizSTART + 1: rizSTART + rizLENGTH) = 'I';
    ctype(GammaSTART + 1 : GammaSTART + GammaLENGTH) = 'I';
    %binary variables
    ctype(tiles_HORISTART + 1 : tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH)='B';
    ctype(eSTART + 1 : fSTART)='B';
    ctype(hSTART + 1 : hSTART + hLENGTH)='B';
    ctype(tech_hISTART+1 : tech_hISTART + tech_hILENGTH)='B';
    ctype(cross_HIJK1START+1: cross_HIJORSTART+ cross_HIJORLENGTH)='B';
    ctype(routsv_HIJSTART+1: routsv_HIJ6START + routsv_HIJ6LENGTH)='B';
    ctype(routsv_hirouterSTART+1: routsv_hirouterSTART + routsv_hirouterLENGTH)='I';
    ctype(routsv_hatHJSTART+1: routsv_tildeHJKORSTART + routsv_tildeHJKORLENGTH)='B';
    ctype(routsv_hatHIJSTART+1 :  routsv_hatHIJSTART + routsv_hatHIJLENGTH) = 'B';
    ctype(routsv_hiTSVSTART+1 : routsv_hiTSVSTART+routsv_hiTSVLENGTH) = 'I';
    ctype(gdor_hijupSTART + 1 : gdor_hijxiOR2START + gdor_hijxiOR2LENGTH) = 'B';
    ctype(gdor_dijxixSTART + 1 : gdor_dijxiySTART + gdor_dijxiyLENGTH) = 'C';
    ctype(gdor_dijxizSTART + 1 : gdor_dijxizSTART + gdor_dijxizLENGTH) = 'I';
    ctype(gdor_sijxixSTART + 1 : gdor_sijxiySTART + gdor_sijxiyLENGTH) = 'C';
    ctype(gdor_sijxizSTART + 1 : gdor_sijxizSTART + gdor_sijxizLENGTH) = 'I';
    ctype(gdor_hatHKplusSTART + 1 : gdor_hijkxi6START + gdor_hijkxi6LENGTH) = 'B';
    ctype(gdor_distrxSTART + 1 : gdor_distdySTART + gdor_distdyLENGTH) = 'C';
    ctype(gdor_haleqbSTART + 1 : gdor_hijxi6START + gdor_hijxi6LENGTH) = 'B';
    ctype(rhdl_hijneq1START + 1 : rhdl_hijphiSTART + rhdl_hijphiLENGTH) = 'B';
end