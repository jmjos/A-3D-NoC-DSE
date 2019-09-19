function [ symmetrical_matrix ] = makeSymmetrical_bottomleft( square_matrix )
%MAKESYMMETRICAL_BOTTOMLEFT makes the input square matrix to a symmetrical matrix.
%   This is done by copying the bottom left triangle to the top right
%   triangle. Every data in the top right is overwritten. Example:
%
%    Eingabe      1 2 3             automatisch       1 0 0
%    hier:        0 4 5           - - - - - - - >     0 4 0
%                 0 0 6                               0 0 6

    n = size(square_matrix,1);
    symmetrical_matrix = zeros(n);

    for i = 1:n
        for j = 1:i
            symmetrical_matrix(j,i) = square_matrix(i,j);
            symmetrical_matrix(i,j) = square_matrix(i,j);
        end
    end
end
