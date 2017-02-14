% function  varargout = Create_handlesEditArea( Category, Type, Option, varargin)
%
% - create the edit areas for area function input
% Option -   'model' or 'generic'
%

%Create_handlesEditArea( Category, Type, Option, varargin) // ( Category, Type, Option, realtype) 
function  varargout = Create_handlesEditArea( Category, Type, Option, varargin)

global VT ;

ValidCreate = 1 ; 
% for File input or Generic input, the type of model is not determined 
if nargin == 4 
    RealType = varargin{1} ;
else
    RealType = Type-1 ;
end


% if option == 'generic'
% the created handles will be at VT.handles_EditArea{ CurrentCategory, Type + numSkip }
% in this way, generic type and model type can share the same cell matrix,
% for programming convenience
% ....
numSkip = 20 ;
if isequal(Option, 'generic')
    Create_handlesEditArea( Category, Type+numSkip, 'model', RealType) ;
    return ;
end ;

% define constants for position and size of the objects in interface,
% Units: normalized
sliderPos = [0.272 0.51 0.012 0.3] ; 

labelPos = [0.028 0.82 0.24 0.03] ;
yStaringPos = 0.785 ;
xPos = [0.037 0.094 0.185] ;
yDelta = 0.034 ;
SizeText = [0.023 0.028] ;
SizeEdit = [0.06 0.03] ;
SizePopmenu = [0.10 0.028] ;

SizeChar = 0.007 ;

% for uicontextmenu in edit aera to do operations such as insert, delete, and From File
if ~exist('VT.cmenu')
    cb1 = ['Callback_EditArea ( 0, 0 , ''Insert'', gco)' ] ; % ['set(hline, ''LineStyle'', ''--'')'];
    cb2 = ['Callback_EditArea ( 0, 0 , ''Delete'', gco)' ] ; % ['set(hline, ''LineStyle'', '':'')'];
    cb3 = ['Callback_EditArea ( 0, 0 , ''From File'', gco)' ] ; % ['set(hline, ''LineStyle'', ''-'')'];
    cb4 = ['Callback_EditArea ( 0, 0 , ''Clear All'', gco)' ] ; % ['set(hline, ''LineStyle'', ''-'')'];

  % Define the context menu items
    VT.cmenu = uicontextmenu ;
    item1 = uimenu(VT.cmenu, 'Label', 'Insert', 'Callback', cb1);
    item2 = uimenu(VT.cmenu, 'Label', 'Delete', 'Callback', cb2);
    item3 = uimenu(VT.cmenu, 'Label', 'From File', 'Callback', cb3);
    item4 = uimenu(VT.cmenu, 'Label', 'Clear All', 'Callback', cb4);
end

% initiate the list of handles
VT.handles_EditArea{Category,Type}.handleList = 0 ;

% to record with type of model you are using
VT.handles_EditArea{Category, Type}.RealType = RealType ;

switch Category
    
    %---------------------------
    %  VOWEL 
    %----------------------------
    case 2  % 'Vowel'
                % how many lines of edit block or sections
                % for Type = 2, 3, 4, 5, the number of block is just Type
                % -1 ;
                if(Type<=5)
                    VT.handles_EditArea{Category, Type}.numBlock = Type-1 ;   
                else
                    VT.handles_EditArea{Category, Type}.numBlock = 9 ;
                end
                numSection = 1 ;  % how many section to be edited in area function
                Module_EditArea(Category, Type, labelPos, yStaringPos, sliderPos, ...
                                    VT.handles_EditArea{Category, Type}.numBlock, numSection) ;

     %---------------------------
     % CONSONANT 
     %----------------------------
     case 3  % 'Consonant'
                Text = 'Constriction Location (cm)' ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(3) = length(Text)*SizeChar ; % labelPos1(3)/3 ; 
                VT.handles_EditArea{Category, Type}.staticText(1) = add_object('text', labelPos1, Text) ;
                
                % edit area
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(1) = xPos(2)+10*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(2) = labelPos1(2)+ 0.1*yDelta ;
                labelPos1(3) = (6)*SizeChar ; %SizeText(1)/2  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Constriction Location''', ',gcbo)' ] ;
                
                VT.handles_EditArea{Category, Type}.ConstrictionLocation = add_object('edit', labelPos1, callback) ;  % Callback
                helpString = 'The location of noise source' ;
                set(VT.handles_EditArea{Category, Type}.ConstrictionLocation, 'TooltipString', helpString)

         
                                % collect handles 
                % In order to control the visibility of handles....
                VT.handles_EditArea{Category,Type}.handleList = ...
                    [ VT.handles_EditArea{Category,Type}.handleList; ...
                        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
                        VT.handles_EditArea{Category, Type}.ConstrictionLocation ; ...
                ] ;

                sliderPos1 = sliderPos ;  %[0.272 0.527 0.012 0.277] ; 
                labelPos1 = labelPos ;   % = [0.028 0.82 0.227 0.032] ;
                yStaringPos1 = yStaringPos ; %0.785  ;

                labelPos1(2) = labelPos1(2) - yDelta*1.7 ; 
                yStaringPos1 = yStaringPos1-yDelta*1.7 ;
                VT.handles_EditArea{Category, Type}.numBlock = 7 ;
                sliderPos1(4) = (VT.handles_EditArea{Category, Type}.numBlock + 1)/10*sliderPos1(4) ; % shrink the slider length
                numSection = 1; %length(PopmenuList) ;  % how many section to be edited in area function
                Module_EditArea(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
                                    VT.handles_EditArea{Category, Type}.numBlock, numSection) ;
         
                % the setup for Consonant is just for type right now.
                % 'arbitrary number of tube ????'
%                 VT.handles_EditArea{Category, Type}.numBlock = 9 ;
%                 numSection = 1 ;  % how many section to be edited in area function
%                 Module_EditArea(Category, Type, labelPos, yStaringPos, sliderPos, ...
%                                     VT.handles_EditArea{Category, Type}.numBlock, numSection) ;
                
     %---------------------------
     %  NASAL 
     %----------------------------
     case 4  % 'Nasal'
                % static 'Nostril'
                Text = 'Number of Nostril(s)' ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(3) = length(Text)*SizeChar ; % labelPos1(3)/3 ; 
                VT.handles_EditArea{Category, Type}.staticText(1) = add_object('text', labelPos1, Text) ;
                
                % '1' or '2' ? checkbox?
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(1) = xPos(2)+6.2*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(2) = labelPos1(2)+ 0.1*yDelta ;
                labelPos1(3) = (6)*SizeChar ; %SizeText(1)/2  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Nostril''', ',gcbo)' ] ;
                
                VT.handles_EditArea{Category, Type}.Nostril(1) = add_object('radiobutton', labelPos1, '1', 0, callback) ;
                labelPos1(1) = xPos(3)-0.9*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(3) = 6*SizeChar ;  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                VT.handles_EditArea{Category, Type}.Nostril(2) = add_object('radiobutton', labelPos1, '2', 1, callback) ;
                helpString = 'If number of nostril is 1, only area function in plot Nostril1 will be used for calculation' ;
                set(VT.handles_EditArea{Category, Type}.Nostril(:), 'TooltipString', helpString)
                
                % static 'Couple Area (cm^2)'
                Text = 'Couple Area (cm^2)' ;
                labelPos1 = labelPos; 
                labelPos1(2) = labelPos1(2) - 1.1*yDelta ;  
                labelPos1(3) = length(Text)*SizeChar ;  % labelPos(3)/2 ; %[0.028 0.82 0.227 0.032] ;
                VT.handles_EditArea{Category, Type}.staticText(2) = add_object('text', labelPos1, Text) ;

                %   Edit for couple area
                labelPos1(1) = xPos(2) + 7*SizeChar ;  %labelPos(3)/4 ; 
                labelPos1(3) = SizeEdit(1) ;  %labelPos(3)/4 ; 
                % labelPos1(2) = labelPos1(2) - yDelta ;  
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Couple Area''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.CoupleArea = add_object('edit', labelPos1, callback) ;  % Callback
                helpString = 'Data of couple area is not used in the calculation right now' ;
                set(VT.handles_EditArea{Category, Type}.CoupleArea, 'TooltipString', helpString)

                %   create popmenu 
                %-------------------------------------------------
                ud = get(VT.handles.vtar,'userdata'); % get titles
                PopmenuList = get_popmenu(ud.titles) ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1 = [labelPos1(1) labelPos1(2)-2.7*yDelta SizePopmenu ] ;
                value = 1 ;
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Popmenu''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.Popmenu = add_object('popupmenu', labelPos1, PopmenuList, value, callback) ;  % Callback
                helpString = 'Select the part whose area function you want to edit below ' ;
                set(VT.handles_EditArea{Category, Type}.Popmenu, 'TooltipString', helpString)

                % collect handles 
                % In order to control the visibility of handles....
                VT.handles_EditArea{Category,Type}.handleList = ...
                    [ VT.handles_EditArea{Category,Type}.handleList; ...
                        VT.handles_EditArea{Category, Type}.Nostril(:); ...
                        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
                        VT.handles_EditArea{Category, Type}.CoupleArea ;  ...    
                         VT.handles_EditArea{Category, Type}.Popmenu ...
                ] ;

                sliderPos1 = sliderPos ;  %[0.272 0.527 0.012 0.277] ; 
                labelPos1 = labelPos ;   % = [0.028 0.82 0.227 0.032] ;
                yStaringPos1 = yStaringPos ; %0.785  ;

            labelPos1(2) = labelPos1(2) - yDelta*4 ; 
            yStaringPos1 = yStaringPos1-yDelta*4 ;
            VT.handles_EditArea{Category, Type}.numBlock = 5 ;
            sliderPos1(4) = (VT.handles_EditArea{Category, Type}.numBlock + 1)/10*sliderPos1(4) ; % shrink the slider length
            numSection = length(PopmenuList) ;  % how many section to be edited in area function
            Module_EditArea(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
                                    VT.handles_EditArea{Category, Type}.numBlock, numSection) ;
                
