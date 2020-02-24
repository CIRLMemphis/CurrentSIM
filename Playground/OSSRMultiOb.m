%% load the original high resolution object
factr = 1;
X     = 256*factr;
Y     = 256*factr;
Z     = 256*factr;
dXY   = 0.025/factr;
dZ    = 0.025/factr;
SSROb = OSSRMultiObject(X, Z, dXY, dZ);
figure;
subplot(1,2,1); imagesc(SSROb(:,:,Z/2)); axis square;
subplot(1,2,2); imagesc(squeeze(SSROb(Y/2,:,:))'); axis square;
figure; plot(SSROb(Y/2, :, Z/2));