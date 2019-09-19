function [ square_matrix ] = makeSquare( matrix, filler )
%MAKESQUARE expands a matrix to make it square.
%   New rows or columns are filled with the value of filler.

    square_matrix = filler*ones(max(size(matrix)));

    for i = 1:size(matrix,1)
        for j = 1:size(matrix,2)
            square_matrix(i,j) = matrix(i,j);
        end
    end
end

