% This function is to get plot data based on the category and which part of
% the area function for each sound.
% 
%  - recalled by filtview(...,'plots')
%
%  to get plot data for 8 subplots in interface
%
%  iAxis, -  which axis 
%  hAxis (used for getting schematic of each sound when iAxis is 8) -  handle of axis for title , xlable and ylalel
%---------------------------------------------------------
function [Xdata , Ydata] = get_plotdata(iAxis, hAxis)
global VT ;

% assumed initial value
Xdata = [0] ;
Ydata = sin(Xdata) ;


% if iAxis is 8, Xdata will be handles to lines and others in schematic of
% sound , VT.numplots = =32 not 8 
if(iAxis == VT.numplots)
            Ydata = 0  ;     
    switch VT.CurrentCategory
        case 3 % 
            Xdata = fimread(3, 1, hAxis)  ;  
        case 4 % nasal
            Xdata = fimread(4, 1, hAxis) ; 
        case 5 % \r\
            switch VT.Rhotic.Geometry.Type
                case 1
                    Xdata = fimread(5,1, hAxis) ; 
                case 2
                    Xdata = fimread(5,2, hAxis) ; 
                otherwise
                    errordlg('error in reading image due to wrong  Type of model ', 'Error', 'modal') ;
            end
        case 6 % \l\
            Xdata = fimread(6, 1, hAxis) ; %
        case 7 
            Xdata = fimread(7, 1, hAxis) ; %
        case 8  % arbitrary 
            Xdata = plotTree(8, hAxis) ; %
        otherwise
    end
end

% reset plots
%  VT.CurrentCategory~=8 is a special case
if (VT.CurrentModeltype == 1 & VT.CurrentGeneric==1 & VT.CurrentCategory~=8);
    return ;
end

