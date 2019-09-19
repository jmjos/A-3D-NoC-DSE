% difference between _default and _default_new: the so called SIMDs have
% been cancelled. Instead, the VJUs combine what formerly SIMDs+VJUs have
% been doing.
% New area-values: 45nm, 28nm, 28nm according to smallVSOC table.
% Components are either CPU cores, ADCs or SIMDs in the sense of that
% table.

%% All Values

% High value instead of Infinity
big = 10000000; % Inf;

% values from smallVSOCArea table
AreaRouter28nm = 1800;
AreaRouter45nm = 3150;
AreaCPUcore28nm = 35807.4;
AreaCPUcore45nm = 62662.95;
AreaADC28nm = big;
AreaADC45nm = 53.4727;
AreaSIMD28nm = 71614.8;
AreaSIMD45nm = 125325.9;
Performance45nm = 1;
Performance28nm = sqrt(1.75)* Performance45nm;
Energy45nm = 1;
Energy28nm = (1/sqrt(1.75))* Energy45nm;

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
ImplementationCosts_ADWandler_45nm = AreaADC45nm;
ImplementationCosts_ADWandler_28nm = AreaADC28nm;
energyConsumption_ADWandler_45nm = Energy45nm;
energyConsumption_ADWandler_28nm = Energy28nm;
performance_ADWandler_45nm = Performance45nm;
performance_ADWandler_28nm = Performance28nm;

% Prozessoren (default grid: 3x2)
processorGrid_height = 3;
processorGrid_width = 2;
ImplementationCosts_processor_45nm = AreaCPUcore45nm;
ImplementationCosts_processor_28nm = AreaCPUcore28nm;
energyConsumption_processor_45nm = Energy45nm;
energyConsumption_processor_28nm = Energy28nm;
performance_processor_45nm = Performance45nm;
performance_processor_28nm = Performance28nm;

% % SIMDs (default grid: 3x2) - cancelled in this new version
% simdGrid_height = processorGrid_height;
% simdGrid_width = processorGrid_width;
% ImplementationCosts_simd = 1;
% energyConsumption_simd = 1;
% performance_simd = 1;

% Viola Jones Units (default number: 3)
violaJonesUnitNumber = 3;
ImplementationCosts_violaJonesUnit_45nm = AreaSIMD45nm;
ImplementationCosts_violaJonesUnit_28nm = AreaSIMD28nm;
energyConsumption_violaJonesUnit_45nm = Energy45nm;
energyConsumption_violaJonesUnit_28nm = Energy28nm;
performance_violaJonesUnit_45nm = Performance45nm;
performance_violaJonesUnit_28nm = Performance28nm;

% Shi Tomasi Units (default number: 3)
shiTomasiUnitNumber = 3;
ImplementationCosts_shiTomasiUnit_45nm = AreaCPUcore45nm;
ImplementationCosts_shiTomasiUnit_28nm = AreaCPUcore28nm;
energyConsumption_shiTomasiUnit_45nm = Energy45nm;
energyConsumption_shiTomasiUnit_28nm = Energy28nm;
performance_shiTomasiUnit_45nm = Performance45nm;
performance_shiTomasiUnit_28nm = Performance28nm;

% KLT Units (default number: 3x3)
kLTGrid_height = 3;
kLTGrid_width = 3;
ImplementationCosts_kLTUnit_45nm = AreaCPUcore45nm;
ImplementationCosts_kLTUnit_28nm = AreaCPUcore28nm;
energyConsumption_kLTUnit_45nm = Energy45nm;
energyConsumption_kLTUnit_28nm = Energy28nm;
performance_kLTUnit_45nm = Performance45nm;
performance_kLTUnit_28nm = Performance28nm;

% Answers to unclear questions (model assumptions)
% - Wie viele Pixel breit ist ein Gesicht maximal?
%       abhängig von Pixelbreite des Bildes und Anzahl der Gesichter auf
%       dem Bild
maximumFaceWidth = picture_widthInPixels / maximumNumberOfFaces;
% - ...
    
% weitere Parameter
n = ADGrid_height*ADGrid_width + ...
    processorGrid_height*processorGrid_width + ...
...    %+ simdGrid_height*simdGrid_width ...
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

% numbering of the components
%    - Order: AD-Wandler, Prozessoren, ...
%    - Starting to count at 1
%    - number the grids in row-major order
ADLength = ADGrid_height*ADGrid_width;
ProceLength = processorGrid_height*processorGrid_width;
% SimdLength = simdGrid_height*simdGrid_width;
ViolaJonesLength = violaJonesUnitNumber;
ShiTomasiLength = shiTomasiUnitNumber;
KLTLength = kLTGrid_height*kLTGrid_width;

