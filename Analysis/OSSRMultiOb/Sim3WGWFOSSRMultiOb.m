run("../../CIRLSetup.m");
colormapSet = 'jet';
colorScale  = [0 1.0];
shouldScale = 0;
xzRegionX   = 257-100:257+99;
xzRegionZ   = 257-100:257+99;
xyRegionX   = 257-50 :257+49;
xyRegionY   = 257-50 :257+49;
yBest       = 257;
zBest       = 257;

%% load the reconstruction results
expNames = ["201911111020_Sim3WOptGWFOSSRMultiOb256"];
iterInd  = [0];
load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'retVars');
 
%% load GWF result
reconObNor = reconOb./sum(reconOb(:));
reconObNor(reconObNor < 0) = 0;
reconObNor = reconObNor/max(reconObNor(:));

%% load the GWF widefield
widefield = retVars{2};
widefieldNor = widefield./sum(widefield(:));
widefieldNor(widefieldNor < 0) = 0;
widefieldNor = widefieldNor/max(widefieldNor(:));

%%
OSSRPlotXYXZ(widefieldNor, reconObNor, yBest, zBest, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, colormapSet)