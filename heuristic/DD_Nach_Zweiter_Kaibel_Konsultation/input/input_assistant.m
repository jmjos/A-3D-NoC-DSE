
% Kenngrößen ----------------------------------------------------------
if (isunix)
    run(['Instanzen/',inputExamplePath,'/input_values.m'])
else
    run(['Instanzen\',inputExamplePath,'\input_values.m'])
end

% % Automatische Vervollständigung --------------------------------------
% 
% % Abfangen nicht symmetrischer Adjazenzmatrizen
% u = makeSquare(u, 0);
% %u = makeSymmetrical_nonzero(u);
% eN = makeSquare(eN, 0);
% eN = makeSymmetrical_nonzero(eN);
% 
% % Application Graph ...................................................
% 
% % eA aus u ermitteln
% 
% eA = (u~=0);
% 
% % Mapping...............................................................
% 
% % Positionen der Tiles
% 
% for i = 1:NumberOfTiles
%     tix(i) = rix(i);
%     tiy(i) = riy(i);
%     tiz(i) = riz(i);
% end
% 
% % Löschen von eventuell vorhandenen 3D-Links
% 
% eN = deleteVLinks(eN, riz);
% 
% %Flächen der einzelnen Layer berechnen
% areas = zeros(ell, 1);
% for layer = 1:ell
%     areas(layer) = max(tix(tiz==layer)+ai(tiz==layer))*...
%         max(tiy(tiz==layer)+bi(tiz==layer));
% end

% Erläuterungen -------------------------------------------------------

% "n" ist die Anzahl der Komponenten im 3D-Chip. Gleichzeitig ist "n" die
% Zahl der Knoten im Applikationsgraph.

% "u" sind die Utilization Costs. "u" ist hier eine n x n - Matrix. In
% Zeile i und Spalte j steht, wie viele Daten zwischen Komponente i und
% Komponente j gesendet werden. Die Matrix u ist symmetrisch.

% "eA" ist eine n x n - Matrix mit logischen Einträgen. Sie enthält genau
% dort Einsen, wo u nicht null ist. "eA" ist die Adjazenzmatrix im
% ungerichteten Applikationsgraph A und definiert damit die Kantenmenge von
% A: E_A.

% eN: Adjazenzmatrix der Topologie N. Definiert die Kantenmenge E_N der
% Topologie und damit alle Links.
% ell: Anzahl der Layer im Chip
% m: Anzahl der Router im Chip
% numberOfTiles: Anzahl der Tiles im Chip
% tix, tiy, tiz: Positionen der Tiles ( = Positionen der Router 1 bis
% numberOfTiles)
% ai, bi: x- und y-Ausdehnung der Tiles
% rix, riy, riz: Positionen der Router
% areas: Größe der verschiedenen Layer in Flächeneinheiten