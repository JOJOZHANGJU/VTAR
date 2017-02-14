% iAxis  used as index for complex sound, which is consistent 
% for area function only,
% for VT.f and VT.AR , it will be updated on plot by calcuation acoustic
% response function ....

function set_plotdata(Category, Type, tempLength, tempArea, varargin )

global VT ;

if (nargin ==5) , iAxis = varargin{1} ; end ;

switch Category
   case 2  % 'Vowel'
%             VT.Vowel.Geometry.Length = tempLength;
%             VT.Vowel.Geometry.Cross_Area = tempArea;
            VT.Vowel.Geometry.DL = tempLength;
            VT.Vowel.Geometry.Area = tempArea;
   case 3  % 'Consonant'
%             VT.Consonant.Geometry.Length = tempLength;
%             VT.Consonant.Geometry.Cross_Area = tempArea;
            VT.Consonant.Geometry.DL = tempLength;
            VT.Consonant.Geometry.Area = tempArea;
   case 4  % 'Nasal'
%        
%        if(iAxis == 1)
%             Xdata = VT.f  ;
%             Ydata = VT.AR ;
%        else
        if(iAxis == 2)
            VT.Nasal.Geometry.PharynxDL = tempLength;
            VT.Nasal.Geometry.PharynxArea =  tempArea ;
       elseif(iAxis == 3)
            VT.Nasal.Geometry.OralDL =  tempLength;
            VT.Nasal.Geometry.OralArea =  tempArea;
       elseif(iAxis == 4)
            VT.Nasal.Geometry.NasalBackDL = tempLength;
            VT.Nasal.Geometry.NasalBackArea =  tempArea;
       elseif(iAxis == 5)
%             VT.Nasal.Geometry.NostrilDL(1, :) = tempLength;
%             VT.Nasal.Geometry.NostrilArea(1, :) =  tempArea;
            VT.Nasal.Geometry.NostrilDL1 = tempLength;  
            VT.Nasal.Geometry.NostrilArea1 =  tempArea;
            VT.Nasal.Geometry.NostrilDL = tempLength;  
            VT.Nasal.Geometry.NostrilArea =  tempArea;
       elseif(iAxis == 6)
%            VT.Nasal.Geometry.NostrilDL(2, :) = tempLength;
%            VT.Nasal.Geometry.NostrilArea(2, :) =  tempArea;
           VT.Nasal.Geometry.NostrilDL2 = tempLength;
           VT.Nasal.Geometry.NostrilArea2 =  tempArea;
       end
       
   case 5  % '/r/'
       %        if(iAxis == 1)
       %             Xdata = VT.f  ;
       %             Ydata = VT.AR ;
       %        else
       VT.Rhotic.Geometry.Type = Type ;
       switch Type
           case 1
               if(iAxis == 2)
                   VT.Rhotic.Geometry.BackDL = tempLength ;
                   VT.Rhotic.Geometry.BackArea  = tempArea;
               elseif(iAxis == 3)
                   VT.Rhotic.Geometry.FrontDL = tempLength  ;
                   VT.Rhotic.Geometry.FrontArea = tempArea ;
               elseif(iAxis == 4)
                   VT.Rhotic.Geometry.SublingualDL  = tempLength ;
                   VT.Rhotic.Geometry.SublingualArea  = tempArea;
               end
           case 2
               if(iAxis == 2)
                   VT.Rhotic.Geometry.MainDL = tempLength ;
                   VT.Rhotic.Geometry.MainArea  = tempArea;
               elseif(iAxis == 3)
                   VT.Rhotic.Geometry.SublingualDL  = tempLength ;
                   VT.Rhotic.Geometry.SublingualArea  = tempArea;
               end
           otherwise
               errordlg('Error in /r/ model type in set_plotdata.m', 'Error', 'modal') ;
       end    
       
   case 6  % '/l/'
%        if(iAxis == 1)
%             Xdata = VT.f  ;
%             Ydata = VT.AR ;
%        else
       if(iAxis == 2)
            VT.Lateral.Geometry.BackDL  = tempLength ;
            VT.Lateral.Geometry.BackArea  = tempArea;
       elseif(iAxis == 3)
            VT.Lateral.Geometry.FrontDL  = tempLength ;
            VT.Lateral.Geometry.FrontArea = tempArea ;
       elseif(iAxis == 4)
            VT.Lateral.Geometry.SupralingualDL   = tempLength ;
            VT.Lateral.Geometry.SupralingualArea  = tempArea;
       elseif(iAxis == 5)
            VT.Lateral.Geometry.LateralDL1   = tempLength ;
            VT.Lateral.Geometry.LateralArea1  = tempArea;
            VT.Lateral.Geometry.LateralDL   = tempLength ;
            VT.Lateral.Geometry.LateralArea  = tempArea;
       elseif(iAxis == 6)
            VT.Lateral.Geometry.LateralDL2   = tempLength ;
            VT.Lateral.Geometry.LateralArea2  = tempArea;
       end

   case 7  % 'Nasalized vowel'
%        
%        if(iAxis == 1)
%             Xdata = VT.f  ;
%             Ydata = VT.AR ;
%        else
        if(iAxis == 2)
            VT.NasalVowel.Geometry.PharynxDL = tempLength;
            VT.NasalVowel.Geometry.PharynxArea =  tempArea ;
       elseif(iAxis == 3)
            VT.NasalVowel.Geometry.OralDL =  tempLength;
            VT.NasalVowel.Geometry.OralArea =  tempArea;
       elseif(iAxis == 4)
            VT.NasalVowel.Geometry.NasalBackDL = tempLength;
            VT.NasalVowel.Geometry.NasalBackArea =  tempArea;
       elseif(iAxis == 5)
