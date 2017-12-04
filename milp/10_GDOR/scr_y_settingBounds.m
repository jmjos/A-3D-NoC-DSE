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

%set all lower bounds to zero
lb = zeros(1,anzahlVar);
lb(tizSTART + 1 : tizSTART + n) = 1;


%set the upper bounds
%initialize upper bounds as non-bound
ub = Inf * ones(1,anzahlVar);

ub(hcSTART + 1 : hcSTART + hcLENGTH) = Inf;
ub(aiSTART + 1 : aiSTART + aiLENGTH) = xMax;
ub(biSTART + 1 : biSTART + biLENGTH) = yMax;
ub(tixSTART + 1 : tixSTART + tixLENGTH) = xMax;
ub(tiySTART + 1 : tiySTART + tiyLENGTH) = yMax;
ub(tizSTART + 1 : tizSTART + tizLENGTH) = l;
ub(rixSTART + 1 : rixSTART + rixLENGTH) = xMax;
ub(riySTART + 1 : riySTART + riyLENGTH) = yMax;
ub(rizSTART + 1 : rizSTART + rizLENGTH) = l;
ub(tiles_HORISTART + 1 : tiles_HORISTART + tiles_HORILENGTH) = 1;
ub(tiles_HORIISTART + 1 : tiles_HORIISTART + tiles_HORIILENGTH) = 1; 
ub(tiles_HORIIISTART + 1 : tiles_HORIIISTART + tiles_HORIIILENGTH) = 1;
ub(tiles_HORIVSTART + 1 : tiles_HORIVSTART + tiles_HORIVLENGTH) = 1;
ub(tiles_HORVSTART + 1 : tiles_HORVSTART + tiles_HORVLENGTH) = 1;
ub(tiles_HORVISTART + 1 : tiles_HORVISTART + tiles_HORVILENGTH) = 1;
ub(tiles_HORVIISTART + 1 : tiles_HORVIISTART + tiles_HORVIILENGTH) = 1;
ub(tiles_HORVIIISTART + 1 : tiles_HORVIIISTART + tiles_HORVIIILENGTH) = 1;
ub(tiles_HAreaXiIAlphaBetaSTART + 1 : tiles_HAreaXiIAlphaBetaSTART + tiles_HAreaXiIAlphaBetaLENGTH) = 1;
ub(tiles_HAreaXiIAlphaBeta1START + 1 : tiles_HAreaXiIAlphaBeta1START + tiles_HAreaXiIAlphaBeta1LENGTH) = 1;
ub(tiles_HAreaXiIAlphaBeta2START + 1 : tiles_HAreaXiIAlphaBeta2START + tiles_HAreaXiIAlphaBeta2LENGTH) = 1;
ub(tiles_HAreaXiIAlphaBeta3START + 1 : tiles_HAreaXiIAlphaBeta3START + tiles_HAreaXiIAlphaBeta3LENGTH) = 1;
ub(tiles_HAreaXiIAlphaBeta4START + 1 : tiles_HAreaXiIAlphaBeta4START + tiles_HAreaXiIAlphaBeta4LENGTH) = 1;
ub(tiles_HAreaXiIAlphaBeta5START + 1 : tiles_HAreaXiIAlphaBeta5START + tiles_HAreaXiIAlphaBeta5LENGTH) = 1;
ub(tiles_HAreaXiIAlphaBeta6START + 1 : tiles_HAreaXiIAlphaBeta6START + tiles_HAreaXiIAlphaBeta6LENGTH) = 1;
ub(eSTART + 1 : eSTART + eLENGTH) = 1;
ub(flow_HISTART + 1 : flow_HISTART + flow_HILENGTH) = 1;
ub(flow_HORISTART + 1 : flow_HORISTART + flow_HORILENGTH) = 1;
ub(flow_HORIISTART + 1 : flow_HORIISTART + flow_HORIILENGTH) = 1;
ub(flow_HIJORSTART + 1 : flow_HIJORSTART + flow_HIJORLENGTH) = 1;
ub(flow_HIJK1START + 1 : flow_HIJK1START + flow_HIJK1LENGTH) = 1;
ub(flow_HIJKa1START + 1 : flow_HIJKa1START + flow_HIJKa1LENGTH) = 1;
ub(flow_HIJKa2START + 1 : flow_HIJKa2START + flow_HIJKa2LENGTH) = 1;
ub(flow_HIJKa3START + 1 : flow_HIJKa3START + flow_HIJKa3LENGTH) = 1;
ub(flow_HIJKa4START + 1 : flow_HIJKa4START + flow_HIJKa4LENGTH) = 1;
ub(flow_HIJK2START + 1 : flow_HIJK2START + flow_HIJK2LENGTH) = 1;
ub(flow_HIJKb1START + 1 : flow_HIJKb1START + flow_HIJKb1LENGTH) = 1;
ub(flow_HIJKb2START + 1 : flow_HIJKb2START + flow_HIJKb2LENGTH) = 1;
ub(flow_HIJKb3START + 1 : flow_HIJKb3START + flow_HIJKb3LENGTH) = 1;
ub(flow_HIJKb4START + 1 : flow_HIJKb4START + flow_HIJKb4LENGTH) = 1;
ub(flow_HIJK3START + 1 : flow_HIJK3START + flow_HIJK3LENGTH) = 1;
ub(flow_HIJKc1START + 1 : flow_HIJKc1START + flow_HIJKc1LENGTH) = 1;
ub(flow_HIJKc2START + 1 : flow_HIJKc2START + flow_HIJKc2LENGTH) = 1;
ub(flow_HIJKc3START + 1 : flow_HIJKc3START + flow_HIJKc3LENGTH) = 1;
ub(flow_HIJKc4START + 1 : flow_HIJKc4START + flow_HIJKc4LENGTH) = 1;
ub(flow_HIJK4START + 1 : flow_HIJK4START + flow_HIJK4LENGTH) = 1;
ub(flow_HIJKd1START + 1 : flow_HIJKd1START + flow_HIJKd1LENGTH) = 1;
ub(flow_HIJKd2START + 1 : flow_HIJKd2START + flow_HIJKd2LENGTH) = 1;
ub(flow_HIJKd3START + 1 : flow_HIJKd3START + flow_HIJKd3LENGTH) = 1;
ub(flow_HIJKd4START + 1 : flow_HIJKd4START + flow_HIJKd4LENGTH) = 1;
ub(flow_HIJ1START + 1 : flow_HIJ1START + flow_HIJ1LENGTH) = 1;
ub(flow_HIJ2START + 1 : flow_HIJ2START + flow_HIJ2LENGTH) = 1;
ub(flow_HIJ3START + 1 : flow_HIJ3START + flow_HIJ3LENGTH) = 1;
ub(fSTART + 1 : fSTART + fLENGTH) = 1;
ub(GammaSTART + 1 : GammaSTART + GammaLENGTH) = m;
ub(hSTART + 1 : hSTART + hLENGTH) = 1;
ub(tech_hISTART + 1 : tech_hISTART + tech_hILENGTH) = 1;
ub(cross_HIJK1START + 1 : cross_HIJK1START + cross_HIJK1LENGTH) = 1;
ub(cross_HIJK2START + 1 : cross_HIJK2START + cross_HIJK2LENGTH) = 1;
ub(cross_HIJK3START + 1 : cross_HIJK3START + cross_HIJK3LENGTH) = 1;
ub(cross_HIJK4START + 1 : cross_HIJK4START + cross_HIJK4LENGTH) = 1;
ub(cross_HIJK5START + 1 : cross_HIJK5START + cross_HIJK5LENGTH) = 1;
ub(cross_HIJK6START + 1 : cross_HIJK6START + cross_HIJK6LENGTH) = 1;
ub(cross_HIJK7START + 1 : cross_HIJK7START + cross_HIJK7LENGTH) = 1;
ub(cross_HIJK8START + 1 : cross_HIJK8START + cross_HIJK8LENGTH) = 1;
ub(cross_HIJORSTART + 1 : cross_HIJORSTART + cross_HIJORLENGTH) = 1;
ub(routsv_HIJSTART + 1 : routsv_HIJSTART + routsv_HIJLENGTH) = 1;
ub(routsv_HIJ1START + 1 : routsv_HIJ1START + routsv_HIJ1LENGTH) = 1;
ub(routsv_HIJ2START + 1 : routsv_HIJ2START + routsv_HIJ2LENGTH) = 1;
ub(routsv_HIJ3START + 1 : routsv_HIJ3START + routsv_HIJ3LENGTH) = 1;
ub(routsv_HIJ4START + 1 : routsv_HIJ4START + routsv_HIJ4LENGTH) = 1;
ub(routsv_HIJ5START + 1 : routsv_HIJ5START + routsv_HIJ5LENGTH) = 1;
ub(routsv_HIJ6START + 1 : routsv_HIJ6START + routsv_HIJ6LENGTH) = 1;
ub(routsv_hirouterSTART + 1 : routsv_hirouterSTART + routsv_hirouterLENGTH) = m;
ub(routsv_hatHJSTART + 1 : routsv_hatHJSTART + routsv_hatHJLENGTH) = 1;
ub(routsv_HJKORSTART + 1 : routsv_HJKORSTART + routsv_HJKORLENGTH) = 1;
ub(routsv_tildeHJKSTART + 1 : routsv_tildeHJKSTART + routsv_tildeHJKLENGTH) = 1;
ub(routsv_tildeHJKORSTART + 1 : routsv_tildeHJKORSTART + routsv_tildeHJKORLENGTH) = 1;
ub(routsv_hatHIJSTART + 1 : routsv_hatHIJSTART + routsv_hatHIJLENGTH) = 1;
ub(routsv_hiTSVSTART + 1 : routsv_hiTSVSTART + routsv_hiTSVLENGTH) = Inf;
ub(cPeakSTART + 1 : cPeakSTART + cPeakLENGTH) = Inf;
ub(cPeak_loadSTART + 1 : cPeak_loadSTART + cPeak_loadLENGTH) = Inf;
ub(cPeak_muSTART + 1 : cPeak_muSTART + cPeak_muLENGTH) = Inf;
ub(cPeak_hmaxSTART + 1 : cPeak_hmaxSTART + cPeak_hmaxLENGTH) = Inf;
ub(gdor_hijupSTART + 1 : gdor_hijupSTART + gdor_hijupLENGTH) = 1;
ub(gdor_hijDxiSTART + 1 : gdor_hijDxiSTART + gdor_hijDxiLENGTH) = 1;
ub(gdor_hijxiOR1START + 1 : gdor_hijxiOR1START + gdor_hijxiOR1LENGTH) = 1;
ub(gdor_hijxiOR2START + 1 : gdor_hijxiOR2START + gdor_hijxiOR2LENGTH) = 1;
ub(gdor_dijxixSTART + 1 : gdor_dijxixSTART + gdor_dijxixLENGTH) = xMax;
ub(gdor_dijxiySTART + 1 : gdor_dijxiySTART + gdor_dijxiyLENGTH) = yMax;
ub(gdor_dijxizSTART + 1 : gdor_dijxizSTART + gdor_dijxizLENGTH) = l;
ub(gdor_sijxixSTART + 1 : gdor_sijxixSTART + gdor_sijxixLENGTH) = xMax;
ub(gdor_sijxiySTART + 1 : gdor_sijxiySTART + gdor_sijxiyLENGTH) = yMax;
ub(gdor_sijxizSTART + 1 : gdor_sijxizSTART + gdor_sijxizLENGTH) = l;
ub(gdor_hatHKplusSTART + 1 : gdor_hatHKplusSTART + gdor_hatHKplusLENGTH) = 1;
ub(gdor_hatHKminusSTART + 1 : gdor_hatHKminusSTART + gdor_hatHKminusLENGTH) = 1;
ub(gdor_hkjplusORSTART + 1 : gdor_hkjplusORSTART + gdor_hkjplusORLENGTH) = 1;
ub(gdor_hkjminusORSTART + 1 : gdor_hkjminusORSTART + gdor_hkjminusORLENGTH) = 1;
ub(gdor_hkj1plusSTART + 1 : gdor_hkj1plusSTART + gdor_hkj1plusLENGTH) = 1;
ub(gdor_hkj2plusSTART + 1 : gdor_hkj2plusSTART + gdor_hkj2plusLENGTH) = 1;
ub(gdor_hkj1minusSTART + 1 : gdor_hkj1minusSTART + gdor_hkj1minusLENGTH) = 1;
ub(gdor_hkj2minusSTART + 1 : gdor_hkj2minusSTART + gdor_hkj2minusLENGTH) = 1;
ub(gdor_hijkxi1START + 1 : gdor_hijkxi1START + gdor_hijkxi1LENGTH) = 1;
ub(gdor_hijkxi2START + 1 : gdor_hijkxi2START + gdor_hijkxi2LENGTH) = 1;
ub(gdor_hijkxi3START + 1 : gdor_hijkxi3START + gdor_hijkxi3LENGTH) = 1;
ub(gdor_hijkxi4START + 1 : gdor_hijkxi4START + gdor_hijkxi4LENGTH) = 1;
ub(gdor_hijkxi5START + 1 : gdor_hijkxi5START + gdor_hijkxi5LENGTH) = 1;
ub(gdor_hijkxi6START + 1 : gdor_hijkxi6START + gdor_hijkxi6LENGTH) = 1;
ub(gdor_distrxSTART + 1 : gdor_distrxSTART + gdor_distrxLENGTH) = Inf;
ub(gdor_distrySTART + 1 : gdor_distrySTART + gdor_distryLENGTH) = Inf;
ub(gdor_distdxSTART + 1 : gdor_distdxSTART + gdor_distdxLENGTH) = Inf;
ub(gdor_distdySTART + 1 : gdor_distdySTART + gdor_distdyLENGTH) = Inf;
ub(gdor_haleqbSTART + 1 : gdor_haleqbSTART + gdor_haleqbLENGTH) = 1;
ub(gdor_hiotaxiOR1START + 1 : gdor_hiotaxiOR1START + gdor_hiotaxiOR1LENGTH) = 1;
ub(gdor_hiotaxi1START + 1 : gdor_hiotaxi1START + gdor_hiotaxi1LENGTH) = 1;
ub(gdor_hijiotaxi2START + 1 : gdor_hijiotaxi2START + gdor_hijiotaxi2LENGTH) = 1;
ub(gdor_hijklORSTART + 1 : gdor_hijklORSTART + gdor_hijklORLENGTH) = 1;
ub(gdor_hijklSTART + 1 : gdor_hijklSTART + gdor_hijklLENGTH) = 1;
ub(gdor_hijklxi1START + 1 : gdor_hijklxi1START + gdor_hijklxi1LENGTH) = 1;
ub(gdor_hijklxi2START + 1 : gdor_hijklxi2START + gdor_hijklxi2LENGTH) = 1;
ub(gdor_hijklxi3START + 1 : gdor_hijklxi3START + gdor_hijklxi3LENGTH) = 1;
ub(gdor_hijklxi4START + 1 : gdor_hijklxi4START + gdor_hijklxi4LENGTH) = 1;
ub(gdor_hijklxi5START + 1 : gdor_hijklxi5START + gdor_hijklxi5LENGTH) = 1;
ub(gdor_hijklxi6START + 1 : gdor_hijklxi6START + gdor_hijklxi6LENGTH) = 1;
ub(gdor_hijklxi7START + 1 : gdor_hijklxi7START + gdor_hijklxi7LENGTH) = 1;
ub(gdor_hijklxi8START + 1 : gdor_hijklxi8START + gdor_hijklxi8LENGTH) = 1;
ub(gdor_hijklxi9START + 1 : gdor_hijklxi9START + gdor_hijklxi9LENGTH) = 1;
ub(gdor_hijklxi10START + 1 : gdor_hijklxi10START + gdor_hijklxi10LENGTH) = 1;
ub(gdor_hijklxi11START + 1 : gdor_hijklxi11START + gdor_hijklxi11LENGTH) = 1;
ub(gdor_hijklxi12START + 1 : gdor_hijklxi12START + gdor_hijklxi12LENGTH) = 1;
ub(gdor_hijklxi19START + 1 : gdor_hijklxi19START + gdor_hijklxi19LENGTH) = 1;
ub(gdor_hijklxi20START + 1 : gdor_hijklxi20START + gdor_hijklxi20LENGTH) = 1;
ub(gdor_hijklxi23START + 1 : gdor_hijklxi23START + gdor_hijklxi23LENGTH) = 1;
ub(gdor_hijklxi24START + 1 : gdor_hijklxi24START + gdor_hijklxi24LENGTH) = 1;
ub(gdor_hijklxi25START + 1 : gdor_hijklxi25START + gdor_hijklxi25LENGTH) = 1;
ub(gdor_hijklxi26START + 1 : gdor_hijklxi26START + gdor_hijklxi26LENGTH) = 1;
ub(gdor_hijxi1START + 1 : gdor_hijxi1START + gdor_hijxi1LENGTH) = 1;
ub(gdor_hijxi2START + 1 : gdor_hijxi2START + gdor_hijxi2LENGTH) = 1;
ub(gdor_hijxi3START + 1 : gdor_hijxi3START + gdor_hijxi3LENGTH) = 1;
ub(gdor_hijxi4START + 1 : gdor_hijxi4START + gdor_hijxi4LENGTH) = 1;
ub(gdor_hijxi5START + 1 : gdor_hijxi5START + gdor_hijxi5LENGTH) = 1;
ub(gdor_hijxi6START + 1 : gdor_hijxi6START + gdor_hijxi6LENGTH) = 1;
ub(rhdl_hijneq1START + 1 : rhdl_hijneq1START + rhdl_hijneq1LENGTH) = 1;
ub(rhdl_hijneq2START + 1 : rhdl_hijneq2START + rhdl_hijneq2LENGTH) = 1;
ub(rhdl_hijneq3START + 1 : rhdl_hijneq3START + rhdl_hijneq3LENGTH) = 1;
ub(rhdl_hijneq4START + 1 : rhdl_hijneq4START + rhdl_hijneq4LENGTH) = 1;
ub(rhdl_hijneq5START + 1 : rhdl_hijneq5START + rhdl_hijneq5LENGTH) = 1;
ub(rhdl_hijneq6START + 1 : rhdl_hijneq6START + rhdl_hijneq6LENGTH) = 1;
ub(rhdl_hijphiSTART + 1 : rhdl_hijphiSTART + rhdl_hijphiLENGTH) = 1;
