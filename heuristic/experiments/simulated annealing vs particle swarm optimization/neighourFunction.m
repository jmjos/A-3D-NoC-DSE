function [pNew] = neighourFunction(p, pLocal, pGlobal)

pNew = p;

prob1 = 0.02;
prob2 = 0.04;

swapI = shortestSwapSequence(p,p);
swapLocal = shortestSwapSequence(p,pLocal);
swapGlobal = shortestSwapSequence(p,pGlobal);

actualSwaps = zeros(size(swapI));
for i = 1:length(p)
    %select swap
    r = rand();
    if (r< prob1)
        actualSwaps(i, :) = swapGlobal(i, :);
    elseif (r < prob2)
        actualSwaps(i, :) = swapLocal(i, :);
    else
        actualSwaps(i, :) = swapI(i, :);
    end
end

%apply swaps
for i = 1:size(actualSwaps, 1)
    pNew(actualSwaps(i,2)) = p(actualSwaps(i,1));
    pNew(actualSwaps(i,1)) = p(actualSwaps(i,2));
    p = pNew;
end

end

