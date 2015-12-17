%% ########################################################################
%  POPULATION COUNTER FOR MOVING STAGE EXPERIMENTS
%  AUTHOR:  RICHARD HENSHAW
%  REQUIRES: bpass.m, pkfnd.m, cntrd.m
%
%  INPUTS:

%  1).  a).  strName:  String of the experimental details, in the form <->
%  DD-MM-YY_###nm_###muE
%       b).  strDS:  Cell array of data site names, used in saving
%  2).  strOut:  Cell array of string names for outputs
%  3).  choose_inversion:  Array of length N, where N is number of data
%  sites.  Can be 0 or 1, 0 being do not invert the image, 1 being invert
%  the image
%  4).  bpassvalue:  2xN array of the values determines from prePrttrck.m,
%  used for the detection stage of the program, values to be used with
%  bpass.m
%  5).  pkvalue:  same as bpassvaule, but values for pkfnd.m
%  6).  Scans:  Number of scans
%  7).  NumImages:  Number of images taken at each site (per scan)
%  8).  ScanPeriod:  Time required to return to a particular site (in
%  seconds)
%  9).  STARTINGDS:  First DataSite that is detectable
%  10).  ENDINGDS:  Last DataSite that is detectable
%  11).  somefolders:  Cell array of strings containing the location of the
%  images for each data site.  THIS NEEDS OPTIMIZING
%
%  OUTPUTS:
%
%       INDIVIDUAL DATA SITES:
%  DD-MM-YY_###nm_###muE_DS##.mat  <-> contains the experimental details,
%  the population count and the mean value at each scan for a specific data
%  site.  This is produced for each valid data site.
%       TOTAL PLOT:
%  ###nm_2000muEplot  .fig and .png  <->  plot showing the behaviour of all
%  the data sites
%
%       CULMULATIVE DATA AND PLOT:
%  
%  ########################################################################
%% 
% Clear, close, clc, then setup save details
close all
clear all
clc
disp('Timer Started')
tic
strName = '02-12-15_625nm_2000muE';
strDS = {'_DS1','_DS2','_DS3','_DS4','_DS5','_DS6','_DS7','_DS8','_DS9',...
    '_DS10','_DS11','_DS12','_DS13','_DS14','_DS15'};
% strName = {'02-12-15_625nm_2000muE_DS1','02-12-15_625nm_2000muE_DS2', ...
%     '02-12-15_625nm_2000muE_DS3',...
%     '02-12-15_625nm_2000muE_DS4','02-12-15_625nm_2000muE_DS5','02-12-15_625nm_2000muE_DS6',...
%     '02-12-15_625nm_2000muE_DS7', '02-12-15_625nm_2000muE_DS8','02-12-15_625nm_2000muE_DS9',...
%     '02-12-15_625nm_2000muE_DS10','02-12-15_625nm_2000muE_DS11','02-12-15_625nm_2000muE_DS12',...
%     '02-12-15_625nm_2000muE_DS13','02-12-15_625nm_2000muE_DS14','02-12-15_625nm_2000muE_DS15'};
% strOut = {'625nm 2000\muEm^{-2}s^{-1}','625nm_2000muEplot.fig',...
%     '625nm_2000muEplot.png','625nm_2000muECulmData.mat',...
%     '625nm 2000\muEm^{-2}s^{-1} Culm Plot','625nm_2000muECulmPlot.fig',...
%     '625nm_2000muECulmPlot.png'};
strOut = {'625nm 2000\muEm^{-2}s^{-1}','625nm_2000muEplot.fig',...
    '625nm_2000muEplot.png','625nm_2000muECulmData.mat',...
    '625nm 2000\muEm^{-2}s^{-1} Culm Plot','625nm_2000muECulmPlot.fig',...
    '625nm_2000muECulmPlot.png'};
% This is in case certain sites detect better with the image inverted
% These 3 arrays NEED to be the same size
choose_inversion = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
bpassvalue  = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10];
pkvalue = [7 7 7 7 7 7 7 7 7 7 7 7 7 7 7; 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11];
Scans = 7;
NumImages = 10;
ScanPeriod = 107; % Time taken to return to site in seconds
STARTINGDS = 1; ENDINGDS = 15;
%% Image Folder:
% Access storage folder, OR work through with explicit directories?

% storagefolder = 'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\';
% folderlist = dir(storagefolder);