ADStart = 0;
ProceStart = ADLength;
% SimdStart = ProceStart + ProceLength;
% ViolaJonesStart = SimdStart + SimdLength;
ViolaJonesStart = ProceStart + ProceLength;
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
% [SIMD_rows_in, SIMD_cols_in] = sectors(picture_heightInPixels, ...
%     picture_widthInPixels, simdGrid_height, simdGrid_width, 'AD-Wandler');
% [SIMD_rows_out, SIMD_cols_out] = sectors(floor(picture_heightInPixels / ...
%     compressionFactor), floor(picture_widthInPixels / compressionFactor ...
%     ), simdGrid_height, simdGrid_width, 'AD-Wandler');
[VJU_rows_in, VJU_cols_in] = sectors(picture_heightInPixels, ...
    picture_widthInPixels, 1, violaJonesUnitNumber, 'ViolaJones');
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
                                       ImplementationCosts_ADWandler_45nm;
Cimpl( (ADStart + 1):(ADStart + ADLength) , 2) = ...
                                       ImplementationCosts_ADWandler_28nm;
Cimpl( (ADStart + 1):(ADStart + ADLength) , 3) = ...
                                       ImplementationCosts_ADWandler_28nm;
Energy( (ADStart + 1):(ADStart + ADLength) , 1) = ...
                                       energyConsumption_ADWandler_45nm;
Energy( (ADStart + 1):(ADStart + ADLength) , 2) = ...
                                       energyConsumption_ADWandler_28nm;
Energy( (ADStart + 1):(ADStart + ADLength) , 3) = ...
                                       energyConsumption_ADWandler_28nm;
Performance( (ADStart + 1):(ADStart + ADLength) , 1) = ...
                                            performance_ADWandler_45nm;
Performance( (ADStart + 1):(ADStart + ADLength) , 2) = ...
                                            performance_ADWandler_28nm;
Performance( (ADStart + 1):(ADStart + ADLength) , 3) = ...
                                            performance_ADWandler_28nm;

%   - Cimpl etc. for Prozessoren
Cimpl( (ProceStart + 1):(ProceStart + ProceLength) , 1) = ...
                                       ImplementationCosts_processor_45nm;
Cimpl( (ProceStart + 1):(ProceStart + ProceLength) , 2) = ...
                                       ImplementationCosts_processor_28nm;
Cimpl( (ProceStart + 1):(ProceStart + ProceLength) , 3) = ...
                                       ImplementationCosts_processor_28nm;
Energy( (ProceStart + 1):(ProceStart + ProceLength) , 1) = ...
                                        energyConsumption_processor_45nm;
Energy( (ProceStart + 1):(ProceStart + ProceLength) , 2) = ...
                                        energyConsumption_processor_28nm;
Energy( (ProceStart + 1):(ProceStart + ProceLength) , 3) = ...
                                        energyConsumption_processor_28nm;
Performance( (ProceStart + 1):(ProceStart + ProceLength) , 1) = ...
                                            performance_processor_45nm;
Performance( (ProceStart + 1):(ProceStart + ProceLength) , 2) = ...
                                            performance_processor_28nm;
Performance( (ProceStart + 1):(ProceStart + ProceLength) , 3) = ...
                                            performance_processor_28nm;

% %   - Cimpl etc. for SIMDs
% Cimpl( (SimdStart + 1):(SimdStart + SimdLength) , 2) = ...
%                                             ImplementationCosts_simd;
% Cimpl( (SimdStart + 1):(SimdStart + SimdLength) , 1) = big;
% Cimpl( (SimdStart + 1):(SimdStart + SimdLength) , 3) = big;
% Energy( (SimdStart + 1):(SimdStart + SimdLength) , 2) = ...
%                                             energyConsumption_simd;
% Energy( (SimdStart + 1):(SimdStart + SimdLength) , 1) = big;
% Energy( (SimdStart + 1):(SimdStart + SimdLength) , 3) = big;
% Performance( (SimdStart + 1):(SimdStart + SimdLength) , 2) = ...
%                                             performance_simd;
% Performance( (SimdStart + 1):(SimdStart + SimdLength) , 1) = big;
% Performance( (SimdStart + 1):(SimdStart + SimdLength) , 3) = big;

