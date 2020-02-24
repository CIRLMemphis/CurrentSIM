run("../../../CIRLSetup.m");
g = ReadTIF(char(CIRLDataPath + "\FairSimData\OMX_U2OS_Actin_525nm.tif"), 3, 5);
slides = 1:size(g,3)-1;
zBF    = 7;
corner = 51:150;
g      = g(corner, corner, slides, :, :);
save(CIRLDataPath + "\FairSimData\Corner100OMX_U2OS_Actin_525nm.mat", 'g');

%%
curSlice = g(:,:,zBF,:,:);
figure;imagesc(squeeze(curSlice(:,:,1,1,1))); axis square; colorbar;
