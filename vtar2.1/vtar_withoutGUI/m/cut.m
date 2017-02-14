% for list of cutting planes defined by xyz1 (one point inside the plane),
% xyz_normal1 (plane normal)
%
% there might be case in which there are 2 loops for the area function.
%
function cutpoints = cut(xyz1, xyz_normal1,face_node, node_xyz, face_num )

%for k = 1:length(xyz1)
for k = 1:size(xyz1,2)
    xyz0 = xyz1(:,k) ;
    xyz_normal = xyz_normal1(:,k) ;

    linevec = node_xyz-repmat(xyz0, 1, size(node_xyz,2)) ;

    inner_product = xyz_normal'*linevec ;
    above_plane = zeros(size(inner_product)) ;
    above_plane(inner_product>0) = 1 ;

    % node_xyz(:,inner_product<0)
    % node_xyz(:,inner_product>0)

    % define the cutting points for each face, 2 points
    %Points = zeros(3,2,face_num) ; % 2 means 2 points for each face, 3 for x y and z
    Points = zeros(3,2*face_num) ; % 2 means 2 points for each face, 3 for x y and z
    for i = 1:  face_num
        temp = getpoints(i,xyz0, xyz_normal, above_plane, face_node, node_xyz ) ;
        %    Points(:,:, i) = temp ;
        Points(:,2*i-1:2*i) = temp ;
    end

    cutpoints{k} = Points ;
end

return ;
