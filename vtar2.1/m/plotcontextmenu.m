% 1. modify contextmenu  when category is changed
% 2. on or off the plots
% option 1 - plot
%        2 - init
% Pos    -   index of plots
function plotcontextmenu(h, option, varargin )
global VT ;
% read the position of item in menu
% check if off or on
% update the plots display

% disp(get(h, 'position')) ;
% get(h) ;

if (nargin == 3) 
    Pos = varargin{1} ; % which plot  ;
end


switch option 
    %-----------------------------------------------------
    %  case 1 for plot when you choose one item from popupmenu
    %------------------------------------------------------
    case 1   % 'plot'
        if (VT.CurrentCategory ~= 8)
            % get plots info.         
            ud = get(VT.handles.vtar,'userdata');
            Numplots = length(find(ud.prefs.plots)) ;
            % at least 2 plots on screen
            
            % ud.prefs.plots(Pos)==1 means this plot will be removed from
            % screen
            if((Numplots <=1 & ud.prefs.plots(Pos)==1) | (Numplots >= 8 & ud.prefs.plots(Pos)==0))
                errordlg('At least 1 plot on display','Error', 'modal');
                return ;
            end
            
            % set is to make mainaxis and ruler plot consistent ....
            % context menu is right click and will not processed 
            % in filtview('mainaxes_down')
            set(VT.handles.vtar,'selectiontype','normal') ;
            
            filtview('cb', Pos) ;
            
            % these statements is just for correction of font size in schematic
            % diagram in plot, 05/24/2004 xinhui
            fig = VT.handles.vtar;
            ud = get(fig,'userdata'); % get titles
            filtview('plots', ud.prefs.plots) ; % to get line data in new plot
            
            
            ud = get(VT.handles.vtar,'userdata');
            hTemp = get(VT.handles.vtar,'uicontextmenu') ;
            hChild1 = get(hTemp, 'Children') ;
            hChild2 = get(VT.handles.Plot, 'Children') ;
            
            %switch get(h, 'Checked')
            h = length(hChild1)+ 1 - h  ;   % the order in submenu is reversed to the order of creation
            switch ud.prefs.plots(Pos)
                case 0
                    set(hChild1(h), 'Checked', 'off') ;
                    set(hChild2(h), 'Checked', 'off') ;
                case 1
                    set(hChild1(h), 'Checked', 'on') ;
                    set(hChild2(h), 'Checked', 'on') ;
                    
                    %             case 0
                    %                 set(h, 'Checked', 'off') ;
                    %             case 1
                    %                 set(h, 'Checked', 'on') ;
            end
        else % arbitrary
            
            % get plots info.         
            ud = get(VT.handles.vtar,'userdata');
            Numplots = length(find(ud.prefs.plots)) ;
            % at least 2 plots on screen
            
            % ud.prefs.plots(Pos)==1 means this plot will be removed from
            % screen
