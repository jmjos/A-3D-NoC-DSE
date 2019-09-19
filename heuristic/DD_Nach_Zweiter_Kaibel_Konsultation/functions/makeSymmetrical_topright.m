function [ symmetrical_matrix ] = makeSymmetrical_topright( square_matrix )
%MAKESYMMETRICAL_TOPRIGHT makes the input square matrix to a symmetrical matrix.
%   This is done by copying the top right triangle to the bottom left
%   triangle. Every data in the bottom left is overwritten. Example:
%
%    Eingabe      1 2 3             automatisch       1 2 3
%    hier:        0 4 5           - - - - - - - >     2 4 5
%                 0 0 6                               3 5 6
    n = size(square_matrix,1);
    symmetrical_matrix = zeros(n);

    for i = 1:n
        for j = 1:i
            symmetrical_matrix(i,j) = square_matrix(j,i);
            symmetrical_matrix(j,i) = square_matrix(j,i);
        end
    end
end

