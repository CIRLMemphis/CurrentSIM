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

%% load the GWF widefield
expNames = ["201910151247_Exp3WOptGWFActinFull"];
iterInd  = [0];
load(CIRLDataPath + "\Results\FairSIM\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');

widefield = retVars{2};
widefieldNor = widefield./sum(widefield(:));
widefieldNor(widefieldNor < 0) = 0;
widefieldNor = widefieldNor/max(widefieldNor(:));

%% load the reconstruction results
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

%%
FairSIMPlotXYXZ(widefieldNor, reconObNor, yBest, zBest, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, colormapSet)