%            if(Numplots <=1 & ( (ud.prefs.plots(Pos)==1) |(ud.prefs.plots(Pos)==8) ))
            if(Numplots <=1 & ( (ud.prefs.plots(Pos)==1) ))
                errordlg('At least 1 plot on display','Error', 'modal');
                return ;
            end
            
            % set is to make mainaxis and ruler plot consistent ....
            % context menu is right click and will not processed 
            % in filtview('mainaxes_down')
            set(VT.handles.vtar,'selectiontype','normal') ;
            
            if (Pos == 1 | Pos ==VT.numplots)
                ud.prefs.plots(Pos) = 1- ud.prefs.plots(Pos) ;  % flip up
            else
                Pos1 = ((Pos-1)-1)*6 + 1 ; % first tube in this selection
                if( ud.prefs.plots(Pos1+1) == 1) % same group
                    ud.prefs.plots(Pos1+1:Pos1+6) = 0 ; % flip                        
                else
                    ud.prefs.plots(Pos1+1:Pos1+6) = 1 ; % display new group of tubes infor.
                    ud.prefs.plots(2:Pos1) = 0 ;  % the rest of tubes number should be invisible
                    ud.prefs.plots(Pos1+7:VT.numplots-1) = 0 ;
                    %                 if(Pos1 == str2num(ud.titles{2}(5:end))) % same group
                    %                     ud.prefs.plots(2:VT.numplots-1) = 1- ud.prefs.plots(2:VT.numplots-1) ; % flip                        
                    %                 else
                    %                     ud.prefs.plots(2:VT.numplots-1) = 1 ; % display new group of tubes infor.
                    %                     for j = 2: VT.numplots-1
                    %                         ud.titles{j} = ['Tube ', num2str(Pos1-1 + j-1)]  ;
                    %                     end
                    %                     th = get(ud.ht.a,'title');
                    %                     set([th{[1:VT.numplots]}],{'string'},ud.titles([1:VT.numplots]), 'color', 'red')
                    
                end
            end
            
            set(VT.handles.vtar,'userdata',ud);
            
            % these statements is just for correction of font size in schematic
            % diagram in plot, 05/24/2004 xinhui
            fig = VT.handles.vtar;
            ud = get(fig,'userdata'); % get titles
            filtview('plots', ud.prefs.plots) ; % to get line data in new plot
            
            
        % change order in order to corrent the font size in schematic,
        % since font size depends on the size of axes
        fvresize(1, VT.handles.vtar) ;  % readjust the position of plots
        filtview('plots', ud.prefs.plots) ; % to get line data in new plot

            
            
            ud = get(VT.handles.vtar,'userdata');
            hTemp = get(VT.handles.vtar,'uicontextmenu') ;
            hChild1 = get(hTemp, 'Children') ;
            hChild2 = get(VT.handles.Plot, 'Children') ;
            
            %switch get(h, 'Checked')
            h = length(hChild1)+ 1 - h  ;   % the order in submenu is reversed to the order of creation
            if(Pos==1 | Pos==VT.numplots)
                switch ud.prefs.plots(Pos)
                    case 0
                        set(hChild1(h), 'Checked', 'off') ;
                        set(hChild2(h), 'Checked', 'off') ;
                    case 1
                        set(hChild1(h), 'Checked', 'on') ;
                        set(hChild2(h), 'Checked', 'on') ;
                end
            else
                switch ud.prefs.plots(Pos1+1) % ud.prefs.plots(2)
                    case 0
                        set(hChild1(h), 'Checked', 'off') ;
                        set(hChild2(h), 'Checked', 'off') ;
                    case 1
                        set(hChild1(h), 'Checked', 'on') ;
                        set(hChild2(h), 'Checked', 'on') ;
                end
                % temp = [2:length(hChild1)-1] ;  % 
                temp = [3:length(hChild1)-1] ;  % one more item added into menu to save plots in main axis , or display all  , starting from bottom of menu

                ind = find( temp~= h) ;
                set(hChild1(temp(ind(:))), 'Checked', 'off') ;
                set(hChild2(temp(ind(:))), 'Checked', 'off') ;
                
            end
        end
        %         
        %         set(VT.handles.vtar,'userdata',ud) ;
        % %        filtview('plots', ud.prefs.plots) ;
        %         filtview('plots', [1 1 1 1 1 1 1 1]) ;
        %         if(ud.prefs.tool.ruler)
        %            filtview('mainaxes_down',find(ud.mainaxes==ud.ruler.allAxesList)) ;       
        %         end
        % 
        
        %-----------------------------------------------------
        %  case 2 for plot when you choose one item from category
        %------------------------------------------------------
    case 2   % 'init'
        
        % if no category chosen, no further steps should be taken...
