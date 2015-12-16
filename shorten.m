str1='01-07-15'; fir='v1'; sec='a-1-10'; third='b-20-11';
    fourth='pk-11_tr-40_param15';
    str2='Reconstruction';
    str3='Particle Tracks 01-07-15/';
    str4='V';
%%
field1='mem'; value1=0;
field2='dim'; value2=2;
field3='good'; value3=5;
field4='quiet'; value4=0;
param=struct(field1,value1,field2,value2,field3,value3,field4,value4);
% result=track(pos,20);
result=track(pos,5,param);
%% Divide into individual particles
j=1; m=1; count=0; q=0;
s=size(result(:,1));
for i=1:(s(1,1)-1)
    if result(i,4)< result(i+1,4)
        for k=1:4
            prcle(:,k,m)=num2cell(result(j:i,k),1);
        end
        m=m+1;
        j=i+1;
    else
    end
end
% fprintf(print4)

% fprintf(print5)
%% All plots
q=size(prcle);
error=10; l=1;
for i=1:q(1,3)
    str=num2str(i);
    x=cell2mat(prcle(1,1,i));
    y=cell2mat(prcle(1,2,i));
    % CHECK FOR MOVEMENT
    % This needs to change-if the first position is far from the mean then
    % it will count it as a mover, instead look at the change between first
    % and last?
    
    % Or look at maximum vs minimum values of x and y?
    maxx=max(x); maxy=max(y);
    minx=min(x); miny=min(y);
    MX=mean(x);
    MY=mean(y);
    if(abs(maxx-minx)>error)
        q1=1;
    else
        q1=0;
    end
    if(abs(maxy-miny)>error)
        q2=1;
    else
        q2=0;
    end

    % If satisfying those checks, plot Movers
    if (q1==1 | q2==1);
%         fh=figure;
%         title(str)
%         xlabel('x'); ylabel('y'); hold on;
%         set(fh,'color','white'); hold on;
%         axis([0 1000 0 1000]); hold on;
%         set(gca,'YDir','reverse'); hold on;
%         scatter(x(1,1),y(1,1),'+g'); hold on;
%         plot(x,y,'.k','MarkerSize',10); hold on;
%         scatter(x(end,1),y(end,1),'or'); hold on;
%         saveas(gcf,[str3 str1 fir '_' str '.jpg']);
%         close all
        movers(l,1)=i;
        l=l+1;
    end

end
%%
% Plot Reconstruction with all
fh=figure;
set(fh,'color','white');
axis([0 1000 0 1000]); hold on;
set(gca,'YDir','reverse'); hold on;
for i=1:q(1,3)
    x=cell2mat(prcle(1,1,i));
    y=cell2mat(prcle(1,2,i));
    plot(x,y); hold on
    clear x y
end
hold off
saveas(gcf,[str3 str2 '.jpg']);
%% Plot Reconstruction with only movers
fh=figure;
set(fh,'color','white');
axis([0 1000 0 1000]); hold on;
set(gca,'YDir','reverse'); hold on;
mo=size(movers);
for i=1:mo(1,1)
    x=cell2mat(prcle(1,1,movers(i,1)));
    y=cell2mat(prcle(1,2,movers(i,1)));
    plot(x,y); hold on
    clear x y
end
hold off
saveas(gcf,[str3 'Movers' '_' sec third fourth '.jpg']);