%         ---------------------------
%          /R/  
%         ----------------------------
    case 5  % '/r/'
        % static 'Sublingual'
        % 'on' or 'off' ? checkbox?
        % static 'Sublingual'
        Text = 'Sublingual Cavity' ;
        labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
        labelPos1(3) = length(Text)*SizeChar ; % labelPos1(3)/3 ; 
        VT.handles_EditArea{Category, Type}.staticText(1) = add_object('text', labelPos1, Text) ;
        
        % '1' or '2' ? checkbox?
        labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
        labelPos1(1) = xPos(2) + 5*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
        labelPos1(2) = labelPos1(2)+0.2*SizeChar  ;
        labelPos1(3) = 6*SizeChar ; %SizeText(1)/2  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
        callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Sublingual''', ',gcbo)' ] ;
        VT.handles_EditArea{Category, Type}.Sublingual(1) = add_object('radiobutton', labelPos1, 'On', 1, callback) ;
        labelPos1(1) = xPos(3)-SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
        labelPos1(3) = 6*SizeChar ;  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
        VT.handles_EditArea{Category, Type}.Sublingual(2) = add_object('radiobutton', labelPos1, 'Off', 0, callback) ;
        helpString = 'If "Off" is selected, Sublingual Cavity will not be included in calculation of acoustic response' ;
        set(VT.handles_EditArea{Category, Type}.Sublingual(:), 'TooltipString', helpString)

        
        switch  RealType
            case 1
                
                %   create popmenu 
                %-------------------------------------------------
                ud = get(VT.handles.vtar,'userdata'); % get titles
                PopmenuList = get_popmenu(ud.titles) ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1 = [labelPos1(1) labelPos1(2)-1.5*yDelta SizePopmenu ];
                value = 1 ;
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Popmenu''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.Popmenu = add_object('popupmenu', labelPos1, PopmenuList, value, callback) ;  % Callback
                helpString = 'Select the part whose area function you want to edit below ' ;
                set(VT.handles_EditArea{Category, Type}.Popmenu, 'TooltipString', helpString)
                
                % collect handles 
                % In order to control the visibility of handles....
                VT.handles_EditArea{Category,Type}.handleList = ...
                    [ VT.handles_EditArea{Category,Type}.handleList; ...
                        VT.handles_EditArea{Category, Type}.Sublingual(:); ...
                        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
                        VT.handles_EditArea{Category, Type}.Popmenu ...
                    ] ;
                
                sliderPos1 = sliderPos ;  %[0.272 0.527 0.012 0.277] ; 
                labelPos1 = labelPos ;   % = [0.028 0.82 0.227 0.032] ;
                yStaringPos1 = yStaringPos ; %0.785  ;
                
                labelPos1(2) = labelPos1(2) - yDelta*2.7 ; 
                yStaringPos1 = yStaringPos1-yDelta*2.9 ;
                VT.handles_EditArea{Category, Type}.numBlock = 6 ;
                sliderPos1(4) = (VT.handles_EditArea{Category, Type}.numBlock + 1)/10*sliderPos1(4) ; % shrink the slider length
                numSection = length(PopmenuList) ;  % how many section to be edited in area function
                Module_EditArea(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
                    VT.handles_EditArea{Category, Type}.numBlock, numSection) ;                
                
            case 2
                Text = 'Sublingual Cavity Location (cm)' ;
                labelPos1 = labelPos; 
                labelPos1(2) = labelPos1(2) - yDelta ;  
                labelPos1(3) = length(Text)*SizeChar ;  % labelPos(3)/2 ; %[0.028 0.82 0.227 0.032] ;
                VT.handles_EditArea{Category, Type}.staticText(2) = add_object('text', labelPos1, Text) ;
                
                %   Edit for location
                labelPos1(1) = xPos(2) + 14*SizeChar ;  %labelPos(3)/4 ; 
                labelPos1(3) = SizeEdit(1) ;  %labelPos(3)/4 ; 
                % labelPos1(2) = labelPos1(2) - yDelta ;  
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Sublingual location''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.SublingualLocation = add_object('edit', labelPos1, callback) ;  % Callback
                helpString = 'Location at which sublingual cavity is connected' ;
                set(VT.handles_EditArea{Category, Type}.SublingualLocation, 'TooltipString', helpString)
                
                %   create popmenu 
                %-------------------------------------------------
                ud = get(VT.handles.vtar,'userdata'); % get titles
                PopmenuList = get_popmenu(ud.titles) ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1 = [labelPos1(1) labelPos1(2)-2.7*yDelta SizePopmenu ] ;
                value = 1 ;
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Popmenu''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.Popmenu = add_object('popupmenu', labelPos1, PopmenuList, value, callback) ;  % Callback
                 helpString = 'Select the part whose area function you want to edit below ' ;
                set(VT.handles_EditArea{Category, Type}.Popmenu, 'TooltipString', helpString)

                
                % collect handles 
                % In order to control the visibility of handles....
                VT.handles_EditArea{Category,Type}.handleList = ...
                    [ VT.handles_EditArea{Category,Type}.handleList; ...
                        VT.handles_EditArea{Category,Type}.Sublingual(:); ...
                        VT.handles_EditArea{Category, Type}.SublingualLocation; ...
                        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
                        VT.handles_EditArea{Category, Type}.Popmenu ...
                    ] ;
                
                sliderPos1 = sliderPos ;  %[0.272 0.527 0.012 0.277] ; 
                labelPos1 = labelPos ;   % = [0.028 0.82 0.227 0.032] ;
                yStaringPos1 = yStaringPos ; %0.785  ;
                
                labelPos1(2) = labelPos1(2) - yDelta*4 ; 
                yStaringPos1 = yStaringPos1-yDelta*4 ;
                VT.handles_EditArea{Category, Type}.numBlock = 5 ;
                sliderPos1(4) = (VT.handles_EditArea{Category, Type}.numBlock + 1)/10*sliderPos1(4) ; % shrink the slider length
                numSection = length(PopmenuList) ;  % how many section to be edited in area function
                Module_EditArea(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
                    VT.handles_EditArea{Category, Type}.numBlock, numSection) ;
                
            otherwise 
                ValidCreate = 0 ; 
                errordlg('model type error', 'Error', 'modal') ;
        end                  

            %         %---------------------------
            %         %  /L/  
            %         %----------------------------
            case 6  % '/l/'

                % static 'LateralOn '
                % 'on' or 'off' ? checkbox?
                % static 'SupralingualOn '
                % 'on' or 'off' ? checkbox?

                % static 'Lateral Channels'
                Text = 'Number of Lateral Channel(s)' ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(3) = length(Text)*SizeChar ; % labelPos1(3)/3 ; 
                VT.handles_EditArea{Category, Type}.staticText(1) = add_object('text', labelPos1, Text) ;
                
                % '1' or '2' ? checkbox?
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(1) = xPos(2)+11*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(3) = 6*SizeChar ; %SizeText(1)/2  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Lateral Channels''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.LateralChannel(1) = add_object('radiobutton', labelPos1, '1', 0, callback) ;
                labelPos1(1) = xPos(3) + 3*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(3) = 6*SizeChar ;  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                VT.handles_EditArea{Category, Type}.LateralChannel(2) = add_object('radiobutton', labelPos1, '2', 1, callback) ;
                helpString = 'If number of lateral channel is 1, only area function in plot Channel1 will be used for calculation' ;
                set(VT.handles_EditArea{Category, Type}.LateralChannel(:), 'TooltipString', helpString)
                
                
                % static 'Supralingual'
                Text = 'Supralingual Cavity' ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(2) = labelPos1(2) - 1.2*yDelta ;  
                labelPos1(3) = length(Text)*SizeChar ; % labelPos1(3)/3 ; 
                VT.handles_EditArea{Category, Type}.staticText(2) = add_object('text', labelPos1, Text) ;
                
                % '1' or '2' ? checkbox?
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(1) = xPos(2)+5*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(2) = labelPos1(2) - 1.1*yDelta ;  
                labelPos1(3) = 6*SizeChar ; %SizeText(1)/2  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Supralingual''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.Supralingual(1) = add_object('radiobutton', labelPos1, 'On', 1, callback) ;
                labelPos1(1) = xPos(3)-2*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(3) = 6*SizeChar ;  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                VT.handles_EditArea{Category, Type}.Supralingual(2) = add_object('radiobutton', labelPos1, 'Off', 0, callback) ;
                helpString = 'If "Off" is selected, Supralingual  Cavity will not be included in calculation of acoustic response' ;
                set(VT.handles_EditArea{Category, Type}.Supralingual(:), 'TooltipString', helpString)
                

                %   create popmenu 
                %-------------------------------------------------
                ud = get(VT.handles.vtar,'userdata'); % get titles
                PopmenuList = get_popmenu(ud.titles) ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1 = [labelPos1(1) labelPos1(2)-2.7*yDelta SizePopmenu ];
                value = 1 ;
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Popmenu''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.Popmenu = add_object('popupmenu', labelPos1, PopmenuList, value, callback) ;  % Callback
                helpString = 'Select the part whose area function you want to edit below ' ;
                set(VT.handles_EditArea{Category, Type}.Popmenu, 'TooltipString', helpString)

                % collect handles 
                % In order to control the visibility of handles....
                VT.handles_EditArea{Category,Type}.handleList = ...
                    [ VT.handles_EditArea{Category,Type}.handleList; ...
                        VT.handles_EditArea{Category, Type}.Supralingual(:); ...
                        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
                        VT.handles_EditArea{Category, Type}.LateralChannel(:) ;  ...    
                         VT.handles_EditArea{Category, Type}.Popmenu ...
                ] ;

                sliderPos1 = sliderPos ;  %[0.272 0.527 0.012 0.277] ; 
                labelPos1 = labelPos ;   % = [0.028 0.82 0.227 0.032] ;
                yStaringPos1 = yStaringPos ; %0.785  ;

            labelPos1(2) = labelPos1(2) - yDelta*4 ; 
            yStaringPos1 = yStaringPos1-yDelta*4 ;
            VT.handles_EditArea{Category, Type}.numBlock = 5 ;
            sliderPos1(4) = (VT.handles_EditArea{Category, Type}.numBlock + 1)/10*sliderPos1(4) ; % shrink the slider length
            numSection = length(PopmenuList) ;  % how many section to be edited in area function
            Module_EditArea(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
                                    VT.handles_EditArea{Category, Type}.numBlock, numSection) ;
                
                
            %         %---------------------------
            %         %  NASALIZED VOWEL  
            %         %----------------------------
            case 7  % 'Nasalized vowel' , same as Nasal
%                             labelPos1(1) = xPos(2)+6.2*SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
%                 labelPos1(2) = labelPos1(2)+ 0.1*yDelta ;
%                 labelPos1(3) = (6)*SizeChar ; %SizeText(1)/2  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
% 
%                 
                
                % static 'Nostril'
                Text = 'Number of Nostril(s)' ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(3) = length(Text)*SizeChar ; % labelPos1(3)/3 ; 
                VT.handles_EditArea{Category, Type}.staticText(1) = add_object('text', labelPos1, Text) ;
                
                % '1' or '2' ? checkbox?
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(1) = xPos(2) + 6.2*SizeChar ;;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(2) = labelPos1(2)+ 0.1*yDelta ;
                labelPos1(3) = 6*SizeChar ; %SizeText(1)/2  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Nostril''', ',gcbo)' ] ;
                
                VT.handles_EditArea{Category, Type}.Nostril(1) = add_object('radiobutton', labelPos1, '1', 0, callback) ;
                labelPos1(1) = xPos(3)-SizeChar ;   % labelPos1(3) = labelPos(3)/4 ; 
                labelPos1(3) = 6*SizeChar ;  %xPos(3) ;   % labelPos1(3) = labelPos(3)/4 ; 
                VT.handles_EditArea{Category, Type}.Nostril(2) = add_object('radiobutton', labelPos1, '2', 1, callback) ;
                set(VT.handles_EditArea{Category, Type}.Nostril(1), 'Enable', 'Off') ;  
                set(VT.handles_EditArea{Category, Type}.Nostril(2), 'Enable', 'Inactive') ;     

                helpString = 'If number of nostril is 1, only area function in plot Nostril1 will be used for calculation' ;
                set(VT.handles_EditArea{Category, Type}.Nostril(:), 'TooltipString', helpString)

                
                % static 'Couple Area (cm^2)'
                Text = 'Couple Area (cm^2)' ;
                labelPos1 = labelPos; 
                labelPos1(2) = labelPos1(2) - 1.1*yDelta ;  
                labelPos1(3) = length(Text)*SizeChar ;  % labelPos(3)/2 ; %[0.028 0.82 0.227 0.032] ;
                VT.handles_EditArea{Category, Type}.staticText(2) = add_object('text', labelPos1, Text) ;

                %   Edit for couple area
                labelPos1(1) = xPos(2) + 7*SizeChar ;  %labelPos(3)/4 ; 
                labelPos1(3) = SizeEdit(1) ;  %labelPos(3)/4 ; 
                % labelPos1(2) = labelPos1(2) - yDelta ;  
                callback = '  ' ;
                VT.handles_EditArea{Category, Type}.CoupleArea = add_object('edit', labelPos1, callback) ;  % Callback
                helpString = 'Data of couple area is not used in the calculation right now' ;
                set(VT.handles_EditArea{Category, Type}.CoupleArea, 'TooltipString', helpString)

                %   create popmenu 
                %-------------------------------------------------
                ud = get(VT.handles.vtar,'userdata'); % get titles
                PopmenuList = get_popmenu(ud.titles) ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1 = [labelPos1(1) labelPos1(2)-2.7*yDelta SizePopmenu ] ;
                value = 1 ;
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Popmenu''', ',gcbo)' ] ;
                VT.handles_EditArea{Category, Type}.Popmenu = add_object('popupmenu', labelPos1, PopmenuList, value, callback) ;  % Callback
                helpString = 'Select the part whose area function you want to edit below ' ;
                set(VT.handles_EditArea{Category, Type}.Popmenu, 'TooltipString', helpString)

                % collect handles 
                % In order to control the visibility of handles....
                VT.handles_EditArea{Category,Type}.handleList = ...
                    [ VT.handles_EditArea{Category,Type}.handleList; ...
                        VT.handles_EditArea{Category, Type}.Nostril(:); ...
                        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
                        VT.handles_EditArea{Category, Type}.CoupleArea ;  ...    
                         VT.handles_EditArea{Category, Type}.Popmenu ...
                ] ;

                sliderPos1 = sliderPos ;  %[0.272 0.527 0.012 0.277] ; 
                labelPos1 = labelPos ;   % = [0.028 0.82 0.227 0.032] ;
                yStaringPos1 = yStaringPos ; %0.785  ;

            labelPos1(2) = labelPos1(2) - yDelta*4 ; 
            yStaringPos1 = yStaringPos1-yDelta*4 ;
            VT.handles_EditArea{Category, Type}.numBlock = 5 ;
            sliderPos1(4) = (VT.handles_EditArea{Category, Type}.numBlock + 1)/10*sliderPos1(4) ; % shrink the slider length
            numSection = length(PopmenuList) ;  % how many section to be edited in area function
            Module_EditArea(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
                                    VT.handles_EditArea{Category, Type}.numBlock, numSection) ;
%             Module_EditArea_arbitrary(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
%                                     VT.handles_EditArea{Category, Type}.numBlock, numSection) ;
                
                
            %         %---------------------------
            %         %  ARBITRARY MODEL  
            %         %----------------------------
            case 8  % 'ARBITRARY TYPE'
                % static text
                Text = {'Tube No.', 'Module', 'Start at', 'End at'} ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                labelPos1(2) = labelPos1(2) + 0.5*yDelta ; 
                space(1) = 8.1*SizeChar ;
                space(2) = 11.5*SizeChar ;
                space(3) = 9*SizeChar ;
                space(4) = 0 ;
                for i = 1:length(Text)
                    labelPos1(3) = length(Text{i})*SizeChar ; % labelPos1(3)/3 ; 
                    VT.handles_EditArea{Category, Type}.staticText(i) = add_object('text', labelPos1, Text(i)) ;
                    labelPos1(1) =  labelPos1(1) + space(i) ;
                end
                
                % first row of popmenus
                PopmenuList{1} = num2str((1:VT.maxnumTubes)') ;
                PopmenuList{2} = {'1-channel', '2-channel'} ;
                PopmenuList{3} = {' ', 'Glottis'} ;
                PopmenuList{4} = {' ', 'Lips', 'Nostril 1','Nostril 2'} ;
                PopmenuList{5} = {'Channel 1', 'Channel 2'} ;
                ListSize(1) = 6*SizeChar ;
                ListSize(2) = 10.6*SizeChar ;
                ListSize(3) = 7.7*SizeChar ;
                ListSize(4) = 8.7*SizeChar ;
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                value = 1 ;

                callback{1} = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ; % tube no. , update data in edit area
                callback{2} = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ; % ? update the channel selection and connected channel if ...
                callback{3} = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ; % update start position
                callback{4} = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ; % update end postion
                for i = 1:length(Text)
                    labelPos2 = [labelPos1(1) labelPos1(2)- 0.2*yDelta ListSize(i) SizePopmenu(2) ] ;
                    VT.handles_EditArea{Category, Type}.Popmenu(i) = add_object('popupmenu', labelPos2, PopmenuList{i}, value, callback{i}) ;  % Callback
                    labelPos1(1) =  labelPos1(1) + space(i) ;
                end

                VT.handles_EditArea{Category, Type}.Index = 1 ;
                VT.handles_EditArea{Category, Type}.IndexOfBranch     = VT.handles_EditArea{Category, Type}.Popmenu(1) ;
                VT.handles_EditArea{Category, Type}.typeOfModule      = VT.handles_EditArea{Category, Type}.Popmenu(2) ; 
                VT.handles_EditArea{Category, Type}.typeOfStartofTube = VT.handles_EditArea{Category, Type}.Popmenu(3) ;
                VT.handles_EditArea{Category, Type}.typeOfEndofTube   = VT.handles_EditArea{Category, Type}.Popmenu(4) ;

                
                % create a popmenu for 2-channels case
                labelPos1 = labelPos;  %[0.028 0.82 0.227 0.032] ;
                value = 1 ;
                % callback = ' ' ;  % update the edit area function based on this choice
                callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ; % update end postion
                i = 5 ;
                    labelPos2 = [labelPos1(1) labelPos1(2)- 1.1*yDelta SizePopmenu(1) SizePopmenu(2)*0.6] ;
                    VT.handles_EditArea{Category, Type}.Popmenu(i) = add_object('popupmenu', labelPos2, PopmenuList{i}, value, callback) ;  % Callback
                VT.handles_EditArea{Category, Type}.channel = VT.handles_EditArea{Category, Type}.Popmenu(5); ;
                
                                VT.handles_EditArea{Category,Type}.handleList = ...
                    [ VT.handles_EditArea{Category,Type}.handleList ; ...
                        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
                        VT.handles_EditArea{Category, Type}.Popmenu(:) ; ...
                    ] ;

                
                
                % create the edit area for area function
                sliderPos1 = sliderPos ;  %[0.272 0.527 0.012 0.277] ; 
                labelPos1 = labelPos ;   % = [0.028 0.82 0.227 0.032] ;
                yStaringPos1 = yStaringPos ; %0.785  ;
                
                labelPos1(2) = labelPos1(2) - yDelta*2.3 ; 
                yStaringPos1 = yStaringPos1-yDelta*2 ;
                VT.handles_EditArea{Category, Type}.numBlock = 4 ;
                sliderPos1(1) = sliderPos1(1) - yDelta*0.25 ;  
                sliderPos1(2) = sliderPos1(2) + yDelta*3 ;  
                sliderPos1(4) = (VT.handles_EditArea{Category, Type}.numBlock + 1)/10*sliderPos1(4) ; % shrink the slider length
                numSection = 2 ; % length(PopmenuList) ;  % how many section to be edited in area function

                % callback needs to be modified !!! for arbitrary type
                Module_EditArea_arbitrary(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
                    VT.handles_EditArea{Category, Type}.numBlock, numSection, 1) ;  % 1 just for arbitarry type to change the static text

                
                
                
                % for edit area for area function            
                for i = 1: VT.handles_EditArea{Category, Type}.numBlock
                    VT.handles_EditArea{Category, Type}.secLen(i) = VT.handles_EditArea{Category, Type}.Length(i);
                    VT.handles_EditArea{Category, Type}.secArea(i) = VT.handles_EditArea{Category, Type}.Area(i);
                end
                

                % connected to other tubes
                sliderPos1 = sliderPos ;  %[0.272 0.527 0.012 0.277] ; 
                labelPos1 = labelPos ;   % = [0.028 0.82 0.227 0.032] ;
                yStaringPos1 = yStaringPos ; %0.785  ;
                
                labelPos1(2) = labelPos1(2) - yDelta*8.2 ; 
                yStaringPos1 = yStaringPos1-yDelta*7.8 ;
                sliderPos1(1) = sliderPos1(1) - yDelta*0.1 ;  
                sliderPos1(2) = sliderPos1(2) - yDelta*0.6;  
                VT.handles_EditArea{Category, Type}.numBlockConnection = 2 ;
                
                sliderPos1(3) = sliderPos1(3)* 0.95 ;
                sliderPos1(4) = sliderPos1(4)* 1 ;
                sliderPos1(4) = (VT.handles_EditArea{Category, Type}.numBlockConnection )/10*sliderPos1(4) ; % shrink the slider length
                numSection = 2 ; % length(PopmenuList) ;  % how many section to be edited in area function

                Module_EditArea_Connection(Category, Type, labelPos1, yStaringPos1, sliderPos1, ...
                    VT.handles_EditArea{Category, Type}.numBlockConnection, numSection, 1) ;
                
                % connected to other tubes
                for i = 1: VT.handles_EditArea{Category, Type}.numBlockConnection
                    VT.handles_EditArea{Category, Type}.nextBranches(i) = VT.handles_EditArea{Category,Type}.Num_Connection(i) ;
                    VT.handles_EditArea{Category, Type}.nextBranchesLocEnd(i) = VT.handles_EditArea{Category,Type}.LocationEnd(i) ;
                    VT.handles_EditArea{Category, Type}.nextBranchesLoc(i) = VT.handles_EditArea{Category,Type}.Location(i) ;
                    VT.handles_EditArea{Category, Type}.nextBranchesLocChannel(i) = VT.handles_EditArea{Category,Type}.Channels(i);
                end
                
                % visibility of some popmenu on module of two channels
                VT.handles_EditArea{Category, Type}.twochannelsHandles = [ VT.handles_EditArea{Category, Type}.Popmenu(5); ...
                                                                      VT.handles_EditArea{Category, Type}.nextBranchesLocChannel(:) ; ...
                                                                      VT.handles_EditArea{Category, Type}.staticText(4);
                                                                      VT.handles_EditArea{Category, Type}.staticText(5);
                                                              ] ;
        otherwise
            VT.handles_EditArea{Category,Type}.handleList = 0 ;  % no handles created ;
            disp('Unknown method. happened in Create_handlesEditArea() ')
    end
    
    if(nargout == 1)
        varargout{1} = ValidCreate  ; 
    end
    
    return ;
    
    
    
    function PopmenuList = get_popmenu(titles) ;
    % decide which plot should be visible and also update the menu item
    j = 0 ;        
    for iTemp = 2: length(titles)-1   % skip the first one and also last one
        if ~isempty(titles{iTemp})
            j = j+1 ;
            PopmenuList{j} = titles{iTemp} ;
        else
            break ;
        end
    end
    if (j==0), errordlg('In creating popmenu', 'Error'); end ;
    return ;
    
    
    
function Module_EditArea(Category, Type, labelPos, yStaringPos, sliderPos, numBlock, numSection, varargin) ;

global VT ;
xPos = [0.037 0.094 0.185] ;
yDelta = 0.036 ;
SizeText = [0.023 0.028] ;
% SizeEdit = [0.06 0.028] ;
SizeEdit = [0.06 0.03] ;
SizeChar = 0.007 ;

SizePopmenu = [0.10 0.028] ;

% create static text
% Text = 'No.               Length (cm)             Area (cm^2)' ;
% VT.handles_EditArea{Category, Type}.staticText = add_object('text', labelPos, Text) ;
% 
% display separately is to make the alignemnt better when window size is
% changed
if (nargin == 8)
    Text = 'Section No.' ;
else
    Text = 'No.' ;
end 
labelPos1 = [labelPos(1) labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(1) = add_object('text', labelPos1, Text) ;
Text = 'Length (cm)' ;
labelPos1 = [labelPos(1)+ SizeChar*10  labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(2) = add_object('text', labelPos1, Text) ;
Text = 'Area (cm^2)' ;
labelPos1 = [labelPos(1)+ SizeChar*23  labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(3) = add_object('text', labelPos1, Text) ;

% create edit area 
for i = 1: numBlock 
    % create static text for No.
    labelPos = [xPos(1), yStaringPos-(i-1)*yDelta, SizeText(1)+SizeChar SizeText(2)  ] ;
    VT.handles_EditArea{Category,Type}.Num(i) = add_object('text', labelPos, num2str(i)) ;
    
    % Then the editable text field for Length and Area
    labelPos = [xPos(2), yStaringPos-(i-1)*yDelta, SizeEdit  ] ;
    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''General''', ',gcbo)' ] ;
    VT.handles_EditArea{Category,Type}.Length(i) = add_object('edit', labelPos, callback) ;

    labelPos = [xPos(3), yStaringPos-(i-1)*yDelta, SizeEdit  ] ;
    VT.handles_EditArea{Category,Type}.Area(i) =   add_object('edit', labelPos, callback) ;
    
    % set uicontextmenu
    if ( numBlock > 4 | Category==8) % add uicontextmenu
        set (VT.handles_EditArea{Category,Type}.Length(i), 'uicontextmenu', VT.cmenu) ;
        set (VT.handles_EditArea{Category,Type}.Area(i), 'uicontextmenu', VT.cmenu) ;
        helpString = 'input length and area for each section, OR right click to insert, delete or load length and area data' ;
        set(VT.handles_EditArea{Category,Type}.Length(i), 'TooltipString', helpString)
        set(VT.handles_EditArea{Category,Type}.Area(i), 'TooltipString', helpString)
    end
