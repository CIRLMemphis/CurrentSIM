run("../../../CIRLSetup.m");
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
load(CIRLDataPath + "/FairSimData/OMX_U2OS_Mitotracker_600nm.mat", 'g');
fh = figure();
fh.WindowState = 'maximized';
subplot(2,2,1); imagesc(g(1:256,1:256,7,1,1));         axis square off; xlabel('x'); ylabel('y'); title('g0'); colormap(colormapSet);
subplot(2,2,2); imagesc(g(1:256,1:256,7,1,2));         axis square off; xlabel('x'); ylabel('y'); title('g1'); colormap(colormapSet);
subplot(2,2,3); imagesc(squeeze(g(257,1:256,:,1,1))'); axis image  off; xlabel('x'); ylabel('z'); title('g0'); colormap(colormapSet);
subplot(2,2,4); imagesc(squeeze(g(257,1:256,:,1,2))'); axis image  off; xlabel('x'); ylabel('z'); title('g1'); colormap(colormapSet);
print(gcf,"U2OSForward.png",'-dpng','-r300');

%% load the reconstruction results
expNames = ["202007261108_Exp3WU2OSMitoOptGWF_jmDouble",...
            "202007240231_Exp3WU2OSMitoPSFVzMBPC_jmDouble"];
iterInd  = [0, 6];
load(CIRLDataPath + "/Results/U2OSMito/" + expNames(1) + "/" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'retVars');
 
%% load GWF result
% WFNor = retVars{2}./sum(retVars{2}(:));
% WFNor(WFNor < 0) = 0;
% WFNor = WFNor/max(WFNor(:));
% 
GWFObNor = reconOb./sum(reconOb(:));
GWFObNor(GWFObNor < 0) = 0;
GWFObNor = GWFObNor/max(GWFObNor(:));

%% load the 2D-GWF reconstruction results
FileTif      = char(CIRLDataPath + "/Results/U2OSMito/FairSIM.tif");
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
 
%%
load(CIRLDataPath + "/Results/U2OSMito/" + expNames(2) + "/" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'retVars');
reconOb = retVars{iterInd(2)};
MBObNor = reconOb./sum(reconOb(:));
MBObNor(MBObNor < 0) = 0;
MBObNor = MBObNor/max(MBObNor(:));

%% XY plan
%colormapSet = 'gray';

fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(widefieldNor(:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('2D-GWF Full');
subplot(1,3,2); imagesc(GWFObNor    (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(1,3,3); imagesc(MBObNor     (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
% subplot(1,4,4); imagesc(MB7ObNor    (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
% title('3D-MB7 Full');
print(gcf,"XYCompareFull.png",'-dpng','-r300');