%   - Cimpl etc. for Viola Jones Units
Cimpl( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 1) ...
                                = ImplementationCosts_violaJonesUnit_45nm;
Cimpl( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 2) ...
                                = ImplementationCosts_violaJonesUnit_28nm;
Cimpl( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 3) ...
                                = ImplementationCosts_violaJonesUnit_28nm;
Energy( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 1)...
                                = energyConsumption_violaJonesUnit_45nm;
Energy( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 2) ...
                                = energyConsumption_violaJonesUnit_28nm;
Energy( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) , 3) ...
                                = energyConsumption_violaJonesUnit_28nm;
Performance( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) ...
                                    , 1) = performance_violaJonesUnit_45nm;
Performance( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) ...
                                    , 2) = performance_violaJonesUnit_28nm;
Performance( (ViolaJonesStart + 1):(ViolaJonesStart + ViolaJonesLength) ...
                                    , 3) = performance_violaJonesUnit_28nm;

%   - Cimpl etc. for Shi Tomasi Units
Cimpl( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 1) = ...
                                    ImplementationCosts_shiTomasiUnit_45nm;
Cimpl( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 2) = ...
                                    ImplementationCosts_shiTomasiUnit_28nm;
Cimpl( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 3) = ...
                                    ImplementationCosts_shiTomasiUnit_28nm;
Energy( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 1) = ...
                                    energyConsumption_shiTomasiUnit_45nm;
Energy( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 2) = ...
                                    energyConsumption_shiTomasiUnit_28nm;
Energy( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) , 3) = ...
                                    energyConsumption_shiTomasiUnit_28nm;
Performance( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) ...
                                    , 1) = performance_shiTomasiUnit_45nm;
Performance( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) ...
                                    , 2) = performance_shiTomasiUnit_28nm;
Performance( (ShiTomasiStart + 1):(ShiTomasiStart + ShiTomasiLength) ...
                                    , 3) = performance_shiTomasiUnit_28nm;

%   - Cimpl etc. for KLT Units
Cimpl( (KLTStart + 1):(KLTStart + KLTLength) , 1) = ...
                                        ImplementationCosts_kLTUnit_45nm;
Cimpl( (KLTStart + 1):(KLTStart + KLTLength) , 2) = ...
                                        ImplementationCosts_kLTUnit_28nm;
Cimpl( (KLTStart + 1):(KLTStart + KLTLength) , 3) = ...
                                        ImplementationCosts_kLTUnit_28nm;
Energy( (KLTStart + 1):(KLTStart + KLTLength) , 1) = ...
                                            energyConsumption_kLTUnit_45nm;
Energy( (KLTStart + 1):(KLTStart + KLTLength) , 2) = ...
                                            energyConsumption_kLTUnit_28nm;
Energy( (KLTStart + 1):(KLTStart + KLTLength) , 3) = ...
                                        energyConsumption_kLTUnit_28nm;
Performance( (KLTStart + 1):(KLTStart + KLTLength) , 1) = ...
                                            performance_kLTUnit_45nm;
Performance( (KLTStart + 1):(KLTStart + KLTLength) , 2) = ...
                                            performance_kLTUnit_28nm;
Performance( (KLTStart + 1):(KLTStart + KLTLength) , 3) = ...
                                            performance_kLTUnit_28nm;

%% Application digraph

% - ADC to processors (1.)
% - processors to Viola Jones Units (2.)
% - VJUs to Shi Tomasi Units (4.)
% - Shi Tomasi Units to KLTs (5.)
% - processors to Shi Tomasi (6.)
% - processors to KLT (7.)
% - done.

u = sparse(n, n);
% Data flow direction:
% Here, we mean by u(1,2) = 16 that there is a dataflow of 16 from
% component 1 to component 2. (I am not sure, if that is conform to the
% heuristic algorithm, or if it even matters there)

% --------------------- 1. ADC to processors -----------------------------

u = u + gridManagement(processorGrid_height, processorGrid_width, ...
                        Pro_rows_in, Pro_cols_in, ProceStart, ...
                        ProceLength, ADGrid_height, ...
                        ADGrid_width, AD_rows, AD_cols, ADStart, ...
                        ADLength, colordepthInBits, framerateInHertz, n);

% --------------------- 2. processors to Viola Jones Units ---------------

u = u + gridManagement( 1,  violaJonesUnitNumber, ...
                        VJU_rows_in, VJU_cols_in, ViolaJonesStart, ...
                        ViolaJonesLength, processorGrid_height, ...
                        processorGrid_width, ...
                        Pro_rows_out, Pro_cols_out, ...
                        ProceStart, ProceLength, ...
                        colordepthInBits, framerateInHertz, n);

