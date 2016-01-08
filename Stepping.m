%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Program to step the individual data sites into a more representative
%  plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all
STARTPOINT = 3;
filelist = dir;
STARTINGDS = 1;
ENDINGDS = 15;
TimeSplit = 107/15;
ExtraFiles = 7;
DSNum = STARTINGDS;
CM = jet(15);
mkdir('Stepped');
strFigSave = {'02-12-15-625nm_2000muEplot.fig','02-12-15-625nm_2000muEplot.png'};
strName = {'02-12-15 625nm 2000muE SteppedPlot','Stepped/'};
fh = figure;
set(fh,'color','white');
box on; 
for i = STARTPOINT:(length(filelist)-ExtraFiles)
    filelist(i).name
    load(filelist(i).name);
    sSc = size(ScanCount);
    for j = 1:(sSc(1,2)/2)
        ScanCount(:,2*j) = ScanCount(:,2*j) + (DSNum)*TimeSplit;
    end
    MeanValues(:,1) = MeanValues(:,1) + (DSNum)*TimeSplit;
    fname = filelist(i).name;
    save([strName{1,2} fname],'ScanCount','MeanValues','ExperimentDetails');
    DSPlot(1,DSNum) = plot(MeanValues(:,1),MeanValues(:,2),'color',CM(DSNum,:),'LineWidth',4);
    hold on;
    clear ScanCount MeanValues ExperimentDetails
    DSNum = DSNum + 1;
end
leg = legend([DSPlot(1,STARTINGDS:ENDINGDS)],...
        'Data Site 1','Data Site 2', 'Data Site 3', 'Data Site 4',...
        'Data Site 5', 'Data Site 6', 'Data Site 7',...
        'Data Site 8', 'Data Site 9', 'Data Site 10', 'Data Site 11',...
        'Data Site 12','Data Site 13','Data Site 14','Data Site 15',...
        'location','northeastoutside'); hold on;
xlabel('Time, seconds');
ylabel('Number of particles detected');
title(strName{1,1})

saveas(gcf,[strName{1,2} strFigSave{1,1}]);
saveas(gcf,[strName{1,2} strFigSave{1,2}]);