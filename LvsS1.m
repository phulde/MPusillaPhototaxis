close all
clear all
load('16-07-15v20a-1-10b-15-11pk-11_tr-20_param15V.mat')
%% Currently only focusing on linear run data
%%
str = '16-07-15_v20LinData_TimesIncl';
% Enter particle number here and order parameter
ORDER = 0.95;
% Minimum number of data points (look at FpS?)
MINPOINTS = 100;
q = size(prcle);
% Count is temporary, Number is final total
SpiralCount = 0; LinearCount = 0; LinearNumber = 0; SpiralNumber = 0;
background = 15; test1 = 0; test2 = 0; test3 = 0;
% peakfinder.m parameters, see documentation
sel = 20;
thresh = 20;
extrema = 1;
includeEndpoints = true;
interpolate = false;
% testing = [406;558;590]; 
% testing = [1144];
% sTEST = size(testing);
% for particle2=1:(sTEST(1,1))
%     particle = testing(particle2,1);

%%
for particle=1:q(1,3)
    clear LinearRuns peakLoc peakMag x y t vx vy speed vi viSumAbs runs
    clear velocity
    % Reset LinearCount for each new particle to be scanned
    LinearCount= 0;
    % Open particle data
	x =cell2mat(prcle(1,1,particle));
	y = cell2mat(prcle(1,2,particle));
	t = cell2mat(prcle(1,3,particle));
	vx = cell2mat(prcle(1,5,particle));
	vy = cell2mat(prcle(1,6,particle));
	speed = cell2mat(prcle(1,7,particle));
    %% Check for minimum number of points
    siSpeed = size(speed); test4 = 0;
    if siSpeed < MINPOINTS
        test4 = test4+1;
        continue
    else
    end

        % Set input for peakfinder.m  See Documentation for details

        % Outputs: peakLoc - index location of peak, peakMag - magnitude of peak
        [peakLoc, peakMag] = peakfinder(speed,sel,thresh,extrema,includeEndpoints,interpolate);
        %%
        % Find start and end of jump, N(1,1) = number of jumps
        % Return peakLoc with second column: start index, third column: end index
        %% Determine if peaks should be merged, shift up if so
    %     s = size(peakLoc);
    %     counter = 0;
    %     i = 1;
    %     for i = 1:(s(1,1)-1)
    %         if (peakLoc(i+1,1)-peakLoc(i,1)) < 2
    %             for j = (i):(s(1,1)-1)
    %                 peakLoc(j,1) = peakLoc(j+1,1);
    %                 peakLoc(end-counter,1) = 0;
    %             end
    %         else
    %         end
    %     end
        N = size(peakLoc);
        if N(1,1) ~= 0
            for i=1:N(1,1)
                % Find Start Point
                % i cycling through each individual peak
                % j is moving either side of the peak, locating endpoints
                for j=1:(peakLoc(i,1))
                    n = peakLoc(i,1)-j;
                    if (n-j)>0
                            if speed(n-j,1) < background;
                                peakLoc(i,2) = n;
                                test1 = 1;
                                break
                            end
                    else
                            % First data point is start of run, prevent 0 index
                            peakLoc(i,2) = 1;
                    end
                end
            end
            %Find End Point
            i=1;
            for i=1:N(1,1)
                peakIndex = peakLoc(i,1);
                ss =size(speed);
                if peakIndex == ss(1,1)
                    peakLoc(i,3) = ss(1,1);
                    continue
                else
                    j = peakIndex+1;
                            while j < ss(1,1)
                                if speed(j,1) < background;
                                    peakLoc(i,3) = j;
                                    test2 = 1;
                                    if j == ss(1,1)
                                     peakLoc(i,3) = j;
                                    else
                                    end
                                % Break out of while loop
                                break
                                else
                                end
                                if (test1+test2) == 2
                                    break
                                else
                                end
                                test3 = test3+1;
                                j=j+1;
                            end
                            % In case peak is penultimate point
                            if j == ss(1,1)
                                peakLoc(i,3) = j;
                            else
                            end

                end
                test1 = 0; test2 = 0;
            end 
            %% Determine if two detected peaks are the same, and if so merge
            % Store temporarily in peakLoc2, clear and restore in peakLoc
    %       j = 1; m(1,1) = 0;
    %         for i=1:(N(1,1)-1)
    %             if peakLoc(i+1,3) == peakLoc(i,3)
    %                 m(j,1) = i;
    %                 j = j+1;
    %             else
    %             end
    %         end
    %         % If there are overlapping peaks, remove SECOND peak
    %         SM = size(m);
    %         if m(1,1) ~= 0
    %             SM = size(m);
    %             for i=1:SM(1,1)
    %                 peakLoc(m(i,1),:) = []
    %             end
    %         else
    %         end
    %         clear m

            %%
            % Calculate unit vector for each point of each run, sum, compare against order parameter
            k = 1;
            i=1;
            for i=1:N(1,1);
                for j = peakLoc(i,2):peakLoc(i,3)
                    velocity = [vx(j,1) vy(j,1)];
                    vi(k,:) = velocity/(norm(velocity));
                    k=k+1;
                    sVi = size(vi);
                end
        % 		viSumAbs = norm(sum(vi)/N(1,1));
