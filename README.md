# MPusillaPhototaxis
Porject investigating the characterisation and dynamics of the common pico eukaryote Micromonas pusilla, focussing specifically on the motion in response to an external light stimulus.

## CODE IN REPOSITORY:

### Population Counting:

+ CounterSec.m

Used for counting population films from stationary microscopic stage.  Same requirments as prttrck except track.m

+ MovingStagePopCount.m  MOST RECENT

Allows for each individual data site to have preset image processing values, and will loop over all the data sets (or a subset of them).  Removes need for reset of PopMovPrtrrck.m after each data site, and doesn't have to be renamed for each new site.

+ PopMovPrtrrck.m   OUTDATED

Moving stage population experiments where the individual data sites have been separated.

+ PopMovPrtrrckAuto.M  OUTDATED

As above, but the layout is different.  Allows for each individual data site to have preset image processing values, and will loop over all the data sets (or a subset of them).  Removes need for reset of PopMovPrtrrck.m after each data site, hence more automated

+ PopPrtrrkMovOLD:

Moving stage, where the individual data sites have NOT been separated, out of date

+ Pre_prttrck:

Used to set up for prttrck.m and for population, check if detecting particles correctly and filelist



### Particle Trajectory Code:

+ Get_Linear_Data.m

Extract lineaer data from LvSp1.m output cell into a matrix

+ LvsSp1.m

Separates linear and spiral tracks from a single experiment.  Could be updated to be a more general function included in the main particle tracking code

+ Plot_Vels.m

Plot speed/time graphs from prttrck

+ prttrckNew.m  REQUIRES UPDATING

Particle Tracking main script.  Needs to have the linear vs spiral sorting included in the main script/turn LvsSp1 into a function?

### From the MATLAB Tracking Code Repository:

+ bpass.m

+ cntrd.m

+ lentrk.m

+ parse_noran.m

+ pkfnd.m

+ read_gdf.m

+ read_noran.m

+ track.m

### From External Sources:

+ peakfinder.m

Used to locate peaks in data




