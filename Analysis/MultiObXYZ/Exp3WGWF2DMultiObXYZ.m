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

%% load the GWF widefield
expNames = ["201910171412_Sim3WOptGWFOSSRMultiOb256"];
iterInd  = [0];
load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');

widefield = retVars{2};
widefieldNor = widefield./sum(widefield(:));
widefieldNor(widefieldNor < 0) = 0;
widefieldNor = widefieldNor/max(widefieldNor(:));

%% load the reconstruction results
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\MultiObXYZ\AutoReconstructionResult.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages+floor(NumberImages/2)*2,'uint16');
for i = 1:NumberImages
    reconOb(:,:,2*(i-1)+1) = imread(FileTif,'Index',i);
end
for i = 2:2:size(reconOb,3)
    if (i+1 <= size(reconOb,3))
        reconOb(:,:,i) = (reconOb(:,:,i-1) + reconOb(:,:,i+1))/2;
    else
        reconOb(:,:,i) = reconOb(:,:,i-1);
    end
end
reconOb    = double(reconOb);
reconObNor = reconOb./sum(reconOb(:));
reconObNor = reconObNor/max(reconObNor(:));
reconObNor = permute(reconObNor, [2, 1, 3]);

%%
OSSRPlotXYXZ(widefieldNor, reconObNor, yBest, zBest, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, colormapSet)