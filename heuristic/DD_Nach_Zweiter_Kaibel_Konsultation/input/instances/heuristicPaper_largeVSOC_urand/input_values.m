% ! f3d-Area and KOZ-Area are zero to allow many 3D links !

%% All Values

% Größe des Eingabe-Bildes in Pixeln
picture_heightInPixels = 720;
picture_widthInPixels = 1280;

% Anzahl der Gesichter auf dem Bild
maximumNumberOfFaces = 6;

% Bildfrequenz in Hertz
framerateInHertz = 60;

% data size of one bayer-pattern-pixel in bit
% Datengröße eines bayer-Matrix-Pixels in bit
colordepthInBits = 8;

% Parameter für Ausführung von Viola Jones und Shi Tomasi
% Number of video frames between two runs of Viola Jones Algorithm etc.
framesBetweenTwoAlgorithmRuns = 30; 

% Komporimierungsfaktor  für Komprimierung durch SIMDs
compressionFactor = 4;

% AD-Wandler (default grid: 3x3)
ADGrid_height = 3;
ADGrid_width = 3;
ImplementationCosts_ADWandler = 1;
energyConsumption_ADWandler = 1;
performance_ADWandler = 1;

% Prozessoren (default grid: 3x2)
processorGrid_height = 3;
processorGrid_width = 2;
ImplementationCosts_processor = 1;
energyConsumption_processor = 1;
performance_processor = 1;

% SIMDs (default grid: 3x2)
simdGrid_height = processorGrid_height;
simdGrid_width = processorGrid_width;
ImplementationCosts_simd = 1;
energyConsumption_simd = 1;
performance_simd = 1;

% Viola Jones Units (default number: 3)
violaJonesUnitNumber = 3;
ImplementationCosts_violaJonesUnit = 1;
energyConsumption_violaJonesUnit = 1;
performance_violaJonesUnit = 1;

% Shi Tomasi Units (default number: 3)
shiTomasiUnitNumber = 3;
ImplementationCosts_shiTomasiUnit = 1;
energyConsumption_shiTomasiUnit = 1;
performance_shiTomasiUnit = 1;

% KLT Units (default number: 3x3)
kLTGrid_height = 3;
kLTGrid_width = 3;
ImplementationCosts_kLTUnit = 1;
energyConsumption_kLTUnit = 1;
performance_kLTUnit = 1;

% Answers to unclear questions (model assumptions)
% - Wie viele Pixel breit ist ein Gesicht maximal?
%       abhängig von Pixelbreite des Bildes und Anzahl der Gesichter auf
%       dem Bild
maximumFaceWidth = picture_widthInPixels / maximumNumberOfFaces;
% - ...
    
% weitere Parameter
n = ADGrid_height*ADGrid_width + ...
    processorGrid_height*processorGrid_width + ...
    + simdGrid_height*simdGrid_width ...
    + violaJonesUnitNumber ...
    + shiTomasiUnitNumber ...
    + kLTGrid_height*kLTGrid_width;
ell = 3;
fR2D = ones(1,ell);
fKOZ = 2;
energyR2D = 1*ones(1,ell);
%fR3Dratio = 1/2;
fSinglePort = fR2D / 5;
% propagation speed and frequency of routers
propagationSpeed = 5*ones(1,ell);
freq = ones(1,ell);

%% Pre-Calculations

% High value instead of Infinity
big = 100000; % Inf;

% numbering of the components
%    - Order: AD-Wandler, Prozessoren, ...
%    - Starting to count at 1
%    - number the grids in row-major order
ADLength = ADGrid_height*ADGrid_width;
ProceLength = processorGrid_height*processorGrid_width;
SimdLength = simdGrid_height*simdGrid_width;
ViolaJonesLength = violaJonesUnitNumber;
ShiTomasiLength = shiTomasiUnitNumber;
KLTLength = kLTGrid_height*kLTGrid_width;

ADStart = 0;
ProceStart = ADLength;
SimdStart = ProceStart + ProceLength;
ViolaJonesStart = SimdStart + SimdLength;
ShiTomasiStart = ViolaJonesStart + ViolaJonesLength;
KLTStart = ShiTomasiStart + ShiTomasiLength;

% Calculation of sections of AD-Grid and Processor-Grid
[AD_rows, AD_cols] = sectors(picture_heightInPixels, ...
    picture_widthInPixels, ADGrid_height, ADGrid_width  ,'AD-Wandler');
[Pro_rows_in, Pro_cols_in] = sectors(picture_heightInPixels, ...
    picture_widthInPixels, processorGrid_height, processorGrid_width, ...
    'Prozessoren');
[Pro_rows_out, Pro_cols_out] = sectors(picture_heightInPixels, ...
    picture_widthInPixels, processorGrid_height, processorGrid_width, ...
    'AD-Wandler');
[SIMD_rows_in, SIMD_cols_in] = sectors(picture_heightInPixels, ...
    picture_widthInPixels, simdGrid_height, simdGrid_width, 'AD-Wandler');
[SIMD_rows_out, SIMD_cols_out] = sectors(floor(picture_heightInPixels / ...
    compressionFactor), floor(picture_widthInPixels / compressionFactor ...
    ), simdGrid_height, simdGrid_width, 'AD-Wandler');
[VJU_rows_in, VJU_cols_in] = sectors(floor(picture_heightInPixels / ...
    compressionFactor), floor(picture_widthInPixels / compressionFactor ...
    ), 1, violaJonesUnitNumber, 'ViolaJones');