end 


% In order to control the visibility of handles....
VT.handles_EditArea{Category,Type}.handleList = ...
    [ VT.handles_EditArea{Category,Type}.handleList; ...
        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
        VT.handles_EditArea{Category,Type}.Num(:) ; ...
        VT.handles_EditArea{Category,Type}.Length(:) ; ...
        VT.handles_EditArea{Category,Type}.Area(:) ; ...
    ] ;

% set up storage space for length and area information for several 
% section,  depending on  'numSection'
for i = 1: numSection
    VT.handles_EditArea{Category,Type}.Length_data{i} = cell(1, 200) ;
    VT.handles_EditArea{Category,Type}.Area_data{i}   = cell(1, 200) ;
end    

% for edit purpose, Pointer is to record current position of array, the
% second one is to know which section we are editing.
% number of sections can be inferred from Length_data{} , ...

% VT.handles_EditArea{Category,Type}.Pointer = 0 ;
VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;

% add slider 
    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Slider''', ')' ] ;
    VT.handles_EditArea{Category,Type}.Slider =  add_object('slider', sliderPos , ...
                                                 callback, numBlock  ); % callback

    VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)

if ( numBlock > 4  | Category==8) 
    % add handle of slider into handleList ...
    VT.handles_EditArea{Category,Type}.handleList = ...
        [ VT.handles_EditArea{Category,Type}.handleList ; ...
            VT.handles_EditArea{Category,Type}.Slider ; ...
        ] ;
end ;

return ;


function Module_EditArea_arbitrary(Category, Type, labelPos, yStaringPos, sliderPos, numBlock, numSection, varargin) ;

global VT ;
xPos = [0.037 0.094 0.185] ;
yDelta = 0.036 ;
SizeText = [0.023 0.028] ;
% SizeEdit = [0.06 0.028] ;
SizeEdit = [0.06 0.03] ;
SizeChar = 0.007 ;

SizePopmenu = [0.10 0.028] ;

% create static text
% Text = 'No.               Length (cm)             Area (cm^2)' ;
% VT.handles_EditArea{Category, Type}.staticText = add_object('text', labelPos, Text) ;
% 
% display separately is to make the alignemnt better when window size is
% changed
if (nargin == 8)
    Text = 'Section No.' ;
else
    Text = 'No.' ;
end 
labelPos1 = [labelPos(1) labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(1) = add_object('text', labelPos1, Text) ;
Text = 'Length (cm)' ;
labelPos1 = [labelPos(1)+ SizeChar*10  labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(2) = add_object('text', labelPos1, Text) ;
Text = 'Area (cm^2)' ;
labelPos1 = [labelPos(1)+ SizeChar*23  labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(3) = add_object('text', labelPos1, Text) ;

% create edit area 
for i = 1: numBlock 
    % create static text for No.
    labelPos = [xPos(1), yStaringPos-(i-1)*yDelta, SizeText(1)+SizeChar, SizeText(2)  ] ;
    VT.handles_EditArea{Category,Type}.Num(i) = add_object('text', labelPos, num2str(i)) ;
    
    % Then the editable text field for Length and Area
    labelPos = [xPos(2), yStaringPos-(i-1)*yDelta, SizeEdit  ] ;
%    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''General_arbitrary''', ',gcbo)' ] ;
    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ;

    VT.handles_EditArea{Category,Type}.Length(i) = add_object('edit', labelPos, callback) ;

    labelPos = [xPos(3), yStaringPos-(i-1)*yDelta, SizeEdit  ] ;
    VT.handles_EditArea{Category,Type}.Area(i) =   add_object('edit', labelPos, callback) ;
    
    % set uicontextmenu
    if ( numBlock > 4 | Category==8) % add uicontextmenu
        set (VT.handles_EditArea{Category,Type}.Length(i), 'uicontextmenu', VT.cmenu) ;
        set (VT.handles_EditArea{Category,Type}.Area(i), 'uicontextmenu', VT.cmenu) ;
    end