% % --------------------- 3. SIMDs to Viola Jones Units --------------------
% 
% u = u + gridManagement( 1,  violaJonesUnitNumber, ...
%                         VJU_rows_in, VJU_cols_in, ViolaJonesStart, ...
%                         ViolaJonesLength, simdGrid_height, ...
%                         simdGrid_width, ... 
%                         SIMD_rows_out, SIMD_cols_out, ...
%                         SimdStart, SimdLength, ...
%                         colordepthInBits, ...
%                         framerateInHertz/framesBetweenTwoAlgorithmRuns, n);

% --------------------- 4. VJUs to Shi Tomasi Units ----------------------

maximumFacesPerVJU = ceil(maximumNumberOfFaces/violaJonesUnitNumber);
% maximumFacesPerSTU = maximumNumberOfFaces/shiTomasiUnitNumber;
 

% A face bounding box consists of four integer numbers
dataLoadOfFaceCoordinates = 2*ceil(log2(picture_heightInPixels)) ...
                            + 2*ceil(log2(picture_widthInPixels));

% Distribute VJU output on STUs
counter = 0;
for currentVJU = 1:violaJonesUnitNumber
    for face = 1:maximumFacesPerVJU
        currentSTU = mod(counter, shiTomasiUnitNumber) + 1;
        u(ViolaJonesStart + currentVJU, ShiTomasiStart + currentSTU) = ...
            u(ViolaJonesStart + currentVJU, ShiTomasiStart + currentSTU)...
            + dataLoadOfFaceCoordinates ...
                *framerateInHertz/framesBetweenTwoAlgorithmRuns;        
        counter = counter + 1;
    end
end
counter = 0;

% --------------------- 5. Shi Tomasi Units to KLTs ----------------------

maximumFacesPerSTU = maximumNumberOfFaces/shiTomasiUnitNumber;
 
% Feuture set consists of many (200!?) integer numbers
dataLoadOfFaceFeatures = 200*ceil(log2(picture_heightInPixels)) ...
                            + 200*ceil(log2(picture_widthInPixels));

% Distribute STU output on KLTs
counter = 0;
for currentSTU = 1:shiTomasiUnitNumber
    for face = 1:maximumFacesPerSTU
        currentKLT = mod(counter, kLTGrid_height*kLTGrid_width) + 1;
        u(ShiTomasiStart + currentSTU, KLTStart + currentKLT) = ...
            u(ShiTomasiStart + currentSTU, KLTStart + currentKLT)...
            + dataLoadOfFaceFeatures ...
                *framerateInHertz/framesBetweenTwoAlgorithmRuns;        
        counter = counter + 1;
    end
end
counter = 0;

% --------------------- 6. processors to Shi Tomasi ----------------------

% Only the image section inside the bounding boxes
% (Send bounding box coordinates from VJU to processor rather than to STU)

% Estimation, how big a face is at most:
% dataLoadOfAFace = picture_heightInPixels*picture_widthInPixels ...
%                                                /maximumNumberOfFaces;
                                  
% Explanation: Picture is cut and each piece goes to the respective
%              STU - in practice, faces will be smaller.

u = u + gridManagement(1, shiTomasiUnitNumber, ...
                        STU_rows_in, STU_cols_in, ShiTomasiStart, ...
                        ShiTomasiLength, processorGrid_height, ...
                        processorGrid_width, ...
                        Pro_rows_out, Pro_cols_out, ...
                        ProceStart, ProceLength, ...
                        colordepthInBits, framerateInHertz/...
                        framesBetweenTwoAlgorithmRuns, n);

                

% --------------------- 7. processors to KLT -----------------------------

% Flaws: - No good image sectors for faces chosen. (Experiment?)
%        - Communication to processor to request certain image sectors
%          is missing.

u = u + gridManagement(kLTGrid_height, kLTGrid_width, ...
                        KLT_rows_in, KLT_cols_in, KLTStart, ...
                        KLTLength, processorGrid_height, ...
                        processorGrid_width, ...
                        Pro_rows_out, Pro_cols_out, ...
                        ProceStart, ProceLength, ...
                        colordepthInBits, framerateInHertz/...
                        1, n);

% for megabyte per second, divide u by 8 million (since u is in bit per
% second)
% idea for a function: outputU(u); prints u

u = u/ mean(mean(u));
