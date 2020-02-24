run("../../../CIRLSetup.m");
g = ReadTIF(char(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm.tif"), 3, 5);
slides = 1:13;
zBF    = 7;
g      = g(:,:,slides,:,:);
save(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm_13Slices.mat", 'g');

%%
curSlice = g(:,:,zBF,:,:);
figure;imagesc(squeeze(curSlice(:,:,1,1,1))); axis square; colorbar;
