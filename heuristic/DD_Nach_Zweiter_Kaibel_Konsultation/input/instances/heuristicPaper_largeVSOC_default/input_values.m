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

% - ADC to processors (1.)
% - processors to SIMDs (2.)
% - SIMDs to Viola Jones Units (3.)
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

% --------------------- 2. processors to SIMDs ---------------------------

u = u + gridManagement(simdGrid_height, simdGrid_width, ...
                        SIMD_rows_in, SIMD_cols_in, SimdStart, ...
                        SimdLength, processorGrid_height, ...
                        processorGrid_width, ...
                        Pro_rows_out, Pro_cols_out, ...
                        ProceStart, ProceLength, ...
                        colordepthInBits, framerateInHertz, n);

% --------------------- 3. SIMDs to Viola Jones Units --------------------

u = u + gridManagement( 1,  violaJonesUnitNumber, ...
                        VJU_rows_in, VJU_cols_in, ViolaJonesStart, ...
                        ViolaJonesLength, simdGrid_height, ...
                        simdGrid_width, ... 
                        SIMD_rows_out, SIMD_cols_out, ...
                        SimdStart, SimdLength, ...
                        colordepthInBits, ...
                        framerateInHertz/framesBetweenTwoAlgorithmRuns, n);

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
