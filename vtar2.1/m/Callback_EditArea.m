% This function  is for the callback at Edit area for area function setting
%
%     list of arguments
%     - category  , it can be zero for UicontextMenu Callback
%     - type
%     -  iAxis information is defined in data structure, only can be
%     modified my Popmenu

%     - varargin{1} ,
%       - 'General'       (category, type, 'general'),
%       - 'Insert'        (0  0  'Insert', gcbo )    -->  (category, type, 'Insert')
%       - 'Delete'        (0  0  'Delete', gcbo, )    -->  (category, type, 'Delete')
%       - 'From File'     (0  0  'From File', gcbo) -->  (category, type, 'From File')
%       - 'Clear All'     (0  0  'Clear All', gcbo) -->  (category, type, 'Clear All')
%       - 'Slider'        (category, type, 'Slider')
%       - 'Nostril'       (category, type, 'Nostril')
%       - 'Couple Area'       (category, type, 'Couple Area')
%       - 'Popmenu'             (category, type, 'Popmenu',
%                                   get(gcbo,'value'), change the value of
%                                   iAxis
%       - 'Sublingual'       (category, type, 'Sublingual')
%       - 'Supralungual'     (category, type, 'Supralungual')
%       - 'Lateral channels' (category, type, 'Lateral channels')
%       - 'Nostril'          (category, type, 'Nostril')
%
function  Callback_EditArea( Category, Type,  varargin )
global VT ;


%       - 'General'       (category, type, 'general'),
%       - 'Insert'        (0  0  'Insert', gcbo )    -->  (category, type, 'Insert')
%       - 'Delete'        (0  0  'Delete', gcbo, )    -->  (category, type, 'Delete')
%       - 'From File'     (0  0  'From File', gcbo) -->  (category, type, 'From File')
%       - 'Clear All'     (0  0  'Clear All', gcbo) -->  (category, type, 'Clear All')
%       - 'Slider'        (category, type, 'Slider')
%       - 'Nostril'       (category, type, 'Nostril')
%       - 'Couple Area'       (category, type, 'Couple Area')
%       - 'Popmenu'             (category, type, 'Popmenu',
%                                   get(gcbo,'value'), change the value of
%                                   iAxis
%       - 'Sublingual'       (category, type, 'Sublingual')
%       - 'Supralungual'     (category, type, 'Supralungual')
%       - 'Lateral channels' (category, type, 'Lateral channels')
%       - 'Nostril'          (category, type, 'Nostril')

action = varargin{1} ;
switch action
    %       - 'General'       (category, type, 'general'),
    % 1. see if it is the case that , vowel and type
    % <5
    % 2. copy data from edit area to array{},
    % editarea_to_array() ;
    % 3. get area function and copy it to vocal
    % tract model parameters, get_areafunction()
    % and set_plotdata()
    case 'General'
        if nargin == 4   % callback from edit area with handle
            h = varargin{2} ;
        else % call from call of model_type popmenu
            h = 0 ;
        end
        if h~=0  % check if the input is valid , but not do correction, just a remind ;
            if isnan( str2double( get(h, 'String') ))
                errordlg('Input must be zero or positive number','Error', 'modal');  % return ;
            end
            if 0 > ( str2double( get(h, 'String') ))
                errordlg('Input must be zero or positive number','Error', 'modal'); % return ;
            end
        end
        if Category==2 & (Type >=2 & Type <=5)  % for vowel with numBlock <=4 ;
            %---------------------------
            %  VOWEL
            %----------------------------
            [j, tempLength, tempArea] = get_areafunction(VT.handles_EditArea{Category,Type}.Length, ...
                VT.handles_EditArea{Category,Type}.Area ) ;
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea) ;

        else  % for any case with numblock >4,which needs to use information of pointer and number of section
            % 2. copy data from edit area to array{},
            % editarea_to_array() ;
            editarea_to_array(Category, Type) ;
            % 3. get area function and copy it to vocal
            % tract model parameters, get_areafunction()
            % and set_plotdata()
            [j, tempLength, tempArea] = get_areafunction1(Category, Type) ;
            % which axis the data belongs to
            iAxis = VT.handles_EditArea{Category,Type}.CurrentSection + 1 ; % not useful to vowel and consonant
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, iAxis);

            % copy the edit area to array with 200, based on Pointer number
            % use a small function to move data  !!! array should be with
            % strings ....

            % get area function from array

            %copy all the current data to plots
            if nargin == 3 % recalled by newly chosen model-type
                for iTemp = 1: length(VT.handles_EditArea{Category,Type}.Length_data)
                    [j, tempLength, tempArea] = get_areafunction1(Category, Type, iTemp) ;
                    % which axis the data belongs to
                    iAxis = iTemp+1 ;
                    set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, iAxis);
                end
            end
        end

        % *********
        % If the callback from slider,
        % Update information in edit area...

        % Update the pointer,

        % **********************
        %  what if it is because 'insert', 'delete', 'From a file'


        %       - 'Insert'        (0  0  'Insert', gcbo )    -->  (category, type, 'Insert')
        % 1. check which block is for gcbo,  num =
        %    get_handles(gcbo) , according current
        %    category, type and iAxis
        % 2. process_array() to do insert
        % 3. copy data from  array{} to ,edit area
        %    array_to_editarea() ;
        % 3. get area function and copy it to vocal
        % tract model parameters, get_areafunction()
        % and set_plotdata()
    case 'Insert'       % (0  0  'Insert', gcbo )    -->  (category, type, 'Insert')
        h = varargin{2} ;
        Category = VT.CurrentCategory ;  % which item is chosen in the menu
        Type = VT.CurrentModeltype ;
        if(Type==1 & VT.CurrentGeneric~=1)
            Type = VT.CurrentGeneric + 20 ;
        end
        update_array (Category,Type, 'Insert', h ) ;  % find which block is using callback
        % array_to_editarea(Category, Type) ;

        %       - 'Delete'        (0  0  'Delete', gcbo, )    -->  (category, type, 'Delete')
        % 1. check which block is for gcbo,  num =
        %    get_handles(gcbo) , according current
        %    category, type and iAxis
        % 2. process_array() to do delete
        % 3. copy data from  array{} to ,edit area
        %    array_to_editarea() ;
        % 3. get area function and copy it to vocal
        % tract model parameters, get_areafunction()
        % and set_plotdata()

    case 'Delete'       % (0  0  'Delete', gcbo, )    -->  (category, type, 'Delete')
        h = varargin{2} ;
        Category = VT.CurrentCategory ;  % which item is chosen in the menu
        Type = VT.CurrentModeltype ;
        if(Type==1 & VT.CurrentGeneric~=1)
            Type = VT.CurrentGeneric + 20 ;
        end
        update_array (Category,Type, 'Delete', h ) ;  % find which block is using callback
        %array_to_editarea(Category, Type) ;

        %       - 'From File'     (0  0  'From File', gcbo) -->  (category, type, 'From File')
        % 1. read file and get data
        % 2. check which block is for gcbo,  num =
        %    get_handles(gcbo) , according current
        %    category, type and iAxis
        % 3. process_array() to do add data
        % 3. copy data from  array{} to ,edit area
        %    array_to_editarea() ;
        % 3. get area function and copy it to vocal
        % tract model parameters, get_areafunction()
        % and set_plotdata()
    case 'From File'    % (0  0  'From File', gcbo) -->  (category, type, 'From File')
        Category = VT.CurrentCategory ;  % which item is chosen in the menu
        Type = VT.CurrentModeltype ;
        if(Type==1 & VT.CurrentGeneric~=1)
            Type = VT.CurrentGeneric + 20 ;
        end
        h = varargin{2} ;
        update_array (Category,Type, 'From File', h ) ;  % find which block is using callback
        % array_to_editarea(Category, Type) ;

        %       - 'Clear All'     (0  0  'Clear All', gcbo) -->  (category, type, 'Clear All')
        % 3. process_array() to do delete data
        % 3. copy data from  array{} to ,edit area
        %    array_to_editarea() ;
        % 3. get area function and copy it to vocal
        % tract model parameters, get_areafunction()
        % and set_plotdata()
    case 'Clear All'    % (0  0  'Clear All', gcbo) -->  (category, type, 'Clear All')
        Category = VT.CurrentCategory ;  % which item is chosen in the menu
        Type = VT.CurrentModeltype ;
        if(Type==1 & VT.CurrentGeneric~=1)
            Type = VT.CurrentGeneric + 20 ;
        end
        h = varargin{2} ;
        update_array (Category,Type, 'Clear All', h ) ;  % find which block is using callback
        % array_to_editarea(Category, Type) ;

        %       - 'Slider'        (category, type, 'Slider')
        % 3. get pointer position
        % 3. copy data from  array{} to ,edit area
        %    array_to_editarea() ;
        %
    case 'Slider'       % (category, type, 'Slider')

        nMax = get( VT.handles_EditArea{Category,Type}.Slider, 'Max') ;
        nValue = get( VT.handles_EditArea{Category,Type}.Slider, 'Value') ;
        VT.handles_EditArea{Category,Type}.Pointer = nMax - round(nValue) ; % from 0 - (200-numBlock)
        array_to_editarea(Category, Type) ;

    case 'Nostril'      % (category, type, 'Nostril')
        h = varargin{2} ;
        % regular process

        % I was trying to disable the axes not being used.
        %                 ud = get(VT.handles.vtar;,'userdata');
        %                 th = get(ud.ht.a,'title');
        %                 set(ud.ht.a(6)), 'enable', 'enable') ;
        %


        if (h == VT.handles_EditArea{Category, Type}.Nostril(1) )
            set(VT.handles_EditArea{Category, Type}.Nostril(1), 'Value', 1)
            set(VT.handles_EditArea{Category, Type}.Nostril(2), 'Value', 0)
            VT.Nasal.Geometry.TwoNostril = 0 ;
        else
            set(VT.handles_EditArea{Category, Type}.Nostril(1), 'Value', 0)
            set(VT.handles_EditArea{Category, Type}.Nostril(2), 'Value', 1)
            VT.Nasal.Geometry.TwoNostril = 1 ;
        end

        % the following was meant to deal with the case of nasalized
        % sound, since always 2 Nostrils in this case.
        % ----------------------------------------------

        %         if(Category==7)  % nasalized sound , always 2 Nostrils
        %             set(VT.handles_EditArea{Category, Type}.Nostril(1), 'Value', 0)
        %             set(VT.handles_EditArea{Category, Type}.Nostril(2), 'Value', 1)
        %             VT.Nasal.Geometry.TwoNostril = 1 ;
        %         else
        %             % regular process
        %             if (h == VT.handles_EditArea{Category, Type}.Nostril(1) )
        %                 set(VT.handles_EditArea{Category, Type}.Nostril(1), 'Value', 1)
        %                 set(VT.handles_EditArea{Category, Type}.Nostril(2), 'Value', 0)
        %                 VT.Nasal.Geometry.TwoNostril = 0 ;
        %             else
        %                 set(VT.handles_EditArea{Category, Type}.Nostril(1), 'Value', 0)
        %                 set(VT.handles_EditArea{Category, Type}.Nostril(2), 'Value', 1)
        %                 VT.Nasal.Geometry.TwoNostril = 1 ;
        %             end
        %         end

        % disable or enable one plots because of changing of number of
        % nostrils
        %
        %
    case 'Sublingual location'
        h = varargin{2} ;
        if (nargin == 5)
            % get a value in file to be display
            set(h, 'string', num2str(varargin{3}))
        end
        % check if data is valid
        if isnan( str2double( get(h, 'String') ))
            errordlg('Input must be zero or positive number','Error', 'modal');  % return ;
        end
        if 0 > ( str2double( get(h, 'String') ))
            errordlg('Input must be zero or positive number','Error', 'modal'); % return ;
        end
        VT.Rhotic.Geometry.SublingualLocation = str2double(get(h, 'string')) ;

    case 'Couple Area'   %    (category, type, 'Couple Area'),h,  value
        h = varargin{2} ;
        if (nargin == 5)
            % get a value in file to be display
            set(h, 'string', num2str(varargin{3}))
        end
        % check if data is valid
        if isnan( str2double( get(h, 'String') ))
            errordlg('Input must be zero or positive number','Error', 'modal');  % return ;
        end
        if 0 > ( str2double( get(h, 'String') ))
            errordlg('Input must be zero or positive number','Error', 'modal'); % return ;
        end

        if(Category == 4)
            VT.Nasal.Geometry.CoupleArea = str2double(get(h, 'string')) ;
        elseif(Category == 7)
            VT.NasalVowel.Geometry.CoupleArea = str2double(get(h, 'string')) ;
        else
            errordlg('something wroing with Couple Area','Error', 'modal'); % return ;
        end

    case 'Constriction Location'   %    (category, type, 'Constriction Location'),h,  value
        h = varargin{2} ;
        if (nargin == 5)
            % get a value in file to be display
            set(h, 'string', num2str(varargin{3}))
        end
        % check if data is valid
        if isnan( str2double( get(h, 'String') ))
            errordlg('Input must be zero or positive number','Error', 'modal');  % return ;
        end
        if 0 > ( str2double( get(h, 'String') ))
            errordlg('Input must be zero or positive number','Error', 'modal'); % return ;
        end

        if(Category == 3)
            VT.Consonant.Geometry.ConstrictionLocation = str2double(get(h, 'string')) ;
        else
            errordlg('something wroing with Constriction Location','Error', 'modal'); % return ;
        end

    case 'Popmenu'       %      (category, type, 'Popmenu', h, value
        h = varargin{2} ;
        if (nargin == 5)
            % get a value in file to be display
            set(h, 'Value', varargin{3})
        end
        VT.handles_EditArea{Category,Type}.CurrentSection = get(h, 'Value') ;
        % reset pointer and slider, copy new data to edit area
        % reset these value
        % VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;
        VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)
        Temp = get(VT.handles_EditArea{Category,Type}.Slider, 'Max') ;
        set(VT.handles_EditArea{Category,Type}.Slider, 'Value', Temp)

        % copy new data to edit area
        array_to_editarea(Category, Type, VT.handles_EditArea{Category,Type}.CurrentSection) ;


        %       get(gcbo,'value'), change the value of
        %      iAxis


    case 'Sublingual'       %(category, type, 'Sublingual')
        h = varargin{2} ;
        if (h == VT.handles_EditArea{Category, Type}.Sublingual(1) )
            set(VT.handles_EditArea{Category, Type}.Sublingual(1), 'Value', 1)
            set(VT.handles_EditArea{Category, Type}.Sublingual(2), 'Value', 0)
            VT.Rhotic.Geometry.SublingualOn = 1 ;
        else
            set(VT.handles_EditArea{Category, Type}.Sublingual(1), 'Value', 0)
            set(VT.handles_EditArea{Category, Type}.Sublingual(2), 'Value', 1)
            VT.Rhotic.Geometry.SublingualOn = 0 ;
        end

    case 'Supralingual'     %(category, type, 'Supralingual')
        h = varargin{2} ;
        if (h == VT.handles_EditArea{Category, Type}.Supralingual(1) )
            set(VT.handles_EditArea{Category, Type}.Supralingual(1), 'Value', 1)
            set(VT.handles_EditArea{Category, Type}.Supralingual(2), 'Value', 0)
            VT.Lateral.Geometry.SupralingualOn = 1 ;
        else
            set(VT.handles_EditArea{Category, Type}.Supralingual(1), 'Value', 0)
            set(VT.handles_EditArea{Category, Type}.Supralingual(2), 'Value', 1)
            VT.Lateral.Geometry.SupralingualOn = 0 ;
        end
    case 'Lateral Channels' %(category, type, 'Lateral channels')
        h = varargin{2} ;
        if (h == VT.handles_EditArea{Category, Type}.LateralChannel(1) )
            set(VT.handles_EditArea{Category, Type}.LateralChannel(1), 'Value', 1)
            set(VT.handles_EditArea{Category, Type}.LateralChannel(2), 'Value', 0)
            VT.Lateral.Geometry.LateralOn = 0 ;
        else
            set(VT.handles_EditArea{Category, Type}.LateralChannel(1), 'Value', 0)
            set(VT.handles_EditArea{Category, Type}.LateralChannel(2), 'Value', 1)
            VT.Lateral.Geometry.LateralOn = 1 ;
        end

    case 'readFile'
        readFile(Category, Type,  varargin{:}) ;

        % if recalled from vtar.m  'area function from file'
        %    Callback_EditArea( VT.CurrentCategory, VT.CurrentModeltype, 'readFile') ;
    case 'Load'
        loadFile(Category, Type,  varargin{:}) ;
    case 'arbitrary'
        val = get(VT.handles_EditArea{Category, Type}.IndexOfBranch, 'value') ;
        if(val ~= VT.handles_EditArea{Category, Type}.Index) % change tube no.
            VT.handles_EditArea{Category, Type}.Index = val ;
            loadTube(Category, Type,  varargin{:}) ;
        else
            % display('2') ; toc
            saveTube(Category, Type,  varargin{:}) ;
        end
        % update plots display on screen
        %------------------------------------
        ud = get(VT.handles.vtar,'userdata');
        filtview('plots', ud.prefs.plots) ;

    otherwise
        errordlg('callback in edit area ', 'Error ', 'modal')
