function   [linePoints, Area] =  calArea5(cutpoints, up) 
% function   [linePoints, Area] =  calArea5(cutpoints, startingPoint, project_normal, xyz_normal) 
%
% Calculating the area based on the cutting points
% there are some other redundant points which should be removed before 
% area can be calculated,
% 
% 
Points = cutpoints ;
 
% list all the cutting points
%displaying it %Points(3,2, )
tempPoints  = 0 ;
%tempPoints = Points(:,(Points(1,:)~=0 |Points(2,:)~=0 |Points(3,:)~=0) ) ;


% get all the points which are not all zeros for x, y, z, which is 
ind = find(Points(1,:)~=0 |Points(2,:)~=0 |Points(3,:)~=0) ;
tempPoints = Points(:, ind) ;

% % original code
%%%%%%%%%%%%%%%%%%%%%%
% linePoints(:,1) = tempPoints(:,1) ;
% indStart = startingPoint ;
% next = startingPoint+1 ;

% modified
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find the points with minimum Y value, which is 
% the highest point in vocal tract shape, please see
% the coordinates of vocal tract
%[tempx indMax] = min(tempPoints(2,1:1:end)) ; % each face has 2 point intersected with plane
if(up==1)
[tempx indMax] = min(tempPoints(2,1:1:end)) ; % each face has 2 point intersected with plane
else
    [tempx indMax] = max(tempPoints(2,1:1:end)) ; % each face has 2 point intersected with plane\
end
if(mod(indMax,2)==0) % each triangle will have two points, we always start from the first point
    indMax = indMax-1 ;
end
linePoints(:,1) = tempPoints(:,indMax) ; % first point in the cutting points for calculating area
indStart = indMax ; % starting point number
next = indMax+1 ; % next point


% get the other points starting from the first point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% indStart = 1 ;
% next = 2 ;
i = 2 ;
%eps = 0.001 ;
eps = 0.000001 ; % two adjacent triangle will share one point , but the precison of floating may prevent them 
                 % exactily the same
while(1)
    linePoints(:,i) = tempPoints(:,next) ;
    %    ind = find(tempPoints(1,:)==tempPoints(1,next) &tempPoints(2,:)==tempPoints(2,next)&tempPoints(3,:)==tempPoints(3,next))
   
    ind = find(abs(tempPoints(1,:)-tempPoints(1,next))<eps &abs(tempPoints(2,:)-tempPoints(2,next))<eps &abs(tempPoints(3,:)-tempPoints(3,next))<eps);
%      ind, next
    j = find(ind~=next) ;  % find the point which is diffretn from next point , but with the same cooridnates
    if(mod(ind(j(1)),2)==1)
        next = ind(j(1))+1 ;
    else
        next = ind(j(1))-1 ;
    end
    i = i+1 ;
    if(next == indStart)  % if the next point comes back to the inital point, means 2 same points on the curve
        break
    end
    if(ind(j(1)) == indStart) % potential next point is the starting point , neglect it , 
        break
    end
    if(i>length(tempPoints))
        disp('Error in finding points for the cutting curve !\n') ;
        break ;
    end
end

 tempPoints1 = linePoints ;
% %figure;  plot3(tempPoints1(1,:),tempPoints1(2,:),tempPoints1(3,:), '-*' );
% % hold on;  plot3(tempPoints1(1,:),tempPoints1(2,:),tempPoints1(3,:), '-*' );
% % get az and el for view the cross section
 p = tempPoints1 ;
% az = 180 ;
% y = p(2,:); z = p(3,:);
% [yMax, indMaxy] = max(y) ;
% [yMin, indMiny] = min(y) ;
% [zMax, indMaxz] = max(z) ;
% [zMin, indMinz] = min(z) ;
% if(abs(yMax-yMin)>abs(zMax-zMin))
%     el = angle( y(indMaxy)-y(indMiny) + j*(z(indMaxy)-z(indMiny)) ) ; % radians
% else
%     el = angle( y(indMinz)-y(indMaxz) + j*(z(indMinz)-z(indMaxz)) ) ; % radians, min and max order is changed for this case
%     % in order to get suitable orientation
% end
% 
% % change el in radian to degree
% el = (el)*180/pi+90 ; % degrees
% % view(az, el) ;
% xlabel('X') ;   ylabel('Y') ;   zlabel('Z') ;
% set(gca, 'XLim', XLim1) ;
% set(gca, 'YLim', YLim1) ;
% set(gca, 'ZLim', ZLim1) ;

% view(2)

%
% calculate area
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% % old code
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% % project_normal = [0; 0; 1] ;
% %xyz_normal % cutting plane normal vector
% costheta = project_normal'*xyz_normal/(norm(project_normal)*norm(xyz_normal)) ;
% %polyarea(p(1,:), p(2,:)) ;
% ind = find(abs(project_normal)==1) ;
% if(ind(1)==1)
%     Area = polyarea(p(2,:), p(3,:))/costheta ;
% elseif (ind(1)==2)
%     Area = polyarea(p(1,:), p(3,:))/costheta ;
% else
%     Area = polyarea(p(1,:), p(2,:))/costheta ;
% end
% % if(ind(1)==1)
% %     Area = costheta*polyarea(p(2,:), p(3,:)) ;
% % elseif (ind(1)==2)
% %     Area = costheta*polyarea(p(1,:), p(3,:)) ;
% % else
% %     Area = costheta*polyarea(p(1,:), p(2,:)) ;
% % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% New code
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% project_normal = [0; 0; 1] ;
%xyz_normal % cutting plane normal vector
xyz_normal = cross(p(:,1)-p(:,3), p(:,1)-p(:,5)) ; % 
project_normal = [0; 0; 1] ; % Z axis
costheta1 = project_normal'*xyz_normal/(norm(project_normal)*norm(xyz_normal)) ;
project_normal = [0; 1; 0] ; % Y axis
costheta2 = project_normal'*xyz_normal/(norm(project_normal)*norm(xyz_normal)) ;
if(abs(costheta1)>abs(costheta2))
    Area = abs( polyarea(p(1,:), p(2,:))/costheta1 ) ;
else
    Area = abs( polyarea(p(1,:), p(3,:))/costheta2 ) ;
end


return ;
