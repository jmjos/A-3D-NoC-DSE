function [ symmetrical_matrix ] = makeSymmetrical_nonzero( square_matrix )
%MAKESYMMETRICAL_NONZERO makes the input square matrix to a symmetrical matrix.
%   This is done by mirroring non zero values to their respective places.
%   If both values are nonzeros, the bottom left value gets copied first
%   and the other one is overwritten.
%
%    Eingabe      1 0 2             automatisch       1 3 6
%    hier:        3 4 5           - - - - - - - >     3 4 5
%                 6 0 7                               6 5 7--
    n = size(square_matrix,1);
    symmetrical_matrix = zeros(n);

    for i = 1:n
        for j = 1:i
            if (square_matrix(i,j)~=0)
                symmetrical_matrix(i,j) = square_matrix(i,j);
                symmetrical_matrix(j,i) = square_matrix(i,j);
            elseif (square_matrix(j,i)~=0)
                symmetrical_matrix(j,i) = square_matrix(j,i);
                symmetrical_matrix(i,j) = square_matrix(j,i);
            end
        end
    end
end