end
return ;


%       - 'General'       (category, type, 'general'),
% 1. see if it is the case that , vowel and type
% <5
% 2. copy data from edit area to array{},
% editarea_to_array() ;
% 3. get area function and copy it to vocal
% tract model parameters, get_areafunction()
% and set_plotdata()

%       - 'Insert'        (0  0  'Insert', gcbo )    -->  (category, type, 'Insert')
% 1. check which block is for gcbo,  num =
%    get_handles(gcbo) , according current
%    category, type and iAxis
% 2. process_array() to do insert
% 3. copy data from  array{} to ,edit area
%    array_to_editarea() ;
% 3. get area function and copy it to vocal
% tract model parameters, get_areafunction()
% and set_plotdata()

%       - 'Delete'        (0  0  'Delete', gcbo, )    -->  (category, type, 'Delete')
% 1. check which block is for gcbo,  num =
%    get_handles(gcbo) , according current
%    category, type and iAxis
% 2. process_array() to do delete
% 3. copy data from  array{} to ,edit area
%    array_to_editarea() ;
% 3. get area function and copy it to vocal
% tract model parameters, get_areafunction()
% and set_plotdata()

%       - 'From File'     (0  0  'From File', gcbo) -->  (category, type, 'From File')
% 1. read file and get data
% 2. check which block is for gcbo,  num =
%    get_handles(gcbo) , according current
%    category, type and iAxis
% 3. process_array() to do add data
% 3. copy data from  array{} to ,edit area
%    array_to_editarea() ;
% 3. get area function and copy it to vocal
% tract model parameters, get_areafunction()
% and set_plotdata()
%       - 'Clear All'     (0  0  'Clear All', gcbo) -->  (category, type, 'Clear All')
% 3. process_array() to do delete data
% 3. copy data from  array{} to ,edit area
%    array_to_editarea() ;
% 3. get area function and copy it to vocal
% tract model parameters, get_areafunction()
% and set_plotdata()
%       - 'Slider'        (category, type, 'Slider')
% 3. get pointer position
% 3. copy data from  array{} to ,edit area
%    array_to_editarea() ;
%

