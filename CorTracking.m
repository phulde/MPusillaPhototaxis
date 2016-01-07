% ########################################################################
%  CORRECTIVE TRACKING FUNCTION
%  AUTHOR:  RICHARD HENSHAW
%  REQUIRES: track2.m
%  After the particle pretracking is complete, run the tracking function,
%  and if any tracking errors occur (from maxdisp or param.m), reduce these
%  values and continue to run until successful.
%  VERSIONING:
%  V1: 07/01/2016
%  REQUIRES TESTING.
%  INPUTS:
%  pos - array of position data
%  maxdisp, param - variables needed for track2.m
%  strTrckOut - string containing save details for final ".mat" output file
%  Folder containing the source images

%  OUTPUTS:
%  .mat with tracking data and the final parameter values saved as well
%  ########################################################################
%%
function [result,maxdisp,param] = CorTracking(pos,maxdisp,param,strTrckOut)

keep_trying = 0;
old_maxdisp = maxdisp;

while value1 > 0
    maxdisp = old_maxdisp;
    while keep_trying == 0
        
        result = track2(pos,maxdisp,param);

        if maxdisp == 1
            disp('Max displacement cannot be reduced further')
            disp('Reset max displacement and reduce param.mem')
            value1 = value1 - 1;
            break
        end

        if (reduce_maxdisp == 1) && (maxdisp ~= 1)
            disp('Tracking failed, try again with reduced max displacement')
            clear result
            result = track2(pos,maxdisp-1,param);
        end

        if reduce_maxdisp == 0
            disp('Tracking complete, continue with main')
            keep_trying = 1;
            break
        end
    end
    
    if keep_trying == 1;
        disp('Tracking Complete, saving final variable details')
        TrackingDetails = {'Experiment','Final maxdisp','Final param.mem'};
        TrackingDetails{2,1} = strName;
        TrackingDetails{2,2} = maxdisp;
        TrackingDetails{2,3} = value1;
        saveas(strTrckOut,'results','param','TrackingDetails');
        return
    else
        disp('Tracking failed!!')
        return
    end
end

if value1 == 0
    disp('Cannot reduce param.mem any further')
end