[STU_rows_in, STU_cols_in] = sectors(floor(picture_heightInPixels  ...
    ), floor(picture_widthInPixels ...
    ), 1, shiTomasiUnitNumber, 'AD-Wandler');
[KLT_rows_in, KLT_cols_in] = sectors(floor(picture_heightInPixels  ...
    ), floor(picture_widthInPixels ...
    ), kLTGrid_height, kLTGrid_width, 'AD-Wandler');

%% Cimpl, energy, performance

% general initialization
Cimpl = ones(n, ell);      
Energy = 10* ones(n,ell);
Performance = 10*ones(n,ell);

%   - Cimpl etc. for AD-Wandler
Cimpl( (ADStart + 1):(ADStart + ADLength) , 1) = ...
                                            ImplementationCosts_ADWandler;
Cimpl( (ADStart + 1):(ADStart + ADLength) , 2) = big;
Cimpl( (ADStart + 1):(ADStart + ADLength) , 3) = big;
Energy( (ADStart + 1):(ADStart + ADLength) , 1) = ...
                                            energyConsumption_ADWandler;
Energy( (ADStart + 1):(ADStart + ADLength) , 2) = big;
Energy( (ADStart + 1):(ADStart + ADLength) , 3) = big;
Performance( (ADStart + 1):(ADStart + ADLength) , 1) = ...
                                            performance_ADWandler;
Performance( (ADStart + 1):(ADStart + ADLength) , 2) = big;
Performance( (ADStart + 1):(ADStart + ADLength) , 3) = big;

%   - Cimpl etc. for Prozessoren
Cimpl( (ProceStart + 1):(ProceStart + ProceLength) , 2) = ...
                                            ImplementationCosts_processor;
Cimpl( (ProceStart + 1):(ProceStart + ProceLength) , 1) = big;
Cimpl( (ProceStart + 1):(ProceStart + ProceLength) , 3) = big;
Energy( (ProceStart + 1):(ProceStart + ProceLength) , 2) = ...
                                            energyConsumption_processor;
Energy( (ProceStart + 1):(ProceStart + ProceLength) , 1) = big;
Energy( (ProceStart + 1):(ProceStart + ProceLength) , 3) = big;
Performance( (ProceStart + 1):(ProceStart + ProceLength) , 2) = ...
                                            performance_processor;
Performance( (ProceStart + 1):(ProceStart + ProceLength) , 1) = big;
Performance( (ProceStart + 1):(ProceStart + ProceLength) , 3) = big;

%   - Cimpl etc. for SIMDs
Cimpl( (SimdStart + 1):(SimdStart + SimdLength) , 2) = ...
                                            ImplementationCosts_simd;
Cimpl( (SimdStart + 1):(SimdStart + SimdLength) , 1) = big;
Cimpl( (SimdStart + 1):(SimdStart + SimdLength) , 3) = big;
Energy( (SimdStart + 1):(SimdStart + SimdLength) , 2) = ...
                                            energyConsumption_simd;
Energy( (SimdStart + 1):(SimdStart + SimdLength) , 1) = big;
Energy( (SimdStart + 1):(SimdStart + SimdLength) , 3) = big;
Performance( (SimdStart + 1):(SimdStart + SimdLength) , 2) = ...
                                            performance_simd;
Performance( (SimdStart + 1):(SimdStart + SimdLength) , 1) = big;
Performance( (SimdStart + 1):(SimdStart + SimdLength) , 3) = big;

%   - Cimpl etc. for Viola Jones Units
Cimpl( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 1) = ...
                                            ImplementationCosts_violaJonesUnit;
Cimpl( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 2) = big;
Cimpl( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 3) = big;
Energy( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 1) = ...
                                            energyConsumption_violaJonesUnit;
Energy( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 2) = big;
Energy( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 3) = big;
Performance( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 1) = ...
                                            performance_violaJonesUnit;
Performance( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 2) = big;
Performance( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 3) = big;

%   - Cimpl etc. for Shi Tomasi Units
Cimpl( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 3) = ...
                                            ImplementationCosts_shiTomasiUnit;
Cimpl( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 1) = big;
Cimpl( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 2) = big;
Energy( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 1) = ...
                                            energyConsumption_shiTomasiUnit;
Energy( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 1) = big;
Energy( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 2) = big;
Performance( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 3) = ...
                                            performance_shiTomasiUnit;
Performance( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 1) = big;
Performance( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 2) = big;

%   - Cimpl etc. for KLT Units
Cimpl( (KLTStart + 1):(KLTStart + KLTLength) , 3) = ...
                                            ImplementationCosts_kLTUnit;
Cimpl( (KLTStart + 1):(KLTStart + KLTLength) , 1) = big;
Cimpl( (KLTStart + 1):(KLTStart + KLTLength) , 2) = big;
Energy( (KLTStart + 1):(KLTStart + KLTLength) , 3) = ...
                                            energyConsumption_kLTUnit;
Energy( (KLTStart + 1):(KLTStart + KLTLength) , 1) = big;
Energy( (KLTStart + 1):(KLTStart + KLTLength) , 2) = big;
Performance( (KLTStart + 1):(KLTStart + KLTLength) , 3) = ...
                                            performance_kLTUnit;
Performance( (KLTStart + 1):(KLTStart + KLTLength) , 1) = big;
Performance( (KLTStart + 1):(KLTStart + KLTLength) , 2) = big;

%% Application digraph

% urand (uniform random traffic) means: jeder mit jedem (fully connected) 
% and same edge weight on every edge.

u = 1000*(ones(n) - eye(n));
