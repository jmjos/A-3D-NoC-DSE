function [bestcoordinates, bestsolution, bestCosts, rows, cols] = ...
    positionsOfComponents_SA(components, ...
    areaCosts,fR2D, applicationDigraph, eta, weightArea, ...
    weightCommunication, maxIterations, initalTemperature, cooling, ...
    output, useSDP, progress, progressPerStep, cheat, manualPlan)

cheat = strcmp(cheat, 'manualFloorplan');

% components = ApplicationDigraph.Nodes.Name;
n = length(components);
area = zeros(n,n);

LinearizationRHSTerm = areaCosts+fR2D; %sqrt(areaCosts+fR2D ...
        %./ eta) + sqrt(areaCosts+fR2D .* eta); Linearization takes place
        % inside minimizeRowsAndColumns.
% for i = 1:n
%     LinearizationRHSTerm(i) = sqrt(areaCosts(i)+fR2D ...
%         / eta) + sqrt(areaCostsComponentsAnd2DRouters * eta);
% end

%NumberOfPossibleSolutions = nchoosek(n^2,n)*factorial(n);

initialSolution = inital(n, LinearizationRHSTerm);

if cheat
    maxIterations = 0;
    % Vorsicht Hack! Funktioniert nur, wenn die Elemente von manualPlan
    % ohne Lücke aufsteigende Zahlen enthalten (Reihenfolge natürlich egal)
    % (In unseren Beispielen ist
    % diese Bedingung erfüllt)
    initialSolution = zeros(n);
    for i = 1:size(manualPlan, 1)
        for j = 1:size(manualPlan,2)
            initialSolution(i,j) = manualPlan(i,j) - min(min(manualPlan)) + 1;
        end
    end
end

solution = initialSolution;
%testsolution = bestSolution;


area = calculateTileAreas(initialSolution, LinearizationRHSTerm,n);

if(useSDP)
    [rows, cols, ~] = minimizeRowsAndColumnsSDP(area, eta);
else
    [rows, cols, ~] = minimizeRowsAndColumns(area, eta);
end
costs = calculateCosts(initialSolution, applicationDigraph, rows, cols, ....
    weightArea, weightCommunication, n);
solCosts = costs;

bestsolution = solution;
bestCosts = solCosts;
%bestRows = rows;
%bestCols = cols;

T = initalTemperature;
for numberOfIterations = 1: maxIterations
    if (strcmp(output, 'on'))
        disp(['In Iteration ', num2str(numberOfIterations), '/', ...
            num2str(maxIterations)])
    end
    if (strcmp(output, 'rare'))
        oldProgress = progress + numberOfIterations*progressPerStep;
        newProgress = oldProgress + progressPerStep;
        oldDecile = floor(oldProgress * 10);
        newDecile = floor(newProgress * 10);
        % print 10%, 20%, ..., 100%
        if (oldDecile ~= newDecile)
            disp([num2str(newDecile), '0 %'])
        end
    end
    T = cooling*T;
    
    testsolution = neigbour(solution, n);
    
	%calculate costs    
    if(useSDP)
        [rows, cols, ~] = minimizeRowsAndColumnsSDP( ...
            calculateTileAreas(testsolution, LinearizationRHSTerm, n) , eta);
    else
        [rows, cols, ~] = minimizeRowsAndColumns( ...
            calculateTileAreas(testsolution, LinearizationRHSTerm, n) , eta);
    end
    [rows, cols, ~] = minimizeRowsAndColumns( ...
       calculateTileAreas(testsolution, LinearizationRHSTerm, n) , eta);
	costs = calculateCosts(testsolution, applicationDigraph, rows, cols, ....
        weightArea, weightCommunication, n);
	
    costDelta = costs - solCosts;
    if (costDelta <= 0)
        solution = testsolution;
        solCosts = costs;
        if (strcmp(output, 'on'))
            display(['        New best costs: '  num2str(costs)])
        end
    elseif (rand < exp(-costDelta/T))
        solution = testsolution;
        solCosts = costs;
        if (strcmp(output, 'on'))
            display(['        New costs: '  num2str(costs)])
        end
    end
    % update bestsolution if necessary
    if (solCosts < bestCosts)
        bestsolution = solution;
        bestCosts = solCosts;
    end
end
if (strcmp(output, 'on') || strcmp(output, 'rare') )
    display(['Overall costs: '  num2str(bestCosts)])
    display('Solution:')
    display(num2str(solution));
end

% calculate rows and cols of bestsolution again
 if(useSDP)