switch VT.CurrentCategory
   case 2  % 'Vowel'
       if(iAxis == 1)
            Xdata = VT.f  ;
            Ydata = VT.AR ;
       elseif(iAxis == 2)
            Xdata = VT.Vowel.Geometry.DL ;
            Ydata = VT.Vowel.Geometry.Area ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       end
       
   case 3  % 'Consonant'
       if(iAxis == 1)
            Xdata = VT.f  ;
            Ydata = VT.AR ;
       elseif(iAxis == 2)
            Xdata = VT.Consonant.Geometry.DL ;
            Ydata = VT.Consonant.Geometry.Area ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       end
       
   case 4  % 'Nasal'
       
       if(iAxis == 1)
            Xdata = VT.f  ;
            Ydata = VT.AR ;
       elseif(iAxis == 2)
            Xdata = VT.Nasal.Geometry.PharynxDL ;
            Ydata = VT.Nasal.Geometry.PharynxArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 3)
            Xdata = VT.Nasal.Geometry.OralDL ;
            Ydata = VT.Nasal.Geometry.OralArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 4)
            Xdata = VT.Nasal.Geometry.NasalBackDL ;
            Ydata = VT.Nasal.Geometry.NasalBackArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 5)
           switch VT.Nasal.Geometry.TwoNostril   % 
               case 0 
                    Xdata = VT.Nasal.Geometry.NostrilDL1(1, :) ;
                    Ydata = VT.Nasal.Geometry.NostrilArea1(1, :) ;
                    [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
               case 1 % if yes, 
                    Xdata = VT.Nasal.Geometry.NostrilDL1(1, :) ;
                    Ydata = VT.Nasal.Geometry.NostrilArea1(1, :) ;
                    [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
                 otherwise 
           end
       elseif(iAxis == 6)
           Xdata = VT.Nasal.Geometry.NostrilDL2(1, :) ;
           Ydata = VT.Nasal.Geometry.NostrilArea2(1, :) ;
           [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       end
       
   case 5  % '\r\'
       switch VT.Rhotic.Geometry.Type
           case 1
               if(iAxis == 1)
                   Xdata = VT.f  ;
                   Ydata = VT.AR ;
               elseif(iAxis == 2)
                   Xdata = VT.Rhotic.Geometry.BackDL ;
                   Ydata = VT.Rhotic.Geometry.BackArea ;
                   [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
               elseif(iAxis == 3)
                   Xdata = VT.Rhotic.Geometry.FrontDL ;
                   Ydata = VT.Rhotic.Geometry.FrontArea ;
                   [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
               elseif(iAxis == 4)
                   Xdata = VT.Rhotic.Geometry.SublingualDL ;
                   Ydata = VT.Rhotic.Geometry.SublingualArea ;
                   [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
               end
           case 2
               if(iAxis == 1)
                   Xdata = VT.f  ;
                   Ydata = VT.AR ;
               elseif(iAxis == 2)
                   Xdata = VT.Rhotic.Geometry.MainDL ;
                   Ydata = VT.Rhotic.Geometry.MainArea ;
                   [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
               elseif(iAxis == 3)
                   Xdata = VT.Rhotic.Geometry.SublingualDL ;
                   Ydata = VT.Rhotic.Geometry.SublingualArea ;
                   [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
               end
           otherwise
               errordlg('Error in \r\ model type', 'Error', 'modal') ;
       end    
       

   case 6  % '\l\'
       if(iAxis == 1)
            Xdata = VT.f  ;
            Ydata = VT.AR ;
       elseif(iAxis == 2)
            Xdata = VT.Lateral.Geometry.BackDL ;
            Ydata = VT.Lateral.Geometry.BackArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 3)
            Xdata = VT.Lateral.Geometry.FrontDL ;
            Ydata = VT.Lateral.Geometry.FrontArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 4)
            Xdata = VT.Lateral.Geometry.SupralingualDL ;
            Ydata = VT.Lateral.Geometry.SupralingualArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 5)
            Xdata = VT.Lateral.Geometry.LateralDL1 ;
            Ydata = VT.Lateral.Geometry.LateralArea1 ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 6)
            Xdata = VT.Lateral.Geometry.LateralDL2 ;
            Ydata = VT.Lateral.Geometry.LateralArea2 ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       end

   case 7  % 'Nasalized vowel'
              if(iAxis == 1)
            Xdata = VT.f  ;
            Ydata = VT.AR ;
       elseif(iAxis == 2)
            Xdata = VT.NasalVowel.Geometry.PharynxDL ;
            Ydata = VT.NasalVowel.Geometry.PharynxArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 3)
            Xdata = VT.NasalVowel.Geometry.OralDL ;
            Ydata = VT.NasalVowel.Geometry.OralArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 4)
            Xdata = VT.NasalVowel.Geometry.NasalBackDL ;
            Ydata = VT.NasalVowel.Geometry.NasalBackArea ;
            [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       elseif(iAxis == 5)
           switch VT.NasalVowel.Geometry.TwoNostril   % 
               case 0 
                    Xdata = VT.NasalVowel.Geometry.NostrilDL1(1, :) ;
                    Ydata = VT.NasalVowel.Geometry.NostrilArea1(1, :) ;
                    [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
               case 1 % if yes, 
                    Xdata = VT.NasalVowel.Geometry.NostrilDL1(1, :) ;
                    Ydata = VT.NasalVowel.Geometry.NostrilArea1(1, :) ;
                    [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
                 otherwise 
           end
       elseif(iAxis == 6)
%            Xdata = VT.NasalVowel.Geometry.NostrilDL(2, :) ;
%            Ydata = VT.NasalVowel.Geometry.NostrilArea(2, :) ;
           Xdata = VT.NasalVowel.Geometry.NostrilDL2(1, :) ;
           Ydata = VT.NasalVowel.Geometry.NostrilArea2(1, :) ;
           [Xdata Ydata] = lengh_to_distance(Xdata, Ydata) ;
       end

   case 8  % 'Arbitrary'
       if(iAxis == 1)
           Xdata = VT.f  ;
           Ydata = VT.AR ;
       elseif(iAxis < VT.numplots)
%                th = get(hAxis,'title');
%               temp = get(th,'string') ;
%               num = str2num(temp(5:end)) ; 
                num = iAxis -1 ;  % plot of area function starts from second axis
              Xdata = VT.Arbitrary.Geometry.Tube(num).secLen ;
              Ydata = VT.Arbitrary.Geometry.Tube(num).secArea ;
              
                  if(VT.Arbitrary.Geometry.Tube(num).numOfSections<=0)
                      Xdata = 0 ;
                      Ydata = 0 ;
                  else
                      ind = VT.Arbitrary.Geometry.Tube(num).numOfSections ;
                      [Xdata Ydata] = lengh_to_distance(Xdata(1:ind), Ydata(1:ind)) ;
                  end
                  
             % how about two channels modules
              if(VT.Arbitrary.Geometry.Tube(num).typeOfModule == 2)
                  Xdata1 = VT.Arbitrary.Geometry.Tube(num).secLen1 ;
                  Ydata1 = VT.Arbitrary.Geometry.Tube(num).secArea1 ;
                  if(VT.Arbitrary.Geometry.Tube(num).numOfSections1<=0)
                      Xdata1 = 0 ;
                      Ydata1 = 0 ;
                  else
                      ind = VT.Arbitrary.Geometry.Tube(num).numOfSections1 ;
                      [Xdata1 Ydata1] = lengh_to_distance(Xdata1(1:ind), Ydata1(1:ind)) ;
                  end
                  line(Xdata1 , Ydata1, 'parent', hAxis, 'color', 'r', 'tag','extra_lines') ;
              end
                  
              % 
%               ind = find(Xdata = 0) ;
%               if (~isempty(ind))
%                   if(ind(1)==1)
%                       Xdata = 0 ;
%                       Ydata = 0 ;
%                   else
%                       [Xdata Ydata] = lengh_to_distance(Xdata(1:ind(1)), Ydata(1:ind(1)) ;
%                   end
%               end
              
       end
  otherwise
      disp('Unknown method. happened in get_plotdata')
end

return ;


% Plot the schematic for each sound
% 
% to get the coordinates, I use paintbrush to draw the schematic as bmp
% image , and then load it into matlab using imread() and imshow(). Finally
% I use ginput() to get the coordinates by clicking mouse.
%-----------------------------------------------------------
function Xdata = fimread(Category, Type, hAxis)

% get(hAxis) ;
Xdata = 0 ;
switch Category
    case 3 
    case 4 %nasal
        Ymax = 290 ; Xmax = 450 ;
        % lines
        X1 = [421   339   339   259   259   242   242   296   296   394   394   431   431   394   394   298   298   157   157    61    61    20    20    61    61   158   158   208   208   260   260   339   339   420] ; 
        Y1 = [94    94   106   106    74    74   170   170   142   142   168   168   208   208   237   237   210   210   239   239   204   204   175   175   143   143   170   170    42    42    10    10    25    25] ;    
        X1 = [421   339   339   259   259   242   242   296   296   394   394   431   431   394   394   298   298   157   157    61    61    20    20    61    61   158   158   228   228   260   260   339   339   420] ; 
        Y1 = [94    94   106   106    74    74   170   170   142   142   168   168   208   208   237   237   210   210   239   239   204   204   175   175   143   143   170   170    42    42    10    10    25    25] ;    
        X2 = [420   340   340   420] ;
        Y2 = [67    67    52    52] ;
        Y1 = Ymax-Y1-10 ;
        Y2 = Ymax-Y2-10 ;
        Xdata(1, :) = line(X1/Xmax, Y1/Ymax, 'color', 'k', 'Parent', hAxis) ;
        Xdata(2, :) = line(X2/Xmax, Y2/Ymax, 'color', 'k', 'Parent', hAxis) ;
        
        % static text 
        Xpos = [  80    80   320   320   280   280   360   360 ] ;
        Ypos = [ 184   215   185   211    47    78    23   128] ;
        staticText = {'Back', 'cavity', 'Oral', 'cavity', 'Velar', 'tube', 'Nostril_1', 'Nostril_2'} ;
        Ypos = Ymax - Ypos ; % it has to be reversed , since the image 's coordinate in y is reversed
        Xpos = Xpos/Xmax ;
        Ypos = Ypos/Ymax ;
        h = 0 ;
        
        pos = get(hAxis, 'position') ;
        %         pos(3)/pos(4)
        % To get right proportion of text in schematic, the size of text
        % should be adjusted corresponding to the aspe?? ratio.
        if (pos(3)/pos(4)<1.8)
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/16  ) ; %, 'FontUnits', 'normal') ;
            end
        elseif (pos(3)/pos(4)<=2)
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/12.5  ) ; %, 'FontUnits', 'normal') ;
            end
        else
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/11  ) ; %, 'FontUnits', 'normal') ;
            end
        end
        
        set(h(:), 'FontWeight', 'bold') ; %, 'FontUnits', 'normalized');
        Xdata = [Xdata; h(:)] ;   
        
        
    case 5 %\r\
        Ymax = 140 ; Xmax = 300 ;
        X = [ 285   269   269   244   244   210   210   228   228   198   198   131   131    80    80     3     3    80    80   131   131   197   197   227  227   267   267   285] ;
        Y = [ 69    69    60    60    38    38    53    53    61    61    31    31    54    54    31    31   104   104    74    74   104   104    69    69    89    89    75    75] ;
        X = X+5 ;
        Xdata = line(X/Xmax, Y/Ymax, 'color', 'k', 'Parent', hAxis) ;
        
        switch Type
            case 1
                % static text
                Xpos = [67   214   205   206] ;
                Xpos = Xpos + 5 ;
                %    Ypos = [18    36   114   134] ;
                Ypos = [18    36   114   128] ;
                Ypos = Ymax - Ypos ;
                Xpos = Xpos/Xmax ;
                Ypos = Ypos/Ymax ;
                staticText = {'Back cavity', 'Front cavity','Sublingual','cavity'} ;
                
            case 2  % main cavity
                %                 130
                %                 15
                % static text
                Xpos = [130   205   206] ;
                Xpos = [130   200   200] ;
                Xpos = Xpos + 5 ;
                %    Ypos = [18    36   114   134] ;
                Ypos = [18  114   128] ;
                Ypos = Ymax - Ypos ;
                Xpos = Xpos/Xmax ;
                Ypos = Ypos/Ymax ;
                staticText = {'Main cavity','Sublingual','cavity'} ;
            otherwise
                errordlg('error in reading image due to wrong  Type of model ', 'Error', 'modal') ;
        end
        h = 0 ;
        
        pos = get(hAxis, 'position') ;
        %         pos(3)/pos(4)
        if (pos(3)/pos(4)<1.8)
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/16  ) ; %, 'FontUnits', 'normal') ;
            end
        elseif (pos(3)/pos(4)<=2)
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/12.5  ) ; %, 'FontUnits', 'normal') ;
            end
        else
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/11  ) ; %, 'FontUnits', 'normal') ;
            end
        end
        
        set(h(:), 'FontWeight', 'bold');
        Xdata = [Xdata; h(:)] ;
        
        
    case 6 %\l\
        
        Ymax = 400 ; Xmax = 900; % 800 ;
        
        % profile of lateral
        X1 = [ 745   694   694   410   410   302   302   172   172    18    18   174   174   304   304   410   410   639   639   460   460   694   694   745 ] ;
        Y1 = [ 257   257   286   286   347   347   286   286   347   347   136   136   196   196   137   137    18    18    76    76   166   166   197   197 ] ;
        Y1 = Ymax-Y1 ;
        Xdata(1, :) = line(X1/Xmax, Y1/Ymax, 'color', 'k', 'Parent', hAxis) ;
        
        center = [570 225] ;
        a = (640-494)/2 ;
        b = (257-226)/2 ;
        
        % calculate the patch 's coordinates
        theta = 0: 0.01: 2*pi ;
        X2 = center(1)+a*cos(theta) ;
        Y2 = center(2)+b*sin(theta) ;
        % delete(h) ;
        h = 0 ;
        Y2 = Ymax-Y2 ;
        
        h = patch(X2/Xmax, Y2/Ymax, 'k', 'Parent', hAxis) ; %, [0.8 0.8 0.8]) ;
        Xdata(2, :) = h ; % line(X2/Xmax, Y2/Ymax, 'color', 'k') ;
        
        X3 = [170   471   691   490   490] ;
        Y3 = [240    100   228   188   266] ;
        
        staticText = {'Back cavity', 'Supralingual cavity', 'Front cavity', 'Channel 1', 'Channel 2'} ; 
        
        Ypos = Ymax - Y3 ;
        Xpos = X3/Xmax ;
        Ypos = Ypos/Ymax ;
        h = 0 ;
        
        pos = get(hAxis, 'position') ;
        if (pos(3)/pos(4)<1.8)
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/16  ) ; %, 'FontUnits', 'normal') ;
            end
        elseif (pos(3)/pos(4)<=2)
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/12.5  ) ; %, 'FontUnits', 'normal') ;
            end
        else
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/10.5  ) ; %, 'FontUnits', 'normal') ;
            end
        end
        
        set(h(:), 'FontWeight', 'bold') ; %, 'FontUnits', 'normalized');
        Xdata = [Xdata; h(:)] ;   
        return ;

        
    case 7 
        Xdata = 0 ;
        Ymax = 290 ; Xmax = 450 ;
        X11 = [421   339   339   259   259   242   242   296   296   394   394   431 ] ;   
        Y11 = [94    94   106   106    74    74   170   170   142   142   168   168  ] ;
        X12 = [431   394   394   298   298   157   157    61    61    20    20    61    61   158   158   228   228   260   260   339   339   420] ; 
        Y12 = [ 208   208   237   237   210   210   239   239   204   204   175   175   143   143   170   170    42    42    10    10    25    25] ;    
        X2 = [420   340   340   420] ;
        Y2 = [67    67    52    52] ;
        
        Y11 = Ymax-Y11-10 ;
        Y12 = Ymax-Y12-10 ;
        Y2 = Ymax-Y2-10 ;
        Xdata(1, :) = line(X11/Xmax, Y11/Ymax, 'color', 'k', 'Parent', hAxis) ;
        Xdata(2, :) = line(X12/Xmax, Y12/Ymax, 'color', 'k', 'Parent', hAxis) ;
        Xdata(3, :) = line(X2/Xmax, Y2/Ymax, 'color', 'k', 'Parent', hAxis) ;
        
        Xpos = [  80    80   320   320   280   280   360   360 ] ;
        Ypos = [ 184   215   185   211    47    78    23   128] ;
        staticText = {'Back', 'cavity', 'Oral', 'cavity', 'Velar', 'tube', 'Nostril_1', 'Nostril_2'} ;

        
        Ypos = Ymax - Ypos ;
        Xpos = Xpos/Xmax ;
        Ypos = Ypos/Ymax ;
        h = 0 ;
        
        
        pos = get(hAxis, 'position') ;
        %         pos(3)/pos(4)
        if (pos(3)/pos(4)<1.8)
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/16  ) ; %, 'FontUnits', 'normal') ;
            end
        elseif (pos(3)/pos(4)<=2)
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/12.5  ) ; %, 'FontUnits', 'normal') ;
            end
        else
            for i = 1: length(Xpos) 
                h(i) = text(Xpos(i), Ypos(i), staticText{i}, 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/11  ) ; %, 'FontUnits', 'normal') ;
            end
        end
        
        set(h(:), 'FontWeight', 'bold') ; %, 'FontUnits', 'normalized');
        Xdata = [Xdata; h(:)] ;   
        
        
    otherwise
