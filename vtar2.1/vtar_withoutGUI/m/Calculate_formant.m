% calculate formants and their bandwidths based on acoustic response
%
function VT = Calculate_formant(VT)

%global VT ;

for i = 1: 5
    VT.Formant(i)     = 0 ; 
    VT.Formant_amp(i) = 0 ; 
    VT.Formant_bw(i)  = 0 ; 
end

% get peaks
[ind,peaks] = findpeaks(VT.AR) ;

% get rid of peaks below 100Hz, also get rid of the point at 
% f = max(vt.f), the last point in the response...
% index = find(VT.f(ind)>100) ;
index = find(VT.f(ind)>100 & (VT.f(ind)<max(VT.f)) ) ;
ind = ind(index) ;

% get formant and also its amplitude
% also get bandwidth for each formant
for i = 1: 5
    if i<= length(ind)
        VT.Formant(i)     = VT.f(ind(i)) ; 
        VT.Formant_amp(i) = VT.AR(ind(i)) ; 
        VT.Formant_bw(i)  = bandwidth(ind(i), VT.f, VT.AR) ; 
    end
end

return ;

% question: how to define bandwidth ????
% temporarily, -3db is used
% ----------------------------------------
function bw = bandwidth(ind, f, AR) 
% on right side
indRight = find(AR(ind:end)<=AR(ind)-3) ;
% no one on right side beblow -3db
if (isempty(indRight))
    bw = NaN ; return ;
end
dfRight = diff( AR( ind:(ind+indRight(1)-1) ) ) ;
% there is another peak before first one on right side beblow -3db
if any(dfRight > 0)
    bw = NaN ; return ;
end

% on left side
indLeft = find(AR(ind:-1:1)<=AR(ind)-3) ;
% no one on left side beblow -3db
if (isempty(indLeft))
    bw = NaN ; return ;
end
dfLeft = diff( AR( (ind-indLeft(1)+1):ind ) ) ;
% there is another peak after last one on left side beblow -3db
if any(dfLeft < 0)
    bw = NaN ; return ;
end

bw = f(ind+indRight(1)-1) - f(ind-indLeft(1)+1) ;
return ;


%------------------------------------------------------------------
%
% I just copy this from ruler.m in digital signal toolbox in matlab
%------------------------------------------------------------------
function [ind,peaks] = findpeaks(y)
% FINDPEAKS  Find peaks in real vector.
%  ind = findpeaks(y) finds the indices (ind) which are
%  local maxima in the sequence y.  
%
%  [ind,peaks] = findpeaks(y) returns the value of the peaks at 
%  these locations, i.e. peaks=y(ind);

y = y(:)';

switch length(y)
case 0
    ind = [];
case 1
    ind = 1;
otherwise
    dy = diff(y);
    not_plateau_ind = find(dy~=0);
    ind = find( ([dy(not_plateau_ind) 0]<0) & ([0 dy(not_plateau_ind)]>0) );
    ind = not_plateau_ind(ind);
    if y(1)>y(2)
        ind = [1 ind];
    end
    if y(end-1)<y(end)
        ind = [ind length(y)];
    end
end

if nargout > 1
    peaks = y(ind);
end
return ;