%             VT.NasalVowel.Geometry.NostrilDL(1, :) = tempLength;
%             VT.NasalVowel.Geometry.NostrilArea(1, :) =  tempArea;
            VT.NasalVowel.Geometry.NostrilDL1 = tempLength;  
            VT.NasalVowel.Geometry.NostrilArea1 =  tempArea;
            VT.NasalVowel.Geometry.NostrilDL = tempLength;  
            VT.NasalVowel.Geometry.NostrilArea =  tempArea;
       elseif(iAxis == 6)
%            VT.NasalVowel.Geometry.NostrilDL(2, :) = tempLength;
%            VT.NasalVowel.Geometry.NostrilArea(2, :) =  tempArea;
           VT.NasalVowel.Geometry.NostrilDL2 = tempLength;
           VT.NasalVowel.Geometry.NostrilArea2 =  tempArea;
       end
       
       
   case 8  % 'Nasals with sinus'
  otherwise
      disp('Unknown method. happened in set_plotdata')
end

% update plots display on screen
%------------------------------------
  ud = get(VT.handles.vtar,'userdata');
  filtview('plots', ud.prefs.plots) ;

return ;

% 
% switch VT.CurrentCategory
%    
%    case 2  % 'Vowel'
%        if(iAxis == 1)
%             Xdata = VT.f  ;
%             Ydata = VT.AR ;
%        elseif(iAxis == 2)
%             Xdata = VT.Vowel.Geometry.Length ;
%             Ydata = VT.Vowel.Geometry.Cross_Area ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        end
%        
%    case 3  % 'Consonant'
%        if(iAxis == 1)
%             Xdata = VT.f  ;
%             Ydata = VT.AR ;
%        elseif(iAxis == 2)
%             Xdata = VT.Consonant.Geometry.Length ;
%             Ydata = VT.Consonant.Geometry.Cross_Area ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        end
%        
%    case 4  % 'Nasal'
%        
%        if(iAxis == 1)
%             Xdata = VT.f  ;
%             Ydata = VT.AR ;
%        elseif(iAxis == 2)
%             Xdata = VT.Nasal.Geometry.PharynxDL ;
%             Ydata = VT.Nasal.Geometry.PharynxArea ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 3)
%             Xdata = VT.Nasal.Geometry.OralDL ;
%             Ydata = VT.Nasal.Geometry.OralArea ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 4)
%             Xdata = VT.Nasal.Geometry.NasalBackDL ;
%             Ydata = VT.Nasal.Geometry.NasalBackArea ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 5)
%            switch VT.Nasal.Geometry.TwoNostril   % 
%                case 0 
%                     Xdata = VT.Nasal.Geometry.OralDL(1, :) ;
%                     Ydata = VT.Nasal.Geometry.OralArea(1, :) ;
%                     [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%                case 1 % if yes, 
%                     Xdata = VT.Nasal.Geometry.OralDL(1, :) ;
%                     Ydata = VT.Nasal.Geometry.OralArea(1, :) ;
%                     [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%                  otherwise 
%            end
%        elseif(iAxis == 6)
%            Xdata = VT.Nasal.Geometry.OralDL(2, :) ;
%            Ydata = VT.Nasal.Geometry.OralArea(2, :) ;
%            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        end
%        
%    case 5  % '/r/'
%        if(iAxis == 1)
%             Xdata = VT.f  ;
%             Ydata = VT.AR ;
%        elseif(iAxis == 2)
%             Xdata = VT.Rhotic.Geometry.BackDL ;
%             Ydata = VT.Rhotic.Geometry.BackArea ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 3)
%             Xdata = VT.Rhotic.Geometry.FrontDL ;
%             Ydata = VT.Rhotic.Geometry.FrontArea ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 4)
%            Xdata = VT.Rhotic.Geometry.SublingualDL ;
%            Ydata = VT.Rhotic.Geometry.SublingualArea ;
%            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        end
% 
%    case 6  % '/l/'
%        if(iAxis == 1)
%             Xdata = VT.f  ;
%             Ydata = VT.AR ;
%        elseif(iAxis == 2)
%             Xdata = VT.Lateral.Geometry.BackDL ;
%             Ydata = VT.Lateral.Geometry.BackArea ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 3)
%             Xdata = VT.Lateral.Geometry.FrontDL ;
%             Ydata = VT.Lateral.Geometry.FrontArea ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 4)
%             Xdata = VT.Lateral.Geometry.LateralDL1 ;
%             Ydata = VT.Lateral.Geometry.LateralArea1 ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 5)
%             Xdata = VT.Lateral.Geometry.LateralDL2 ;
%             Ydata = VT.Lateral.Geometry.LateralArea2 ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        elseif(iAxis == 6)
%             Xdata = VT.Lateral.Geometry.SupralingualDL ;
%             Ydata = VT.Lateral.Geometry.SupralingualArea ;
%             [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
%        end
% 
%    case 7  % 'Nasalized vowel'
%    case 8  % 'Nasals with sinus'
%   otherwise
%       disp('Unknown method. happened in get_plotdata')
% end
% 
% return ;
% 
% 


