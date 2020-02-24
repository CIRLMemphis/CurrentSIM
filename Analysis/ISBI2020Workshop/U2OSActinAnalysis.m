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

%% load the MB results
load(CIRLDataPath + "/Results/U2OSActin/" + expNames(2) + "/" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb = retVars{iterInd(2)};
MBObNor = reconOb./sum(reconOb(:));
MBObNor(MBObNor < 0) = 0;
MBObNor = MBObNor/max(MBObNor(:));

%% XY plan
xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;
fig   = figure();
fig.WindowState = 'maximized';
[ha, pos] = TightSubplot(1,3,[.01 .001],[.01 .03],[.01 .01]);
axes(ha(1));
imagesc(WFNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
axes(ha(2));
imagesc(GWFObNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
axes(ha(3));
imagesc(MBObNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');