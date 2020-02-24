run("../../CIRLSetup.m");
colormapSet = 'jet';
colorScale  = [0 1.0];
shouldScale = 0;
xzRegionX   = 450:650;
xzRegionZ   =   1:50;
xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;
yBest       = 512;
zBest       = 13;

%% load the reconstruction results
expNames = ["201910151247_Exp3WOptGWFActinFull",   ...
            "201910170618_Exp3WMBActinFullIter100",...
            "201910171618_Exp3WMBPCActinFullIter100"];
iterInd  = [0, 10, 8];
load(CIRLDataPath + "\Results\FairSIM\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'retVars');
 
%% load GWF result
GWFObNor = reconOb./sum(reconOb(:));
GWFObNor(GWFObNor < 0) = 0;
GWFObNor = GWFObNor/max(GWFObNor(:));

%% load the 2D-GWF reconstruction results
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\FairSIM\FairSIM_AutoReconstructionResult.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages+floor(NumberImages/2)*2,'uint16');
for i = 1:NumberImages
    reconOb(:,:,2*(i-1)+1) = imread(FileTif,'Index',i);
end
for i = 2:2:size(reconOb,3)
    reconOb(:,:,i) = (reconOb(:,:,i-1) + reconOb(:,:,i+1))/2;
end
reconOb    = double(reconOb);
reconObNor = reconOb./sum(reconOb(:));
reconObNor = reconObNor/max(reconObNor(:));
widefieldNor = reconObNor;

%% load the MB results
load(CIRLDataPath + "\Results\FairSIM\" + expNames(2) + "\" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb = retVars{iterInd(2)};
MBObNor = reconOb./sum(reconOb(:));
MBObNor(MBObNor < 0) = 0;
MBObNor = MBObNor/max(MBObNor(:));

%% load the MBPC results
load(CIRLDataPath + "\Results\FairSIM\" + expNames(3) + "\" + expNames(3) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb   = retVars{iterInd(3)};
MBPCObNor = reconOb./sum(reconOb(:));
MBPCObNor(MBPCObNor < 0) = 0;
MBPCObNor = MBPCObNor/max(MBPCObNor(:));
MBPCObNor = MBPCObNor/max(MBPCObNor(:))/0.5;

%% XY plan
%colormapSet = 'gray';

figure
subplot(1,4,1); imagesc(widefieldNor(:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('2D-GWF Full');
subplot(1,4,2); imagesc(GWFObNor    (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(1,4,3); imagesc(MBObNor     (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
subplot(1,4,4); imagesc(MBPCObNor   (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MBPC Full');

xyRegionX   =   50:350;
xyRegionY   =   50:350;
figure;
subplot(1,4,1); imagesc(widefieldNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 2D-GWF');
subplot(1,4,2); imagesc(GWFObNor    (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(1,4,3); imagesc(MBObNor     (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
subplot(1,4,4); imagesc(MBPCObNor   (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MBPC');

xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;
figure;
subplot(1,4,1); imagesc(widefieldNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 2D-GWF');
subplot(1,4,2); imagesc(GWFObNor    (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(1,4,3); imagesc(MBObNor     (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
subplot(1,4,4); imagesc(MBPCObNor   (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MBPC');

%% XZ plan
%colormapSet = 'gray';

figure
subplot(4,1,1); imagesc(squeeze(widefieldNor(yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('2D-GWF Full');
subplot(4,1,2); imagesc(squeeze(GWFObNor    (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(4,1,3); imagesc(squeeze(MBObNor     (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
subplot(4,1,4); imagesc(squeeze(MBPCObNor   (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MBPC Full');

figure;
subplot(4,1,1); imagesc(squeeze(widefieldNor(yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 2D-GWF');
subplot(4,1,2); imagesc(squeeze(GWFObNor    (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(4,1,3); imagesc(squeeze(MBObNor     (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
subplot(4,1,4); imagesc(squeeze(MBPCObNor   (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MBPC');


%% XY montages
figure;montage(widefieldNor(xyRegionY, xyRegionX, zBest-7:zBest+7)); colormap(colormapSet);
figure;montage(GWFObNor    (xyRegionY, xyRegionX, zBest-7:zBest+7)); colormap(colormapSet);
figure;montage(MBObNor     (xyRegionY, xyRegionX, zBest-7:zBest+7)); colormap(colormapSet);
figure;montage(MBPCObNor   (xyRegionY, xyRegionX, zBest-7:zBest+7)); colormap(colormapSet);

%% XZ montages
cur  = widefieldNor;
temp = zeros(size(cur,1), size(cur, 3), size(cur, 2));
for yInd = 1:size(cur,1)
    temp(yInd,:,:) = squeeze(cur(yInd,:,:))';
end
temp = permute(temp(yBest-7:yBest+7, xzRegionZ, xzRegionX), [2, 3, 1]);
figure;montage(temp); colormap(colormapSet);

cur  = GWFObNor;
temp = zeros(size(cur,1), size(cur, 3), size(cur, 2));
for yInd = 1:size(cur,1)
    temp(yInd,:,:) = squeeze(cur(yInd,:,:))';
end
temp = permute(temp(yBest-7:yBest+7, xzRegionZ, xzRegionX), [2, 3, 1]);
figure;montage(temp); colormap(colormapSet);

cur  = MBObNor;
temp = zeros(size(cur,1), size(cur, 3), size(cur, 2));
for yInd = 1:size(cur,1)
    temp(yInd,:,:) = squeeze(cur(yInd,:,:))';
end
temp = permute(temp(yBest-7:yBest+7, xzRegionZ, xzRegionX), [2, 3, 1]);
figure;montage(temp); colormap(colormapSet);

cur  = MBPCObNor;
temp = zeros(size(cur,1), size(cur, 3), size(cur, 2));
for yInd = 1:size(cur,1)
    temp(yInd,:,:) = squeeze(cur(yInd,:,:))';
end
temp = permute(temp(yBest-7:yBest+7, xzRegionZ, xzRegionX), [2, 3, 1]);
figure;montage(temp); colormap(colormapSet);