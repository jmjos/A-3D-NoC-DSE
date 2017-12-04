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
addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio1271\cplex\matlab\x64_win64');
clear all
useCPLEX = true;
useSPARSE = true;
presetPositions = true;
x0given = false;
usePlotting = true;
saveSolution = false;
saveSolutionName = 'solution.mat';
OptimizationTime = 60;
options = cplexoptimset('Display', 'on', 'MaxTime', 150);


%m \geq n
m = 7;
n = 7;
l = 2;
eta = 1;
F = FV_CostMatrix(n,m,l,eta);
delta = 0.1;
phi = [0,0,0];
c = 1000;
xMax = 100;
yMax = 100;

% utilization u
% HINWEIS: Kanten zu sich selbst sind verboten.
uPre = ones(n,n)-diag(ones(n,1));
u = uPre(:);
%eA = ones(n^2,1)-diag(n^2,);
%eA(2) = 1;
%eA(3) = 1;
% eA(4) = 1;
% eA(8) = 1;
% %eA(2) = 1;
% eA(14) = 1;

% E_A
eA = (u~=0);


maxRoutersPerTile = m-n+1;
maxTSVsPerTile = m-n+1;

% optionale Eingaben:

% maximal Länge m! 
if (presetPositions)
    rix = [1 1 3 3 1 1 3];
    riy = [1 3 1 3 1 3 1];
    riz = [1 1 1 1 2 2 2];
    tix = [];
    tiy = [];
    tiz = [];
    ai = [];
    bi = [];
    eN = [];
else
    rix = [];
    riy = [];
    riz = [];
    tix = [];
    tiy = [];
    tiz = [];
    ai = [];
    bi = [];
    eN = [];
end
% % eN, i<j (j<i automatisch)
% eN = zeros(m^2,1);
% eN(2) = 1;
% eN(8) = 1;
% eN(20) = 1;

%% Variablen namen
run('scr_b_Variables_LENGTH.m')
run('scr_b_Variables_START.m') % enthält auch anzahlVar

% Anzahl der Gleichungen
run('scr_c_anzahlGl.m')

% Anzahl der Ungleichungen
run('scr_c_anzahlUgl.m')

%% generiere kostenfunktion (wir minimieren)
run('scr_f_costFunction.m')

%% generiere integer variablen
run('scr_g_integerBinaryContinuous.m')


%% trage richtige werte in A und b ein
tic
run('scr_i_initialisierungAAeqEtc.m')

% Testgleichungen
%--------------------------------------------------------------------------
run('scr_k_Test.m')

% technische Constraints: 
%--------------------------------------------------------------------------
run('scr_l_technischeConstraints.m')

% Tiles may not overlap constraints
%--------------------------------------------------------------------------
run('scr_m_tilesMayNotOverlap.m')

% area constraint per tile
%--------------------------------------------------------------------------
run('scr_n_AreaConstraintForTiles.m')

% aspect ratio einhalten
%--------------------------------------------------------------------------
run('scr_o_AspectRatioConstraint.m')

% grid based topology and TSVs between neighbored layers
%--------------------------------------------------------------------------
run('scr_p_GridBasedTopologyEtc.m')

% Modul 1 bis 4, forbid connections between non neighbored routers
%--------------------------------------------------------------------------
run('scr_q_ForbidConnectionsBetwEtc.m')

% Modul 5, forbid connections between non neighbored routers
%--------------------------------------------------------------------------
run('scr_r_ForbidCon_Module_five.m')

% eij is symmetrical
%--------------------------------------------------------------------------
run('scr_s_RoutersNotSelfConnected.m')

% flow inequations
%-------------------------------------------------------------------------
run('scr_t_FlowInequations.m')

% Links don't cross tiles
% -------------------------------------------------------------------------
run('scr_u_LinksDoNotCrossTiles.m')

% hiRouter, hiTSV berechnen
%-------------------------------------------------------------------------
run('scr_v_hirouterHitsvBerechnen.m')

% routers and tiles
% ------------------------------------------------------------------------
run('scr_w_routersAndTiles.m')

% cPeak
% ------------------------------------------------------------------------
run('scr_x_cPeak.m')

toc           
%% setting bounds
run('scr_y_settingBounds.m')

%% lin

if(~useCPLEX)
options = optimoptions('intlinprog','MaxTime',OptimizationTime);
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub, options);
else
    sostype = [];
    sosind = [];
    soswt = [];
    if(~x0given)
        x0 = [];
    end
    x = cplexmilp(f,A,b,Aeq,beq,sostype,sosind,soswt,lb,ub,ctype, x0, options);
end
if (saveSolution)
    save(saveSolutionName, 'x');
end
%solution = x(aiSTART + 1 : tizSTART + tizLENGTH)

%% plot
run('scr_z_plot.m')