%       - 'Couple Area'       (category, type, 'Couple Area')
%1. copy this value to data structure
%2. copy this to geometry parameter

%       - 'Popmenu'             (category, type, 'Popmenu',
%                                   get(gcbo,'value'), change the value of
%                                   iAxis
% change the current iAxis
% update the edit area display
%       - 'Sublingual'       (category, type, 'Sublingual')
% 1. update popmenu according to number of Sublingual'
% 2. update editarea if the current edit area
% is going to be removed.
% 2. change the prefesplots
% 3. disable or able one item

% same sequence for the following 2 options
%
%       - 'Supralungual'     (category, type, 'Supralungual')

%       - 'Lateral channels' (category, type, 'Lateral channels')






% get the information for area function based on input from edit area
% get rid of bad data input like NaN or negative value
% just for vowel ? simple cases
function [j, tempLength, tempArea] = get_areafunction(hLength, hArea ) ;
j = 0 ;
nLength = length( hLength ) ;
tempLength = 0 ;
tempArea = 0 ;
for i = 1: nLength
    if isnan( str2double( get(hLength(i), 'String') ))
        break ;
    end
    if isnan( str2double( get(hArea(i), 'String') ))
        break ;
    end
    if ( str2double( get(hLength(i), 'String') )) < 0
        break ;
    end
    if ( str2double( get(hArea(i), 'String') )) < 0
        break ;
    end
    j = j+1 ;
    tempLength(j)= str2double( get(hLength(i), 'String') ) ;
    tempArea(j)  = str2double( get(hArea(i), 'String') );
end

return ;


%  Copy data from edit area to cell array corresping to which section
%  (num)and pointer position
% -----------------------------------------------------
function editarea_to_array(Category, Type)
global VT ;
iLength = length(VT.handles_EditArea{Category,Type}.Length) ;
startingPos = VT.handles_EditArea{Category,Type}.Pointer ;
num =  VT.handles_EditArea{Category,Type}.CurrentSection ; % which section being edited

for i = 1:iLength
    sTemp1 = get(VT.handles_EditArea{Category,Type}.Length(i), 'String');
    sTemp2 = get(VT.handles_EditArea{Category,Type}.Area(i), 'String');

    VT.handles_EditArea{Category,Type}.Length_data{num}{i+startingPos} = sTemp1 ;
    VT.handles_EditArea{Category,Type}.Area_data{num}{i+startingPos} = sTemp2 ;

end

h = gcbo ;
for i = 1:iLength
    if (h ==VT.handles_EditArea{Category,Type}.Length(i) |  h ==VT.handles_EditArea{Category,Type}.Area(i))
        if isnan( str2double( get(h, 'String') ))
            errordlg('Input must be zero or positive number','Error', 'modal');  break ; % return ;
        end
        if 0 > ( str2double( get(h, 'String') ))
            errordlg('Input must be zero or positive number','Error', 'modal');  break ;% return ;
        end
    end
end


%    VT.handles_EditArea{Category,Type}.CurrentSection
%
%    VT.handles_EditArea{Category,Type}.Num(i)
%    for i =1: numSection
%      = cell(1, 200) ;
%     VT.handles_EditArea{Category,Type}.Area_data{i}   = cell(1, 200) ;
% end

return ;

% copy data to edit area if slider is changed
%  Copy data from cell array to edit area  corresping to which section
%  (num)and pointer position
%------------------------------------------------------------
function array_to_editarea(Category, Type, varargin) ;
global VT ;
iLength = length(VT.handles_EditArea{Category,Type}.Length) ;
startingPos = VT.handles_EditArea{Category,Type}.Pointer ;

if (nargin == 2)
    num =  VT.handles_EditArea{Category,Type}.CurrentSection ; % which section being edited
else
    num = varargin{1} ;
end

for i = 1:iLength
    sTemp1 = VT.handles_EditArea{Category,Type}.Length_data{num}{i+startingPos} ;
    sTemp2 = VT.handles_EditArea{Category,Type}.Area_data{num}{i+startingPos} ;

    set(VT.handles_EditArea{Category,Type}.Length(i), 'String', sTemp1);
    set(VT.handles_EditArea{Category,Type}.Area(i), 'String', sTemp2);
    set(VT.handles_EditArea{Category,Type}.Num(i), 'String', i+startingPos);
end

return ;




% 3. get area function and copy it to vocal
% tract model parameters, get_areafunction()
% and set_plotdata()

% function [j, tempLength, tempArea] = get_areafunction1(Category, Type, varargin)
%
% this function is to get area function from cell array
% where the area funciton information is stored in string
% instead of double.
%
% num : which section from which the function get the area function
% for example, /r/ sound has 2 or 3 parts in schematic
%---------------------------------------------------------------
function [j, tempLength, tempArea] = get_areafunction1(Category, Type, varargin)
global VT ;
if (nargin == 2)
    num =  VT.handles_EditArea{Category,Type}.CurrentSection ; % which section being edited
else
    num = varargin{1} ;
end

j = 0 ;
nLength = 200 ; % length( hLength ) ;
tempLength = 0 ;
tempArea = 0 ;
for i = 1: nLength
    Temp1 = str2double( VT.handles_EditArea{Category,Type}.Length_data{num}{i} ) ;
    Temp2   = str2double( VT.handles_EditArea{Category,Type}.Area_data{num}{i} ) ;

    if isnan( Temp1 ) |  isnan(Temp2 )
        break ;
    end
    if Temp1<0 | Temp2<0
        break ;
    end

    j = j+1 ;
    tempLength(j)= Temp1 ;
    tempArea(j)  = Temp2 ;
end

return ;



% For callbacks of unimenu
% do Insert, delete, ....
%--------------------------------
function update_array (Category,Type, action, h ) ;  % find which block is using callback

global VT ;
iIndex = get_index(Category,Type, h) ;
num =  VT.handles_EditArea{Category,Type}.CurrentSection ; % which section being edited
iLength = length(VT.handles_EditArea{Category,Type}.Length_data{num}) ;

switch action
    %       - 'Insert'        (0  0  'Insert', gcbo )    -->  (category, type, 'Insert')
    % 1. check which block is for gcbo,  num =
    %    get_handles(gcbo) , according current
    %    category, type and iAxis
    % 2. process_array() to do insert
    % 3. copy data from  array{} to ,edit area
    %    array_to_editarea() ;
    % 3. get area function and copy it to vocal
    % tract model parameters, get_areafunction()
    % and set_plotdata()
    case 'Insert'       %  essentially, 'Insert before'     (0  0  'Insert', gcbo )    -->  (category, type, 'Insert')
        startingPos = iIndex + VT.handles_EditArea{Category,Type}.Pointer ;

        for i = iLength: -1: startingPos+1
            VT.handles_EditArea{Category,Type}.Length_data{num}{i} = VT.handles_EditArea{Category,Type}.Length_data{num}{i-1} ;
            VT.handles_EditArea{Category,Type}.Area_data{num}{i} = VT.handles_EditArea{Category,Type}.Area_data{num}{i-1} ;
        end
        if(startingPos <= iLength )
            VT.handles_EditArea{Category,Type}.Length_data{num}{startingPos} = [] ;
            VT.handles_EditArea{Category,Type}.Area_data{num}{startingPos} = [] ;
        end




        %       - 'Delete'        (0  0  'Delete', gcbo, )    -->  (category, type, 'Delete')
        % 1. check which block is for gcbo,  num =
        %    get_handles(gcbo) , according current
        %    category, type and iAxis
        % 2. process_array() to do delete
        % 3. copy data from  array{} to ,edit area
        %    array_to_editarea() ;
        % 3. get area function and copy it to vocal
        % tract model parameters, get_areafunction()
        % and set_plotdata()

    case 'Delete'       % (0  0  'Delete', gcbo, )    -->  (category, type, 'Delete')
        startingPos = iIndex + VT.handles_EditArea{Category,Type}.Pointer ;

        for i = startingPos : iLength-1
            VT.handles_EditArea{Category,Type}.Length_data{num}{i} = VT.handles_EditArea{Category,Type}.Length_data{num}{i+1} ;
            VT.handles_EditArea{Category,Type}.Area_data{num}{i} = VT.handles_EditArea{Category,Type}.Area_data{num}{i+1} ;
        end
        VT.handles_EditArea{Category,Type}.Length_data{num}{iLength} = [] ;
        VT.handles_EditArea{Category,Type}.Length_data{num}{iLength} = [] ;

        %       - 'From File'     (0  0  'From File', gcbo) -->  (category, type, 'From File')
        % 1. read file and get data
        % 2. check which block is for gcbo,  num =
        %    get_handles(gcbo) , according current
        %    category, type and iAxis
        % 3. process_array() to do add data
        % 3. copy data from  array{} to ,edit area
        %    array_to_editarea() ;
        % 3. get area function and copy it to vocal
        % tract model parameters, get_areafunction()
        % and set_plotdata()
    case 'From File'    % (0  0  'From File', gcbo) -->  (category, type, 'From File')
        [j tempLength, tempArea] = readFile ;
        if j < 0  % no file reading succeeds
            return ;
        end
        % reading data with success
        startingPos = iIndex + VT.handles_EditArea{Category,Type}.Pointer ;

        % it is equivalent to insert length(tempLength) ,

        % move old data, shift....
        for i = iLength: -1: startingPos+length(tempLength)
            %            iTemp = i-startingPos+1 ;
            %            if (iTemp<=length(tempLength))
            VT.handles_EditArea{Category,Type}.Length_data{num}{i} = ...
                VT.handles_EditArea{Category,Type}.Length_data{num}{i-length(tempLength)} ;
            VT.handles_EditArea{Category,Type}.Area_data{num}{i} = ...
                VT.handles_EditArea{Category,Type}.Area_data{num}{i-length(tempLength)} ;
            %            end ;
        end

        % put into new data
        for i = startingPos : iLength
            iTemp = i-startingPos+1 ;
            if (iTemp<=length(tempLength))
                VT.handles_EditArea{Category,Type}.Length_data{num}{i} = num2str(tempLength(iTemp)) ;
                VT.handles_EditArea{Category,Type}.Area_data{num}{i} = num2str(tempArea(iTemp)) ;
            end ;
        end


        %       - 'Clear All'     (0  0  'Clear All', gcbo) -->  (category, type, 'Clear All')
        % 3. process_array() to do delete data
        % 3. copy data from  array{} to ,edit area
        %    array_to_editarea() ;
        % 3. get area function and copy it to vocal
        % tract model parameters, get_areafunction()
        % and set_plotdata()
    case 'Clear All'    % (0  0  'Clear All', gcbo) -->  (category, type, 'Clear All')
        for i = 1 : iLength
            VT.handles_EditArea{Category,Type}.Length_data{num}{i} = [] ;
            VT.handles_EditArea{Category,Type}.Area_data{num}{i} = [] ;
        end
end

% copy back to edit area and also update the plots
array_to_editarea(Category, Type) ;
if (Category == 8)
    Callback_EditArea( Category, Type, 'arbitrary', 0) ;
else
    [j, tempLength, tempArea] = get_areafunction1(Category, Type) ;
    % which axis the data belongs to
    iAxis = num + 1 ; % not useful to vowel and consonant
    set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, iAxis);
