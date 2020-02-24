run("../../../../CIRLSetup.m");
g         = ReadTIF(char(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm.tif"), 3, 5);
xyRegionX =   1:128;
%xyRegionY =   512-127:512;
xyRegionY =   1:128;
g         = g(xyRegionY, xyRegionX, :,:,:);
[Y, X, Z, Nthe, Nphi] = size(g);
for zInd = 1:Z
    for l = 1:Nthe
        for k = 1:Nphi
            g(:,:,zInd,l,k) = fadeBorderCos(g(:,:,zInd,l,k), 15);
        end
    end
end
save(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm_Corner128.mat", 'g');

%%
curSlice = g(:,:,7,:,:);
figure;imagesc(squeeze(curSlice(:,:,1,1,1))); axis square; colorbar;