end

return ;


% plot a schematic for arbitrary type of sound 
function             Xdata = plotTree(Category, hAxis)
global VT 
global currentTube ; 


global loopTest  % for check loop exist staring from glottis
global Xmin Xmax Ymin Ymax  % for set up the axes x and y limit of schematic
global endLips  endNostril1  endNostril2  % for check the duplicate tubes with lips, nostrils, used in plotNode() in this file

Xmin = 0 ;  Xmax = 0.00001 ; 
Ymin = 0 ;  Ymax = 0.00001 ; 
endLips = 0 ;
endNostril1 = 0 ;
endNostril2 = 0 ;

% constants
TWOCHANNELS = 2 ;
GLOTTIS = 2 ;
LIPS = 2 ;
NOSTRIL1 = 3 ;
NOSTRIL2 = 4 ;
END = 99900000  ;
CHANNEL_1 =  20000000 ; 
CHANNEL_2 =  40000000 ;


startPos = [0 0] ;

Xdata = 0 ;

currentTube = VT.Arbitrary.Geometry.Tube ;
root = 0 ;

% find the first tube staring from glottis ;
% find the root of tree
for i = 1: VT.maxnumTubes
   if(currentTube(i).typeOfStartofTube == GLOTTIS) 
       if(root~=0) 
           errordlg(['Just one tube can start from glottis: ' 'branch ' num2str(root) ' or   branch ' num2str(i) ], 'Error', 'modal') ;    
       else
           root = i ;     
       end
   end