%         if (VT.CurrentCategory == 1)
%             return ;
%         end
        
        hTemp = get(VT.handles.vtar,'uicontextmenu') ;
        delete(get(hTemp, 'Children')) ;
        % add submenu to menu bar instead of only contextMenu
        delete(get(VT.handles.Plot, 'Children')) ;
        
        
        fig = VT.handles.vtar;
        ud = get(fig,'userdata'); % get titles
        
        % decide which plot should be visible and also update the menu item
        ud.prefs.plots = [zeros(1, VT.numplots)]'  ;
        for iTemp = 1: length(ud.titles)
            if ~isempty(ud.titles{iTemp})
                if(VT.CurrentCategory ~= 8)
                    ud.prefs.plots(iTemp) = 1 ; 
                    uimenu(hTemp, 'label',ud.titles{iTemp},'checked', 'on', 'Callback', ...
                        ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(iTemp), ')']) ;
                    %                    ['plotcontextmenu(gcbo, 1, ' num2str(iTemp), ')']) ;
                    % add submenu to menu bar instead of only contextMenu                
                    uimenu(VT.handles.Plot, 'label',ud.titles{iTemp},'checked', 'on', 'Callback', ...
                        ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(iTemp), ')']) ;
                    %                    ['plotcontextmenu(gcbo, 1, ' num2str(iTemp), ')']) ;
                else %arbitrary
                    if(iTemp<=2 | iTemp==VT.numplots) % the first 2 and last one on schematic
                        ud.prefs.plots(iTemp) = 1 ; 
                        uimenu(hTemp, 'label',ud.titles{iTemp},'checked', 'on', 'Callback', ...
                            ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(iTemp), ')']) ;
                        %                    ['plotcontextmenu(gcbo, 1, ' num2str(iTemp), ')']) ;
                        % add submenu to menu bar instead of only contextMenu                
                        uimenu(VT.handles.Plot, 'label',ud.titles{iTemp},'checked', 'on', 'Callback', ...
                            ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(iTemp), ')']) ;
                        %                    ['plotcontextmenu(gcbo, 1, ' num2str(iTemp), ')']) ;
                    else
                        ud.prefs.plots(iTemp) = 0 ; 
                        uimenu(hTemp, 'label',ud.titles{iTemp},'checked', 'off', 'Callback', ...
                            ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(iTemp), ')']) ;
                        %                    ['plotcontextmenu(gcbo, 1, ' num2str(iTemp), ')']) ;
                        % add submenu to menu bar instead of only contextMenu                
                        uimenu(VT.handles.Plot, 'label',ud.titles{iTemp},'checked', 'off', 'Callback', ...
                            ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(iTemp), ')']) ;
                        %                    ['plotcontextmenu(gcbo, 1, ' num2str(iTemp), ')']) ;
                    end
                    
                end
            else
                break ;
            end
        end
        
        switch VT.CurrentCategory
            
            case 2  % 'Vowel'
                %                 uimenu(hTemp, 'label','Acoustic Response','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 1)') ;
                %                 uimenu(hTemp, 'label','Vocal Tract','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 2)') ;
                
            case 3  % 'Consonant'
                %                 uimenu(hTemp, 'label','Acoustic Response','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 1)') ;
                %                 uimenu(hTemp, 'label','Vocal Tract','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 2)') ;
                
            case 4  % 'Nasal'
                %                 uimenu(hTemp, 'label','Acoustic Response','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 1)') ;
                %                 uimenu(hTemp, 'label','Pharynx','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 2)') ;
                %                 uimenu(hTemp, 'label','Oral','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 3)') ;
                %                 uimenu(hTemp, 'label','Back','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 4)') ;
                %                 uimenu(hTemp, 'label','Nostril_1','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 5)') ;
                %                 uimenu(hTemp, 'label','Nostril_2','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 6)') ;
                if (iTemp ~= length(ud.titles))
                    uimenu(hTemp, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                    ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    uimenu(VT.handles.Plot, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                    ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    ud.prefs.plots(VT.numplots) = 1 ;
                end
            case 5  % '/r/'
                %                 uimenu(hTemp, 'label','Acoustic Response','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 1)') ;
                %                 uimenu(hTemp, 'label','Back','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 2)') ;
                %                 uimenu(hTemp, 'label','Front','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 3)') ;
                %                 uimenu(hTemp, 'label','Sublingual','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 4)') ;
                %                 uimenu(hTemp, 'label','Schematic','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 8)') ;
                if (iTemp ~= length(ud.titles))
                    uimenu(hTemp, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                    ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    uimenu(VT.handles.Plot, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                    ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    ud.prefs.plots(VT.numplots) = 1 ;
                end
                
            case 6  % '/l/'
                %                 uimenu(hTemp, 'label','Acoustic Response','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 1)') ;
                %                 uimenu(hTemp, 'label','Back','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 2)') ;
                %                 uimenu(hTemp, 'label','Front','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 3)') ;
                %                 uimenu(hTemp, 'label','Channel1','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 4)') ;
                %                 uimenu(hTemp, 'label','Channel2','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 5)') ;
                %                 uimenu(hTemp, 'label','Superlingual','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 6)') ;
                %                 uimenu(hTemp, 'label','Schematic','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 8)') ;
                if (iTemp ~= length(ud.titles))
                    uimenu(hTemp, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                    ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    

                    %                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    uimenu(VT.handles.Plot, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                    ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    ud.prefs.plots(VT.numplots) = 1 ;
                end
                
            case 7  % 'Nasalized vowel'
                %                 uimenu(hTemp, 'label','Acoustic Response','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 1)') ;
                %                 uimenu(hTemp, 'label','Pharynx','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 2)') ;
                %                 uimenu(hTemp, 'label','Oral','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 3)') ;
                %                 uimenu(hTemp, 'label','Back','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 4)') ;
                %                 uimenu(hTemp, 'label','Nostril_1','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 5)') ;
                %                 uimenu(hTemp, 'label','Nostril_2','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 6)') ;
                if (iTemp ~= length(ud.titles))
                    uimenu(hTemp, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                    ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    uimenu(VT.handles.Plot, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                     ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                       ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    ud.prefs.plots(VT.numplots) = 1 ;
                end
                
            case 8  % 'Arbitrary'
                
                if (iTemp ~= length(ud.titles))
                    uimenu(hTemp, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                     ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                       ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                   uimenu(VT.handles.Plot, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
                     ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
%                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
                    ud.prefs.plots(VT.numplots) = 1 ;
                end
                
                % reset the titles for plot 2-7
                    % ud.prefs.plots(2:VT.numplots ) = 1 ;
                    ud.prefs.plots(2:7) = 1 ;
                    
%                     fig = VT.handles.vtar;
%                     ud = get(fig,'userdata');
                    for j = 2: VT.numplots-1
                        ud.titles{j} = ['Tube ', num2str(j-1)]  ;
                    end
                        th = get(ud.ht.a,'title');
                    set([th{[1:VT.numplots]}],{'string'},ud.titles([1:VT.numplots]), 'color', 'red')



                %                 uimenu(hTemp, 'label','Acoustic Response','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 1)') ;
                %                 uimenu(hTemp, 'label','Pharynx','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 2)') ;
                %                 uimenu(hTemp, 'label','Oral','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 3)') ;
                %                 uimenu(hTemp, 'label','Back','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 4)') ;
                %                 uimenu(hTemp, 'label','Nostril_1','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 5)') ;
                %                 uimenu(hTemp, 'label','Nostril_2','checked', 'on', 'Callback', 'plotcontextmenu(gcbo, 1, 6)') ;
%                 if (iTemp ~= length(ud.titles))
%                     uimenu(hTemp, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
%                     ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
% %                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
%                     uimenu(VT.handles.Plot, 'label','Schematic','separator', 'on','checked', 'on', 'Callback',...
%                     ['plotcontextmenu(', num2str(iTemp), ', 1,' , num2str(VT.numplots), ')']) ;
% %                        ['plotcontextmenu(gcbo, 1, ' num2str(VT.numplots), ')']) ;    
%                     ud.prefs.plots(VT.numplots) = 1 ;
%                 end
                
                
            otherwise
                % disp('Unknown method. happened in g VT.CurrentCategory, plotcontextmenu ')
        end
        
        uimenu(hTemp, 'label','Save plot(s) in main axis (RED COLOR) as *.fig','separator', 'on', 'Callback',...
                    ['savefile(gcbo)']) ;
        uimenu(VT.handles.Plot, 'label','Display all','separator', 'on', 'Callback',...
                     ['plotcontextmenu(gcbo, 2)']) ;

                
                
        set(VT.handles.vtar,'userdata',ud)
%         filtview('plots', ud.prefs.plots) ; % to get line data in new plot
%         fvresize(1, VT.handles.vtar) ;  % readjust the position of plots
        

        % change order in order to corrent the font size in schematic,
        % since font size depends on the size of axes
        fvresize(1, VT.handles.vtar) ;  % readjust the position of plots
        filtview('plots', ud.prefs.plots) ; % to get line data in new plot
        
        
        % add here to clear the formant and bandwidth...
        Calculate_formant(VT.handles) ;
        RePlot(VT.handles) ;  % just for formant display


        %-----------------------------------------------------------------------------------------------        
    otherwise
        disp('Unknown method. happened in plotcontextmenu')
end




return ;



function RePlot(handles)
global VT 

Display_formant(handles.F1, VT.Formant(1) );
Display_formant(handles.F2, VT.Formant(2) );
Display_formant(handles.F3, VT.Formant(3) );
Display_formant(handles.F4, VT.Formant(4) );
Display_formant(handles.F5, VT.Formant(5) );

Display_formant(handles.F1_amp, VT.Formant_amp(1), '%10.2f' );
Display_formant(handles.F2_amp, VT.Formant_amp(2), '%10.2f'  );
Display_formant(handles.F3_amp, VT.Formant_amp(3), '%10.2f'  );
Display_formant(handles.F4_amp, VT.Formant_amp(4), '%10.2f'  );
Display_formant(handles.F5_amp, VT.Formant_amp(5), '%10.2f'  );

Display_formant(handles.F1_bw, VT.Formant_bw(1) );
Display_formant(handles.F2_bw, VT.Formant_bw(2) );
Display_formant(handles.F3_bw, VT.Formant_bw(3) );
Display_formant(handles.F4_bw, VT.Formant_bw(4) );
Display_formant(handles.F5_bw, VT.Formant_bw(5) );

return ;

%-----------------------------------------------------------------------
%  display information of formant
%
function Display_formant(h, data, varargin)

if( ~isnumeric(data))
    errordlg('Error for formant information','Error', 'modal'); return ;
end
if data == 0
    set(h, 'String',  ' ');
elseif (isnan(data))
    set(h, 'String',  ' *** ');
else
    %set(h, 'String', data );
    if nargin == 3
        set(h, 'String', num2str(data, varargin{1}) );
    else
        set(h, 'String', num2str(data) );
    end
end
return ;
