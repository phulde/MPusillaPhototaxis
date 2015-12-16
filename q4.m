close all
male = [120:0.01:220]; female = [100:0.01:220]; comb = [80:0.01:240];
muM = 170; sdM = 10; muF = 160; sdF = 8;
normMale = normpdf(male,muM,sdM);
normFemale = normpdf(female,muF,sdF);
Cmale = normcdf(male,muM,sdM);
Cfmale = normcdf(female,muF,sdF);
normComb = normpdf(comb,muM+muF,12.8062485);
Ccomb = normcdf(comb,muM+muF,12.8062485);
%%
fh = figure; box on; xlabel('Height (cm)'); title('Q4'); hold on;
set(fh,'color','white');
p1 = plot(male,normMale,'b'); hold on;
p2 = plot(female,normFemale,'g');
p11 = plot(comb,normComb,'r');
leg = legend([p1 p2 p11],'Male','Female',...
    'Combined PDF','location','northeastoutside');
%%
gh = figure; set(gh,'color','white');
box on; xlabel('Height (cm)'); title('Q4'); hold on;
p3 = plot(male,Cmale,'b'); hold on;
p4 = plot(female,Cfmale,'g');
p33 = plot(comb,Ccomb,'r');
leg2 = legend([p3 p4 p33],'Male CDF','Female CDF','CombCDF',...
    'location','northeastoutside');