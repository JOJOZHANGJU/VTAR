%function [Distance, Area2] = lengh_to_distance(DL, Area) 
% 
%  to get the function of area and distance , from area and length of each section
%  get the distance from delta_L
function [Distance, Area2] = lengh_to_distance(DL, Area) 

Delta_L = 0.1 ;  %0.2  % Setp size in length for calculation purpose 

Area1  = [] ;
DL1 = [] ;  
for i = 1: length(DL) 
    if(DL(i) <= Delta_L)
        DL1 = [DL1 DL(i) ] ;
        Area1  = [Area1  Area(i)] ;
    else
        if(ceil(DL(i)/Delta_L) < 100)
            Temp_Length = Delta_L*ones(1,ceil(DL(i)/Delta_L)) ;  %round
            if(sum(Temp_Length)> DL(i))
                Temp_Length(end) = Delta_L -(sum(Temp_Length)-DL(i))  ;    
            end
            
            Temp_Area   = Area(i)*ones(1,ceil(DL(i)/Delta_L)) ; %round
            DL1 = [DL1 Temp_Length ] ;
            Area1  = [Area1 Temp_Area] ;
        else  % if length is too large, the maximum number of section is 100 ;
            Temp_Length = DL(i)/100*ones(1,100) ;
            Temp_Area   = Area(i)*ones(1,100) ; 
            DL1 = [DL1 Temp_Length ] ;
            Area1  = [Area1 Temp_Area] ;
            % h = warndlg('Please be aware that large length of section will reduce the accuracy of modelling', 'warning', 'modal') ;
        end
    end
end 


Cross_Area = Area1 ;
Length =  DL1 ; 

Distance  = zeros(1, 2*length(Cross_Area)) ;
Area2 = zeros(1, 2*length(Cross_Area)) ;
for i = 1: length(Cross_Area)
    if i==1
        Distance(2*i-1) = 0 ;
        Distance(2*i) = Length(1) ;
    else
        Distance(2*i-1) = sum(Length(1:i-1)) ;
        Distance(2*i) = sum(Length(1:i)) ;
    end
    Area2(2*i-1) = Cross_Area(i) ;
    Area2(2*i  ) = Cross_Area(i) ;
end ;    
return ;


% the following is the function before I modified, 04-17/2004
% get the distance from delta_L
function [Distance, Area] = lengh_to_distance_(Length, Cross_Area) 

Delta_L = 0.1 ;  %0.2  % Setp size in length for calculation purpose 

% In order to get better result, Delta_L used for calculation
AF3  = [] ;
LAF3 = [] ;  
 for i = 1: length(Length) 
     if(Length(i) <= Delta_L)
         LAF3 = [LAF3 Length(i) ] ;
         AF3  = [AF3  Cross_Area(i)] ;
     else
         Temp_Length = Delta_L*ones(1,ceil(Length(i)/Delta_L)) ;  %round
         if(sum(Temp_Length)> Length(i))
             Temp_Length(end) = Delta_L -(sum(Temp_Length)-Length(i))  ;    
         end
         
         Temp_Area   = Cross_Area(i)*ones(1,ceil(Length(i)/Delta_L)) ; %round
         LAF3 = [LAF3 Temp_Length ] ;
         AF3  = [AF3 Temp_Area] ;
     end
end 

Cross_Area = AF3 ;
Length =  LAF3 ; 

for i = 1: length(Cross_Area)
    if i==1
        Distance(2*i-1) = 0 ;
        Distance(2*i) = Length(1) ;
    else
        Distance(2*i-1) = sum(Length(1:i-1)) ;
        Distance(2*i) = sum(Length(1:i)) ;
    end
    Area(2*i-1) = Cross_Area(i) ;
    Area(2*i  ) = Cross_Area(i) ;
end ;    
return ;