[rows, cols, ~] = minimizeRowsAndColumnsSDP( ...
       calculateTileAreas(bestsolution, LinearizationRHSTerm, n) , eta);
 else
[rows, cols, ~] = minimizeRowsAndColumns( ...
       calculateTileAreas(bestsolution, LinearizationRHSTerm, n) , eta); 
 end
bestcoordinates = calculateCoordiantes(bestsolution, n, rows, cols);
end

function [coordinates] = calculateCoordiantes(solution, n, rows, cols)
    % calculate coordinates from row heights and column widths
    rowsCols = rowsColsOfComponents(solution, n);
    coordinates = -ones(n, 2);
    for comp = 1:n
        coordinates(comp, :) = [sum(rows(1:rowsCols(comp,1)-1)), ...
            sum(cols(1:rowsCols(comp,2)-1))];
    end
    
end

function [solution] = inital(n, areas)
% solution is a nxn-Matrix with numbers from 1 to n for the placed
% components and zeros everywhere else.
	%solution = zeros(n);
    % for i = 1:n
    %     solution(1,i) = i;
    % end
%    for i=1:n
%        solution(mod(i-1,ceil(sqrt(n)))+1,ceil(i/ceil(sqrt(n))))=i;
%    end
    solution = zeros(n);
    areasInSolution = zeros(n);
    lastRow = 1;
    lastCol = 2;
    fillRow = 1;
    a= 0;
    b= 0;
    [B,I] = sort(areas,'descend');
    solution(1, 1) = I(1);
    areasInSolution(1, 1) = B(1);
    solution(1, 2) = I(2);
    areasInSolution(1, 2) = B(2);
    for i  = 3:length(I)
       %found or fill?
       if (lastRow * lastCol >= i)
           %fill
           if (fillRow)
               a = a;
               b = b + 1;
           else
               a = a + 1;
               b = b;
           end
       else
           %found
           % row or column?
           if (sum(areasInSolution(:,1)) > sum(areasInSolution(1,:)))
               % column
               fillRow = 0;
               lastCol = lastCol + 1;
               a = 1;
               b = lastCol;
           else
               % row
               fillRow = 1;
               lastRow = lastRow + 1;
               a = lastRow;
               b = 1;
           end
       end
       solution(a, b) = I(i);
       areasInSolution(a, b) = B(i);
    end
end

function [solution] = neigbour(solution, n)
	%draw random index
	switchIndex = randi([1,n],1,1);
	switchPositionOld = find(solution == switchIndex);
	newPosition = randi([1,n^2],1,1);
	if (solution(newPosition)~=0)
		%switch
		solution(switchPositionOld)=solution(newPosition);
		solution(newPosition)= switchIndex;
	else 
		%move
		solution(newPosition)=switchIndex;
		solution(switchPositionOld)=0;
	end
	
	permuteRow=[find(any(solution, 1)==1), find(any(solution, 1)==0)];
    solution = solution(:,permuteRow);
	permuteCols=[find(any(solution, 2)==1); find(any(solution, 2)==0)];
    solution = solution(permuteCols,:);
end

function [costs] = calculateCosts(solution, applicationDigraph, rows, cols, weightArea, ...
    weightCommunication, n)
       
    formattedsolution = rowsColsOfComponents(solution, n);
    
	% area costs
    areaCosts = max(sum(rows),sum(cols))^2;
    CommunicationCosts = 0;
    % communication costs
    % sum over every edge in ApplicationDigraph of: hop-distance*weight
    for i = 1:size(applicationDigraph.Edges,1)        
        CommunicationCosts = CommunicationCosts + ...
            applicationDigraph.Edges.Weight(i)* ...
            sum(abs(formattedsolution(findnode ...
            (applicationDigraph, applicationDigraph.Edges{i,1}(1)),:) ...
            - formattedsolution(findnode ...
            (applicationDigraph, applicationDigraph.Edges{i,1}(2)),:)));
    end    
    costs = weightArea*areaCosts + weightCommunication*CommunicationCosts;
end

function [formattedsolution] = rowsColsOfComponents(solution, n)
    formattedsolution = -1*ones(n,2);
    for i = 1:n
        [formattedsolution(i,1),formattedsolution(i,2)] = find(solution == i);
    end
    
end

function [area] = calculateTileAreas(solution, individualAreas,n)
% solution matrix with area values instead of component numbering
area = zeros(n,n);
for i = 1:n
    for j = 1:n
        if (solution(i,j) ~= 0)
            area(i,j) = individualAreas(solution(i,j));
        end
    end
end
end