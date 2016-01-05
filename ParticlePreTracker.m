% ########################################################################
%  PARTICLE LOCATOR FOR TRAJECORY EXPERIMENTS
%  AUTHOR:  RICHARD HENSHAW
%  REQUIRES: bpass.m, pkfnd.m, cntrd.m
%  Takes an image set (in a folder), and locates the particles for that
%  film
%  INPUTS:
%  .txt file containing frametime data
%  Folder containing the source images

%  OUTPUTS:
%  .mat file with the position data stored, and the radius of the particles
%  ########################################################################
%%
%%
images = [];
t = 0;
strPos = 'DDMMYY_exp_positiondata';
% List all the files in some folder
somefolder='G:\2016_Micromonas\19-10-15\v10\';
filelist=dir(somefolder);
%% Get FrameTimes
disp('Obtaining frametimes from input file')
fileID=fopen([somefolder, '19-10-15_v10frametimes.txt'],'r');
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
%%  Load the images in the directory into the images array
disp('Load image data')
for i=3:size(filelist,1)
    %// filelist is not a folder
    if filelist(i).isdir ~= true
        fname = filelist(i).name;
        % if file extension is TFF
        if strcmp( fname(size(fname,2)-3:size(fname,2)) ,'.tiff'  ) == 1
            tmp = imread([somefolder fname]);
            % convert it to grayscale image if tmp is a color
            % image/picture
            if size(tmp,3) == 3
            tmp = rgb2gray(tmp);
            % resize of image
            % tmp = imresize(tmp,[320 240],'bilinear');
            % put it into images buffer
            images(:,:,count) = tmp;           
            % images = [images tmp];
            disp([fname ' loaded']);
            count=count+1;
            end
        end
    end
end
%%  Locate particles and store locations
disp('Locate particles and store their locations')
FRAMENO = 1
for i=STARTFRAME:(size(filelist,1)-4)
    fname=filelist(i).name;
    a=double(imread([somefolder fname]));
    b=bpass(a,1,10);
    pk=pkfnd(b,20,11);
    cnt=cntrd(b,pk,11);
     %Convert Rg to R, using spherical approximation
    r=cnt(:,4);
    r(:,2)=sqrt((5/3).*r(:,1).*r(:,1));
    r(:,3)=sqrt((5/3).*cnt(:,4).*cnt(:,4));
    s=size(cnt(:,1));
    R(t+1:s(1,1)+t,1)=r(:,3);
    pos(t+1:s(1,1)+t,1)=cnt(:,1); %x
    pos(t+1:s(1,1)+t,2)=cnt(:,2); %y
    pos(t+1:s(1,1)+t,3)=time(FRAMENO,3); %time
    t=size(pos(:,1));
    FRAMENO=FRAMENO+1
end
saveas([strPos , '.mat'],'pos');