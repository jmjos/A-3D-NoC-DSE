function [swaps] = shortestSwapSequence(p1, p2)

%identity
swaps = repmat(transpose(1:length(p1)), 1,2);

%find differences
differentPositions = find((p1~=p2) == 1);

%swap pairwise between differences
for i = 1:length(differentPositions)/2
    swaps(i,1) = differentPositions(2*i-1);
    swaps(i,2) = differentPositions(2*i);
end
end