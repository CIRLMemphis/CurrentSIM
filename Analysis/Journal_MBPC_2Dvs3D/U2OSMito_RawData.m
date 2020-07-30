clear
load("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData/FairSimData/OMX_U2OS_Mitotracker_600nm.mat", 'g');
figure;
subplot(231); imagesc(squeeze(g(:,:,7,1,1))); axis square off; colormap hot;
subplot(232); imagesc(squeeze(g(:,:,7,2,1))); axis square off; colormap hot;
subplot(233); imagesc(squeeze(g(:,:,7,3,1))); axis square off; colormap hot;
subplot(234); imagesc(squeeze(g(100:128+100,1:128,7,1,1))); axis square off; colormap hot;
subplot(235); imagesc(squeeze(g(100:128+100,1:128,7,2,1))); axis square off; colormap hot;
subplot(236); imagesc(squeeze(g(100:128+100,1:128,7,3,1))); axis square off; colormap hot;