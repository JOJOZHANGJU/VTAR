% to get the cutting points of a plane on a face
function   temp = getpoints(face,xyz0, xyz_normal, above_plane, face_node, node_xyz ) 

temp = zeros(3,2) ;
% test if all 3 points are on the side of the plane
if(all(above_plane(face_node(:,face))) | all(1-above_plane(face_node(:,face))))
    return ;
end

% find two lines
if(sum(above_plane(face_node(:,face)))==1)
    ind = find(above_plane(face_node(:,face))==1 );
else
    ind = find(above_plane(face_node(:,face))==0 );
end

% determine the cross points

p1 = node_xyz(:,face_node(ind,face)) ;
%line 1
p2 = node_xyz(:,face_node( 1+mod(ind,3),face)) ;
q = (xyz0-p2)'*xyz_normal/((p1-p2)'*xyz_normal);
temp(:,1) = p2+(p1-p2)*q ;

%line 2
p2 = node_xyz(:,face_node( 1+mod(ind+1,3),face)) ;
q = (xyz0-p2)'*xyz_normal/((p1-p2)'*xyz_normal);
temp(:,2) = p2+(p1-p2)*q ;
return ;

