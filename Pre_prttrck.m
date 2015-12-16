%    str1='15-07-15'; fir='v3'; sec='a-1-10'; third='b-20-11';
%     fourth='pk-11_tr-15_param15';
%     str2='Reconstruction';
%     str3='Particle Tracks 15-07-15_v3/';
%     str4='V';
%     str5='Particle Sp_vs_Time 15-07-v3jpgs/';
%     str6='Particle Sp_vs_Time 15-07-v3figs/';
% mkdir('Particle Tracks 15-07-15_v3');
% mkdir('Particle Sp_vs_Time 15-07-v3jpgs');
% mkdir('Particle Sp_vs_Time 15-07-v3figs');
close all
STARTFRAME=8;
FpS=25;
Mag=60;
% Minimum max velocity for a particle to be considered a NewMover
MINIVEL=10;
% somefolder='G:\2016_Micromonas\02-12-15\625nm\110E\021215_1515\DataSite1\';
% filelist=dir(somefolder);
img=imread('021215_1646_00003_00003_00004.tiff');
im2 = imcomplement(img);
a=double(img);
a2 = double(im2);
b=bpass(a2,1,10);
pk=pkfnd(b,4,11);
cnt=cntrd(b,pk,11);
fh=figure;
% A = mat2gray(a);
imagesc(a2);
xlabel('x'); ylabel('y'); hold on;
axis([0 1000 0 1000]); hold on;
set(gca,'YDir','reverse'); hold on;
scatter(cnt(:,1),cnt(:,2),'k.')
        clear a b pk s