end

% no root
if (root == 0)
    return ;
end

% bubble sorting the children branches
for i = 1: VT.maxnumTubes
    currentTube(i)=  bubbleSorting(currentTube(i)) ; 
end


% calculate width and height , also required height for plotting
currentTube(1).Width = [] ;
currentTube(1).Height = [] ;
currentTube(1).heightReq = [] ;
heightTubegroup(root) ;


loopTest = ones(1,VT.maxnumTubes ) ; 
Xdata = plotNode (root, startPos, hAxis) ;
ind = find(Xdata ~= 0) ;
Xdata = Xdata(ind(:)) ;  % get rid of Xdata 's element with  zero

set(hAxis, 'xlim', [Xmin-1.4 Xmax+3.4], 'ylim', [Ymin-1.4 Ymax+1.4]) ;


return 



% (i).IndexOfBranch = [ -1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).typeOfModule  = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).typeOfStartofTube = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).typeOfEndofTube   = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).numOfSections = [ 0 ] ;
%     VT.Arbitrary.Geometry.Tube(i).secLen = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).secArea = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).numOfSections1 = [ 0 ] ;
%     VT.Arbitrary.Geometry.Tube(i).secLen1 = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).secArea1 = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranches = zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLoc =  zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLocEnd =  zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLocChannel =  ones(1, 10) ;
% 