end
return ;


%
% Get the index for unicontextmenu callback
% based on handle h, find which number or edit area is being edited
%---------------------------------------------------
function iIndex = get_index(Category,Type, h) ;
global VT ;
iIndex = find(VT.handles_EditArea{Category,Type}.Length == h) ;
if ~isempty(iIndex), return ; end ;
iIndex = find(VT.handles_EditArea{Category,Type}.Area == h) ;
if isempty(iIndex)
    errordlg('Index error', 'Error!!! ', 'modal') ;, return ;
end ;
return ;



%        loadFile(Category, Type,  varargin{:}) ;




%function [j, tempLength, tempArea] = readFile(varargin)
function [j, tempLength, tempArea] = readFile(varargin)

global VT ;
j = -1 ;
tempLength = 0 ;
tempArea = 0 ;

if nargin >= 2
    Category = varargin{1} ;
    Type     = varargin{2} ;

end

% no argument input means read only for one section
% 3 means that a file need to be specified here
% 4 means that a file name is already speciied by varargin{4}

% get the file name
if nargin == 0 | nargin == 3
    % read file for one section,  recalled by contextuimenu
    %----------------------------
    [filename, pathname] = uigetfile( ...
        {'*.ARE', 'All Area Function -Files (*.ARE)'; ...
        '*.*','All Files (*.*)'}, ...
        'load area function data');
    % If "Cancel" is selected then return
    if isequal([filename,pathname],[0,0]), return ; end ;
    % Otherwise construct the fullfilename and Check and load the file.
    File = fullfile(pathname,filename);
    if isempty(File)
        return ;
    end
    if exist(File) ~= 2
        errordlg('File does not exist','Error', 'modal'); return ;
    end


else
    File = varargin{4};
end

% reading file
if nargin == 0
    % read file for one section,  recalled by contextuimenu
    %---------------------------------------------------
    fid = fopen(File);
    a = fscanf(fid,'%c', 1) ;  % skip 4 chars just for the format in madea's area function file
    %  disp(a) ;
    while a ~= ']'
        a = fscanf(fid,'%c',1) ;
        if(feof(fid))
            errordlg('File format error', 'Error', 'modal') ;  return ;
        end
    end

    SectionNum = fscanf(fid,'%f',1) ;
    if isempty(SectionNum)
        errordlg('File format error', 'Error', 'modal') ;  return ;
    end
    SectionNum = round (SectionNum );
    if(SectionNum <= 0)
        errordlg(['File format error: ' ' SectionNum <= 0 '], 'Error', 'modal') ;  return ;
    end

    % read all the data after Location
    jtemp = 1 ;
    tempArray = [] ;
    while 1
        temp = fscanf(fid,'%f',1) ;
        if(isempty(temp))
            break ;
        end
        tempArray(jtemp) = temp ;
        jtemp = jtemp + 1 ;
    end

    if (length(tempArray) == SectionNum + 1 )
        j = SectionNum ;
        SectionLength = tempArray(1) ;
        tempLength = SectionLength*ones(1,SectionNum) ;
        tempArea =  tempArray(2:end) ;
    elseif (length(tempArray) == 2*SectionNum)
        j = SectionNum ;
        tempLength = tempArray(1:SectionNum) ;
        tempArea   =  tempArray(SectionNum+1:end) ;
    else
        errordlg(['File format error: ' ' length of data is wrong '], 'Error', 'modal') ;  return ;
    end

    j = 1 ;  %  reading should be ok if the running program reaches here.

    fclose(fid)
