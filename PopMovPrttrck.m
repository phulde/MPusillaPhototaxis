% close all
% clear all
%% Set up save details
strName = '02-12-15_625nm_300muE_DS11';
strIn = '625nm 300\muEm^{-2}s^{-1}';
Scans = 15;
DataSite = 11;
NumImages = 10;
ScanPeriod = 230; % Time taken to return to site in seconds
plt_labels(1) = 1; STARTINGDS = 2;
bvalue = 3;
if DataSite == STARTINGDS
    CulmCounter = 3;
else
end
%%
ExperimentDetails = {'Scans','DataSites','NumImages','ScanPeriod','pkvalue'};
ExperimentDetails{2,1} = Scans; ExperimentDetails{2,2} = DataSite;
ExperimentDetails{2,3} = NumImages; ExperimentDetails{2,4} = ScanPeriod;
ExperimentDetails{2,5} = bvalue;
%% Image Folder:
somefolder='C:\Users\Richard\Documents\PhD\02-12-15\625nm\300E\021215_1646\DataSite 11\';
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
ImCounter = 0;
for i = 1 : NumImages
    i
    for j = 1 : Scans
        fname = filelist(3+ImCounter).name;
        a = double(imread([somefolder fname]));
        b = bpass(a,1,10);
        pk = pkfnd(b,bvalue,11);
        cnt = cntrd(b,pk,11);
        Particles = size(cnt);
        ScanCount(i,(2*j-1)) = Particles(1,1);
        ScanCount(i,2*j) = (j-1)*ScanPeriod;
        ImCounter = ImCounter + 1;
        clear a b pk cnt s
    end
end
for i = 1 : Scans
    MeanValues(i,1) = mean(ScanCount(1:NumImages,2*i));
    MeanValues(i,2) = mean(ScanCount(1:NumImages,2*i - 1));
end
ScanCount(NumImages + 1,:) = mean(ScanCount(1:NumImages,:));
if DataSite == STARTINGDS
    CulmMeanValues = MeanValues;
else
    CulmMeanValues(:,CulmCounter) = MeanValues(:,2);
    CulmCounter = CulmCounter + 1;
end
save([strName,'.mat'],'ScanCount','ExperimentDetails','MeanValues','CulmMeanValues')
%%
if DataSite == STARTINGDS
    fh = figure;
    set(fh,'color','white');
    box on; xlabel('Time (seconds)'); ylabel('Number Detected'); title(strIn);
    hold on;
else
    fh = gcf;
end
% Intensity_Plot(DataSite,Scans,ScanCount,NumImages,MeanValues);
CM = jet(Scans);
for i = 1 : Scans
    plot(ScanCount(1:NumImages,2*i),ScanCount(1:NumImages,2*i - 1),'color',CM(DataSite,:),'marker','o');
    hold on;
end
DS11 = plot(MeanValues(:,1),MeanValues(:,2),'color',CM(DataSite,:),'LineWidth',4);
hold on;
leg = legend([DS2 DS3 DS4 DS5 DS6 DS7 DS8 DS9 DS10 DS11],...
    'Data Site 2', 'Data Site 3', 'Data Site 4','Data Site 5', 'Data Site 6', 'Data Site 7',...
    'Data Site 8', 'Data Site 9', 'Data Site 10', 'Data Site 11','location','northeastoutside');
saveas(gcf,'625_300.fig')
clear ScanCount ExperimentDetails MeanValues
