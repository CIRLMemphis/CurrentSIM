run("../../../CIRLSetup.m");
g = ReadTIF(char(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm.tif"), 3, 5);
slides = 1:13;
zBF    = 7;
g      = g(:,:,slides,:,:);
g      = g - min(g(:));

PSF  = fspecial('gaussian',20,50);
padG = zeros(612-80, 612-80, 19, size(g,4), size(g,5));
for l = 1:size(g,4)
    for k = 1:size(g,5)
        padG(:,:,:,l,k) = padarray(g(:,:,:,l,k),[10 10 3]);
        for zInd = 1:size(padG,3)
            padG(:,:,zInd,l,k) = edgetaper(padG(:,:,zInd,l,k), PSF);
        end
    end
end
g = padG;

save(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm_13PaddedSlices.mat", 'g');

%%
curSlice = g(:,:,zBF,:,:);
figure;imagesc(squeeze(curSlice(:,:,1,1,1))); axis square; colorbar;
figure;plot(curSlice(1+(612-80)/2,:,1,1,1));