% do bubble sorting for schematic display nicely
function Output = bubbleSorting(Tube)

END = 99900000  ;
% do some change in order to do sorting conveniently
for i = 1: length(Tube.nextBranches)
    if(Tube.nextBranches(i) == 0) 
        Tube.nextBranchesLoc(i) = 0 ;
    elseif(Tube.nextBranchesLocEnd(i) == 1)
        Tube.nextBranchesLoc(i) = END ;
    end            
end

for i = length(Tube.nextBranches): -1: 1
    for j = 2:i
        if (Tube.nextBranchesLoc(j-1) < Tube.nextBranchesLoc(j))
            temp1 = Tube.nextBranches(j-1) ;
            temp2 = Tube.nextBranchesLoc(j-1) ;
            temp3 = Tube.nextBranchesLocEnd(j-1) ;
            Tube.nextBranches(j-1)       = Tube.nextBranches(j) ;
            Tube.nextBranchesLoc(j-1)    = Tube.nextBranchesLoc(j) ;
            Tube.nextBranchesLocEnd(j-1) = Tube.nextBranchesLocEnd(j) ;
            Tube.nextBranches(j)       = temp1 ; 
            Tube.nextBranchesLoc(j)    = temp2 ;
            Tube.nextBranchesLocEnd(j) = temp3 ;
        end
    end
end
Output = Tube ;
return ;

%   for (i = (array_size - 1); i >= 0; i--)
%   {
%     for (j = 1; j <= i; j++)
%     {
%       if (locations[j-1] > locations[j])
%       {
%         temp1 = locations[j-1];
%         locations[j-1] = locations[j];
%         locations[j] = temp1;
% 
%         temp2 = branches[j-1];
%         branches[j-1] = branches[j];
%         branches[j] = temp2;
% 
%       }
%     }
%   }

function Output = plotNode (root, startPos, hAxis) 

global currentTube ; 
global loopTest 
global endLips  endNostril1  endNostril2  % for check the duplicate tubes with lips, nostrils, used in plotNode() in this file

% constants
% TWOCHANNELS = 2 ;
GLOTTIS = 2 ;
LIPS = 2 ;
NOSTRIL1 = 3 ;
NOSTRIL2 = 4 ;

if (loopTest(root) == 1) % first vist 
    loopTest(root) = 0 ;
else 
    errordlg(['Connection loop exist at branch ' num2str(root)], 'Error', 'modal') ;
    Output = 0 ;
    return ;
end


% check if duplicate tubes with LIPS, Nostirl .....
   if(currentTube(root).typeOfEndofTube == LIPS) 
       if(endLips~=0) 
           errordlg(['Just one tube can end at lips: ' 'branch ' num2str(endLips) ' or   branch ' num2str(root) ], 'Error', 'modal') ;    
       else
           endLips = root ;     
       end
   end
   if(currentTube(root).typeOfEndofTube == NOSTRIL1) 
       if(endNostril1~=0) 
           errordlg(['Just one tube can end at NOSTRIL 1: ' 'branch ' num2str(endNostril1) ' or   branch ' num2str(root) ], 'Error', 'modal') ;    
       else
           endNostril1 = root ;     
       end
   end
   if(currentTube(root).typeOfEndofTube == NOSTRIL2) 
       if(endNostril2~=0) 
           errordlg(['Just one tube can end at NOSTRIL 2: ' 'branch ' num2str(endNostril2) ' or   branch ' num2str(root) ], 'Error', 'modal') ;    
       else
           endNostril2 = root ;     
       end
   end  


% get dimension size of tube ;
Width  = currentTube(root).Width ;
Height = currentTube(root).Height ;

