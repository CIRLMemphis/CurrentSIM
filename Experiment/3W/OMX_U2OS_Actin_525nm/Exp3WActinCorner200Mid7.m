run("../../../CIRLSetup.m");
g = ReadTIF(char(CIRLDataPath + "\FairSimData\OMX_U2OS_Actin_525nm.tif"), 3, 5);
slides = 1:12;
zBF    = 7;
corner = 1:200;
g      = g(corner, corner, slides, :,:);
save(CIRLDataPath + "\FairSimData\Corner200Mid7_OMX_U2OS_Actin_525nm.mat", 'g');

%%
curSlice = g(:,:,zBF,:,:);
figure;imagesc(squeeze(curSlice(:,:,1,1,1))); axis square; colorbar;
