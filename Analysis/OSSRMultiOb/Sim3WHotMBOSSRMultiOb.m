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
expNames = ["201910171412_Sim3WOptGWFOSSRMultiOb256", "201910170821_Sim3WMBHotOSSRMultiOb256Iter200"];
iterInd  = [0, 3];

%% load the GWF widefield
load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
widefield = retVars{2};
widefieldNor = widefield./sum(widefield(:));
widefieldNor(widefieldNor < 0) = 0;
widefieldNor = widefieldNor/max(widefieldNor(:));

%% load the MB results
load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(2) + "\" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb    = retVars{iterInd(2)};
reconObNor = reconOb./sum(reconOb(:));
reconObNor(reconObNor < 0) = 0;
reconObNor = reconObNor/max(reconObNor(:));

%%
OSSRPlotXYXZ(widefieldNor, reconObNor, yBest, zBest, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, colormapSet)