% This works for now, although there is a better/neater way
somefolder = {'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 1\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 2\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 3\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 4\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 5\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 6\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 7\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 8\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 9\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 10\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 11\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 12\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 13\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 14\',...
    'C:\Users\Richard\Documents\PhD\02-12-15\625nm\2000E\021215_1003\DataSite 15\'};
for DSNum = STARTINGDS:ENDINGDS
    disp(['Current data site:  ', strName, strDS{1,DSNum}])    
    %% Save experiment details for future reference
    ExperimentDetails = {'Experiment','Scans','DataSite','NumImages','ScanPeriod','pkvalue'};
    ExperimentDetials{2,1} = strName;
    ExperimentDetails{2,2} = Scans; ExperimentDetails{2,3} = DSNum;
    ExperimentDetails{2,4} = NumImages; ExperimentDetails{2,5} = ScanPeriod;
    ExperimentDetails{2,6} = pkvalue;
    %
    if DSNum == STARTINGDS
        CulmCounter = 3;
    else
    end
    %% Load images
    clear filelist images
    filelist=dir(somefolder{1,DSNum});
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
        disp(['Rep Image Number:  ',num2str(i)])
        for j = 1 : Scans
            if choose_inversion(1,DSNum) == 1
                if j == 1
                    disp('Invert images for this data site')
                else
                end
                fname = filelist(3+ImCounter).name;
                img = imread([somefolder{1,DSNum} fname]);
                imgcompl = imcomplement(img);
                a = double(imgcompl);
                b = bpass(a,bpassvalue(1,DSNum),bpassvalue(2,DSNum));
                pk = pkfnd(b,pkvalue(1,DSNum),pkvalue(2,DSNum));
                cnt = cntrd(b,pk,11);
                Particles = size(cnt);
                ScanCount(i,(2*j-1)) = Particles(1,1);
                ScanCount(i,2*j) = (j-1)*ScanPeriod;
                ImCounter = ImCounter + 1;
                clear a b pk cnt s
            else
                 if j == 1
                    disp('Invert images for this data site')
                else
                end
                fname = filelist(3+ImCounter).name;
                img = imread([somefolder{1,DSNum} fname]);
                a = double(img);
                b = bpass(a,bpassvalue(1,DSNum),bpassvalue(2,DSNum));
                pk = pkfnd(b,pkvalue(1,DSNum),pkvalue(2,DSNum));
                cnt = cntrd(b,pk,11);
                Particles = size(cnt);
                ScanCount(i,(2*j-1)) = Particles(1,1);
                ScanCount(i,2*j) = (j-1)*ScanPeriod;
                ImCounter = ImCounter + 1;
                clear a b pk cnt s
            end
        end
    end
    for i = 1 : Scans
        MeanValues(i,1) = mean(ScanCount(1:NumImages,2*i));
        MeanValues(i,2) = mean(ScanCount(1:NumImages,2*i - 1));
    end
    ScanCount(NumImages + 1,:) = mean(ScanCount(1:NumImages,:));
    if DSNum == STARTINGDS
        CulmMeanValues = MeanValues;
    else
        CulmMeanValues(:,CulmCounter) = MeanValues(:,2);
        CulmCounter = CulmCounter + 1;
    end
    disp(['Saving Data Site:  ', num2str(DSNum)])
    save([strName,strDS{1,DSNum},'.mat'],'ScanCount','ExperimentDetails','MeanValues')
    if DSNum == ENDINGDS
            save([strOut{1,4}],'CulmMeanValues')
    else
    end
    %% Make figure if it is the first iteration
    if DSNum == STARTINGDS
        disp('First Data Site, so create figure for plot')
        fh = figure;
        set(fh,'color','white');
        box on; xlabel('Time (seconds)'); ylabel('Number Detected');
        title(strOut{1,1});
        hold on;
    else
        disp('Adding most recent Data Site to plot...')
        fh = gcf;
    end
    CM = jet(ENDINGDS);
    for i = 1 : Scans
        plot(ScanCount(1:NumImages,2*i),ScanCount(1:NumImages,2*i - 1),'color',CM(DSNum,:),'marker','o');
        hold on;
    end
    DSPlot(1,DSNum) = plot(MeanValues(:,1),MeanValues(:,2),'color',CM(DSNum,:),'LineWidth',4);
    hold on;
    % THIS WILL NEED CHANGING DEPENDING ON THE VALID DATA SITES
%     leg = legend([DSPlot(1,STARTINGDS:ENDINGDS],...
%         'Data Site 1','Data Site 2', 'Data Site 3', 'Data Site 4',...
%         'Data Site 5', 'Data Site 6', 'Data Site 7',...
%         'Data Site 8', 'Data Site 9', 'Data Site 10', 'Data Site 11',...
%         'Data Site 12','Data Site 13','Data Site 14','Data Site1 15',...
%         'location','northeastoutside');
    if DSNum == ENDINGDS
    leg = legend([DSPlot(1,STARTINGDS:ENDINGDS)],...
        'Data Site 1','Data Site 2', 'Data Site 3', 'Data Site 4',...
        'Data Site 5', 'Data Site 6', 'Data Site 7',...
        'Data Site 8', 'Data Site 9', 'Data Site 10', 'Data Site 11',...
        'Data Site 12','Data Site 13','Data Site 14','Data Site 15',...
        'location','northeastoutside');
        saveas(gcf,strOut{1,3})
    else
    end
    saveas(gcf,strOut{1,2})
    clear ScanCount ExperimentDetails MeanValues
    disp(['Data Site ', num2str(DSNum),' complete'])
    if DSNum ~= ENDINGDS
        disp(['Proceed to Data Site ', num2str(DSNum+1)])
    else
        disp('Final Data Site completed, plot saving')
    end
end
%% Culmulative Plot
disp('Create Culmulative Plot and save Culmulative Data')
close all
sCMV = size(CulmMeanValues);
for i = 1:Scans
    CulmMeanValues(i,sCMV(1,2)+1) = NaN;
    CulmMeanValues(i,sCMV(1,2)+2) = sum(CulmMeanValues(i,2:sCMV(1,2)));
end
sCMV = size(CulmMeanValues);
gh = figure;
set(gh,'color','white')
box on; xlabel('Time (seconds)'); ylabel('Total Detected (summed across all detectable sites)');
title(strOut{1,5}); hold on;
p1 = plot(CulmMeanValues(:,1),CulmMeanValues(:,sCMV(1,2)),'-bx','LineWidth',3);
% leg2 = legend([p1],'Total detected \textit{Micromonas Pusillla}',...
%     'location','northeastoutside');
saveas(gcf,strOut{1,6})
saveas(gcf,strOut{1,7})
save([strOut{1,4}],'CulmMeanValues')
disp('Complete')
%%
TimeSpent = toc;
disp(['Total Running Time: ',TimeSpent])