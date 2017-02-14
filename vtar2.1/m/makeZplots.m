% Function to make impedence plots

function makeZplots(x,y,style,fighandle)

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
plot(x(low:high),y(low:high),style);

return;