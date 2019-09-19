function [u] = gridManagement(processorGrid_height, ...
                              processorGrid_width, ...
                              Pro_rows, ...
                              Pro_cols, ...
                              ProceStart, ...
                              ProceLength, ...
                              ADGrid_height, ...
                              ADGrid_width, ...
                              AD_rows, ...
                              AD_cols, ...
                              ADStart, ...
                              ADLength, ...
                              colordepth, ...
                              framerate, ...
                              n)
                          
%GRIDMANAGEMENT writes part of the application digraph
%   gets pixels from source and finds correct destinations.

% OUTPUT: appDigraphSnippet, I mean, u. Not to be confused with the real u.

% code was originally written in input_values.m for the single management
% of the pixels from AD-changers to processors. I found out, that it can be
% used as a general function. The old names stayed.

u = sparse(n,n);

% first compute in pixels, later multiply the matrix with framerate and
% color depth

% really ugly (because inefficient and stupid as hell) but works properly

% loop over all processors
for processorRow = 1:processorGrid_height
    for processorColumn = 1:processorGrid_width
        processor = ProceStart + (processorRow-1)*processorGrid_width + ...
                                                         processorColumn;
        % loop over all pixels in the image sector
        for pixelRow = Pro_rows(processorRow,1):Pro_rows(processorRow,2)
            % find corresponding AD-Wandler
            adRow = min(find( AD_rows(:,2) >= pixelRow) );
            for pixelColumn = Pro_cols(processorColumn,1): ...
                                             Pro_cols(processorColumn,2)
                adColumn = min(find( AD_cols(:,2) >= pixelColumn) );
                adWandler = ADStart + (adRow-1)*ADGrid_width + adColumn;
                
                % update u
                if processor > ProceStart + ProceLength
                    disp('Prozessor')
                end
                if adWandler > ADStart + ADLength
                    disp('AD')
                end
                u(adWandler, processor) = u(adWandler, processor) + 1;
            end
        end
    end
end

u = u*colordepth*framerate;

end

