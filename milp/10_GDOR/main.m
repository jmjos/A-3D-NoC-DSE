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

% system configuration
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
if (useCPLEX)
  options = cplexoptimset('Display', 'on', 'MaxTime', OptimizationTime);
end

% inputs
m = 10; 		% maximum number of routers (in Z)
n = 6; 			% number of components (in Z) m \geq n
l = 3; 			% number of layers (in Z)
eta = 1; 		% aspect ratio of component areas (in (0,1])
delta = 0.1; 	% distance between components
phi = [0,0,0]; 	% unplaced component location
c = 1000;		% large constant (c_1, ...)
xMax = 100;		% maximum chip dimensions
yMax = 100;		% maximum chip dimensions
fKOZ = 1;		% KOZ size
fR2D = zeros(l);% router 2D consts
fR2D = ones(l,1);
ImplementationCosts = zeros(n,l); % implementation costs of components per layer
ImplementationCosts = ones(n,l);
F = FV_CostMatrix(n,m,l,eta,ImplementationCosts, fR2D, fKOZ );
PerformanceValues = ones(n,l); % performance of each component (maximize)
EnergyConsumption = ones(n,l); % energy consumption of components (minimize)

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

% optional inputs:

% preset positions of routers, their size etc.
if (presetPositions)
    rix = [1 ];
    riy = [1 ];
    riz = [1 ];
    tix = [];
    tiy = [];
    tiz = [];
    ai = [];
    bi = [];
    eN = [];
    if (length(rix) > m || length(rix) > m || length(rix) > m)
    	error('wrong dimension of preset values');
    end
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
run('scr_b_Variables_START.m') % enth�lt auch anzahlVar

% Anzahl der Gleichungen
run('scr_c_anzahlGl.m')

% Anzahl der Ungleichungen
run('scr_c_anzahlUgl.m')

%% generiere kostenfunktion (wir minimieren)
run('scr_f_costFunction.m')

%% generiere integer variablen
run('scr_g_integerBinaryContinuous.m')
disp('GHJK')

%% trage richtige werte in A und b ein
tic

anzahlUglSum = 0;

run('scr_i_initialisierungAAeqEtc.m')
disp(['UglNo nach Init.: ', num2str(UglNo)])
disp(['anzUgl: ', num2str(0)])

% Testgleichungen
%--------------------------------------------------------------------------
run('scr_k_Test.m')
disp(['UglNo nach Testgl: ', num2str(UglNo)])
disp(['anzUgl: ', num2str(0)])

% technische Constraints:
%--------------------------------------------------------------------------
run('scr_l_technischeConstraints.m')
disp(['UglNo nach technische Cons.: ', num2str(UglNo)])
anzahlUglSum = anzahlUglSum +anzahlUglTech;
disp(['anzUgl: ', num2str(anzahlUglSum)])

% Tiles may not overlap constraints
%--------------------------------------------------------------------------
run('scr_m_tilesMayNotOverlap.m')
disp(['UglNo nach maynoverlap: ', num2str(UglNo)])
anzahlUglSum = anzahlUglSum +anzahlUglTilesOverlap;
disp(['anzUgl: ', num2str(anzahlUglSum)])

% Routers have different locations
% -------------------------------------------------------------------------
run('scr_mm_routershavedifferentlocations.m')
disp(['UglNo nach routers differ loc: ', num2str(UglNo)])
anzahlUglSum = anzahlUglSum +anzahlUglRouDiff;
disp(['anzUgl: ', num2str(anzahlUglSum)])

% area constraint per tile
%--------------------------------------------------------------------------
run('scr_n_AreaConstraintForTiles.m')

% aspect ratio einhalten
%--------------------------------------------------------------------------
run('scr_o_AspectRatioConstraint.m')
disp(['UglNo nach Epsilon: ', num2str(UglNo)])
anzahlUglSum = anzahlUglSum +anzahlUglAreaTiles;
disp(['anzUgl: ', num2str(anzahlUglSum)])

% grid based topology and TSVs between neighbored layers
%--------------------------------------------------------------------------
run('scr_p_GridBasedTopologyEtc.m')
disp(['UglNo nach GBT: ', num2str(UglNo)])
anzahlUglSum = anzahlUglSum +anzahlUglGridBTop;
disp(['anzUgl: ', num2str(anzahlUglSum)])

% Modul 1 bis 4, forbid connections between non neighbored routers
%--------------------------------------------------------------------------
run('scr_q_ForbidConnectionsBetwEtc.m')

% Modul 5, forbid connections between non neighbored routers
%--------------------------------------------------------------------------
run('scr_r_ForbidCon_Module_five.m')
disp(['UglNo nach Forbid: ', num2str(UglNo)])
anzahlUglSum = anzahlUglSum +anzahlUglForbidCon;
disp(['anzUgl: ', num2str(anzahlUglSum)])

% eij is symmetrical
%--------------------------------------------------------------------------
run('scr_s_RoutersNotSelfConnected.m')
disp(['UglNo nach RouNot: ', num2str(UglNo)])
anzahlUglSum = anzahlUglSum +anzahlUglRouNotSelfCon;
disp(['anzUgl: ', num2str(anzahlUglSum)])

% flow inequations
%-------------------------------------------------------------------------
run('scr_t_FlowInequations.m')
disp(['UglNo nach Flow: ', num2str(UglNo)])
anzahlUglSum = anzahlUglSum +anzahlUglFlowetc;
disp(['anzUgl: ', num2str(anzahlUglSum)])

% Links don't cross tiles
% -------------------------------------------------------------------------
run('scr_u_LinksDoNotCrossTiles.m')
disp(['UglNo nach LossTiles: ', num2str(UglNo)])

% hiRouter, hiTSV berechnen
%-------------------------------------------------------------------------
run('scr_v_hirouterHitsvBerechnen.m')
disp(['UglNo nach hitsv: ', num2str(UglNo)])

% routers and tiles
% ------------------------------------------------------------------------
run('scr_w_routersAndTiles.m')
disp(['UglNo nach r&t: ', num2str(UglNo)])

% cPeak
% ------------------------------------------------------------------------
run('scr_x_cPeak.m')
disp(['UglNo nach peak: ', num2str(UglNo)])

% Gateway DOR
% ------------------------------------------------------------------------
run('GatewayDimensionOrderRouting.m')
disp(['UglNo nach allem: ', num2str(UglNo)])
disp(['anzahlUgl: ', num2str(anzahlUgl)])

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
