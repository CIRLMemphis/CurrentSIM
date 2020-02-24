run("../../CIRLSetup.m");
colormapSet = 'jet';
colorScale  = [0 1.0];
shouldScale = 0;
xzRegionX   = 450:650;
xzRegionZ   =   1:50;
xyRegionX   = 300:800;
xyRegionY   = 300:600;
yBest       = 512;
zBest       = 13;

%% load the reconstruction results
expNames = ["201910151247_Exp3WOptGWFActinFull", "201910171618_Exp3WMBPCActinFullIter100"];
iterInd  = [0, 8];

%% load the GWF widefield
load(CIRLDataPath + "\Results\FairSIM\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
widefield = retVars{2};
widefieldNor = widefield./sum(widefield(:));
widefieldNor(widefieldNor < 0) = 0;
widefieldNor = widefieldNor/max(widefieldNor(:));

%% load the MB results
load(CIRLDataPath + "\Results\FairSIM\" + expNames(2) + "\" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
%reconOb    = retVars{iterInd(2)};
reconOb    = retVars{8};
reconObNor = reconOb./sum(reconOb(:));
reconObNor(reconObNor < 0) = 0;
reconObNor = reconObNor/max(reconObNor(:))/0.6;

%%
FairSIMPlotXYXZ(widefieldNor, reconObNor, yBest, zBest, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, colormapSet);