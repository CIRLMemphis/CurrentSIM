run("../../../CIRLSetup.m");
load(CIRLDataPath + "\Simulation\3W\Sim3WMultiOb2P256.mat");

%%
init5 = g(:,:,:,1,1) + g(:,:,:,1,2) + g(:,:,:,1,3) + g(:,:,:,1,4) + g(:,:,:,1,5);
init3 = g(:,:,:,1,1) + g(:,:,:,1,2) + g(:,:,:,1,3);

figure;
subplot(1,2,1); imagesc(init5(:,:,1+size(g,3)/2)); axis square; xlabel('x'); ylabel('y');
subplot(1,2,2); imagesc(init3(:,:,1+size(g,3)/2)); axis square; xlabel('x'); ylabel('y');
suptitle("init guess of 7 and 5 out of 15");

[MSE, SSIM] = MSESSIM(init5, init3)

%%
init5FT = log(abs(FT(init5)));
init3FT = log(abs(FT(init3)));
figure;
subplot(1,2,1); imagesc(init5FT(:,:,1+size(g,3)/2)); axis square; xlabel('x'); ylabel('y');
subplot(1,2,2); imagesc(init3FT(:,:,1+size(g,3)/2)); axis square; xlabel('x'); ylabel('y');
suptitle("init guess of 7 and 5 out of 15");