end 


% In order to control the visibility of handles....
VT.handles_EditArea{Category,Type}.handleList = ...
    [ VT.handles_EditArea{Category,Type}.handleList; ...
        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
        VT.handles_EditArea{Category,Type}.Num(:) ; ...
        VT.handles_EditArea{Category,Type}.Length(:) ; ...
        VT.handles_EditArea{Category,Type}.Area(:) ; ...
    ] ;

% set up storage space for length and area information for several 
% section,  depending on  'numSection'
for i = 1: numSection
    VT.handles_EditArea{Category,Type}.Length_data{i} = cell(1, 200) ;
    VT.handles_EditArea{Category,Type}.Area_data{i}   = cell(1, 200) ;
end    

% for edit purpose, Pointer is to record current position of array, the
% second one is to know which section we are editing.
% number of sections can be inferred from Length_data{} , ...

% VT.handles_EditArea{Category,Type}.Pointer = 0 ;
VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;

% add slider 
%    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Slider_arbitrary''', ')' ] ;
    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ;
    VT.handles_EditArea{Category,Type}.Slider =  add_object('slider', sliderPos , ...
                                                 callback, numBlock  ); % callback

    VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)

if ( numBlock > 4  | Category==8) 
    % add handle of slider into handleList ...
    VT.handles_EditArea{Category,Type}.handleList = ...
        [ VT.handles_EditArea{Category,Type}.handleList ; ...
            VT.handles_EditArea{Category,Type}.Slider ; ...
        ] ;
end ;

return ;



% for the edit area of tube connection information at arbitrary category
function Module_EditArea_Connection(Category, Type, labelPos, yStaringPos, sliderPos, numBlock, numSection, varargin) ;

global VT ;
yDelta = 0.032 ;
SizeText = [0.023 0.028] ;
% SizeEdit = [0.06 0.028] ;
SizeEdit = [0.04 0.028] ;
SizeChar = 0.007 ;
xPos = [0.037 (0.094+SizeChar*0.8) (0.185-0.4*SizeChar)] ;

SizePopmenu = [0.10 0.028] ;

% create static text
% Text = 'No.               Length (cm)             Area (cm^2)' ;
% VT.handles_EditArea{Category, Type}.staticText = add_object('text', labelPos, Text) ;
% 
% display separately is to make the alignemnt better when window size is
% changed
% if (nargin == 8)
%     Text = 'Connected Tube No.' ;
% else
%     Text = 'No.' ;
% end     

Text = 'Connected by :' ;
labelPos1 = [labelPos(1) labelPos(2)+yDelta*0.8 SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(1) = add_object('text', labelPos1, Text) ;

Text = 'Tube No.' ;
labelPos1 = [labelPos(1) labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(2) = add_object('text', labelPos1, Text) ;

Text = 'Connection Location (cm)' ;
labelPos1 = [labelPos(1)+ SizeChar*10.5  labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(3) = add_object('text', labelPos1, Text) ;
% Text = 'Area (cm^2)' ;
% labelPos1 = [labelPos(1)+ SizeChar*23  labelPos(2) SizeChar*length(Text) labelPos(4)] ;
% VT.handles_EditArea{Category, Type}.staticText(3) = add_object('text', labelPos1, Text) ;


% in case of module (2-two channels)
Text = 'On' ;
labelPos1 = [xPos(3)+SizeChar*6.4 labelPos(2)+yDelta*0.5 SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(4) = add_object('text', labelPos1, Text) ;

Text = 'Channel' ;
labelPos1 = [xPos(3)+SizeChar*6.4 labelPos(2) SizeChar*length(Text) labelPos(4)] ;
% labelPos1 = [labelPos(1)+ SizeChar*10.5  labelPos(2) SizeChar*length(Text) labelPos(4)] ;
VT.handles_EditArea{Category, Type}.staticText(5) = add_object('text', labelPos1, Text) ;



% create edit area 
for i = 1: numBlock 
    % create popmenu for tube No.
    PopmenuList = ['  '; num2str((1:VT.maxnumTubes)')] ;
    value = 1 ;
    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ;
    labelPos = [xPos(1)-yDelta*0.3, yStaringPos-(i-1)*yDelta, SizeEdit(1)*1.2 SizeEdit(1)*0.7  ] ;
    VT.handles_EditArea{Category, Type}.Num_Connection(i) = add_object('popupmenu', labelPos, PopmenuList, value, callback) ;  % Callback

    
    % Then the editable text field for Length and Area
    labelPos = [xPos(2), yStaringPos-(i-1)*yDelta,  SizeEdit(1)*2  SizeEdit(2)] ;
    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ;
    VT.handles_EditArea{Category,Type}.LocationEnd(i) =  add_object('checkbox', labelPos, 'at End    or', 0, callback) ;

    labelPos = [xPos(3), yStaringPos-(i-1)*yDelta, SizeEdit  ] ;
    VT.handles_EditArea{Category,Type}.Location(i) =  add_object('edit', labelPos, callback) ;

    %   create popmenu 
    %-------------------------------------------------
    PopmenuList = {'1','2'} ;
    value = 1 ;
%    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Popmenu''', ',gcbo)' ] ;
    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ;
    labelPos = [xPos(3)+SizeChar*7, yStaringPos-(i-1)*yDelta+yDelta*0.01, SizeEdit(1)*0.8 SizeEdit(1)*0.7  ] ;
    VT.handles_EditArea{Category, Type}.Channels(i) = add_object('popupmenu', labelPos, PopmenuList, value, callback) ;  % Callback
    