% Width = sum(currentTube(root).secLen( 1:currentTube(root).numOfSections)) ;
% if (Width == 0) Width = 1 ; end  % in case no data there 
% 
% Height = sum(currentTube(root).secArea( 1:currentTube(root).numOfSections)) ;
% if (Height == 0 | currentTube(root).numOfSections==0) % in case no data there 
%     Height = 1 ;
% else
%     Height = Height / currentTube(root).numOfSections ;
% end

% plot the tube based on its size and starting position
h = plotBox(root, Width, Height, startPos, hAxis) ;
Output = [ h(:)] ;

newStartPos = [ startPos(1)+Width+1 startPos(2)] ; 
%     xPos = [startPos(1) newStartPos(1)] ; 
%     yPos = [startPos(2) newStartPos(2)] ; 
%     h(1) = line(xPos, yPos, 'parent', hAxis) ;
%     
%     
%     h(2) = text(startPos(1), startPos(2), num2str(root), 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/12.5  ) ;
%     Output = h(:) ;

j = 0 ;
for i = 1: length(currentTube(root).nextBranches)
    if(currentTube(root).nextBranches(i) == 0)  % one branches
        continue ; 
        %errordlg('Program error : currentTube(root).nextBranches(i) == 0') ;    
    end
    
    j = j+1 ;
    % first child
    if (j==1)
        % based on the first children 
        if(currentTube(root).nextBranchesLocEnd(i) == 1) % side branch or end branch
            newStartPos = [ startPos(1)+Width+1 startPos(2)] ; 

            % draw a line to connect this node to one of its children
            xPos = [startPos(1) newStartPos(1)] ;
            yPos = [startPos(2) newStartPos(2)] ;
            h    = line(xPos, yPos, 'color', 'k', 'LineWidth', 0.5, 'parent', hAxis) ;
            Output = [Output(:); h(:)] ;

        else
            % in case user may input some strange number in location
            if(currentTube(root).nextBranchesLoc(i) >0 & currentTube(root).nextBranchesLoc(i) <=Width)
                newStartPos = [ startPos(1)+currentTube(root).nextBranchesLoc(i) startPos(2)+Height+1] ; 
            else
                errordlg(['Input error : branching location is larger than the length of tube or location is zero : branch ' num2str(currentTube(root).nextBranches(i)), '  on brach ' num2str(root) ], 'Error', 'modal') ;    
                newStartPos = [ startPos(1)+Width/2 startPos(2)+Height+1] ; 
            end
            % draw a line to connect this node to one of its children
            xPos = [newStartPos(1) newStartPos(1)] ;
            yPos = [startPos(2)+Height newStartPos(2)] ;
            h    = line(xPos, yPos, 'color', 'k', 'LineWidth', 0.5, 'parent', hAxis) ;
            Output = [Output(:); h(:)] ;
        end
        h = plotNode (currentTube(root).nextBranches(i), newStartPos, hAxis) ;
        Output = [Output(:); h(:)] ;
    else
%        heightReq = heightTubegroup(currentTube(root).nextBranches(i-1)) ;     
        heightReq = currentTube( currentTube(root).nextBranches(i-1) ).heightReq  ;     

        newStartPos(2) = newStartPos(2)+heightReq ; 
        if(currentTube(root).nextBranchesLocEnd(i) == 1) % side branch or end branch
            newStartPos(1) = startPos(1)+Width+1  ; 
            
            % draw a line to connect this node to one of its children
            xPos = [startPos(1) newStartPos(1) newStartPos(1)] ;
            yPos = [startPos(2) startPos(2) newStartPos(2)] ;
            h    = line(xPos, yPos, 'color', 'k', 'LineWidth', 0.5, 'parent', hAxis) ;
            Output = [Output(:); h(:)] ;
        else
            % in case user may input some strange number in location
            if(currentTube(root).nextBranchesLoc(i) >0 & currentTube(root).nextBranchesLoc(i) <=Width)
                newStartPos(1) = startPos(1)+currentTube(root).nextBranchesLoc(i)  ; 
            else
                errordlg(['Input error : branching location is larger than the length of tube or location is zero : branch ' num2str(currentTube(root).nextBranches(i)), '  on brach ' num2str(root) ], 'Error', 'modal') ;    
%                errordlg(['Input error : branching location is larger than the length of tube or location is zero : ' num2str(root) ]) ;    
                newStartPos(1) = startPos(1)+Width/2  ; 
            end
            
            % in case that the height is larger than the position of chid
            % branch 
            if(newStartPos(2)<= startPos(2)+Height )
                newStartPos(2)= startPos(2) + Height + 1 ;
            end
                
            % draw a line to connect this node to one of its children
            xPos = [newStartPos(1) newStartPos(1)] ;
            yPos = [startPos(2)+Height newStartPos(2)] ;
            h    = line(xPos, yPos, 'color', 'k', 'LineWidth', 0.5, 'parent', hAxis) ;
            Output = [Output(:); h(:)] ;

        end
        h = plotNode (currentTube(root).nextBranches(i), newStartPos, hAxis) ;
        Output = [Output(:); h(:)] ;
    end
    
