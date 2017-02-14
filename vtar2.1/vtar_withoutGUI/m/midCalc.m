function     midP =  midCalc(X)
% X is the point coordinates of cross sections
% X(1:3, ...) , midpoint at projection of midsagtital plane in 
% MR images, Y-Z plane, 
%
% Z min and max
[Zmin, indZmin] = min(X(3,:)) ; 
[Zmax, indZmax] = max(X(3,:)) ; 

% Y min and max
[Ymin, indYmin] = min(X(2,:)) ; 
[Ymax, indYmax] = max(X(2,:)) ; 

if(abs(Zmin-Zmax)>abs(Ymin-Ymax))
    midP = (X(:, indZmin)+X(:, indZmax))/2 ; 
else
    midP = (X(:, indYmin)+X(:, indYmax))/2 ; 
end

return ;
