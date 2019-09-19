%% nur floor planning testen

%bis hier in nehmen wir die eingabe an:
%% Initialization: lese Eingabe ein
clear all;
useInputAssistant = false;
useSDP = true;
saveas = 'test';

% Zum Beispiel: Beispiel1, Minibsp_linkLoad, Vorlage
if (isunix)
    otherFolder = 'Eingabe/Instanzen/Srinivasan_1'; % '../EE_Heuristik_Und_MILP';
else
    otherFolder = 'Eingabe/Instanzen/Srinivasan_1';
end
inputExamplePath ='input_values.m'; % 'inputForBoth.m';
% Paths
currentDir = pwd;
if (isunix)
    addpath([currentDir, '/functions'])
else
    addpath([currentDir, '\functions'])
end


% Eingabe Applikationsgraph und Mapping
if useInputAssistant
    if (isunix)
        run('Eingabe/input_assistant.m')
    else
        run('Eingabe\input_assistant.m')
    end
else
    if (isunix)
        run([otherFolder,'/',inputExamplePath])
    else
        run([otherFolder,'\',inputExamplePath])
    end
end

addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio128\cplex\matlab\x64_win64');
addpath('C:\Program Files\Mosek\8\toolbox\r2014a');
addpath('C:\Program Files\export_fig');


%% manuell hacken, dass nur ein layer da ist

ComponentInLayer = cell(ell, 1);
ComponentInLayer{1} = 1:n;


weightArea = 1;
weightCommunication  = 0;
%% floor planning of components and vLinks


fprintf('\n\n-----------------------\n 2D floor planning per layer:\n');

FPTime = tic;

%lengthly calculation to get all relevant positions of components, routers
componentPositions = -ones(n,3);
componentOrder = cell(ell,1);
fillRouterIndex = n;
for layer=1:ell
    display(['Layer: ', num2str(layer)]);
    output = 'on'; %off, rare
    FPmaxIterations = 500;
    FPinitalTemperature =30;
    FPcooling = 0.98;
    eta = 0.4;
    [positions, order, ~, rows, cols] = ...
        positionsOfComponents_SA...
        (ComponentInLayer{layer}, ...
        Cimpl(ComponentInLayer{layer}, layer), fR2D(layer),...
        digraph(u(ComponentInLayer{layer}, ComponentInLayer{layer})), eta,...
        weightArea, weightCommunication, ...
        FPmaxIterations, FPinitalTemperature, FPcooling, output, useSDP);
    localIndex=1;
    componentOrder{layer} = zeros(size(order));
    for component=ComponentInLayer{layer}
        componentOrder{layer}(find(order==localIndex))=component;
        componentPositions(component, :) = [positions(localIndex, :), layer];
        localIndex= localIndex+1;
    end
    %delete 0-rows and cols
    componentOrder{layer}(find(any(componentOrder{layer}')==0), :) = [];
    componentOrder{layer}(:,find(any(componentOrder{layer})==0)) = [];
    %add additional routers for mesh topology
    fillrouterIndexes = find(componentOrder{layer}(:)==0);
    fillRouters = fillRouterIndex + 1 :fillRouterIndex + length(fillrouterIndexes);
    componentOrder{layer}(fillrouterIndexes) = fillRouters;
    
    %add positions of new inserted routers into component positions
    newRouterLocations = -1*ones(length(fillrouterIndexes),2);
    for i = fillRouters - fillRouterIndex
        [newRouterLocations(i,1),newRouterLocations(i,2)] = find(componentOrder{layer} == i+ fillRouterIndex);
    end
    coordinates = -ones(length(fillrouterIndexes), 2);
    for comp = fillRouters-fillRouterIndex
        coordinates(comp, :) = [sum(rows(1:newRouterLocations(comp,1)-1)), ...
            sum(cols(1:newRouterLocations(comp,2)-1))];
    end
    for comp = fillRouters-fillRouterIndex
        componentPositions(comp+fillRouterIndex,:) = [coordinates(comp, :), layer];
    end
  
    fillRouterIndex = fillRouterIndex + length(fillrouterIndexes);
end

FPelapsedTime = toc(FPTime);
fprintf("----------------\nTiming:\n----------------\n");
fprintf("\t Floor planning              %4.2f sec.\n", FPelapsedTime);

%% auswertung
fprintf("----------------\nVerschenkt pro feld:\n----------------\n");
area = Cimpl(ComponentInLayer{layer}, layer);
for i=1:n
    [row, col] = find(order == i);
    areagiven = rows(row)*cols(col);
    verschenkt = 1-(area(i)/areagiven);
    fprintf("ben. Flaeche %4.2f, gegeb. Fläche %4.2f, verschenkt: %4.2f\n", area(i), areagiven, verschenkt);
    gesamt = sum(rows)*sum(cols);
    fprintf("\n\n gesamt:")
    
end
disp(gesamt)

%% vergleich gegen paper
% testsolution = zeros(14,14);
% testsolution(2, 2) = 1;
% testsolution(2, 3) = 2;
% testsolution(3, 3) = 3;
% testsolution(4, 2) = 4;
% testsolution(3, 2) = 5;
% testsolution(4, 1) = 6;
% testsolution(3, 1) = 7;
% testsolution(1, 2) = 8;
% testsolution(1, 3) = 9;
% testsolution(2, 4) = 10;
% testsolution(3, 4) = 11;
% testsolution(4, 3) = 12;
% testsolution(4, 4) = 13;
% testsolution(4, 5) = 14;
% eta = 0.4
% LinearizationRHSTerm = area;
% 
% uebergabe = zeros(n,n);
% for i = 1:n
%     for j = 1:n
%         if (testsolution(i,j) ~= 0)
%             uebergabe(i,j) = LinearizationRHSTerm(testsolution(i,j));
%         end
%     end
% end
% 
% 
% [rows, cols, ~] = minimizeRowsAndColumnsSDP( uebergabe , eta);
%      fprintf("----------------\nVerschenkt pro feld:\n----------------\n");
% area = Cimpl(ComponentInLayer{layer}, layer);
% for i=1:n
%     [row, col] = find(testsolution == i);
%     areagiven = rows(row)*cols(col);
%     verschenkt = 1-(area(i)/areagiven);
%     fprintf("ben. Flaeche %4.2f, gegeb. Fläche %4.2f, verschenkt: %4.2f\n", area(i), areagiven, verschenkt);
%     gesamt = sum(rows)*sum(cols);
%     fprintf("\n\n gesamt:")
%     
% end
% disp(gesamt)   
        
%% sdp mit reihe als lösung
%% vergleich gegen paper
% testsolution = zeros(14,14);
% testsolution(1, 1) = 1;
% testsolution(1, 2) = 2;
% testsolution(1, 3) = 3;
% testsolution(1, 4) = 4;
% testsolution(1, 5) = 5;
% testsolution(1, 6) = 6;
% testsolution(1, 7) = 7;
% testsolution(1, 8) = 8;
% testsolution(1, 9) = 9;
% testsolution(1, 10) = 10;
% testsolution(1, 11) = 11;
% testsolution(1, 12) = 12;
% testsolution(1, 13) = 13;
% testsolution(1, 14) = 14;

%% teilproblem 1 aus dem paper:

PaperSolution = zeros(14,14);
PaperSolution(1,2) = 7+1;
PaperSolution(1,3) = 8+1;
PaperSolution(2,2) = 0+1;
PaperSolution(2,3) = 1+1;
PaperSolution(2,4) = 9+1;
PaperSolution(3,1) = 6+1;
PaperSolution(3,2) = 4+1;
PaperSolution(3,3) = 2+1;
PaperSolution(3,4) = 10+1;
PaperSolution(4,1) = 5+1;
PaperSolution(4,2) = 3+1;
PaperSolution(4,3) = 11+1;
PaperSolution(4,4) = 12+1;
PaperSolution(4,5) = 13+1;





%eingabe für sdp
eta = .1
LinearizationRHSTerm = Cimpl;

uebergabe = zeros(n,n);
testsolution = PaperSolution;
for i = 1:n
    for j = 1:n
        if (testsolution(i,j) ~= 0)
            uebergabe(i,j) = LinearizationRHSTerm(testsolution(i,j));
        end
    end
end

[rows, cols, ~] = minimizeRowsAndColumnsSDP( uebergabe , eta);

%rekonstruierte die paper lösung
zerorows = find(any(uebergabe,2)== 0);
zerocols = find(any(uebergabe,1)== 0);

uebergabe(zerorows, :) = [];
uebergabe(:, zerocols) = [];
colsPaper = max(sqrt(uebergabe), [], 1);
rowsPaper = max(sqrt(uebergabe), [], 2);


limits = max([sum(rows), sum(rowsPaper), sum(cols), sum(colsPaper)]);

%plot paper loesung
% close all
%figure(1)
%set(gca, 'XDir','reverse')
% set(gca, 'YDir','reverse')
% set(gca,'xlim',[0 limits],'ylim',[0 limits])
% axis equal
% for col = 1:length(colsPaper)
    % for row = 1:length(rowsPaper)
       % rectangle('Position',[sum(colsPaper(1:col-1)) sum(rowsPaper(1:row-1)) colsPaper(col) rowsPaper(row)])
       % if (testsolution(row,col) ~= 0)
        % rectangle('Position',[sum(colsPaper(1:col-1)) sum(rowsPaper(1:row-1)) sqrt(Cimpl(testsolution(row, col))) sqrt(Cimpl(testsolution(row, col)))],'FaceColor',[0 .5 .5])
       % end
    % end
% end


%plot unsere loesung
% figure(2)
% set(gca, 'YDir','reverse')
% set(gca,'xlim',[0 limits],'ylim',[0 limits])
% axis equal
% for col = 1:length(cols)
    % for row = 1:length(rows)
       % rectangle('Position',[sum(cols(1:col-1)) sum(rows(1:row-1)) cols(col) rows(row)])
       % if (testsolution(row,col) ~= 0)
           % if (sqrt(testsolution(row, col)) >= rows(row) && sqrt(testsolution(row, col)) >= cols(col))
              % rectangle('Position',[sum(cols(1:col-1)) sum(rows(1:row-1)) sqrt(Cimpl(testsolution(row, col))) sqrt(Cimpl(testsolution(row, col)))],'FaceColor',[0 .5 .5])
           % else
               % if (rows(row)<cols(col))
                   % rectangle('Position',[sum(cols(1:col-1)) sum(rows(1:row-1)) Cimpl(testsolution(row, col))/rows(row) rows(row)],'FaceColor',[0 .5 .5])
               % else
                   % rectangle('Position',[sum(cols(1:col-1)) sum(rows(1:row-1))  cols(col) Cimpl(testsolution(row, col))/cols(col)],'FaceColor',[0 .5 .5])
               % end
           % end
       % end
    % end
% end

%auswertung
fprintf("----------------\nVerschenkt pro feld:\n----------------\n");
%area = Cimpl(ComponentInLayer{layer}, layer);
area = Cimpl;


fprintf("\n\n--------------------------------------------------------\n")
% kommunikationskosten
%hop distance * bandbreite
bandwidthPaper = 0;
for i = 1:length(data)
    [x1, y1] = find(testsolution == data(i,1));
    [x2, y2] = find(testsolution == data(i,2));
    bandwidthPaper = bandwidthPaper + data(i, 3) * (abs(x1-x2) + abs(y1 - y2));
end
fprintf("communication paper and solution (does not change  %5.2f\n", bandwidthPaper);

% maximale bandbreite eines links nach routing algorithmus
bandwidthLinkPaper = zeros(n-1, n-1);
for i = 1:length(data)
    [sourceX, sourceY] = find(testsolution == data(i,1));
    [dstX, dstY] = find(testsolution == data(i,2));
    B = sort([sourceX, dstX]);
    bandwidthLinkPaper(B(1):B(2)-1, sourceY) = bandwidthLinkPaper(B(1):B(2)-1, sourceY) + data(i,3);
    B = sort([sourceY, dstY]);
    bandwidthLinkPaper(dstX, B(1):B(2)-1) = bandwidthLinkPaper(dstX, B(1):B(2)-1) + data(i,3);
end

fprintf("max bandwidth  %5.2f\n", max(max(bandwidthLinkPaper)));


%area costs:
gesamtPaper = sum(rowsPaper)*sum(colsPaper);    
fprintf("\n Area Paper: %4.0f \n", gesamtPaper)
gesamt = sum(rows)*sum(cols);    
fprintf(" Area unser: %4.0f \n", gesamt)
fprintf("-------------------\n gespart  %4.2f\n", gesamt/gesamtPaper);
fprintf("\n\n--------------------------------------------------------\n")



%% als nächstes testen wir das SA

%nur ein layer
ComponentInLayer = cell(ell, 1);
ComponentInLayer{1} = 1:n;
weightArea = 0;
weightCommunication  = 4;

reruns = 30;
ResultsBandwidths = zeros(1,reruns);
ResultsBandwidthLinks = zeros(1,reruns);
ResultsAreas = zeros(1,reruns);
for rerun = 1:reruns
    fprintf('\n\n-----------------------\n 2D floor planning per layer:\n');

    FPTime = tic;

    %lengthly calculation to get all relevant positions of components, routers
    componentPositions = -ones(n,3);
    componentOrder = cell(ell,1);
    fillRouterIndex = n;
    for layer=1:ell
        display(['Layer: ', num2str(layer)]);
        output = 'off'; %off, rare
        FPmaxIterations = 15000;
        FPinitalTemperature =30;
        FPcooling = 0.98;
        eta = 0.1;
        [positions, order, ~, rows, cols] = ...
            positionsOfComponents_SA...
            (ComponentInLayer{layer}, ...
            Cimpl(ComponentInLayer{layer}, layer), fR2D(layer),...
            digraph(u(ComponentInLayer{layer}, ComponentInLayer{layer})), eta,...
            weightArea, weightCommunication, ...
            FPmaxIterations, FPinitalTemperature, FPcooling, output, useSDP);
        localIndex=1;
        componentOrder{layer} = zeros(size(order));
        for component=ComponentInLayer{layer}
            componentOrder{layer}(find(order==localIndex))=component;
            componentPositions(component, :) = [positions(localIndex, :), layer];
            localIndex= localIndex+1;
        end
        %delete 0-rows and cols
        componentOrder{layer}(find(any(componentOrder{layer}')==0), :) = [];
        componentOrder{layer}(:,find(any(componentOrder{layer})==0)) = [];
        %add additional routers for mesh topology
        fillrouterIndexes = find(componentOrder{layer}(:)==0);
        fillRouters = fillRouterIndex + 1 :fillRouterIndex + length(fillrouterIndexes);
        componentOrder{layer}(fillrouterIndexes) = fillRouters;

        %add positions of new inserted routers into component positions
        newRouterLocations = -1*ones(length(fillrouterIndexes),2);
        for i = fillRouters - fillRouterIndex
            [newRouterLocations(i,1),newRouterLocations(i,2)] = find(componentOrder{layer} == i+ fillRouterIndex);
        end
        coordinates = -ones(length(fillrouterIndexes), 2);
        for comp = fillRouters-fillRouterIndex
            coordinates(comp, :) = [sum(rows(1:newRouterLocations(comp,1)-1)), ...
                sum(cols(1:newRouterLocations(comp,2)-1))];
        end
        for comp = fillRouters-fillRouterIndex
            componentPositions(comp+fillRouterIndex,:) = [coordinates(comp, :), layer];
        end

        fillRouterIndex = fillRouterIndex + length(fillrouterIndexes);
    end

    FPelapsedTime = toc(FPTime);
    fprintf("----------------\nTiming:\n----------------\n");
    fprintf("\t Floor planning              %4.2f sec.\n", FPelapsedTime);

    testsolution = order;


    %plot unsere loesung
%     figure(5)
%     set(gca, 'YDir','reverse')
%     set(gca,'xlim',[0 limits],'ylim',[0 limits])
%     axis equal
%     for col = 1:length(cols)
%         for row = 1:length(rows)
%            rectangle('Position',[sum(cols(1:col-1)) sum(rows(1:row-1)) cols(col) rows(row)])
%            if (testsolution(row,col) ~= 0)
%                if (sqrt(testsolution(row, col)) >= rows(row) && sqrt(testsolution(row, col)) >= cols(col))
%                   rectangle('Position',[sum(cols(1:col-1)) sum(rows(1:row-1)) sqrt(Cimpl(testsolution(row, col))) sqrt(Cimpl(testsolution(row, col)))],'FaceColor',[0 .5 .5])
%                else
%                    if (rows(row)<cols(col))
%                        rectangle('Position',[sum(cols(1:col-1)) sum(rows(1:row-1)) Cimpl(testsolution(row, col))/rows(row) rows(row)],'FaceColor',[0 .5 .5])
%                    else
%                        rectangle('Position',[sum(cols(1:col-1)) sum(rows(1:row-1))  cols(col) Cimpl(testsolution(row, col))/cols(col)],'FaceColor',[0 .5 .5])
%                    end
%                end
%            end
%         end
%     end

    %auswertung
    fprintf("----------------\nVerschenkt pro feld:\n----------------\n");
    %area = Cimpl(ComponentInLayer{layer}, layer);
    area = Cimpl;
    for i=1:n
        [row, col] = find(testsolution == i);
        areagiven = rows(row)*cols(col);
        verschenkt = 1-(area(i)/areagiven);
        fprintf("ben. Flaeche %4.2f, gegeb. Fläche %4.2f, verschenkt: %4.2f\n", area(i), areagiven, verschenkt);
    end

    % kommunikationskosten
    %hop distance * bandbreite
    bandwidthSA = 0;
    for i = 1:length(data)
        [x1, y1] = find(testsolution == data(i,1));
        [x2, y2] = find(testsolution == data(i,2));
        bandwidthSA = bandwidthSA + data(i, 3) * (abs(x1-x2) + abs(y1 - y2));
    end
    %fprintf("communication modified  %5.2f\n", bandwidthSA);
    %fprintf("compared to paper %4.6f\n", bandwidthSA/bandwidthPaper);

    % maximale bandbreite eines links nach routing algorithmus
    bandwidthLinkSA = zeros(n-1, n-1);
    for i = 1:length(data)
        [sourceX, sourceY] = find(testsolution == data(i,1));
        [dstX, dstY] = find(testsolution == data(i,2));
        B = sort([sourceX, dstX]);
        bandwidthLinkSA(B(1):B(2)-1, sourceY) = bandwidthLinkSA(B(1):B(2)-1, sourceY) + data(i,3);
        B = sort([sourceY, dstY]);
        bandwidthLinkSA(dstX, B(1):B(2)-1) = bandwidthLinkSA(dstX, B(1):B(2)-1) + data(i,3);
    end
    %fprintf("max bandwidth modified  %5.2f\n", max(max(bandwidthLinkSA)));
    %fprintf("max bandwidth change  %5.5f\n", max(max(bandwidthLinkSA)) / max(max(bandwidthLinkPaper)));


    gesamtPaper = sum(rowsPaper)*sum(colsPaper);    
    %fprintf("\n gesamt Paper: %4.0f \n", gesamtPaper)
    gesamt = sum(rows)*sum(cols);    
    %fprintf(" gesamt unser: %4.0f \n", gesamt)
    %fprintf(" -------------------\n gespart  %4.2f\n", gesamt/gesamtPaper);
    
    ResultsBandwidths(rerun) = bandwidthSA;
	ResultsBandwidthLinks(rerun) = max(max(bandwidthLinkSA));
    ResultsAreas(rerun) = gesamt;
    
end

fprintf("Ergbenisse: \n            mean    std\n")
fprintf("weightArea %4.2f, weightCommunication, %4.2f, FPmaxIterations %4.2f\n",weightArea, weightCommunication, FPmaxIterations);
fprintf("Area:       %4.2f   %4.2f\n",mean(ResultsAreas), std(ResultsAreas));
fprintf("Bandwidth:  %4.2f   %4.2f\n",mean(ResultsBandwidths), std(ResultsBandwidths));
fprintf("MaxBandW:   %4.2f   %4.2f\n",mean(ResultsBandwidthLinks), std(ResultsBandwidthLinks));
