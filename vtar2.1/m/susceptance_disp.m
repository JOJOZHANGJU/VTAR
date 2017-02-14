function susceptance_disp(f, B1, B2, S) ;

fighandle = figure; 
% B1 = 1/Z1 ; B2 = 1/Z2 ; 
% plot(f, imag(B1),'.', 'color', 'b') ; 
h1 = makeZplots(f, imag(B1), 'b',fighandle)
hold on ;
% plot(f, imag(B2),'.', 'color', 'r') ; 
h2 = makeZplots(f, imag(B2), 'r',fighandle)
% plot(f, imag(B1), 'color', 'b') ; 
% hold on ;
% plot(f, imag(B2), 'color', 'r') ; 

title('Susceptace Plot') ; 
xlabel('Frequency (Hz)') ;
ylabel('1/Ohm') ;
% legend([h1, h2], S, 'location', 'best') ;  % only work for ver7, not
% ver6.5
legend([h1, h2], S{1}, S{2}) ;  % only work for ver7, not

grid on ; 
% set(gca, 'ylim', [-1 1]) ;
set(gca, 'ylim', [-2 2]) ;
set(gca, 'xlim', [0, max(f)]) ;
return ; 

% from tarun 
function h = makeZplots(x,y,style,fighandle)

xvec = [x(1:end-1) x(2:end)];
yvec = [y(1:end-1) y(2:end)];
slopevec = (yvec(:,2) - yvec(:,1))./(xvec(:,2) - xvec(:,1));
indices = find(abs(slopevec) > 0.2);
xvec = xvec(indices,:);
yvec = yvec(indices,:);
figure(fighandle);
hold on;
low = 1;
for i = 1:length(indices),
   high = indices(i);
   plot(x(low:high),y(low:high),style);
   low = indices(i)+1;
end;
high = length(x);
h = plot(x(low:high),y(low:high),style);

return;
