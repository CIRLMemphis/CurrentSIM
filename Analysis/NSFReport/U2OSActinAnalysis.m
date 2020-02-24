run("../../CIRLSetup.m");
colormapSet = 'hot';
colorScale  = [0 1.0];
shouldScale = 0;
xzRegionX   = 450:650;
xzRegionZ   =   1:50;
xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;
yBest       = 512;
zBest       = 13;

%%
load(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm.mat", 'g');
fh = figure();
fh.WindowState = 'maximized';
subplot(2,2,1); imagesc(g(1:256,1:256,7,1,1));         axis square off; xlabel('x'); ylabel('y'); title('g0'); colormap(colormapSet);
subplot(2,2,2); imagesc(g(1:256,1:256,7,1,2));         axis square off; xlabel('x'); ylabel('y'); title('g1'); colormap(colormapSet);
subplot(2,2,3); imagesc(squeeze(g(257,1:256,:,1,1))'); axis image  off; xlabel('x'); ylabel('z'); title('g0'); colormap(colormapSet);
subplot(2,2,4); imagesc(squeeze(g(257,1:256,:,1,2))'); axis image  off; xlabel('x'); ylabel('z'); title('g1'); colormap(colormapSet);
print(gcf,"U2OSForward.png",'-dpng','-r300');

%% load the reconstruction results
expNames = ["201912181803_Exp3WU2OSActinOptGWF", ...
            "201912221021_Exp3WU2OSActinOTFMB"];
iterInd  = [0, 6];
load(CIRLDataPath + "/Results/U2OSActin/" + expNames(1) + "/" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'retVars');
 
%% load GWF result
WFNor = retVars{2}./sum(retVars{2}(:));
WFNor(WFNor < 0) = 0;
WFNor = WFNor/max(WFNor(:));

GWFObNor = reconOb./sum(reconOb(:));
GWFObNor(GWFObNor < 0) = 0;
GWFObNor = GWFObNor/max(GWFObNor(:));

%% load the 2D-GWF reconstruction results
FileTif      = char(CIRLDataPath + "/Results/FairSIM/FairSIM_AutoReconstructionResult.tif");
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
recon2DGWF = reconObNor/max(reconObNor(:));

%% load the MB results
load(CIRLDataPath + "/Results/U2OSActin/" + expNames(2) + "/" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb = retVars{iterInd(2)};
MBObNor = reconOb./sum(reconOb(:));
MBObNor(MBObNor < 0) = 0;
MBObNor = MBObNor/max(MBObNor(:));

%% plot the widefield
fh = figure();
fh.WindowState = 'maximized';
subplot(2,1,1); imagesc(WFNor(:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
subplot(2,1,2); imagesc(squeeze(WFNor(yBest, :, :))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('z');
title('Widefield');
print(gcf,"WidefieldFull.png",'-dpng','-r300');


%% XY plan
%colormapSet = 'gray';

fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(recon2DGWF(:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('2D-GWF Full');
subplot(1,3,2); imagesc(GWFObNor    (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(1,3,3); imagesc(MBObNor     (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(1,3,3); imagesc(MBObNor     (:, :,round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
print(gcf,"XYCompareFull.png",'-dpng','-r300');

xyRegionX   =   50:350;
xyRegionY   =   50:350;
fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(recon2DGWF(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 2D-GWF');
subplot(1,3,2); imagesc(GWFObNor    (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(1,3,3); imagesc(MBObNor     (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(1,3,3); imagesc(MBObNor     (round(xyRegionY/2), round(xyRegionX/2),round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
print(gcf,"XYCompareTopLeft.png",'-dpng','-r300');

xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;
fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(recon2DGWF(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 2D-GWF');
subplot(1,3,2); imagesc(GWFObNor    (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(1,3,3); imagesc(MBObNor     (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(1,3,3); imagesc(MBObNor    (round(xyRegionY/2), round(xyRegionX/2),round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
print(gcf,"XYCompareBottomLeft.png",'-dpng','-r300');

%% XZ plan
%colormapSet = 'gray';

fh = figure();
fh.WindowState = 'maximized';
subplot(3,1,1); imagesc(squeeze(recon2DGWF(yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('2D-GWF Full');
subplot(3,1,2); imagesc(squeeze(GWFObNor    (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(3,1,3); imagesc(squeeze(MBObNor     (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(3,1,3); imagesc(squeeze(MBObNor     (yBest/2, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
print(gcf,"XZCompareFull.png",'-dpng','-r300');

fh = figure();
fh.WindowState = 'maximized';
subplot(3,1,1); imagesc(squeeze(recon2DGWF(yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 2D-GWF');
subplot(3,1,2); imagesc(squeeze(GWFObNor    (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(3,1,3); imagesc(squeeze(MBObNor     (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(3,1,3); imagesc(squeeze(MBObNor     (yBest/2, round(xzRegionX/2), round(xzRegionZ/2)))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
print(gcf,"XZCompareMiddle.png",'-dpng','-r300');


%% WF vs ours 
%colormapSet = 'gray';

fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(WFNor   (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Widefield Full');
subplot(1,3,2); imagesc(GWFObNor(:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(1,3,3); imagesc(MBObNor (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(1,3,3); imagesc(MBObNor     (:, :,round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
print(gcf,"XYMethodCompareFull.png",'-dpng','-r300');

xyRegionX   =   50:350;
xyRegionY   =   50:350;
fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(WFNor   (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed Widefield');
subplot(1,3,2); imagesc(GWFObNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(1,3,3); imagesc(MBObNor (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(1,3,3); imagesc(MBObNor     (round(xyRegionY/2), round(xyRegionX/2),round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
print(gcf,"XYMethodCompareTopLeft.png",'-dpng','-r300');

xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;

for zInd = zBest-6:2:zBest+6
    fh = figure();
    fh.WindowState = 'maximized';
    subplot(1,3,1); imagesc(WFNor   (xyRegionY, xyRegionX,zInd)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
    title('Zoomed Widefield');
    subplot(1,3,2); imagesc(GWFObNor(xyRegionY, xyRegionX,zInd)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
    title('Zoomed 3D-GWF');
    subplot(1,3,3); imagesc(MBObNor (xyRegionY, xyRegionX,zInd)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
    %subplot(1,3,3); imagesc(MBObNor    (round(xyRegionY/2), round(xyRegionX/2),round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
    title('Zoomed 3D-MB');
    print(gcf,"XYMethodCompareBottomLeft" + zInd + ".png",'-dpng','-r300');
end

%% XZ plan
%colormapSet = 'gray';

fh = figure();
fh.WindowState = 'maximized';
subplot(3,1,1); imagesc(squeeze(WFNor   (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Widefield Full');
subplot(3,1,2); imagesc(squeeze(GWFObNor(yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(3,1,3); imagesc(squeeze(MBObNor (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(3,1,3); imagesc(squeeze(MBObNor     (yBest/2, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
print(gcf,"XZMethodCompareFull.png",'-dpng','-r300');

fh = figure();
fh.WindowState = 'maximized';
subplot(3,1,1); imagesc(squeeze(WFNor   (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed Widefield');
subplot(3,1,2); imagesc(squeeze(GWFObNor(yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(3,1,3); imagesc(squeeze(MBObNor (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
%subplot(3,1,3); imagesc(squeeze(MBObNor     (yBest/2, round(xzRegionX/2), round(xzRegionZ/2)))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
print(gcf,"XZMethodCompareMiddle.png",'-dpng','-r300');
