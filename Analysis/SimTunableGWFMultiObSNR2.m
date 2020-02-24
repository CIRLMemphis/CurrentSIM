run("../CIRLSetup.m");
colormapSet = 'jet';

%% load the reconstruction results
expName = '201908211719_SimTunableGWFMultiOb256SNR2';
load(CIRLDataPath + "\Results\" + expName + "\" + expName + ".mat");

%% remove the negative values of the reconOb
reconOb(reconOb < 0) = 0;

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
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

%% Forward images
zBF        = 1 + Z/2;
yBF        = 1 + Y/2;
ct         = 0;
ForwardFig = figure('Position', get(0, 'Screensize'));
for k = 1:Nphi
    ct = ct + 1;
    subplot(2,Nphi,ct); 
    imagesc(g(:,:,zBF,1,k)); axis square; colormap(colormapSet); colorbar;
    xlabel('x'); ylabel('y'); title("Phase " + num2str(k));
end
for k = 1:Nphi
    ct = ct + 1;
    subplot(2,Nphi,ct);
    imagesc(squeeze(g(yBF,:,:,1,k))'); axis square; colormap(colormapSet); colorbar;
    xlabel('x'); ylabel('z');
end
suptitle('Forward image for orientation 0');
saveas(ForwardFig, "TunableSNR2ForwardImage.jpg");

%% load GWF middle steps
OTF    = retVars{1};
DeComp = retVars{2};
Denom  = retVars{3};
DeConv = retVars{4};
AD     = retVars{5};
DeCoAD = retVars{6};
WF     = retVars{7};

%% compare original ob vs GWF results
norOb      = HROb./max(HROb(:));
norReconOb = reconOb./max(reconOb(:));

TrueVsGWF = figure('Position', get(0, 'Screensize'));
subplot(3,3,1); 
imagesc(norOb(:,:,z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title('True Object'); caxis([0 1]);
subplot(3,3,2); 
imagesc(norReconOb(:,:,z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title('GWF SNR2'); caxis([0 1]);
subplot(3,3,3); 
         plot(squeeze(norOb     (y2BF, :, z2BF)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', 'SNR2'); caxis([0 1]);
xlabel('x'); ylabel('Intensity'); legend;

subplot(3,3,4);
imagesc(squeeze(norOb(y2BF,:,:))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); caxis([0 1]);
subplot(3,3,5);
imagesc(squeeze(norReconOb(y2BF,:,:))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); caxis([0 1]);
subplot(3,3,6); 
         plot(squeeze(norOb     (y2BF, y2BF-12, :)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, y2BF-12, :)), 'DisplayName', 'SNR2');
xlabel('z'); ylabel('Intensity'); legend;

subplot(3,3,7);
imagesc(norOb(midSlice, midSlice, z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); title('Zoomed-in middle');
subplot(3,3,8);
imagesc(norReconOb(midSlice, midSlice, z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); title('Zoomed-in middle'); caxis([0 1]);

suptitle('Comparison of the true object and GWF SNR2 reconstructed image');

saveas(TrueVsGWF, "TunableSNR2TrueVsGWF.jpg");

[ MSE, SSIM ] = MSESSIM(norReconOb, norOb)