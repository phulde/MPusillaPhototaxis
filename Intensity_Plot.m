function Intensity_Plot(DataSite,Scans,ScanCount,NumImages,MeanValues)
CM = jet(Scans);
for i = 1 : Scans
    plot(ScanCount(1:NumImages,2*i),ScanCount(1:NumImages,2*i - 1),'marker','o');
    hold on;
end
DS2 = plot(MeanValues(:,1),MeanValues(:,2),'color',CM(DataSite,:),'LineWidth',4);
hold on;
return