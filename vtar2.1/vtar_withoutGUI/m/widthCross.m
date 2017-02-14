function     width =  midCalc(X)
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
    width = norm( X(2:3, indZmin)-X(2:3, indZmax) ) ; 
else
    width = norm( X(2:3, indYmin)-X(2:3, indYmax) ) ; 
end

return ;