%     if(currentTube(root).nextBranches(i) ~= 0)  % one branches
%         h = plotNode (currentTube(root).nextBranches(i),[newStartPos(1) newStartPos(2)+j*5], hAxis) ;
%         Output = [Output(:); h(:)] ;
%         j = j+1 ;
%     end
end
return ;
% 
% (i).IndexOfBranch = [ -1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).typeOfModule  = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).typeOfStartofTube = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).typeOfEndofTube   = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).numOfSections = [ 0 ] ;
%     VT.Arbitrary.Geometry.Tube(i).secLen = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).secArea = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).numOfSections1 = [ 0 ] ;
%     VT.Arbitrary.Geometry.Tube(i).secLen1 = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).secArea1 = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranches = zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLoc =  zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLocEnd =  zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLocChannel =  ones(1, 10) ;
% 


% plot one tube     
function Output = plotBox(root, Width, Height, startPos, hAxis) 
global Xmin  Xmax Ymin Ymax ;
global currentTube ; 
TWOCHANNELS = 2 ;
GLOTTIS = 2 ;
LIPS = 2 ;
NOSTRIL1 = 3 ;
NOSTRIL2 = 4 ;
END = 99900000  ;
CHANNEL_1 =  20000000 ; 
CHANNEL_2 =  40000000 ;

% max and min x and y  cooridnates
temp = startPos(1)+Width ; 
if (temp > Xmax) Xmax = temp; end ;
% temp = startPos(2)-0.5*Height  ; 
% if (temp < Ymin) Ymin = temp ; end ;
temp = startPos(2)+Height ; 
if (temp > Ymax) Ymax = temp ; end;

% box
xPos = [startPos(1) startPos(1)+Width startPos(1)+Width startPos(1) startPos(1) ] ;
yPos = [startPos(2) startPos(2) startPos(2)+Height startPos(2)+Height startPos(2)] ;
h(1)    = line(xPos(1:2), yPos(1:2), 'color', 'k', 'LineWidth', 2, 'parent', hAxis) ;
h(2)    = line(xPos(3:4), yPos(3:4), 'color', 'k', 'LineWidth', 2, 'parent', hAxis) ;
h(4)    = line(xPos([1 4]), yPos([1 4]), 'color', 'k', 'LineWidth', 0.3, 'parent', hAxis) ;

% if tube ends without any children at the end , and its end is not LIPS,
% NOSTRIL,  it is supposed to be closed end , so the line has high weight
ind = find(currentTube(root).nextBranchesLocEnd==1 & currentTube(root).nextBranches~=0) ;
if (isempty(ind) & currentTube(root).typeOfEndofTube~=LIPS & currentTube(root).typeOfEndofTube~=NOSTRIL1 & currentTube(root).typeOfEndofTube~=NOSTRIL2) ; 
    h(3)    = line(xPos(2:3), yPos(2:3), 'color', 'k', 'LineWidth', 2, 'parent', hAxis) ;
else
    h(3)    = line(xPos(2:3), yPos(2:3), 'color', 'k', 'LineWidth', 0.3, 'parent', hAxis) ;
end
Output = h(:) ;

% determine the size of font in plot 
pos = get(hAxis, 'position') ;
 %pos(3)/pos(4)
if (pos(3)/pos(4)<1.8)
    sizeFont = 1/20;
elseif (pos(3)/pos(4)<=2.5)
    sizeFont = 1/17;
else
    sizeFont = 1/9;
end

