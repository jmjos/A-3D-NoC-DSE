function [rows, cols] = sectors(picture_height, picture_width, ...
                        numberOfRows, numberOfColumns, processingElement)
%SECTORS Cut the image into nearly equally sized pieces along a grid
%   'AD-Wandler': Pieces are not overlapping
%   'Prozessoren': Each piece is one row and one column larger in each
%   direction (auﬂer am Rand) than its non-overlapping version
%   rounding: The remainder after division is put from right to left or
%   from bottom to top to the sections, one by one, to each row/column (
%   like you give cards in Mau-Mau one to the first player, one to the
%   second... until there are no cards left)
%   'ViolaJones': not implemented and I don't know, what was meant by it.
%           It, still, is handled like 'AD-Wandler'.

% Output format: 
%    rows: numberOfRows x 2 - vector
%    cols: numberOfCols x 2 - vector
%          containing the starting and the end-pixel-number of each row of
%          sectors.
rows = zeros(numberOfRows,2);
cols = zeros(numberOfColumns,2);

rowLength = floor(picture_height / numberOfRows);
rowRemainder = picture_height - rowLength*numberOfRows;

colLength = floor(picture_width / numberOfColumns);
colRemainder = picture_width - colLength*numberOfColumns;

% Calculate Output as if there was no remainder and no overlapping
rows(:,1) = (0:(numberOfRows - 1))' *rowLength;
rows(:,2) = (1:numberOfRows)' *rowLength - 1;

cols(:,1) = (0:(numberOfColumns - 1))' *colLength;
cols(:,2) = (1:numberOfColumns)' *colLength - 1;

% deal out the remainder Mau-Mau-style
rows( (numberOfRows + 1 - rowRemainder):numberOfRows  ,:) = ...
    rows( (numberOfRows + 1 - rowRemainder):numberOfRows  ,:) ...
        + [(0:(rowRemainder - 1))' , (1:rowRemainder)' ];

cols( (numberOfColumns + 1 - colRemainder):numberOfColumns  ,:) = ...
    cols( (numberOfColumns + 1 - colRemainder):numberOfColumns  ,:) ...
        + [(0:(colRemainder - 1))' , (1:colRemainder)' ];

    
% include the overlapping in case of 'Prozessoren'
if isequal(processingElement, 'Prozessoren')
    rows(2:numberOfRows        ,1) = rows(2:numberOfRows        ,1) - 1;
    rows(1: numberOfRows - 1   ,2) = rows(1:numberOfRows - 1    ,2) + 1;
    cols(2:numberOfColumns     ,1) = cols(2:numberOfColumns     ,1) - 1;
    cols(1:numberOfColumns - 1 ,2) = cols(1:numberOfColumns - 1 ,2) + 1;
end

end