%     % set uicontextmenu
%     if ( numBlock > 4 | Category==8) % add uicontextmenu
%         set (VT.handles_EditArea{Category,Type}.Length(i), 'uicontextmenu', VT.cmenu) ;
%         set (VT.handles_EditArea{Category,Type}.Area(i), 'uicontextmenu', VT.cmenu) ;
%     end
end 


% In order to control the visibility of handles....
VT.handles_EditArea{Category,Type}.handleList = ...
    [ VT.handles_EditArea{Category,Type}.handleList; ...
        VT.handles_EditArea{Category, Type}.staticText(:) ; ...
        VT.handles_EditArea{Category,Type}.Num_Connection(:) ; ...
        VT.handles_EditArea{Category,Type}.LocationEnd(:) ; ...
        VT.handles_EditArea{Category,Type}.Location(:) ; ...
        VT.handles_EditArea{Category,Type}.Channels(:) ; ...
       
    ] ;

% % set up storage space for length and area information for several 
% % section,  depending on  'numSection'
% for i = 1: numSection
%     VT.handles_EditArea{Category,Type}.Length_data{i} = cell(1, 200) ;
%     VT.handles_EditArea{Category,Type}.Area_data{i}   = cell(1, 200) ;
% end    

% for edit purpose, Pointer is to record current position of array, the
% second one is to know which section we are editing.
% number of sections can be inferred from Length_data{} , ...

