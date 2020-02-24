run("../CIRLSetup.m");
colormapSet = 'gray';

%% load the reconstruction results
expName = '201908191004_SimTunableMBMultiOb256Iter400';
load(CIRLDataPath + "\Results\" + expName + "\" + expName + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb');
 
%% remove the negative values of the reconOb
% reconOb(reconOb < 0) = 0;

%% load the original high resolution object
X2 = X;
Y2 = Y;
Z2 = Z;
X = X/2;
Y = Y/2;
Z = Z/2;
dXY = dXY*2;
dZ  = dZ *2;
HROb = MultiObject(X*2, Z*2, dXY/2, dZ/2);

%% True Object
z2BF      = 1 + Z2/2;
y2BF      = 1 + Y2/2;
midOff   = 41;
midSlice = y2BF-midOff-1:y2BF+midOff-1;
TrueObFig = figure('Position', get(0, 'Screensize'));
subplot(3,1,1); 
imagesc(HROb(:,:,z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title('True Object');
subplot(3,1,2);
imagesc(squeeze(HROb(y2BF,:,:))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z');
subplot(3,1,3);
imagesc(HROb(midSlice, midSlice, z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); title('Zoomed-in middle');
saveas(TrueObFig, "TrueObject.jpg");

%% compare original ob vs GWF results
norOb      = HROb;
norReconOb = reconOb./sum(reconOb(:))*sum(HROb(:));

TrueVsGWF = figure('Position', get(0, 'Screensize'));
subplot(3,3,1); 
imagesc(norOb(:,:,z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title('True Object'); caxis([0 1]);
subplot(3,3,2); 
imagesc(norReconOb(:,:,z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title('MB'); caxis([0 1]);
subplot(3,3,3); 
         plot(squeeze(norOb     (y2BF, :, z2BF)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', 'MB'); caxis([0 1]);
xlabel('x'); ylabel('Intensity'); legend;

subplot(3,3,4);
imagesc(squeeze(norOb(y2BF,:,:))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); caxis([0 1]);
subplot(3,3,5);
imagesc(squeeze(norReconOb(y2BF,:,:))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); caxis([0 1]);
subplot(3,3,6); 
         plot(squeeze(norOb     (y2BF, y2BF-12, :)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, y2BF-12, :)), 'DisplayName', 'MB');
xlabel('z'); ylabel('Intensity'); legend;

subplot(3,3,7);
imagesc(norOb(midSlice, midSlice, z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); title('Zoomed-in middle');
subplot(3,3,8);
imagesc(norReconOb(midSlice, midSlice, z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); title('Zoomed-in middle'); caxis([0 1]);

suptitle('Comparison of the true object and MB reconstructed image');

saveas(TrueVsGWF, "TunableTrueVsMBIter400.jpg");

[ MSE, SSIM ] = MSESSIM(norReconOb, norOb)