% number 
if (currentTube(root).typeOfModule == TWOCHANNELS)
    h = text(startPos(1)+0.5*Width, startPos(2)+0.5*Height, [num2str(root) '(2-channel)'], 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize',sizeFont); % 1/12.5  ) ;
else
    h = text(startPos(1)+0.5*Width, startPos(2)+0.5*Height, num2str(root), 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize',sizeFont); % 1/12.5  ) ;
end
Output = [Output;  h(:)] ;

% G, L, N, N
if(currentTube(root).typeOfStartofTube == GLOTTIS)
    h = text(startPos(1)+0.2, startPos(2)+0.5*Height, 'Glottis', 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', sizeFont); %1/12.5  ) ;
    Output = [Output;  h(:)] ;
end

if(currentTube(root).typeOfEndofTube == LIPS)
    h = text(startPos(1)+Width+0.2, startPos(2)+0.5*Height, 'Lips', 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', sizeFont); %, 1/12.5  ) ;
    Output = [Output;  h(:)] ;
end
if(currentTube(root).typeOfEndofTube == NOSTRIL1 )
    h = text(startPos(1)+Width+0.2, startPos(2)+0.5*Height, 'Nostril1', 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', sizeFont); %, 1/12.5  ) ;
    Output = [Output;  h(:)] ;
end
if(currentTube(root).typeOfEndofTube == NOSTRIL2 )
    h = text(startPos(1)+Width+0.2, startPos(2)+0.5*Height, 'Nostril2', 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', sizeFont); %, 1/12.5  ) ;
    Output = [Output;  h(:)] ;
end

return ;

% to calculate the tree height , each tube's width and height
function heightReq = heightTubegroup(root)
global currentTube ; 

if ~isempty(currentTube(root).Width)
    errordlg('Loop exists in configuration !', 'Error', 'modal') ;
    heightReq = 0 ;
    return ;
end

% get dimension size of tube ;
Width = sum(currentTube(root).secLen( 1:currentTube(root).numOfSections)) ;
if (Width == 0 | Width<0.1) Width = 1 ; end  % in case no data there 

Height = sum(currentTube(root).secArea( 1:currentTube(root).numOfSections)) ;
if (Height < 0.1 | Height == 0 | currentTube(root).numOfSections==0) % in case no data there 
    Height = 0.1 ;
else
    Height = Height / currentTube(root).numOfSections ;
end

currentTube(root).Width  = Width  ;
currentTube(root).Height = Height ; 

% try to get required height for tree branches...
j = 0 ;
heightReq = 0 ;
for i = 1: length(currentTube(root).nextBranches)
    
    if(currentTube(root).nextBranches(i) == 0)  % one branches
        continue ;
    %    errordlg('Program error : currentTube(root).nextBranches(i) == 0') ;    
    end
    j = j+1 ;
    if(j==1 & ~currentTube(root).nextBranchesLocEnd(i)) % if first next is side branch , the children will start from heigt
        heightReq = Height+1 + heightReq + heightTubegroup(currentTube(root).nextBranches(i)); 
    elseif(j~=1 & ~currentTube(root).nextBranchesLocEnd(i)) % if first next is side branch , the children will start from heigt
        if (heightReq <= Height)
            heightReq = Height + 1 ;
        end
        heightReq = heightReq + heightTubegroup(currentTube(root).nextBranches(i)) ;
    else    
        heightReq = heightReq + heightTubegroup(currentTube(root).nextBranches(i)) ;
    end
end

if (heightReq < (Height+1) )
    heightReq = Height+1 ;
end
currentTube(root).heightReq = heightReq ;
return ;


return ;


% % plot one tube     
% function Output = plotBox(root, Width, Height, startPos, hAxis) 
% global Xmin  Xmax Ymin Ymax ;
% global currentTube ; 
% TWOCHANNELS = 2 ;
% GLOTTIS = 2 ;
% LIPS = 2 ;
% NOSTRIL1 = 3 ;
% NOSTRIL2 = 4 ;
% END = 99900000  ;
% CHANNEL_1 =  20000000 ; 
% CHANNEL_2 =  40000000 ;
% 
% % max and min x and y  cooridnates
% temp = startPos(1)+Width ; 
% if (temp > Xmax) Xmax = temp; end ;
% 
% temp = startPos(2)-0.5*Height  ; 
% if (temp < Ymin) Ymin = temp ; end ;
% temp = startPos(2)+0.5*Height ; 
% if (temp > Ymax) Ymax = temp ; end;
% 
% % box
% xPos = [startPos(1) startPos(1)+Width startPos(1)+Width startPos(1) startPos(1) ] ;
% yPos = [startPos(2)-0.5*Height startPos(2)-0.5*Height startPos(2)+0.5*Height startPos(2)+0.5*Height startPos(2)-0.5*Height] ;
% h    = line(xPos, yPos, 'color', 'k', 'parent', hAxis) ;
% Output = h ;
% 
% % determine the size of font in plot 
% pos = get(hAxis, 'position') ;
%  %pos(3)/pos(4)
% if (pos(3)/pos(4)<1.8)
%     sizeFont = 1/20;
% elseif (pos(3)/pos(4)<=2.5)
%     sizeFont = 1/17;
% else
%     sizeFont = 1/9;
% end
% 
% % number 
% if (currentTube(root).typeOfModule == TWOCHANNELS)
%     h = text(startPos(1)+0.5*Width, startPos(2), [num2str(root) '(2)'], 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/12.5  ) ;
% else
%     h = text(startPos(1)+0.5*Width, startPos(2), num2str(root), 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', 1/12.5  ) ;
% end
% Output = [Output;  h(:)] ;
% 
% 
% 
% % G, L, N, N
% if(currentTube(root).typeOfStartofTube == GLOTTIS)
%     h = text(startPos(1), startPos(2), 'Glottis', 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', sizeFont); %1/12.5  ) ;
%     Output = [Output;  h(:)] ;
% end
% 
% if(currentTube(root).typeOfEndofTube == LIPS)
%     h = text(startPos(1)+Width, startPos(2), 'Lips', 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', sizeFont); %, 1/12.5  ) ;
%     Output = [Output;  h(:)] ;
% end
% if(currentTube(root).typeOfEndofTube == NOSTRIL1 | currentTube(root).typeOfEndofTube == NOSTRIL2)
%     h = text(startPos(1)+Width, startPos(2), 'Nostril', 'Parent', hAxis,'FontUnits', 'normalized', 'FontSize', sizeFont); %, 1/12.5  ) ;
%     Output = [Output;  h(:)] ;
% end
% 
% %     VT.Arbitrary.Geometry.Tube(i).typeOfModule  = [ 1 ] ;
% %     VT.Arbitrary.Geometry.Tube(i). = [ 1 ] ;
% %     VT.Arbitrary.Geometry.Tube(i).   = [ 1 ] ;
% %     VT.Arbitrary.Geometry.Tube(i).numOfSections = [ 0 ] ;
% %     VT.Arbitrary.Geometry.Tube(i).secLen = zeros(1, 200) ;
% 
% return ;
% 