% VT.handles_EditArea{Category,Type}.Pointer = 0 ;
%VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;

% add slider 
%    callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''Slider''', ')' ] ;
callback = ['Callback_EditArea(', num2str(Category), ',', num2str(Type),',''arbitrary''', ',gcbo)' ] ;
VT.handles_EditArea{Category,Type}.SliderConnection =  add_object('slider', sliderPos , ...
                                                 callback, numBlock , 10 ); % callback

    VT.handles_EditArea{Category,Type}.PointerConnection = 0 ;  % from 0 - (200-numBlock)

if ( numBlock > 4  | Category==8) 
    % add handle of slider into handleList ...
    VT.handles_EditArea{Category,Type}.handleList = ...
        [ VT.handles_EditArea{Category,Type}.handleList ; ...
            VT.handles_EditArea{Category,Type}.SliderConnection ; ...
        ] ;
end ;

return ;

function h = add_object(controlType, Position, varargin)
%    'Interruptible', 'off', ... 
%    'BusyAction', 'Cancel', ...                   

switch controlType
    case 'text'
           h = uicontrol( ...
    'Style','text', ...
    'Units','normalized', ...
    'Visible', 'Off', ...
    'HorizontalAlignment', 'left', ...
    'Position',Position, ...
    'String', varargin{1});
