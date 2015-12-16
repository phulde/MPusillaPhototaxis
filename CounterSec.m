close all
clear all
%%
% somefolder='C:\Users\Richard\Documents\Final Year Project\TimeLapse\Second\Second Time Lapse\';
somefolder = 'G:\2015_micromonas\Movie_Matthew\06-07-15\Micromonas 827, 40x Oil, 1fps, Blue 001\';
filelist=dir(somefolder);
% filelist = dir('C:/Users/Richard/Documents/Final Year Project/Tracking/24-11-v2/');
images = [];
%// the first two in filelist are . and ..
count = 1;
t=0;
FpS = 1;
for i=3:(size(filelist,1))
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
            tmp=1-tmp;
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
place=1
t=0
% i = 4;
    for i=3:(size(filelist,1))-4
    fname=filelist(i).name;
    a=double(imread([somefolder fname]));
    b=bpass(a,1,10);
    pk=pkfnd(b,13,11);
    cnt=cntrd(b,pk,11);
    s=size(cnt);
%     %Convert Rg to R, using spherical approximation
    count(i-2,1)=s(1,1);
    count(i-2,2)=t;
%     if i==13
%     else
    clear a b pk cnt s
%     end
    place=place+1
    t=t+1./FpS;
end
