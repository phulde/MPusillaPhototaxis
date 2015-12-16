% Remember to load particle data first!!!
%% Set up saving details
str1='15-07-15'; fir='v1'; sec='a-1-10'; third='b-20-11';
fourth='pk-11_tr-15_param15';
str2='Reconstruction';
str3='Particle Tracks 15-07-15_v1/';
str4='V';
str5='Particle Sp_vs_Time 15-07-v1/'
% % mkdir('Particle Sp_vs_Time 15-07-v1');
% %% Enter numbers of interest
% Interest = [47 72 138 148];
% In=size(Interest);
% clear Vels Times
% for i=1:In(1,2);
%         str=num2str(i);
%         Vels=cell2mat(prcle(1,7,i));
%         Times=cell2mat(prcle(1,3,i));
%         fh=figure;
%         title(str)
%         xlabel('x'); ylabel('y'); hold on;
%         set(fh,'color','white'); hold on;
%         scatter(Times,Vels,'+g'); hold on;
%         plot(Times,Vels,'k'); hold on;
%         saveas(gcf,[str5 str1 fir '_' str '.jpg']);
%         close all
% end

q=size(prcle);
error=10;
m=1;
for n=1:q(1,3)
    str=num2str(n);
    x=cell2mat(prcle(1,1,n));
    y=cell2mat(prcle(1,2,n));
    t=cell2mat(prcle(1,3,n));
    V(1,1)=0; V(1,2)=0;
    sx=size(x);
    for j=2:sx
        V(j,1)=abs(x(j,1)-x(j-1,1));
        V(j,2)=abs(y(j,1)-y(j-1,1));
        V2=V.^2;
        V(j,3)=7.4.*(FpS.*sqrt(V2(j,1)+V2(j,2)))./Mag;
    end
    for k=1:3
        prcle(:,k+4,n)=num2cell(V(:,k),1);  
    end
    if max(V(:,3))>MINIVEL

    % Plot movers
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
    % Plot Sp_vs_Time
        fh=figure;
        title(str)
        xlabel('x'); ylabel('y'); hold on;
        set(fh,'color','white'); hold on;
        scatter(t,V(:,3),'+g'); hold on;
        plot(t,V(:,3),'k'); hold on;
        saveas(gcf,[str5 str1 fir '_' str '.jpg']);
        close all
    % Store Identity of NewMovers
        NewMovers(m,1)=n;
        m=m+1;
    end
    clear x y V V2 sx t
    
end