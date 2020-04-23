run("../../../CIRLSetup.m");
g = ReadTIF(char(CIRLDataPath + "/FairSimData/OMX_U2OS_Mitotracker_600nm.tif"), 3, 5);
background = 90;
g = g - background;

slides = 1:size(g,3);
zBF    = 6;
g      = g(:,:,slides,:,:);
[Y, X, Z, Nthe, Nphi] = size(g);
for zInd = 1:Z
    for l = 1:Nthe
        for k = 1:Nphi
            g(:,:,zInd,l,k) = fadeBorderCos(g(:,:,zInd,l,k), 15);
        end
    end
end
save(CIRLDataPath + "/FairSimData/OMX_U2OS_Mitotracker_600nm.mat", 'g');

%%
curSlice = g(:,:,zBF,:,:);
figure;imagesc(squeeze(curSlice(:,:,1,1,1))); axis square; colorbar;