else

    % if Category == 8 do not use following statment
    if (Category == 8)
        createTree(File)
        return ;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555555
    % if the file is .mat file, instead of .ARE file
    % /r/ or /l/ data used
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    if(~isa(File, 'Char')) % not a real file
    if(~ischar(File)) % not a real file
        %      'Main'
        tempModelType = 2 ;
        % do this before create edit area if the type is different from 1.
        updateplots(VT.handles, 'category',  tempModelType)
        if(tempModelType ~= VT.handles_EditArea{Category,Type}.RealType)

            % check if tempModelType right
            if(tempModelType <= 0 | tempModelType>length(VT.Model_types{Category})-2 ) % if the model type array is 4, that means there are 2 types of model
                hTemp = errordlg('Model selection error in the input file', 'Error', 'modal') ;  return ;
            end

            % if the model type is diffenernt from default, the edit area
            % should be rebuilt since different modle may have different
            % data structure and input interface.
            %---------------------------------------
            % if (tempModelType)
            Ind = find (VT.handles_EditArea{ Category,Type }.handleList ~= 0) ;   % do not delete root
            delete(VT.handles_EditArea{ Category,Type }.handleList(Ind) ) ;
            VT.handles_EditArea{ Category,Type } = [] ;
            % set(VT.handles_EditArea{ Category,Type }.handleList, 'visible', 'off') ;
            if( ~Create_handlesEditArea( Category, Type, 'model', tempModelType ) )
                return ;  % invalid tempModelType
            end;
        end

        tempLength = File(:,1); tempArea = File(:,2);
        put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
        set_plotdata(Category, tempModelType, tempLength, tempArea, 2);  % 2 unused for vowel
        %      'Sublingual_on_or_off'             [1 - on , 0 - off]
        [tempLength] = 0 ;
        if(tempLength == 1)
            Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(1))
        elseif(tempLength == 0)
            Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(2))
        else
            errordlg(['reading Sublingual_on_or_off !'], 'Error', 'modal') ; % return ;
        end
        %      'Sublingual'
        if(tempLength == 1)
        else
            set_plotdata(Category, tempModelType, 0, 0, 3);  %
        end
        VT.Current_handle_EditArea = VT.handles_EditArea{ Category,Type }.handleList ;
        set(VT.Current_handle_EditArea, 'visible', 'on') ;
        % reset these value
        VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;
        VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)
        Temp = get(VT.handles_EditArea{Category,Type}.Slider, 'Max') ;
        set(VT.handles_EditArea{Category,Type}.Slider, 'Value', Temp) ;

          % popmenu
            Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;
        return ;
    end
