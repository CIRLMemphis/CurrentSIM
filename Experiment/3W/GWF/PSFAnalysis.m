run("../OMX_LSEC_Actin_525nm/Exp3WLSECActinFullSetup.m");

%%
Z2   = 13;
dZ2  = dZ/2;
h    = PSFLutz(X, Z2, dXY, dZ2, psfpar);
[im, jm, Nn] = Pattern3W3D(X, Y, Z2, u, w, dXY, dZ2, phi, offs, theta, phizDeg);

%% analytic OTFs
hA = zeros(X, Y, Z2, 2);
hA(:,:,:,1) = h;
hA(:,:,:,2) = h.*im(:,:,:,1,1,3);
HA = zeros(X, Y, Z2, 2);
HA(:,:,:,1) = FT(h);
HA(:,:,:,2) = FT(hA(:,:,:,2));

%% FairSIM OTFs
load('FairSIMGreenLRHn_512_512_13.mat')
hnLR = zeros(size(Hn));
HnLR = Hn;
for k = 1:size(Hn, 4)
    hnLR(:,:,:,k) = IFT(Hn(:,:,:,k));
end

%%
load('FairSIMGreenHRHn_512_512_13.mat')
hnHR = zeros(size(Hn));
HnHR = Hn;
for k = 1:size(Hn, 4)
    hnHR(:,:,:,k) = IFT(Hn(:,:,:,k));
end

%%
indOTF = 1;
zBF = 7;
fh = figure();
fh.WindowState = 'maximized';
subplot(2,3,1); imagesc(log(abs(HA(:,:, zBF, indOTF))));             axis square; colorbar; xlabel('u');  ylabel('v'); title('analytic OTF 1');
subplot(2,3,2); imagesc(log(abs(HnLR(:,:, zBF, indOTF))));           axis square; colorbar; xlabel('u');  ylabel('v'); title('FairSIM OTF 1');
subplot(2,3,3); imagesc(log(abs(HnHR(:,:, zBF, indOTF))));           axis square; colorbar; xlabel('u');  ylabel('v'); title('upsampled FS OTF 1');
subplot(2,3,4); imagesc(squeeze(log(abs(HA(1+Y/2,:, :, indOTF))))'); axis square; colorbar; xlabel('u');  ylabel('w');
subplot(2,3,5); imagesc(squeeze(log(abs(HnLR(1+Y/2,:, :, 1))))');    axis square; colorbar; xlabel('u');  ylabel('w');
subplot(2,3,6); imagesc(squeeze(log(abs(HnHR(1+Y/2,:, :, 1))))');    axis square; colorbar; xlabel('u');  ylabel('w');
print(gcf,"OTFs1Compare.png",'-dpng','-r600');

%%
indOTF = 2;
zBF = 7;
fh = figure();
fh.WindowState = 'maximized';
subplot(2,3,1); imagesc(log(abs(HA(:,:, zBF, indOTF))));               axis square; colorbar; xlabel('u');  ylabel('v'); title('analytic OTF 2');
subplot(2,3,2); imagesc(log(abs(HnLR(:,:, zBF, indOTF))));             axis square; colorbar; xlabel('u');  ylabel('v'); title('FairSIM OTF 2');
subplot(2,3,3); imagesc(log(abs(HnHR(:,:, zBF, indOTF))));             axis square; colorbar; xlabel('u');  ylabel('v'); title('upsampled FS OTF 2');
subplot(2,3,4); imagesc(squeeze(log(abs(HA(1+Y/2,:, :, indOTF))))');   axis square; colorbar; xlabel('u');  ylabel('w');
subplot(2,3,5); imagesc(squeeze(log(abs(HnLR(1+Y/2,:, :, indOTF))))'); axis square; colorbar; xlabel('u');  ylabel('w');
subplot(2,3,6); imagesc(squeeze(log(abs(HnHR(1+Y/2,:, :, indOTF))))'); axis square; colorbar; xlabel('u');  ylabel('w');
print(gcf,"OTFs2Compare.png",'-dpng','-r600');

%%
indOTF = 1;
zBF = 7;
figure;
subplot(2,3,1); imagesc(log(abs(hA(:,:, zBF, indOTF))));               axis square;
subplot(2,3,2); imagesc(log(abs(hnLR(:,:, zBF, indOTF))));             axis square;
subplot(2,3,3); imagesc(log(abs(hnHR(:,:, zBF, indOTF))));             axis square;
subplot(2,3,4); imagesc(squeeze(log(abs(hA(1+Y/2,:, :, indOTF))))');   axis square;
subplot(2,3,5); imagesc(squeeze(log(abs(hnLR(1+Y/2,:, :, indOTF))))'); axis square;
subplot(2,3,6); imagesc(squeeze(log(abs(hnHR(1+Y/2,:, :, indOTF))))'); axis square;
suptitle('PSFs comparison at middle z')