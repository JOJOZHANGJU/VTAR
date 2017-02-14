%    recalled by category callback.......
%
%
%   s - 'category'   , for new category chosen, all the plots need to be
%                       rearranged
%

function updateplots(handles, s, varargin) ;
global VT ;
% display('category-------------') ;
% VT.CurrentCategory

if(nargin == 3)
    Type = varargin{1};
else
    Type = 1 ;
end

switch s
    %---------------------------------------------------    
    case 'category'   
        % 'Vowel'
        % update titles, lables for all the plot in this category
        get_titles(VT.CurrentCategory, Type) ;  
        
        % update the contextmenu for the new category
        plotcontextmenu(gcbo, 2) 
        return ;
        
        % update plots on screen
        
    %---------------------------------------------------    
    case 'asdafcategory'   
    
    otherwise
      disp('Unknown method. happened in updateplots')
end

return ;




%  update titles of plots for each category
function get_titles(Category, varargin)
global VT ;

if(nargin == 2)
    Type = varargin{1};
else
    Type = 1 ;
end
    fig = VT.handles.vtar;
    ud = get(fig,'userdata');

    ud.tags =    { 'magaxes'
                   'area_1'
                   'area_2'
                   'area_3'
                   'area_4'
                   'area_5'
                   'area_6'
                   'area_7' 
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   
               };

    ud.xlabels = {  'Frequency (Hz)'
                    'Distance (cm)'
                    'Distance (cm) '
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    ' ' };
  
    ud.ylabels = {  'Amplitude (dB)'
                    'Area (cm^2)'
                    'Area (cm^2)'
                    'Area (cm^2)'
                    'Area (cm^2)'
                    'Area (cm^2)'
                    'Area (cm^2)'
                    'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' 
                    'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' 
                    'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' ;'Area (cm^2)' 
                    ' '};

switch Category

   case 1  % 'Vowel'
               ud.titles = {   'Acoustic Response' 
                   'Vocal Tract'  
                   '' 
                   '' 
                   '' 
                   ''
                   ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   ''};
                   ud.xlabels = {  'Frequency (Hz)'
                    'Distance From Glottis (cm)'
                    'Distance (cm) '
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    ' ' };

       switch(Type)
           case 1
           case 2
           otherwise
               % errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
       end
   case 2  % 'Vowel'
               ud.titles = {   'Acoustic Response' 
                   'Vocal Tract'  
                   '' 
                   '' 
                   '' 
                   ''
                   ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   ''};
       switch(Type)
           case 1
           case 2
           otherwise
               % errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
       end
                   ud.xlabels = {  'Frequency (Hz)'
                    'Distance From Glottis (cm)'
                    'Distance (cm) '
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    ' ' };
   case 3  % 'Consonant'
               ud.titles = {   'Acoustic Response' 
                   'Vocal Tract'  
                   '' 
                   '' 
                   '' 
                   ''
                   ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   ''};
       switch(Type)
           case 1
           case 2
           otherwise
               % errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
       end
       
                   ud.xlabels = {  'Frequency (Hz)'
                    'Distance From Glottis (cm)'
                    'Distance (cm) '
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)';'Distance (cm)'; 'Distance (cm)'; 'Distance (cm)'
                    ' ' };
   case 4  % 'Nasal'
%                ud.titles = {   'Acoustic Response' 
%                    'Pharynx' 
%                    'Oral' 
%                    'Back'
%                    'Nostril_1'
%                    'Nostril_2'
%                    ''
%                    'Schematic'};
               ud.titles = {   'Acoustic Response' 
                   'Back' 
                   'Oral' 
                   'Velar tube'
                   'Nostril_1'
                   'Nostril_2'
                   ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   'Schematic'};
       switch(Type)
           case 1
           case 2
           otherwise
               % errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
       end
   case 5  % '/r/'
               ud.titles = {   'Acoustic Response' 
                        'Back'
                        'Front'
                        'Sublingual'
                        ''
                        ''
                        ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                        'Schematic'
                        };
       switch(Type)

           case 1  % default value
           case 2
                   ud.titles = {   'Acoustic Response' 
                        'Main'
                        'Sublingual'
                        ''
                        ''
                        ''
                        ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                        'Schematic'
                        };
           otherwise
               % errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
       end
               
   case 6  % '/l/'
               ud.titles = {   'Acoustic Response' 
                   'Back' 
                   'Front' 
                   'Supralingual'
                   'Channel_1'
                   'Channel_2'
                   ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   'Schematic' };
       switch(Type)
           case 1
           case 2
           otherwise
               % errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
       end
   case 7  % 'Nasalized vowel'
%                ud.titles = {   'Acoustic Response' 
%                    'Pharynx' 
%                    'Oral' 
%                    'Back'
%                    'Nostril_1'
%                    'Nostril_2'
%                    ''
%                    'Schematic' };
               ud.titles = {   'Acoustic Response' 
                   'Back' 
                   'Oral' 
                   'Velar tube'
                   'Nostril_1'
                   'Nostril_2'
                   ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   'Schematic'};
               
       switch(Type)
           case 1
           case 2
           otherwise
               % errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
       end

   case 8  % 'arbitrary'
               ud.titles = {   'Acoustic Response' 
                   'Tube  1- 6' 
                   'Tube  7-12' 
                   'Tube 13-18'
                   'Tube 19-24'
                   'Tube 25-30'
                   ''
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   '';'';'';'';'';'';'';'';
                   'Schematic' };
       switch(Type)
           case 1
           case 2
           otherwise
               % errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
       end
%        ud.titles = {   'Acoustic Response' 
%                     'Pharynx' 
%                     'Oral' 
%                     'Back'
%                     'Nostril_1'
%                     'Nostril_2'
%                     ''
%                     'Schematic' };
  otherwise
      disp('Unknown method. happened in get_plotdata')
end

 
%   set the title and label for 6 plots
%     fig = VT.handles.vtar;
%     ud = get(fig,'userdata');
    
    th = get(ud.ht.a,'title');
     set([th{[1:VT.numplots]}],{'string'},ud.titles([1:VT.numplots]), 'color', 'red')
    % set([th{[1:VT.numplots]}],{'string'},ud.titles([1:VT.numplots]), 'color', 'k', 'FontWeight', 'bold' )

    set([th{:}],{'tag'},ud.tags)
    set(ud.ht.a,{'tag'},ud.tags)
    
    xh = get(ud.ht.a,'xlabel');
    set([xh{:}],{'string'},ud.xlabels,{'tag'},ud.tags)
    yh = get(ud.ht.a,'ylabel');
    set([yh{:}],{'string'},ud.ylabels,{'tag'},ud.tags)

    % just for titles....
    set(fig,'userdata', ud);
return ;