%%%%%%%%%%%%%%%%%%%%%%%%
%%% /r/ data from .mat
%%%%%%%%%%%%%%%%%%%%%%%%%

    % read file on data of area function
    %---------------------------------------------------

    % check if type match
    % tempCategory = get_data(Category, 'Category_Selection:', File) ;  % get data from file
    tempCategory = get_data(0, 'Category_Selection:', File) ;  % get data from file
    if ((Category-1) ~= tempCategory)
        if(Category ~= 1)   % I am trying to include one case that import area function wihtout specifiy the category from interface, just infer from file
            errordlg('Category Error', 'Error', 'modal') ;  return ;
        else
            Category = tempCategory + 1 ;
            % other work to do , since category is NONE  right now
        end
    end

    tempModelType  = get_data(0, 'Model_Selection:', File) ;  % get data from file
    tempModelType = round(tempModelType) ;

    % do this before create edit area if the type is different from 1.
    updateplots(VT.handles, 'category',  tempModelType)
    if(tempModelType ~= VT.handles_EditArea{Category,Type}.RealType)

        % check if tempModelType right
        if(tempModelType <= 0 | tempModelType>length(VT.Model_types{Category})-2 ) % if the model type array is 4, that means there are 2 types of model
            hTemp = errordlg('Model selection error in the input file', 'Error', 'modal') ;  return ;
        end

        % if the model type is diffenernt from default, the edit area
        % should be rebuilt since different modle may have different
        % data structure and input interface.
        %---------------------------------------
        % if (tempModelType)
        Ind = find (VT.handles_EditArea{ Category,Type }.handleList ~= 0) ;   % do not delete root
        delete(VT.handles_EditArea{ Category,Type }.handleList(Ind) ) ;
        VT.handles_EditArea{ Category,Type } = [] ;
        % set(VT.handles_EditArea{ Category,Type }.handleList, 'visible', 'off') ;
        if( ~Create_handlesEditArea( Category, Type, 'model', tempModelType ) )
            return ;  % invalid tempModelType
        end;
        VT.Current_handle_EditArea = VT.handles_EditArea{ Category,Type }.handleList ; 
        set(VT.Current_handle_EditArea, 'visible', 'on') ;
    end

    % update the titles in case modeltype  is changed
    updateplots(VT.handles, 'category',  tempModelType) ;

    % reset these value
    VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;
    VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)
    Temp = get(VT.handles_EditArea{Category,Type}.Slider, 'Max') ;
    set(VT.handles_EditArea{Category,Type}.Slider, 'Value', Temp) ;

    switch    Category
        case 2  % 'Vowel'

            [j, tempLength, tempArea] = get_data(Category-1, 'Vowel', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel
            % tempModelType
            array_to_editarea(Category, Type) ;

        case 3  % 'Consonant'
            [j, tempLength, tempArea] = get_data(Category-1, 'Consonant', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel
            array_to_editarea(Category, Type) ;

            % 'Constriction_Location'
            [tempLength] = get_data(Category-1, '''Constriction_Location''', File) ;  % get data from file
            % copy this to edit area
            Callback_EditArea(Category, Type, 'Constriction Location', VT.handles_EditArea{Category, Type}.ConstrictionLocation, tempLength)


        case 4  % 'Nasal'
            %            Pharynx
            [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel

            %            Oral
            [j, tempLength, tempArea] = get_data(Category-1, '''Oral''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel
            %            Back
            [j, tempLength, tempArea] = get_data(Category-1, '''Velar_tube''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 4);  % 2 unused for vowel
            %            Nostril_1
            [j, tempLength, tempArea] = get_data(Category-1, '''Nostril_1''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 4) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 5);  % 2 unused for vowel

            %        number of nostrils
            [tempLength] = get_data(Category-1, '''number_of_Nostril''', File) ;  % get data from file
            % copy this to edit area
            if(tempLength == 2)
                Callback_EditArea(Category, Type, 'Nostril', VT.handles_EditArea{Category, Type}.Nostril(2))
            elseif(tempLength == 1)
                Callback_EditArea(Category, Type, 'Nostril', VT.handles_EditArea{Category, Type}.Nostril(1))
            else
                errordlg(['number_of_Nostril WRONG !'], 'Error', 'modal') ; % return ;
            end

            %            Nostril_2
            if(tempLength == 2)
                [j, tempLength, tempArea] = get_data(Category-1, '''Nostril_2''', File) ;  % get data from file
                put_areafunction(Category,Type,tempLength, tempArea, 5) ; % put data into array
                set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 6);  % 2 unused for vowel
            end

            % popmenu
            Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;

            % do not need it since Popmenu callback will do this ....
            % array_to_editarea(Category, Type) ;

            %           'CoupleArea'
            [tempLength] = get_data(Category-1, '''CoupleArea''', File) ;  % get data from file
            Callback_EditArea(Category, Type, 'Couple Area', VT.handles_EditArea{Category, Type}.CoupleArea, tempLength) ;


        case 5  % '/r/'
            switch tempModelType
                case 1
                    %      'Back'
                    [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
                    put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
                    set_plotdata(Category, tempModelType, tempLength, tempArea, 2);  % 2 unused for vowel

                    %      'Front'
                    [j, tempLength, tempArea] = get_data(Category-1, '''Front''', File) ;  % get data from file
                    put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
                    set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel
                    %      'Sublingual_on_or_off'             [1 - on , 0 - off]
                    [tempLength] = get_data(Category-1, '''Sublingual_on_or_off''', File) ;  % get data from file
                    if(tempLength == 1)
                        Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(1))
                    elseif(tempLength == 0)
                        Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(2))
                    else
                        errordlg(['reading Sublingual_on_or_off !'], 'Error', 'modal') ; % return ;
                    end
                    %      'Sublingual'
                    if(tempLength == 1)
                        [j, tempLength, tempArea] = get_data(Category-1, '''Sublingual''', File) ;  % get data from file
                        put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
                        set_plotdata(Category, tempModelType, tempLength, tempArea, 4);  % 2 unused for vowel
                    else
                        set_plotdata(Category, tempModelType, 0, 0, 4);  %
                    end

                case 2
                    %      'Main'
                    [j, tempLength, tempArea] = get_data(Category-1, '''Main''', File) ;  % get data from file
                    put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
                    set_plotdata(Category, tempModelType, tempLength, tempArea, 2);  % 2 unused for vowel
                    %      'Sublingual_on_or_off'             [1 - on , 0 - off]
                    [tempLength] = get_data(Category-1, '''Sublingual_on_or_off''', File) ;  % get data from file
                    if(tempLength == 1)
                        Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(1))
                    elseif(tempLength == 0)
                        Callback_EditArea(Category, Type, 'Sublingual', VT.handles_EditArea{Category, Type}.Sublingual(2))
                    else
                        errordlg(['reading Sublingual_on_or_off !'], 'Error', 'modal') ; % return ;
                    end
                    %      'Sublingual'
                    if(tempLength == 1)
                        [j, tempLength, tempArea] = get_data(Category-1, '''Sublingual''', File) ;  % get data from file
                        put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
                        set_plotdata(Category, tempModelType, tempLength, tempArea, 3);  % 2 unused for vowel

                        % sublingual_caivity_location
                        [tempLength] = get_data(Category-1, '''SublingualLocation''', File) ;  % get data from file
                        Callback_EditArea(Category, Type, 'Sublingual location', VT.handles_EditArea{Category, Type}.SublingualLocation, tempLength) ;

                    else
                        set_plotdata(Category, tempModelType, 0, 0, 3);  %
                    end
                otherwise
                    errordlg('Error in /r/ model type', 'Error', 'modal') ;
            end



            % popmenu
            Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;


        case 6  % '/l/'


            %      'Back'
            [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel
            %      'Front'
            [j, tempLength, tempArea] = get_data(Category-1, '''Front''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel
            %      'Channel1'
            [j, tempLength, tempArea] = get_data(Category-1, '''Channel1''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 4) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 5);  % 2 unused for vowel

            %      'Number_of_Channels'          2    [ 2 or 1, if 1, then only Channel1 valid]
            [tempLength] = get_data(Category-1, '''Number_of_Channels''', File) ;  % get data from file
            if(tempLength == 2)
                Callback_EditArea(Category, Type, 'Lateral Channels', VT.handles_EditArea{Category, Type}.LateralChannel(2)) ;
            elseif(tempLength == 1)
                Callback_EditArea(Category, Type, 'Lateral Channels', VT.handles_EditArea{Category, Type}.LateralChannel(1)) ;
            else
                errordlg(['Number_of_Channels !'], 'Error', 'modal') ; % return ;
            end

            %      'Channel2'
            if(tempLength == 2)
                [j, tempLength, tempArea] = get_data(Category-1, '''Channel2''', File) ;  % get data from file
                put_areafunction(Category,Type,tempLength, tempArea, 5) ; % put data into array
                set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 6);  % 2 unused for vowel
            end
            %      'Supralingual_on_or_off'      1    [1 - on , 0 - off]
            [tempLength] = get_data(Category-1, '''Supralingual_on_or_off''', File) ;  % get data from file

            if(tempLength == 1)
                Callback_EditArea(Category, Type, 'Supralingual', VT.handles_EditArea{Category, Type}.Supralingual(1))
            elseif(tempLength == 0)
                Callback_EditArea(Category, Type, 'Supralingual', VT.handles_EditArea{Category, Type}.Supralingual(2))
            else
                errordlg(['Supralingual_on_or_off !'], 'Error', 'modal') ; % return ;
            end
            %      'Supralingual'
            if(tempLength == 1)
                [j, tempLength, tempArea] = get_data(Category-1, '''Supralingual''', File) ;  % get data from file
                put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
                set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 4);  % 2 unused for vowel

            end

            % popmenu
            Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;



        case 7  % 'Nasalized_vowel'
            %      'number_of_Nostril' 2                  [ always 2 in current coding  or 1, if 1, then only Nostril_1 valid]
            %      'Pharynx'
            %      'Oral'
            %      'Back'
            %      'Nostril_1'
            %      'Nostril_2'
            %      'CoupleArea'  2.0
            %            Pharynx
            [j, tempLength, tempArea] = get_data(Category-1, '''Back''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 1) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 2);  % 2 unused for vowel

            %            Oral
            [j, tempLength, tempArea] = get_data(Category-1, '''Oral''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 2) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 3);  % 2 unused for vowel
            %            Back
            [j, tempLength, tempArea] = get_data(Category-1, '''Velar_tube''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 3) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 4);  % 2 unused for vowel
            %            Nostril_1
            [j, tempLength, tempArea] = get_data(Category-1, '''Nostril_1''', File) ;  % get data from file
            put_areafunction(Category,Type,tempLength, tempArea, 4) ; % put data into array
            set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 5);  % 2 unused for vowel

            %        number of nostrils
            [tempLength] = get_data(Category-1, '''number_of_Nostril''', File) ;  % get data from file
            % copy this to edit area
            if(tempLength == 2)
                Callback_EditArea(Category, Type, 'Nostril', VT.handles_EditArea{Category, Type}.Nostril(2))
            else
                Callback_EditArea(Category, Type, 'Nostril', VT.handles_EditArea{Category, Type}.Nostril(1))
            end

            %            Nostril_2
            if(tempLength == 2)
                [j, tempLength, tempArea] = get_data(Category-1, '''Nostril_2''', File) ;  % get data from file
                put_areafunction(Category,Type,tempLength, tempArea, 5) ; % put data into array
                set_plotdata(Category, VT.handles_EditArea{Category, Type}.RealType, tempLength, tempArea, 6);  % 2 unused for vowel
            end

            % popmenu
            Callback_EditArea(Category, Type, 'Popmenu', VT.handles_EditArea{Category, Type}.Popmenu, 1) ;

            % do not need it since Popmenu callback will do this ....
            % array_to_editarea(Category, Type) ;

            %           'CoupleArea'
            [tempLength] = get_data(Category-1, '''CoupleArea''', File) ;  % get data from file
            Callback_EditArea(Category, Type, 'Couple Area', VT.handles_EditArea{Category, Type}.CoupleArea, tempLength) ;



        otherwise
    end
end

return ;



% pass area functin data into cell array and store it .
%
% ------------------------------------------------
function put_areafunction(Category,Type,tempLength, tempArea, num) ; % put data into array
global VT ;

% remove old data
iLength = length(VT.handles_EditArea{Category,Type}.Length_data{num}) ;
for i = 1 : iLength
    VT.handles_EditArea{Category,Type}.Length_data{num}{i} = [] ;
    VT.handles_EditArea{Category,Type}.Area_data{num}{i} = [] ;
end

% put into new data
for iTemp = 1 : iLength
    if (iTemp<=length(tempLength))
        VT.handles_EditArea{Category,Type}.Length_data{num}{iTemp} = num2str(tempLength(iTemp)) ;
        VT.handles_EditArea{Category,Type}.Area_data{num}{iTemp} = num2str(tempArea(iTemp)) ;
    end ;
end
return ;


% function [j, tempLength, tempArea] = get_data1(Category, String, File, Datatype) ;  % get data from file
%
% j = -1 ;
% tempLength = 1 ;
% tempArea   = 0 ;
%
%     fid = fopen(File);
%     a = fscanf(fid,'%c', 1) ;  % skip 4 chars just for the format in madea's area function file
%     while a ~= ']'
%         a = fscanf(fid,'%c',1) ;
%         if(feof(fid))
%             errordlg('File format error', 'Error', 'modal') ;  return ;
%         end
%     end
%
%     % check category if correct
% %     a = fscanf(fid,'%s', 1) ;  % skip 4 chars just for the format in madea's area function file
% %     while ~isequal(a, 'Category_Selection:')
% %         a = fscanf(fid,'%s',1) ;
% %     end
%     a = fscanf(fid,'%f',1) ;
%     if ((Category-1) ~= a)
%         errordlg('Category Error', 'Error', 'modal') ;  return ;
%     end
%
%     % look for String, then read from there
%     a = fscanf(fid,'%s', 1) ;  % skip 4 chars just for the format in madea's area function file
%     while ~isequal(a, String)
%         a = fscanf(fid,'%s',1) ;
%         if(feof(fid))
%             errordlg('File format error', 'Error', 'modal') ;  return ;
%         end
%     end
%
%     % some function recall just need one output, I put it into tempLength
%     if (Datatype == 1)
%         SectionNum = fscanf(fid,'%f',1) ;
%         j = SectionNum ;
%         % disp(SectionNum)
%         SectionLength = fscanf(fid,'%f',1) ;
%         %disp(SectionLength)
%         tempLength = SectionLength*ones(1,SectionNum) ;
%         for i = 1:SectionNum
%             tempArea(i) = fscanf(fid,'%f', 1) ;
%         end
%     else
%         tempLength= fscanf(fid,'%f', 1) ;
%     end
%
%     fclose(fid) ;
%
% return ;




% new
% function [j, tempLength, tempArea] = get_data(Category, String, File, Datatype) ;  % get data from file
function [varargout] = get_data(Category, Location, File)  % get data from file

% the following statement is for the case of file reading error...
j = -1 ;
tempLength = 1 ;
tempArea   = 0 ;
if (nargout == 3)
    varargout{1} = j ;
    varargout{2} = tempLength ;
    varargout{3} = tempArea ;
else
    varargout{1} = tempLength ;
end


fid = fopen(File);
a = fscanf(fid,'%c', 1) ;  %
while a ~= ']'
    a = fscanf(fid,'%c',1) ;
    if(feof(fid))
        errordlg('File format error, no ] found', 'Error', 'modal') ;  return ;
    end
end

% check category if correct
%     a = fscanf(fid,'%s', 1) ;  % skip 4 chars just for the format in madea's area function file
%     while ~isequal(a, 'Category_Selection:')
%         a = fscanf(fid,'%s',1) ;
%     end

%     a = fscanf(fid,'%f',1) ;
%     if ((Category-1) ~= a)
%         errordlg('Category Error', 'Error', 'modal') ;  return ;
%     end

% read data starting from location such as '[2]'
% if (Category == 0), skip this, because that will be Category reading
% form file, do not need to read [num] in the file format
if (Category ~= 0)
    String = ['['  num2str(Category) ']'] ;
    % look for String, then read from there
    a = fscanf(fid,'%s', 1) ;  %
    while ~isequal(a, String)
        a = fscanf(fid,'%s',1) ;
        if(feof(fid))
            errordlg(['File format error :' String 'Not found'], 'Error', 'modal') ;  return ;
        end
    end
end

% look for String, then read from there, for sounds such as nasal,
% rhotic, lateral....
a = fscanf(fid,'%s', 1) ;  % skip 4 chars just for the format in madea's area function file
while ~isequal(a, Location)
    a = fscanf(fid,'%s',1) ;
    if(feof(fid))
        errordlg(['File format error: ' Location ' Not found '], 'Error', 'modal') ;  return ;
    end
end

% some function recall just need one output, I put it into tempLength
if (nargout == 3)
    SectionNum = fscanf(fid,'%f',1) ;
    if isempty(SectionNum)
        errordlg('File format error', 'Error', 'modal') ;  return ;
    end
    SectionNum = round (SectionNum );
    if(SectionNum <= 0)
        errordlg(['File format error: ' ' SectionNum <= 0 '], 'Error', 'modal') ;  return ;
    end

    % read all the data after Location
    jtemp = 1 ;
    tempArray = [] ;
    while 1
        temp = fscanf(fid,'%f',1) ;
        if(isempty(temp))
            break ;
        end
        tempArray(jtemp) = temp ;
        jtemp = jtemp + 1 ;
    end

    if (length(tempArray) == SectionNum + 1 )
        j = SectionNum ;
        SectionLength = tempArray(1) ;
        tempLength = SectionLength*ones(1,SectionNum) ;
        tempArea =  tempArray(2:end) ;
    elseif (length(tempArray) == 2*SectionNum)
        j = SectionNum ;
        tempLength = tempArray(1:SectionNum) ;
        tempArea   =  tempArray(SectionNum+1:end) ;
    else
        errordlg(['File format error: ' ' length of data is wrong '], 'Error', 'modal') ;  return ;
    end
else
    temp= fscanf(fid,'%f', 1) ;
    if(isempty(temp))
        errordlg(['File format error: ' Location ' ''s value Not found '], 'Error', 'modal') ;  return ;
    end
    tempLength = temp ;
end

if (nargout == 3)
    varargout{1} = j ;
    varargout{2} = tempLength ;
    varargout{3} = tempArea ;
else
    varargout{1} = tempLength ;
end


fclose(fid) ;

return ;

%     VT.Arbitrary.Geometry.Tube(i).IndexOfBranch = [ -1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).numOfSections = [ 0 ] ;
%     VT.Arbitrary.Geometry.Tube(i).secLen = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).secArea = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).numOfSections1 = [ 0 ] ;
%     VT.Arbitrary.Geometry.Tube(i).secLen1 = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).secArea1 = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranches = zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLoc =  zeros(1, 10) ;
%
%                     VT.handles_EditArea{Category, Type}.IndexOfBranch     = VT.handles_EditArea{Category, Type}.Popmenu(1) ;
%                 VT.handles_EditArea{Category, Type}.typeOfModule      = VT.handles_EditArea{Category, Type}.Popmenu(2) ;
%                 VT.handles_EditArea{Category, Type}.typeOfStartofTube = VT.handles_EditArea{Category, Type}.Popmenu(3) ;
%                 VT.handles_EditArea{Category, Type}.typeOfEndofTube   = VT.handles_EditArea{Category, Type}.Popmenu(4) ;
%
%
%                 VT.handles_EditArea{Category, Type}.channel = VT.handles_EditArea{Category, Type}.Popmenu(5); ;
%                     VT.handles_EditArea{Category, Type}.secLen(i) = VT.handles_EditArea{Category, Type}.Length(i);
%                     VT.handles_EditArea{Category, Type}.secArea(i) = VT.handles_EditArea{Category, Type}.Area(i);
%
%                     VT.handles_EditArea{Category, Type}.nextBranches(i) = VT.handles_EditArea{Category,Type}.Num_Connection(i) ;
%                     VT.handles_EditArea{Category, Type}.nextBranchesLocEnd(i) = VT.handles_EditArea{Category,Type}.LocationEnd(i) ;
%                     VT.handles_EditArea{Category, Type}.nextBranchesLoc(i) = VT.handles_EditArea{Category,Type}.Location(i) ;
%                     VT.handles_EditArea{Category, Type}.nextBranchesLocChannel(i) = VT.handles_EditArea{Category,Type}.Channels(i);
%




