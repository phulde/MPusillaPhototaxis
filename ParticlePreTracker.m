% ########################################################################
%  PARTICLE LOCATOR FOR TRAJECTORY EXPERIMENTS
%  AUTHOR:  RICHARD HENSHAW
%  REQUIRES: bpass.m, pkfnd.m, cntrd.m
%  Takes an image set (in a folder), and locates the particles for that
%  film
%  VERSIONING:
%  V2: 06/01/2016
%  Remove need to imread each image twice, decrease computational time
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
%%  Load the images in the directory into the images array, FRAMENO
disp('Load image data')
FRAMENO = 1;
t = 0;
for i=3:size(filelist,1)
    %// filelist is not a folder
    if filelist(i).isdir ~= true
        if strcmp( fname(size(fname,2)-3:size(fname,2)) ,'.tiff'  ) == 1
            fname = filelist(i).name;
            tmp = double(imread([somefolder fname]));
            images(:,:,FRAMENO) = tmp;           
            % images = [images tmp];
            disp([fname ' loaded']);
            % Now loaded, particle locate and store locations
            b = bpass(images(:,:,FRAMENO),1,10);
            pk = pkfnd(b,20,11);
            cnt = cntrd(b,pk,11);
            % Convert Rg to R using spherical approximation
            r=cnt(:,4);
            r(:,2)=sqrt((5/3).*r(:,1).*r(:,1));
            r(:,3)=sqrt((5/3).*cnt(:,4).*cnt(:,4));
            s=size(cnt(:,1));
            R(t+1:s(1,1)+t,1)=r(:,3);
            % Add number of rows to pos then put in the cnt, time arrays
            % directly
            for j = 1:3
                pos(t+1:s(1,1)+t,j) = 0;
            end
            % Then insert the data
            pos(t+1:s(1,1)+t,1)=cnt(:,1); %x
            pos(t+1:s(1,1)+t,2)=cnt(:,2); %y
            pos(t+1:s(1,1)+t,3)=time(FRAMENO,3); %time
            t = size(pos(:,1));
            FRAMENO=FRAMENO+1;
            clear b pk cnt 
        end
    end
end
disp('Particles located, saving output...')
saveas([strPos , '.mat'],'pos');