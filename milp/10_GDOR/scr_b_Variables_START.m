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

% varSTART  tiles: start indexes
hcSTART = 0;
aiSTART = hcSTART + hcLENGTH;
biSTART = aiSTART + aiLENGTH;
tixSTART = biSTART + biLENGTH;
tiySTART = tixSTART + tixLENGTH;
tizSTART = tiySTART + tiyLENGTH;
rixSTART = tizSTART + tizLENGTH;
riySTART = rixSTART + rixLENGTH;
rizSTART = riySTART + riyLENGTH;
tiles_HORISTART = rizSTART + rizLENGTH;
tiles_HORIISTART = tiles_HORISTART + tiles_HORILENGTH;
tiles_HORIIISTART = tiles_HORIISTART + tiles_HORIILENGTH;
tiles_HORIVSTART = tiles_HORIIISTART + tiles_HORIIILENGTH;
tiles_HORVSTART = tiles_HORIVSTART + tiles_HORIVLENGTH;
tiles_HORVISTART = tiles_HORVSTART + tiles_HORVLENGTH;
tiles_HORVIISTART = tiles_HORVISTART + tiles_HORVILENGTH;
tiles_HORVIIISTART = tiles_HORVIISTART + tiles_HORVIILENGTH;
tiles_HAreaXiIAlphaBetaSTART = tiles_HORVIIISTART + tiles_HORVIIILENGTH;
tiles_HAreaXiIAlphaBeta1START = tiles_HAreaXiIAlphaBetaSTART + tiles_HAreaXiIAlphaBetaLENGTH;
tiles_HAreaXiIAlphaBeta2START = tiles_HAreaXiIAlphaBeta1START + tiles_HAreaXiIAlphaBeta1LENGTH;
tiles_HAreaXiIAlphaBeta3START = tiles_HAreaXiIAlphaBeta2START + tiles_HAreaXiIAlphaBeta2LENGTH;
tiles_HAreaXiIAlphaBeta4START = tiles_HAreaXiIAlphaBeta3START + tiles_HAreaXiIAlphaBeta3LENGTH;
tiles_HAreaXiIAlphaBeta5START = tiles_HAreaXiIAlphaBeta4START + tiles_HAreaXiIAlphaBeta4LENGTH;
tiles_HAreaXiIAlphaBeta6START = tiles_HAreaXiIAlphaBeta5START + tiles_HAreaXiIAlphaBeta5LENGTH;
% varSTART fluss: start indexes:
eSTART = tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH;
flow_HISTART = eSTART + eLENGTH;
flow_HORISTART = flow_HISTART + flow_HILENGTH;
flow_HORIISTART = flow_HORISTART + flow_HORILENGTH;
flow_HIJORSTART = flow_HORIISTART + flow_HORIILENGTH;
flow_HIJK1START = flow_HIJORSTART + flow_HIJORLENGTH; 
flow_HIJKa1START = flow_HIJK1START + flow_HIJK1LENGTH;
flow_HIJKa2START = flow_HIJKa1START + flow_HIJKa1LENGTH;
flow_HIJKa3START = flow_HIJKa2START + flow_HIJKa2LENGTH;
flow_HIJKa4START = flow_HIJKa3START + flow_HIJKa3LENGTH;
flow_HIJK2START = flow_HIJKa4START + flow_HIJKa4LENGTH;  
flow_HIJKb1START = flow_HIJK2START + flow_HIJK2LENGTH;
flow_HIJKb2START = flow_HIJKb1START + flow_HIJKb1LENGTH;
flow_HIJKb3START = flow_HIJKb2START + flow_HIJKb2LENGTH;
flow_HIJKb4START = flow_HIJKb3START + flow_HIJKb3LENGTH;
flow_HIJK3START = flow_HIJKb4START + flow_HIJKb4LENGTH;
flow_HIJKc1START = flow_HIJK3START + flow_HIJK3LENGTH;
flow_HIJKc2START = flow_HIJKc1START + flow_HIJKc1LENGTH;
flow_HIJKc3START = flow_HIJKc2START + flow_HIJKc2LENGTH;
flow_HIJKc4START = flow_HIJKc3START + flow_HIJKc3LENGTH;
flow_HIJK4START = flow_HIJKc4START + flow_HIJKc4LENGTH;
flow_HIJKd1START = flow_HIJK4START + flow_HIJK4LENGTH;
flow_HIJKd2START = flow_HIJKd1START + flow_HIJKd1LENGTH;
flow_HIJKd3START = flow_HIJKd2START + flow_HIJKd2LENGTH;
flow_HIJKd4START = flow_HIJKd3START + flow_HIJKd3LENGTH;
flow_HIJ1START = flow_HIJKd4START + flow_HIJKd4LENGTH;
flow_HIJ2START = flow_HIJ1START + flow_HIJ1LENGTH;
flow_HIJ3START = flow_HIJ2START + flow_HIJ2LENGTH;
% varSTART flow
fSTART = flow_HIJ3START + flow_HIJ3LENGTH;
GammaSTART = fSTART + fLENGTH;
hSTART = GammaSTART + GammaLENGTH;
% varSTART technical constraint
tech_hISTART = hSTART + hLENGTH;
cross_HIJK1START = tech_hISTART + tech_hILENGTH;
cross_HIJK2START = cross_HIJK1START + cross_HIJK1LENGTH;
cross_HIJK3START = cross_HIJK2START + cross_HIJK2LENGTH;
cross_HIJK4START = cross_HIJK3START + cross_HIJK3LENGTH;
cross_HIJK5START = cross_HIJK4START + cross_HIJK4LENGTH;
cross_HIJK6START = cross_HIJK5START + cross_HIJK5LENGTH;
cross_HIJK7START = cross_HIJK6START + cross_HIJK6LENGTH;
cross_HIJK8START = cross_HIJK7START + cross_HIJK7LENGTH;
cross_HIJORSTART = cross_HIJK8START + cross_HIJK8LENGTH;
% varSTART router_tsv
routsv_HIJSTART = cross_HIJORSTART + cross_HIJORLENGTH;
routsv_HIJ1START = routsv_HIJSTART + routsv_HIJLENGTH;
routsv_HIJ2START = routsv_HIJ1START + routsv_HIJ1LENGTH;
routsv_HIJ3START = routsv_HIJ2START + routsv_HIJ2LENGTH;
routsv_HIJ4START = routsv_HIJ3START + routsv_HIJ3LENGTH;
routsv_HIJ5START = routsv_HIJ4START + routsv_HIJ4LENGTH;
routsv_HIJ6START = routsv_HIJ5START + routsv_HIJ5LENGTH;
routsv_hirouterSTART = routsv_HIJ6START + routsv_HIJ6LENGTH;
routsv_hatHJSTART = routsv_hirouterSTART + routsv_hirouterLENGTH;
routsv_HJKORSTART = routsv_hatHJSTART + routsv_hatHJLENGTH;
routsv_tildeHJKSTART = routsv_HJKORSTART + routsv_HJKORLENGTH;
routsv_tildeHJKORSTART = routsv_tildeHJKSTART + routsv_tildeHJKLENGTH;
routsv_hatHIJSTART = routsv_tildeHJKORSTART + routsv_tildeHJKORLENGTH;
routsv_hiTSVSTART = routsv_hatHIJSTART + routsv_hatHIJLENGTH;
cPeakSTART = routsv_hiTSVSTART + routsv_hiTSVLENGTH;
cPeak_loadSTART = cPeakSTART + cPeakLENGTH;
cPeak_muSTART = cPeak_loadSTART + cPeak_loadLENGTH;
cPeak_hmaxSTART = cPeak_muSTART + cPeak_muLENGTH;
% varSTART GDOR
gdor_hijupSTART = cPeak_hmaxSTART + cPeak_hmaxLENGTH;
gdor_hijDxiSTART = gdor_hijupSTART + gdor_hijupLENGTH;
gdor_hijxiOR1START = gdor_hijDxiSTART + gdor_hijDxiLENGTH;
gdor_hijxiOR2START = gdor_hijxiOR1START + gdor_hijxiOR1LENGTH;
gdor_dijxixSTART = gdor_hijxiOR2START + gdor_hijxiOR2LENGTH;
gdor_dijxiySTART = gdor_dijxixSTART + gdor_dijxixLENGTH;
gdor_dijxizSTART = gdor_dijxiySTART + gdor_dijxiyLENGTH;
gdor_sijxixSTART = gdor_dijxizSTART + gdor_dijxizLENGTH;
gdor_sijxiySTART = gdor_sijxixSTART + gdor_sijxixLENGTH;
gdor_sijxizSTART = gdor_sijxiySTART + gdor_sijxiyLENGTH;
gdor_hatHKplusSTART = gdor_sijxizSTART + gdor_sijxizLENGTH;
gdor_hatHKminusSTART = gdor_hatHKplusSTART + gdor_hatHKplusLENGTH;
gdor_hkjplusORSTART = gdor_hatHKminusSTART + gdor_hatHKminusLENGTH;
gdor_hkjminusORSTART = gdor_hkjplusORSTART + gdor_hkjplusORLENGTH;
gdor_hkj1plusSTART = gdor_hkjminusORSTART + gdor_hkjminusORLENGTH;
gdor_hkj2plusSTART = gdor_hkj1plusSTART + gdor_hkj1plusLENGTH;
gdor_hkj1minusSTART = gdor_hkj2plusSTART + gdor_hkj2plusLENGTH;
gdor_hkj2minusSTART = gdor_hkj1minusSTART + gdor_hkj1minusLENGTH;
gdor_hijkxi1START = gdor_hkj2minusSTART + gdor_hkj2minusLENGTH;
gdor_hijkxi2START = gdor_hijkxi1START + gdor_hijkxi1LENGTH;
gdor_hijkxi3START = gdor_hijkxi2START + gdor_hijkxi2LENGTH;
gdor_hijkxi4START = gdor_hijkxi3START + gdor_hijkxi3LENGTH;
gdor_hijkxi5START = gdor_hijkxi4START + gdor_hijkxi4LENGTH;
gdor_hijkxi6START = gdor_hijkxi5START + gdor_hijkxi5LENGTH;
gdor_distrxSTART = gdor_hijkxi6START + gdor_hijkxi6LENGTH;
gdor_distrySTART = gdor_distrxSTART + gdor_distrxLENGTH;
gdor_distdxSTART = gdor_distrySTART + gdor_distryLENGTH;
gdor_distdySTART = gdor_distdxSTART + gdor_distdxLENGTH;
gdor_haleqbSTART = gdor_distdySTART + gdor_distdyLENGTH;
gdor_hiotaxiOR1START = gdor_haleqbSTART + gdor_haleqbLENGTH; % Name nochmal ändern?
gdor_hiotaxi1START = gdor_hiotaxiOR1START + gdor_hiotaxiOR1LENGTH;   % same
gdor_hijiotaxi2START = gdor_hiotaxi1START + gdor_hiotaxi1LENGTH; % was ist mit OR2? Sind die Namen noch nicht vergeben?
gdor_hijklORSTART = gdor_hijiotaxi2START + gdor_hijiotaxi2LENGTH;
gdor_hijklSTART = gdor_hijklORSTART + gdor_hijklORLENGTH;
gdor_hijklxi1START = gdor_hijklSTART + gdor_hijklLENGTH;
gdor_hijklxi2START = gdor_hijklxi1START + gdor_hijklxi1LENGTH;
gdor_hijklxi3START = gdor_hijklxi2START + gdor_hijklxi2LENGTH;
gdor_hijklxi4START = gdor_hijklxi3START + gdor_hijklxi3LENGTH;
gdor_hijklxi5START = gdor_hijklxi4START + gdor_hijklxi4LENGTH;
gdor_hijklxi6START = gdor_hijklxi5START + gdor_hijklxi5LENGTH;
gdor_hijklxi7START = gdor_hijklxi6START + gdor_hijklxi6LENGTH;
gdor_hijklxi8START = gdor_hijklxi7START + gdor_hijklxi7LENGTH;
gdor_hijklxi9START = gdor_hijklxi8START + gdor_hijklxi8LENGTH;
gdor_hijklxi10START = gdor_hijklxi9START + gdor_hijklxi9LENGTH;
gdor_hijklxi11START = gdor_hijklxi10START + gdor_hijklxi10LENGTH;
gdor_hijklxi12START = gdor_hijklxi11START + gdor_hijklxi11LENGTH; % Variablennamen werden ab  hier bestimmt nochmal anders.
gdor_hijklxi19START = gdor_hijklxi12START + gdor_hijklxi12LENGTH;
gdor_hijklxi20START = gdor_hijklxi19START + gdor_hijklxi19LENGTH;
gdor_hijklxi23START = gdor_hijklxi20START + gdor_hijklxi20LENGTH;
gdor_hijklxi24START = gdor_hijklxi23START + gdor_hijklxi23LENGTH;
gdor_hijklxi25START = gdor_hijklxi24START + gdor_hijklxi24LENGTH;
gdor_hijklxi26START = gdor_hijklxi25START + gdor_hijklxi25LENGTH;
gdor_hijxi1START = gdor_hijklxi26START + gdor_hijklxi26LENGTH;
gdor_hijxi2START = gdor_hijxi1START + gdor_hijxi1LENGTH;
gdor_hijxi3START = gdor_hijxi2START + gdor_hijxi2LENGTH;
gdor_hijxi4START = gdor_hijxi3START + gdor_hijxi3LENGTH;
gdor_hijxi5START = gdor_hijxi4START + gdor_hijxi4LENGTH;
gdor_hijxi6START = gdor_hijxi5START + gdor_hijxi5LENGTH;
% routers have different locations
rhdl_hijneq1START = gdor_hijxi6START + gdor_hijxi6LENGTH;
rhdl_hijneq2START  = rhdl_hijneq1START + rhdl_hijneq1LENGTH;
rhdl_hijneq3START = rhdl_hijneq2START + rhdl_hijneq2LENGTH;
rhdl_hijneq4START = rhdl_hijneq3START + rhdl_hijneq3LENGTH;
rhdl_hijneq5START = rhdl_hijneq4START + rhdl_hijneq4LENGTH;
rhdl_hijneq6START = rhdl_hijneq5START + rhdl_hijneq5LENGTH;
rhdl_hijphiSTART = rhdl_hijneq6START + rhdl_hijneq6LENGTH;
% Anzahl der Variablen
anzahlVar = rhdl_hijphiSTART + rhdl_hijphiLENGTH;