% load area function of tube in arbitrary type
%-----------------------------------------------
function loadTube(Category, Type,  varargin)
global VT ;

% tube no, module, start and end
i = VT.handles_EditArea{Category, Type}.Index ;
ind = i ;
set(VT.handles_EditArea{Category, Type}.typeOfModule, 'value', VT.Arbitrary.Geometry.Tube(i).typeOfModule) ;
set(VT.handles_EditArea{Category, Type}.typeOfStartofTube, 'value', VT.Arbitrary.Geometry.Tube(i).typeOfStartofTube)  ;
set(VT.handles_EditArea{Category, Type}.typeOfEndofTube, 'value' , VT.Arbitrary.Geometry.Tube(i).typeOfEndofTube)  ;

% channel information
set(VT.handles_EditArea{Category, Type}.channel, 'value', 1) ;
if(VT.Arbitrary.Geometry.Tube(i).typeOfModule == 2)
    set(VT.handles_EditArea{Category, Type}.twochannelsHandles(:), 'visible', 'on') ;
    % set(), % display popmenu
    % set value to 1 ;
else
    set(VT.handles_EditArea{Category, Type}.twochannelsHandles(:), 'visible', 'off') ;
end

% copy information to edit area
% reset these pointer value
VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;
VT.handles_EditArea{Category,Type}.Pointer = 0 ;  % from 0 - (200-numBlock)
Temp = get(VT.handles_EditArea{Category,Type}.Slider, 'Max') ;
set(VT.handles_EditArea{Category,Type}.Slider, 'Value', Temp) ;


