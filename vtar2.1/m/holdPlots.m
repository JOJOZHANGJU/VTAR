% function holdPlots(status)
%
% hold plots which is used to compare the freq. response at different
% settings of area function
%

function holdPlots(status)
global VT ;
% VT.numplots = 32 ;
if strcmp(status,'holdOn') == 1
    ud = get(VT.handles.vtar,'userdata');
    
    if isempty(VT.handleHoldPlots)
        num = 1 ;
    else
        temp = size(VT.handleHoldPlots) ;
        num = temp(1)+1 ;
    end
    
    MAP = hsv ; % colormap('default') ; % change color of the plots which have been held on
    
    % find all lines in each axis
    for i = 1: length(ud.ht.a)-1  % for each axis, except the last one of schematic of sound category
        h = findobj(ud.ht.a(i),'Type','line') ;
        k = 1 ;   % numerate how many lines need to be held
        tempHandle = [] ;
        for j = 1:length(h)
            temp = get(h(j), 'tag') ;
            if strcmp(temp,'hold')~=1  % get rid of line which is already at hold status
                tempHandle(k) = copyobj(h(j), ud.ht.a(i)) ;
                % MAP(num, :)
                % set(tempHandle(k),  'tag', 'hold', 'color', [MAP(num*3, :)]) ;
                set(tempHandle(k),  'tag', 'hold', 'color', ud.colororder{mod(num, 7)+1}) ;
                k = k+1 ;
            end
        end
        VT.handleHoldPlots{num, i} = tempHandle(:);
        % need to change its color
        
    end

elseif strcmp(status,'holdOff') == 1
        % get rid of the object in hold status
    if ~isempty(VT.handleHoldPlots)        
        temp = size(VT.handleHoldPlots) ;
        for i = 1: temp(1)
            for j = 1: temp(2)
                delete(VT.handleHoldPlots{i,j})
            end
        end
    end
        
    VT.handleHoldPlots = [] ;
    
end