%    'FontUnits', 'normalized', ...

    case 'edit'
      h  = uicontrol( ...
        'Style','edit', ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Visible', 'Off', ...
        'Position',Position , ...
        'Callback', varargin{1} ,...
        'String', ' ') ;
    
    case 'slider'
       numBlock = varargin{2} ;
       if(nargin == 5)
           numMax =  varargin{3} ;
       else
           numMax = 200 ;
       end
       h =  uicontrol( ...
        'Style','slider', ...
        'Units','normalized', ...
        'Visible', 'Off', ...
        'Position',Position, ...
        'SliderStep',[1/(numMax+1-numBlock) numBlock/(numMax+1-numBlock)],  ...
        'Min', 0, 'Max', (numMax-numBlock) , ...
        'Callback', varargin{1}, ...
        'ListboxTop', 1 , ...
        'Value', numMax-numBlock ) ;
    
    case 'popupmenu'

        PopmenuList = varargin{1} ;
        value  = varargin{2} ; 
        callback  = varargin{3} ;   ;  % Callback
        
        h=  uicontrol( ...
            'Style','popupmenu', ...
            'Units','normalized', ...
            'Visible', 'Off', ...
            'BackgroundColor', 'w', ...
            'Position',Position, ...
            'String',PopmenuList, 'Value', 1, 'Callback', callback);
        
    case 'radiobutton'
        string = varargin{1} ;
        value  = varargin{2} ; 
        callback  = varargin{3} ;   ;  % Callback
        h=  uicontrol( ...
            'Style','radiobutton', ...
            'Units','normalized', ...
            'Visible', 'Off', ...
            'Position',Position, ...
            'String',string, 'Value', value, 'Callback', callback);
        
    case 'checkbox'
        string = varargin{1} ;
        value  = varargin{2} ; 
        callback  = varargin{3} ;   ;  % Callback
        h=  uicontrol( ...
            'Style','checkbox', ...
            'Units','normalized', ...
            'Visible', 'Off', ...
            'Position',Position, ...
            'String',string, 'Value', value, 'Callback', callback);

    otherwise
        errordlg('add-object ??? ', 'Error ')
end
return ;

%end


% 
% 
% 
% if(Type==6 | Type==7 |Type> numSkip)   % second condition corresponding to 'generic'
%     % 7 arbitrary , 8 from File
%     % create edit area with 9 lines and an array to store 200 values
%     % create slider
%     VT.handles_EditArea{Category,Type}.Length_data = cell(1, 200) ;
%     VT.handles_EditArea{Category,Type}.Area_data = cell(1, 200) ;
%     
%     VT.handles_EditArea{Category,Type}.Slider =  uicontrol( ...
%         'Style','slider', ...
%         'Units','normalized', ...
%         'Visible', 'Off', ...
%         'Position',sliderPos, ...
%         'SliderStep',[0.01 0.1],  ...
%         'Value', 1 ) ;
%     VT.handles_EditArea{Category,Type}.handleList = ...
%         [ VT.handles_EditArea{Category,Type}.handleList ; ...
%             VT.handles_EditArea{Category,Type}.Slider ; ...
%         ]
% end 
% 
% 
% 
% 


