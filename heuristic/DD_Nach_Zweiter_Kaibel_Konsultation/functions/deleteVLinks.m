function [ new_matrix ] = deleteVLinks( old_matrix, xi )
%DELETEVLINKS Connections between vertices of different layers are deleted. 
%   old_matrix is a symmetrical 0/1 square matrix and xi is a vector with
%   the same length as old_matrix.
%   old_matrix is seen as an adjacency matrix of a graph. xi contains an
%   assignment of every node to different layers. Now, edges between
%   different layers are deleted.

new_matrix = old_matrix;

for i = 1:length(old_matrix)
    for j = 1:length(old_matrix)
        if xi(i) ~= xi(j)
            new_matrix(i,j) = 0;
            new_matrix(j,i) = 0;
        end
    end
end

