function cutpoints = cut_betw_2_planes(linePoints1,linePoints2, deltaD ,face_node, node_xyz, face_num ) 

tempLine1 = linePoints1 ;
tempLine2 = linePoints2 ;

% adding N slices based on the distance of 3 plances
    temp1 = linePoints1 ; % directly put it mean() will not work ?
    meanxyz1 = mean(temp1,2) ;
    temp1 = linePoints2 ;
    meanxyz2 = mean(temp1,2) ;
    dist = norm(meanxyz1-meanxyz2) ; % tube length
%    N = round(dist/2.5) ;
%    N = round(dist/deltaD) ;
    N = ceil(dist/deltaD) ;

    
% first line, min Y, ind(1,1), max Y ind(1,2)
[tempx ind(1,1)] = min(tempLine1(2,:)) ;[tempx ind(1,2)] = max(tempLine1(2,:)) ;

% second line, min Y, ind(2,1), max Y ind(2,2)
[tempx ind(2,1)] = min(tempLine2(2,:)) ;    [tempx ind(2,2)] = max(tempLine2(2,:)) ;

% get reference points
x(:,1,1) = tempLine1(:,ind(1,1)) ;x(:,1,2) = tempLine1(:,ind(1,2)) ;
x(:,2,1) = tempLine2(:,ind(2,1)) ;x(:,2,2) = tempLine2(:,ind(2,2)) ;
x(1, :,:) = 0 ; % only keep Y and Z information , 

k1 = 1 ; 
%N = 6 ;
% First section, insert N-1 between 2 slices
for k = 1:N+1
    xnew1(:,k,1) = x(:,1,1)+(k-1)*(x(:,2,1)-x(:,1,1))/(N+1) ;
    xnew1(:,k,2) = x(:,1,2)+(k-1)*(x(:,2,2)-x(:,1,2))/(N+1) ;
    xnew(:,k1) = xnew1(:,k,1) ;
    temp = xnew1(:,k,2)- xnew1(:,k,1) ;
    xnormalnew(:,k1) = [0; -temp(3); temp(2)]
    
    if (temp(3)==0 & temp(2)==0)
        xnormalnew(:,k1) = [0; -1; 0] ;
    end
    k1 = k1+1 ;
end


cutpoints = cut(xnew, xnormalnew,face_node, node_xyz, face_num ) % cell array 

return ;
