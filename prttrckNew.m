close all
clear all
%% TO CHANGE FOR EACH RUN:
% STRING NAMES
% FRAMETIMES FILE NAME
% mkdir
% Framerate
% CHECK TIME
%% Set up save details
    str1='19-10-15'; fir=''; sec='a-1-10'; third='b-15-11';
    fourth='pk-11_tr-12_param15';
    str2='Reconstruction';
    str3='Particle Tracks 19-10-15_v10/';
    str4='V';
    str5='Particle Tracks 19-10-15_v10jpgs/';
    str6='Particle Tracks 19-10-15_v10figs/';
mkdir('Particle Tracks 19-10-15_v10');
% mkdir('Particle Tracks 19-10-15_v1');
% mkdir('Particle Tracks 19-10-15_v1');

STARTFRAME=3;
FpS=1 ;
Mag=40;
% Minimum max velocity for a particle to be considered a NewMover
MINIVEL=12;
%%
%// list all the files in some folder
% somefolder = '~/Images/';
somefolder='G:\2016_Micromonas\19-10-15\v10\';
% somefolder = 'C:\Users\Richard\Documents\
filelist=dir(somefolder);
%% Get FrameTimes
fileID=fopen('19-10-15_v10frametimes.txt','r');
formatSpec='%f';
time=fscanf(fileID,formatSpec);
r=size(time); k=1;
fclose(fileID);
for i=2:r(1,1)
    if (time(i,1)<time(i-1,1))
        j(k,1)=i;
        k=k+1;
    else
    end
end
N=size(j);
for i=1:r(1,1)
    time(i,2)=time(i,1);
end
for n=1:N(1,1)
    for i=j(n):r(1,1)
        time(i,2)=time(i,1)+65535.*n;
    end
end
time(1,3)=0;
for i=2:r(1,1)
    time(i,3)=time(i-1,3)+(1./FpS);
end

%%
% filelist = dir('C:/Users/Richard/Documents/Final Year Project/Tracking/24-11-v2/');
images = [];
%// the first two in filelist are . and ..
count = 1;
t=0;
for i=3:size(filelist,1)
    %// filelist is not a folder
    if filelist(i).isdir ~= true
        fname = filelist(i).name;
        %// if file extension is TFF
        if strcmp( fname(size(fname,2)-3:size(fname,2)) ,'.tiff'  ) == 1
            tmp = imread([somefolder fname]);
           
            %// convert it to grayscale image if tmp is a color
            %// image/picture
            if size(tmp,3) == 3
            tmp = rgb2gray(tmp);
            %//resize of image
            %tmp = imresize(tmp,[320 240],'bilinear');
            %// put it into images buffer
            images(:,:,count) = tmp;
%             count = count +1;  PUT THIS AT THE END
             
            %images = [images tmp];
            disp([fname ' loaded']);
            count=count+1;
            end
        end
    end
end
%% After images loaded, locate particles and store locations
count=1;
% for i=3:size(filelist,1)
FRAMENO=1
for i=STARTFRAME:(size(filelist,1)-4)
%     for i=3:(size(filelist,1)-1)
    fname=filelist(i).name;
    a=double(imread([somefolder fname]));
    b=bpass(a,1,10);
    pk=pkfnd(b,20,11);
    cnt=cntrd(b,pk,11);
%     %Convert Rg to R, using spherical approximation
    r=cnt(:,4);
    r(:,2)=sqrt((5/3).*r(:,1).*r(:,1));
    r(:,3)=sqrt((5/3).*cnt(:,4).*cnt(:,4));
%     %
    s=size(cnt(:,1));
    R(t+1:s(1,1)+t,1)=r(:,3);
    pos(t+1:s(1,1)+t,1)=cnt(:,1); %x
    pos(t+1:s(1,1)+t,2)=cnt(:,2); %y
    pos(t+1:s(1,1)+t,3)=time(FRAMENO,3); %time
    t=size(pos(:,1));
    FRAMENO=FRAMENO+1
end
MR=mean(R);
%% Track and save: pos,result
field1='mem'; value1=15;
field2='dim'; value2=2;
field3='good'; value3=2;
field4='quiet'; value4=0;
param=struct(field1,value1,field2,value2,field3,value3,field4,value4);
save([str3 '_PreTrack_','.mat'],'pos','R');
result=track(pos,12,param);
%% Divide into individual particles
j=1; m=1; count=0; q=0;
s=size(result(:,1));
for i=1:(s(1,1)-1)
    if result(i,4)~=result(i+1,4)
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

%% Calculate velocities in \mu ms^-1, find NewMovers
q=size(prcle);
m=1;
for n=1:q(1,3)
    str=num2str(n);
    x=cell2mat(prcle(1,1,n));
    y=cell2mat(prcle(1,2,n));
    t=cell2mat(prcle(1,3,n));
    V(1,1)=0; V(1,2)=0;
    sx=size(x);
    for j=2:sx
        V(j,1)=(x(j,1)-x(j-1,1));
        V(j,2)=(y(j,1)-y(j-1,1));
        V2=V.^2;
        V(j,3)=7.4.*(FpS.*sqrt(V2(j,1)+V2(j,2)))./Mag;
    end
    for k=1:3
        prcle(:,k+4,n)=num2cell(V(:,k),1);  
    end
    if max(abs(V(:,3)))>MINIVEL

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
    % Store Identity of NewMovers
        NewMovers(m,1)=n;
        m=m+1;
    else
    end
    clear x y V V2 sx t
    
end
% Plot Sp_vs_Time
NM=size(NewMovers);
for i=1:NM(1,1)
%     n=NewMovers(i,1);
%     str=num2str(n);
%     t=cell2mat(prcle(1,3,n));
%     v=cell2mat(prcle(1,7,n));
%     fh=figure;
%     title(str)
%     xlabel('Time (s)'); ylabel('Speed'); hold on;
%     set(fh,'color','white'); hold on;
%     scatter(t,v,'+g'); hold on;
%     plot(t,v,'k'); hold on;
%     saveas(gcf,[str5 str1 fir '_' str '.jpg']);
%     saveas(gcf,[str6 str1 fir '_' str '.fig']);
    close all
    clear t v
end
%% All plots
l=1;
error=100;
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
save([str3 str1,fir,sec,third,fourth,str4,'.mat'],'pos','result','prcle','R','movers','NewMovers')
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
%%  Plot NewMovers
fh=figure;
set(fh,'color','white');
axis([0 1000 0 1000]); hold on;
set(gca,'YDir','reverse'); hold on;
NM=size(NewMovers);
for i=1:NM(1,1)
    x=cell2mat(prcle(1,1,NewMovers(i,1)));
    y=cell2mat(prcle(1,2,NewMovers(i,1)));
    plot(x,y); hold on
    clear x y
end
hold off
saveas(gcf,[str3 'NewMovers' '_' sec third fourth '.jpg']);