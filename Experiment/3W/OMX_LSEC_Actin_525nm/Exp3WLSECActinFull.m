run("../../../CIRLSetup.m");
g = ReadTIF(char(CIRLDataPath + "/FairSimData/OMX_LSEC_Actin_525nm.tif"), 3, 5);
background = 85;
g = g - background;

slides = 1:size(g,3);
zBF    = 5;
g      = g(:,:,slides,:,:);
[Y, X, Z, Nthe, Nphi] = size(g);
for zInd = 1:Z
    for l = 1:Nthe
        for k = 1:Nphi
            g(:,:,zInd,l,k) = fadeBorderCos(g(:,:,zInd,l,k), 15);
        end
    end
end
save(CIRLDataPath + "/FairSimData/OMX_LSEC_Actin_525nm.mat", 'g');

%%
curSlice = g(:,:,zBF,:,:);
figure;imagesc(squeeze(curSlice(512-128:512,1:128,1,3,1))); axis square; colorbar;