% 
% 
%     labelPos = [xPos(3), yStaringPos-(i-1)*yDelta, SizeEdit  ]
%     VT.handles_EditArea{Category,Type}.Area(i) 
%     
%     
%     
%     
%     
%     VT.handles_EditArea{Category,Type}.Num(i) = ...
%         uicontrol( ...
%         'Style','text', ...
%         'Units','normalized', ...
%         'Visible', 'Off', ...
%         'Position',labelPos, ...
%         'String', num2str(i) ) ;
%     %         'BackgroundColor',[0.50 0.50 0.50], ...
%     %         'ForegroundColor',[1 1 1], ...
% 
% 
% 
% VT.handles_EditArea{Category, Type}.staticText = ...
%     uicontrol( ...
%     'Style','text', ...
%     'Units','normalized', ...
%     'Visible', 'Off', ...
%     'Position',labelPos, ...
%     'String',Text);
% 
% % create edit area 
% for i = 1: VT.handles_EditArea{Category, Type}.numBlock 
%     labelPos = [xPos(1), yStaringPos-(i-1)*yDelta, SizeText  ] ;
%     VT.handles_EditArea{Category,Type}.Num(i) = ...
%         uicontrol( ...
%         'Style','text', ...
%         'Units','normalized', ...
%         'Visible', 'Off', ...
%         'Position',labelPos, ...
%         'String', num2str(i) ) ;
%     %         'BackgroundColor',[0.50 0.50 0.50], ...
%     %         'ForegroundColor',[1 1 1], ...
%     
%     % Then the editable text field
%     labelPos = [xPos(2), yStaringPos-(i-1)*yDelta, SizeEdit  ] ;
%     VT.handles_EditArea{Category,Type}.Length(i) = ...
%         uicontrol( ...
%         'Style','edit', ...
%         'Units','normalized', ...
%         'BackgroundColor',[1 1 1], ...
%         'Visible', 'Off', ...
%         'Position',labelPos , ...
%         'Callback', ['Callback_EditArea(', num2str(Category), ',', num2str(Type), ')'] , ...
%         'String', ' ') ;
%     
%     %         'HorizontalAlignment','left', ...
%     %         'Max',10, ...
%     %         'Callback','graf2d(''eval'')', ...
%     
%     labelPos = [xPos(3), yStaringPos-(i-1)*yDelta, SizeEdit  ]
%     VT.handles_EditArea{Category,Type}.Area(i) = uicontrol( ...
%         'Style','edit', ...
%         'Units','normalized', ...
%         'BackgroundColor',[1 1 1], ...
%         'Visible', 'Off', ...
%         'Position',labelPos , ...
%         'Callback', ['Callback_EditArea(', num2str(Category), ',', num2str(Type), ')'] ,...
%         'String', ' ') ;
%     
%     if ( VT.handles_EditArea{Category, Type}.numBlock > 4) % add uicontextmenu
%         set (VT.handles_EditArea{Category,Type}.Length(i), 'uicontextmenu', VT.cmenu) ;
%         set (VT.handles_EditArea{Category,Type}.Area(i), 'uicontextmenu', VT.cmenu) ;
%     end
%     
%     %                     if(Type<=5 & i==(Type-1))
%     %                         break ;
%     %                     end
% end ;
% 
% % In order to control the visibility of handles....
% VT.handles_EditArea{Category,Type}.handleList = ...
%     [ VT.handles_EditArea{Category, Type}.staticText ; ...
%         VT.handles_EditArea{Category,Type}.Num(:) ; ...
%         VT.handles_EditArea{Category,Type}.Length(:) ; ...
%         VT.handles_EditArea{Category,Type}.Area(:) ; ...
%     ]
% % create slides and ....
% if(Type==6 | Type==7 |Type> numSkip)   % second condition corresponding to 'generic'
%     % 7 arbitrary , 8 from File
%     % create edit area with 9 lines and an array to store 200 values
%     % create slider
%     %                     VT.handles_EditArea{Category,Type}.Length_data = zeros(1, 200) ;
%     %                     VT.handles_EditArea{Category,Type}.Area_data = zeros(1, 200) ;
%     VT.handles_EditArea{Category,Type}.Length_data = cell(1, 200) ;
%     VT.handles_EditArea{Category,Type}.Area_data = cell(1, 200) ;
%     VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)
%     
%     VT.handles_EditArea{Category,Type}.Slider =  uicontrol( ...
%         'Style','slider', ...
%         'Units','normalized', ...
%         'Visible', 'Off', ...
%         'Position',sliderPos, ...
%         'SliderStep',[0.01 0.1],  ...
%         'Value', 1 ) ;
%     VT.handles_EditArea{Category,Type}.handleList = ...
%         [ VT.handles_EditArea{Category,Type}.handleList ; ...
%             VT.handles_EditArea{Category,Type}.Slider ; ...
%         ]
% end 
% %errordlg('Create_handlesEditArea for vowel','Error', 'modal');
% 
% 
% 
% 
%     


             
                
                
%                 
%                 % create popmenu
%                 % create static text
%                 Text = 'No.               Length (cm)           Area (cm^2)' ;
%                 VT.handles_EditArea{Category, Type}.staticText = ...
%                     uicontrol( ...
%                     'Style','text', ...
%                     'Units','normalized', ...
%                     'Visible', 'Off', ...
%                     'Position',labelPos, ...
%                     'String',Text);
%                 if(Type<=5)
%                     VT.handles_EditArea{Category, Type}.numBlock = Type-1 ;
%                 else
%                     VT.handles_EditArea{Category, Type}.numBlock = 9 ;
%                 end
%                 
%                 % create edit area 
%                 for i = 1: VT.handles_EditArea{Category, Type}.numBlock 
%                     labelPos = [xPos(1), yStaringPos-(i-1)*yDelta, SizeText  ] ;
%                     VT.handles_EditArea{Category,Type}.Num(i) = ...
%                         uicontrol( ...
%                         'Style','text', ...
%                         'Units','normalized', ...
%                         'Visible', 'Off', ...
%                         'Position',labelPos, ...
%                         'String', num2str(i) ) ;
%                     %         'BackgroundColor',[0.50 0.50 0.50], ...
%                     %         'ForegroundColor',[1 1 1], ...
%                     
%                     % Then the editable text field
%                     labelPos = [xPos(2), yStaringPos-(i-1)*yDelta, SizeEdit  ] ;
%                     VT.handles_EditArea{Category,Type}.Length(i) = ...
%                         uicontrol( ...
%                         'Style','edit', ...
%                         'Units','normalized', ...
%                         'BackgroundColor',[1 1 1], ...
%                         'Visible', 'Off', ...
%                         'Position',labelPos , ...
%                         'Callback', ['Callback_EditArea(', num2str(Category), ',', num2str(Type), ')'] , ...
%                         'String', ' ') ;
%                     
%                     %         'HorizontalAlignment','left', ...
%                     %         'Max',10, ...
%                     %         'Callback','graf2d(''eval'')', ...
%                     
%                     labelPos = [xPos(3), yStaringPos-(i-1)*yDelta, SizeEdit  ]
%                     VT.handles_EditArea{Category,Type}.Area(i) = uicontrol( ...
%                         'Style','edit', ...
%                         'Units','normalized', ...
%                         'BackgroundColor',[1 1 1], ...
%                         'Visible', 'Off', ...
%                         'Position',labelPos , ...
%                         'Callback', ['Callback_EditArea(', num2str(Category), ',', num2str(Type), ')'] ,...
%                         'String', ' ') ;
%                     
%                     if ( VT.handles_EditArea{Category, Type}.numBlock > 4) % add uicontextmenu
%                         set (VT.handles_EditArea{Category,Type}.Length(i), 'uicontextmenu', VT.cmenu) ;
%                         set (VT.handles_EditArea{Category,Type}.Area(i), 'uicontextmenu', VT.cmenu) ;
%                     end
%                     
%                     %                     if(Type<=5 & i==(Type-1))
%                     %                         break ;
%                     %                     end
%                 end ;
%                 
%                 % In order to control the visibility of handles....
%                 VT.handles_EditArea{Category,Type}.handleList = ...
%                     [ VT.handles_EditArea{Category, Type}.staticText ; ...
%                         VT.handles_EditArea{Category,Type}.Num(:) ; ...
%                         VT.handles_EditArea{Category,Type}.Length(:) ; ...
%                         VT.handles_EditArea{Category,Type}.Area(:) ; ...
%                     ]
%                 % create slides and ....
%                 if(Type==6 | Type==7 |Type> numSkip)   % second condition corresponding to 'generic'
%                     % 7 arbitrary , 8 from File
%                     % create edit area with 9 lines and an array to store 200 values
%                     % create slider
%                     %                     VT.handles_EditArea{Category,Type}.Length_data = zeros(1, 200) ;
%                     %                     VT.handles_EditArea{Category,Type}.Area_data = zeros(1, 200) ;
%                     VT.handles_EditArea{Category,Type}.Length_data = cell(1, 200) ;
%                     VT.handles_EditArea{Category,Type}.Area_data = cell(1, 200) ;
%                     VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)
%                     
%                     VT.handles_EditArea{Category,Type}.Slider =  uicontrol( ...
%                         'Style','slider', ...
%                         'Units','normalized', ...
%                         'Visible', 'Off', ...
%                         'Position',sliderPos, ...
%                         'SliderStep',[0.01 0.1],  ...
%                         'Value', 1 ) ;
%                     VT.handles_EditArea{Category,Type}.handleList = ...
%                         [ VT.handles_EditArea{Category,Type}.handleList ; ...
%                             VT.handles_EditArea{Category,Type}.Slider ; ...
%                         ]
%                 end 
%                 %errordlg('Create_handlesEditArea for vowel','Error', 'modal');
%             
         