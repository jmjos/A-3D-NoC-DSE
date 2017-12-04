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

% varLENGTH fuer die tiles und deren groesse:
hcLENGTH = 1;
aiLENGTH = m;
biLENGTH = m;
tixLENGTH = m;
tiyLENGTH = m;
tizLENGTH = m;
rixLENGTH = m;
riyLENGTH = m;
rizLENGTH = m;
tiles_HORILENGTH    = m^2 - m;
tiles_HORIILENGTH   = m^2 - m;
tiles_HORIIILENGTH  = m^2 - m;
tiles_HORIVLENGTH   = m^2 - m;
tiles_HORVLENGTH    = m^2 - m;
tiles_HORVILENGTH   = m^2 - m;
tiles_HORVIILENGTH  = m^2 - m;
tiles_HORVIIILENGTH = m^2 - m;
tiles_HAreaXiIAlphaBetaLENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta1LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta2LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta3LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta4LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta5LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;
tiles_HAreaXiIAlphaBeta6LENGTH = (maxRoutersPerTile+1) * (maxTSVsPerTile+1) * l * m;

% varLENGTH fuer den fluss:% network edges E_N
% network edges E_N
eLENGTH = m^2;
% varLENGTH grid based topology and TSCs connect to neighbored layers
flow_HILENGTH    = m^2;
flow_HORILENGTH   = m^2;
flow_HORIILENGTH  = m^2;
% varLENGTH forbid connections between non-neighbored routers
flow_HIJORLENGTH = m*(m-1);
flow_HIJK1LENGTH = m*(m-1)*(m-2);
flow_HIJKa1LENGTH = m*(m-1)*(m-2);
flow_HIJKa2LENGTH = m*(m-1)*(m-2);
flow_HIJKa3LENGTH = m*(m-1)*(m-2);
flow_HIJKa4LENGTH = m*(m-1)*(m-2);
flow_HIJK2LENGTH = m*(m-1)*(m-2);
flow_HIJKb1LENGTH = m*(m-1)*(m-2);
flow_HIJKb2LENGTH = m*(m-1)*(m-2);
flow_HIJKb3LENGTH = m*(m-1)*(m-2);
flow_HIJKb4LENGTH = m*(m-1)*(m-2);
flow_HIJK3LENGTH = m*(m-1)*(m-2);
flow_HIJKc1LENGTH = m*(m-1)*(m-2);
flow_HIJKc2LENGTH = m*(m-1)*(m-2);
flow_HIJKc3LENGTH = m*(m-1)*(m-2);
flow_HIJKc4LENGTH = m*(m-1)*(m-2);
flow_HIJK4LENGTH = m*(m-1)*(m-2);
flow_HIJKd1LENGTH = m*(m-1)*(m-2);
flow_HIJKd2LENGTH = m*(m-1)*(m-2);
flow_HIJKd3LENGTH = m*(m-1)*(m-2);
flow_HIJKd4LENGTH = m*(m-1)*(m-2);
flow_HIJ1LENGTH = m*(m-1);
flow_HIJ2LENGTH = m*(m-1);
flow_HIJ3LENGTH = m*(m-1);
% varLENGTH routers are not self-connected
% eij = eji
%flow
fLENGTH = m^2 * sum(eA);
GammaLENGTH = m*sum(eA);
hLENGTH = m^2 * sum(eA);
tech_hILENGTH = m;
% varLENGTH cross
cross_HIJK1LENGTH = m*(m-1)*(m-2);
cross_HIJK2LENGTH = m*(m-1)*(m-2);
cross_HIJK3LENGTH = m*(m-1)*(m-2);
cross_HIJK4LENGTH = m*(m-1)*(m-2);
cross_HIJK5LENGTH = m*(m-1)*(m-2);
cross_HIJK6LENGTH = m*(m-1)*(m-2);
cross_HIJK7LENGTH = m*(m-1)*(m-2);
cross_HIJK8LENGTH = m*(m-1)*(m-2);
cross_HIJORLENGTH = m*(m-1);
% varLENGTH router_tsv
routsv_HIJLENGTH = m*(m-n);
routsv_HIJ1LENGTH = m*(m-n);
routsv_HIJ2LENGTH = m*(m-n);
routsv_HIJ3LENGTH = m*(m-n);
routsv_HIJ4LENGTH = m*(m-n);
routsv_HIJ5LENGTH = m*(m-n);
routsv_HIJ6LENGTH = m*(m-n);
routsv_hirouterLENGTH = m;
routsv_hatHJLENGTH = m;
routsv_HJKORLENGTH = m*(m-1);
routsv_tildeHJKLENGTH = m*(m-1);
routsv_tildeHJKORLENGTH = m*(m-1);
routsv_hatHIJLENGTH = m*(m-n);
routsv_hiTSVLENGTH = m;
cPeakLENGTH = 1;
cPeak_loadLENGTH = m^2;
cPeak_muLENGTH = 1;
cPeak_hmaxLENGTH = m^2;
% varLENGTH GDOR
gdor_hijupLENGTH = sum(eA);
gdor_hijDxiLENGTH = sum(eA)*l;
gdor_hijxiOR1LENGTH = sum(eA)*l;
gdor_hijxiOR2LENGTH = sum(eA)*l;
gdor_dijxixLENGTH = sum(eA)*l;
gdor_dijxiyLENGTH = sum(eA)*l;
gdor_dijxizLENGTH = sum(eA)*l;
gdor_sijxixLENGTH = sum(eA)*l;
gdor_sijxiyLENGTH = sum(eA)*l;
gdor_sijxizLENGTH = sum(eA)*l;
gdor_hatHKplusLENGTH = m;
gdor_hatHKminusLENGTH = m;
gdor_hkjplusORLENGTH = m*(m-1);
gdor_hkjminusORLENGTH = m*(m-1);
gdor_hkj1plusLENGTH = m*(m-1);
gdor_hkj2plusLENGTH = m*(m-1);
gdor_hkj1minusLENGTH = m*(m-1);
gdor_hkj2minusLENGTH = m*(m-1);
gdor_hijkxi1LENGTH = sum(eA)*l*(m-1);
gdor_hijkxi2LENGTH = sum(eA)*l*(m-1);
gdor_hijkxi3LENGTH = sum(eA)*l*(m-1);
gdor_hijkxi4LENGTH = sum(eA)*l*(m-1);
gdor_hijkxi5LENGTH = sum(eA)*l*(m-1);
gdor_hijkxi6LENGTH = sum(eA)*l*(m-1);
gdor_distrxLENGTH = sum(eA)*(m-1)*l;
gdor_distryLENGTH = sum(eA)*(m-1)*l;
gdor_distdxLENGTH = sum(eA)*l;
gdor_distdyLENGTH = sum(eA)*l;
gdor_haleqbLENGTH = sum(eA)*l*(2*(m-1) + 2);
gdor_hiotaxiOR1LENGTH = m*l; % Name nochmal ändern?
gdor_hiotaxi1LENGTH = m*l;   % same
gdor_hijiotaxi2LENGTH = sum(eA)*(m-1)*l; % was ist mit OR2? Sind die Namen noch nicht vergeben?
gdor_hijklORLENGTH = sum(eA)*m*m;
gdor_hijklLENGTH = sum(eA)*m*m;
gdor_hijklxi1LENGTH = sum(eA)*m^2*l;
gdor_hijklxi2LENGTH = sum(eA)*m^2*l;
gdor_hijklxi3LENGTH = sum(eA)*m^2*l;
gdor_hijklxi4LENGTH = sum(eA)*m^2*l;
gdor_hijklxi5LENGTH = sum(eA)*m^2*l;
gdor_hijklxi6LENGTH = sum(eA)*m^2*l;
gdor_hijklxi7LENGTH = sum(eA)*m^2*l;
gdor_hijklxi8LENGTH = sum(eA)*m^2*l;
gdor_hijklxi9LENGTH = sum(eA)*m^2*l;
gdor_hijklxi10LENGTH = sum(eA)*m^2*l;
gdor_hijklxi11LENGTH = sum(eA)*m^2*l;
gdor_hijklxi12LENGTH = sum(eA)*m^2*l; % Variablennamen werden ab  hier bestimmt nochmal anders.
gdor_hijklxi19LENGTH = sum(eA)*m^2*l;
gdor_hijklxi20LENGTH = sum(eA)*m^2*l;
gdor_hijklxi23LENGTH = sum(eA)*m^2*l;
gdor_hijklxi24LENGTH = sum(eA)*m^2*l;
gdor_hijklxi25LENGTH = sum(eA)*m^2*l;
gdor_hijklxi26LENGTH = sum(eA)*m^2*l;
gdor_hijxi1LENGTH = sum(eA)*l;
gdor_hijxi2LENGTH = sum(eA)*l;
gdor_hijxi3LENGTH = sum(eA)*l;
gdor_hijxi4LENGTH = sum(eA)*l;
gdor_hijxi5LENGTH = sum(eA)*l;
gdor_hijxi6LENGTH = sum(eA)*l;
% routers have different locations auxiliary variables
rhdl_hijneq1LENGTH = m*(m-1);
rhdl_hijneq2LENGTH = m*(m-1);
rhdl_hijneq3LENGTH = m*(m-1);
rhdl_hijneq4LENGTH = m*(m-1);
rhdl_hijneq5LENGTH = m*(m-1);
rhdl_hijneq6LENGTH = m*(m-1);
rhdl_hijphiLENGTH = m*(m-1);