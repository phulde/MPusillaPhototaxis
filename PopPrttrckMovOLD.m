close all
clear all
%% Set up save details
str1 = '25-11-15PopulationExperiments';
Scans = 10;
DataSites = 15;
NumImages = 10;
ScanPeriod = 100; % Time taken to return to site in seconds
%%
ExperimentDetails = {'Scans','DataSites','NumImages','ScanPeriod'};
ExperimentDetails{2,1} = Scans; ExperimentDetails{2,2} = DataSites;
ExperimentDetails{2,3} = NumImages; ExperimentDetails{2,4} = ScanPeriod;
%% Image Folder:
somefolder='G:\2016_Micromonas\19-10-15\v10\';
filelist=dir(somefolder);
images = [];
% The first two in filelist are . and ..
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
            disp([fname ' loaded']);
            end
        end
    end
end
%% After images loaded, locate and count particles
% Indicies look strange, but is to separate the different data sites
% count=1;
% % for i=3:size(filelist,1)
% % FRAMENO=1
% SiteTime = 0;
SiteNum = 0;
ImCounter = 0
for i = 1 : DataSites
    for j = 1 : NumImages
        for k = 1 : Scans
            fname = filelist(3+ImCounter).name;
            a=double(imread([somefolder fname]));
            b=bpass(a,1,10);
            pk=pkfnd(b,13,11);
            cnt=cntrd(b,pk,11);
            s = size(cnt);
            SiteCount(j,(2*k - 1)) = s(1,1);
            SiteCount(j,2*k) = (j-1)*ScanPeriod;
            ImCounter = ImCounter + 1
            clear a b pk cnt s
        end
        ScanPeriod = 0;
        PopCount(i,1) = cell2mat(SiteCount);
    end
end
save([,'.mat'],'PopCount','ExperimentDetails')
