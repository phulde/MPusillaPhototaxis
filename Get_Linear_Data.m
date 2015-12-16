% Load data
load('16-07-15_v20LinData_TimesIncl.mat');
%%
strFullData = '16-07-15Data_InclTimes';
sLinData = size(LinearData);
% t=0; % DELETE THIS AFTER THE FIRST RUN!!!!!!!!!
% LinearData: Run Number, Duration, peakMag, thetaDeg, thetaRad, particle,
% xdirection, ydirection, time(start), time(stop)
%%
for i=1:sLinData(1,1)
    particleData = cell2mat(LinearData(i,1));
    sParData = size(particleData);
    % Check that there is a run for that particle
%     if particleData(1,1) ~= 0
    if (sParData ~= [0,0])
       for j=1:sParData(1,2)
            FDatWiTimes(t+1:sParData(1,1)+t,j) = particleData(1:end,j);
       end
        t = size(FDatWiTimes(:,1));

    else
        continue
    end
    i;
    clear particleData
end
save([strFullData,'.mat'],'FDatWiTimes')
%%