% copy data to array
%
array_and_arbitraryGeometry(Category, Type, ind, 2) ; % copy data in 2 channels into array, 1 means array to ...geometry
array_to_editarea(Category, Type) ;

% connection informaiton
% copy connection information directly to edit area
VT.handles_EditArea{Category,Type}.PointerConnection = 0 ;  % from 0 - (200-numBlock)
Temp = get(VT.handles_EditArea{Category,Type}.SliderConnection, 'Max') ;
set(VT.handles_EditArea{Category,Type}.SliderConnection, 'Value', Temp) ;

for i = 1: VT.handles_EditArea{Category,Type}.numBlockConnection
    set(VT.handles_EditArea{Category, Type}.nextBranches(i), 'value', VT.Arbitrary.Geometry.Tube(ind).nextBranches(i)+1)  ;
    set(VT.handles_EditArea{Category, Type}.nextBranchesLocEnd(i), 'value', VT.Arbitrary.Geometry.Tube(ind).nextBranchesLocEnd(i) )  ;
    set(VT.handles_EditArea{Category, Type}.nextBranchesLoc(i), 'string', VT.Arbitrary.Geometry.Tube(ind).nextBranchesLoc(i)) ;
    set(VT.handles_EditArea{Category, Type}.nextBranchesLocChannel(i), 'value', VT.Arbitrary.Geometry.Tube(ind).nextBranchesLocChannel(i)) ;
end

return ;


% save tube information from interface
function saveTube(Category, Type,  varargin)
global VT ;
% display('2') ; toc

h = varargin{2} ;
% tube no, module, start and end
i = VT.handles_EditArea{Category, Type}.Index ;
ind = i ;
VT.Arbitrary.Geometry.Tube(i).typeOfModule      = get(VT.handles_EditArea{Category, Type}.typeOfModule, 'value') ;
VT.Arbitrary.Geometry.Tube(i).typeOfStartofTube = get(VT.handles_EditArea{Category, Type}.typeOfStartofTube, 'value') ;
VT.Arbitrary.Geometry.Tube(i).typeOfEndofTube   = get(VT.handles_EditArea{Category, Type}.typeOfEndofTube, 'value') ;





% slider
nMax = get( VT.handles_EditArea{Category,Type}.Slider, 'Max') ;
nValue = get( VT.handles_EditArea{Category,Type}.Slider, 'Value') ;
VT.handles_EditArea{Category,Type}.Pointer = nMax - round(nValue) ; % from 0 - (200-numBlock)

% save data and then load it , so it considers two case: 1- slider move 2-
% data changes
if(h ~= VT.handles_EditArea{Category,Type}.Slider)
    editarea_to_array(Category, Type) ;
end
array_and_arbitraryGeometry(Category, Type, ind, 1) ; % copy data in 2 channels into array, 1 means array to ...geometry

array_to_editarea(Category, Type) ;  % just in case slider moves

% channel information
channelNum = get(VT.handles_EditArea{Category, Type}.typeOfModule, 'value') ;
if(channelNum == 2)
    set(VT.handles_EditArea{Category, Type}.twochannelsHandles(:), 'visible', 'on') ;
else
    set(VT.handles_EditArea{Category, Type}.twochannelsHandles(:), 'visible', 'off') ;
end

channelNo = get(VT.handles_EditArea{Category, Type}.channel, 'value') ;
VT.handles_EditArea{Category,Type}.CurrentSection = channelNo ;
if(channelNum == 1 & channelNo==2)  % need to display information on channel 1
    VT.handles_EditArea{Category,Type}.CurrentSection = 1 ;
end
array_to_editarea(Category, Type) ;  % in case CurrentSection is changed


% connection informaiton
% copy connection information directly to edit area
nMax = get( VT.handles_EditArea{Category,Type}.SliderConnection, 'Max') ;
nValue = get( VT.handles_EditArea{Category,Type}.SliderConnection, 'Value') ;
VT.handles_EditArea{Category,Type}.PointerConnection = nMax - round(nValue) ; % from 0 - (200-numBlock)
startPos =  VT.handles_EditArea{Category,Type}.PointerConnection ;
% save informaiton
if(h ~= VT.handles_EditArea{Category,Type}.SliderConnection)
    for i = 1: VT.handles_EditArea{Category,Type}.numBlockConnection
        VT.Arbitrary.Geometry.Tube(ind).nextBranches(i+startPos)  = -1 + get(VT.handles_EditArea{Category, Type}.nextBranches(i), 'value') ;
        VT.Arbitrary.Geometry.Tube(ind).nextBranchesLocEnd(i+startPos)  = get(VT.handles_EditArea{Category, Type}.nextBranchesLocEnd(i), 'value') ;
        temp =  str2num(get(VT.handles_EditArea{Category, Type}.nextBranchesLoc(i), 'string')) ;
        if(isempty(temp))
            VT.Arbitrary.Geometry.Tube(ind).nextBranchesLoc(i+startPos)  = 0.01 ;
        else
            VT.Arbitrary.Geometry.Tube(ind).nextBranchesLoc(i+startPos)  = temp ;
        end
        VT.Arbitrary.Geometry.Tube(ind).nextBranchesLocChannel(i+startPos)  = get(VT.handles_EditArea{Category, Type}.nextBranchesLocChannel(i), 'value') ;
    end
end

% load info. in case slider moves
for i = 1: VT.handles_EditArea{Category,Type}.numBlockConnection
    set(VT.handles_EditArea{Category, Type}.nextBranches(i), 'value', VT.Arbitrary.Geometry.Tube(ind).nextBranches(i+startPos)+1)  ;
    set(VT.handles_EditArea{Category, Type}.nextBranchesLocEnd(i), 'value', VT.Arbitrary.Geometry.Tube(ind).nextBranchesLocEnd(i+startPos) ) ;
    set(VT.handles_EditArea{Category, Type}.nextBranchesLoc(i), 'string', VT.Arbitrary.Geometry.Tube(ind).nextBranchesLoc(i+startPos) ) ;
    set(VT.handles_EditArea{Category, Type}.nextBranchesLocChannel(i), 'value', VT.Arbitrary.Geometry.Tube(ind).nextBranchesLocChannel(i+startPos) ) ;
end

% display('2') ; toc
% VT.Arbitrary.Geometry.Tube(ind)
% VT.Arbitrary.Geometry.Tube(ind).secLen(1)
return ;



function array_and_arbitraryGeometry(Category, Type, ind, direction)  % copy data in 2 channels into array, 1 means array to ...geometry
global VT ;

if (direction == 1) % copy data from array to geometry
    [j, tempLength, tempArea] = get_areafunction1(Category, Type, 1) ;
    VT.Arbitrary.Geometry.Tube(ind).numOfSections = j ;
    VT.Arbitrary.Geometry.Tube(ind).secLen(1:length(tempLength))  = tempLength ;
    VT.Arbitrary.Geometry.Tube(ind).secArea(1:length(tempLength)) = tempArea ;

    [j, tempLength, tempArea] = get_areafunction1(Category, Type, 2) ;
    VT.Arbitrary.Geometry.Tube(ind).numOfSections1 = j ;
    VT.Arbitrary.Geometry.Tube(ind).secLen1(1:length(tempLength))  = tempLength ;
    VT.Arbitrary.Geometry.Tube(ind).secArea1(1:length(tempLength)) = tempArea ;

else % copy data from geometry to array

    for i = 1: 2
        VT.handles_EditArea{Category,Type}.Length_data{i} = cell(1, 200) ;
        VT.handles_EditArea{Category,Type}.Area_data{i}   = cell(1, 200) ;
    end

    nLength =  VT.Arbitrary.Geometry.Tube(ind).numOfSections ; %
    for i = 1: nLength % channel 1
        VT.handles_EditArea{Category,Type}.Length_data{1}{i} = num2str(VT.Arbitrary.Geometry.Tube(ind).secLen(i))  ;
        VT.handles_EditArea{Category,Type}.Area_data{1}{i}   = num2str(VT.Arbitrary.Geometry.Tube(ind).secArea(i)) ;
    end

    nLength =  VT.Arbitrary.Geometry.Tube(ind).numOfSections1 ; %
    for i = 1: nLength % channel 1
        VT.handles_EditArea{Category,Type}.Length_data{2}{i} = num2str(VT.Arbitrary.Geometry.Tube(ind).secLen1(i)) ;
        VT.handles_EditArea{Category,Type}.Area_data{2}{i}   = num2str(VT.Arbitrary.Geometry.Tube(ind).secArea1(i)) ;
    end
end

return ;