%                 viSumAbs = norm(sum(vi))/N(1,1);
                viSumAbs = norm((sum(vi))/sVi(1,1));
                if viSumAbs < ORDER;
                    SpiralCount = SpiralCount+1;
                    SpiralRuns(SpiralCount,1) = i;

                else 
                    LinearCount = LinearCount+1;
    %                 LinearRuns(LinearCount,1) = i;
                    LinearRuns(i,1) = i;

                end
            end
            % Having found the linear runs, extract run data
            % LinearRuns[Jump Number, Run Duration, peakMag, angle of orientation (theta)]
            % Angle with respect to a unit vector orientated along +ve x axis
            if LinearCount > 0;
                for i=1:LinearCount
    %                 runs = LinearRuns(i,1);
                    runs = i;
                    start = peakLoc(runs,2); stop = peakLoc(runs,3);
                    % Make a unit vector pointing along direction of the run
                    RunDir = [(x(stop,1)-x(start,1)) (y(stop,1)-y(start,1))];
                    Ri = RunDir/(norm(RunDir));
                    x1 = Ri(1,1); y1 = Ri(1,2); x2 = 1; y2 = 0;
                    thetaRad = mod(atan2(x1*y2-x2*y1,x1*x2+y1*y2),2*pi);
                    thetaDeg = thetaRad*(180/(2*pi));
                    LinearRuns(i,2) = t(stop,1)-t(start,1);
                    LinearRuns(i,3) = peakMag(runs,1);
                    LinearRuns(i,4) = thetaDeg;
                    LinearRuns(i,5) = thetaRad;
                    LinearRuns(i,6) = particle;
                    LinearRuns(i,7:8) = RunDir;
                    LinearRuns(i,9) = t(start,1);
                    LinearRuns(i,10) = t(stop,1);
                    % Look at next run and waiting time
%                     if i ~= LinearCount
%                         nextrun = peakLoc(runs+1,2); % start of next run
%                         WaitTime = t(nextrun,1)-t(stop,1);
%                         LinearRuns(i,9) = WaitTime;
%                                         particle
% 
%                     else
%                     end
                end
                LinearData(particle,1) = {LinearRuns};
                % Put into LinearData cell-array
            % 	LinearData(particle,1) = mat2cell(LinearRuns);
    %             LinearData(1,1) = {LinearRuns};
            else
            end
    %         s = size(peakLoc);
    %         fh=figure;
    %         set(fh,'color','white');
    %         plot(t,speed); hold on;
    %         for i=1:s
    %             point = peakLoc(i,1);
    %             scatter(t(point,1),speed(point,1));hold on
    %         end

        else
        end
%         particle
%         LinearNumber = LinearNumber + LinearCount
%         SpiralNumber = SpiralNumber + SpiralCount
    end
%     LinearNumber
%     SpiralNumber
%     test4
    %% Plot theta distribution
    ThetaData = [0,0];
    if LinearNumber ~= 0
        clear theta s s1
        s = 1; s1 = 0;
        sLD = size(LinearData);
        for i=1:sLD(1,1)
            partData = cell2mat(LinearData(i,1));
            sPD = size(partData);
            if sPD ==[0,0]
                continue
            else
    %             if JJ ~= 0
                    ThetaData(s1+1:sPD(1,1)+s1,1) = partData(:,5);
                    ThetaData(s1+1:sPD(1,1)+s1,2) = partData(:,6);
                    s1 = size(ThetaData(:,1));
    %             else
    %             end
            end
            clear partData sPD JJ
        end
    else
%     end
    end

%% Remove zeros from theta data WHY IS THIS HAPPENING?????
sTh = size(ThetaData); j = 1; remove(1,1) = 0;
% for i=1:sTh(1,1)
if ThetaData(1,2)~=0
    for i=1:sTh(1,1)
        if ThetaData(i,2) == 0
            remove(j,1) = i;
            j=j+1;
        else
        end
    end
    if remove(1,1) ~= 0
        sRem = size(remove);
        j = 0;
        for k=1:(sRem(1,1))
            r = remove(k,1)-j;
            ThetaData(r,:) = [];
            j = j+1;
        end
    else
    end
else
end
save([str,'.mat'],'LinearData','LinearNumber','ThetaData')
%%