run("../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];

%% load the reconstruction results
expName = '201908231109_SimTunableMBMultiOb256Iter1000';
load(CIRLDataPath + "\Results\" + expName + "\" + expName + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'retVars');

%% load the original high resolution object
X2 = X;
Y2 = Y;
Z2 = Z;
X = X/2;
Y = Y/2;
Z = Z/2;
dXY = dXY*2;
dZ  = dZ *2;
HROb  = MultiObject(X*2, Z*2, dXY/2, dZ/2);
norOb = HROb;

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

%% load MB middle steps
vars = [{norOb}, retVars];
for k = 1:length(vars)
    vars{k} = vars{k}./sum(vars{k}(:))*sum(HROb(:));
end
TruevsIterFig = XYXZSubplot(vars, z2BF, y2BF, ...
                            ["True Object", "200 Iter", "400 Iter", "600 Iter", "800 Iter", "1000 Iter"],...
                            "MB different iterations", colormapSet, midSlice, colorScale);
saveas(TruevsIterFig, "TunableMBTruevsIterIter1000.jpg");


%% compare original ob vs GWF results
norReconOb = reconOb./sum(reconOb(:))*sum(HROb(:));
norReconOb(norReconOb < 0) = 0;

TrueVsGWF = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(3,3,[.01 0.0],[.01 .03],[.01 .01]);
axes(ha(1));
imagesc(norOb(:,:,z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('y'); title('True Object'); caxis(colorScale);
axes(ha(2));
imagesc(norReconOb(:,:,z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('y'); title('MB'); caxis(colorScale);
subplot(3,3,3); 
         plot(squeeze(norOb     (y2BF, :, z2BF)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', 'MB'); caxis(colorScale);
xlabel('x'); ylabel('Intensity'); legend;

axes(ha(4));
imagesc(squeeze(norOb(y2BF,:,:))'); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
axes(ha(5));
imagesc(squeeze(norReconOb(y2BF,:,:))'); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
subplot(3,3,6); 
         plot(squeeze(norOb     (y2BF, y2BF-12, :)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, y2BF-12, :)), 'DisplayName', 'MB');
xlabel('z'); ylabel('Intensity'); caxis(colorScale); legend;

axes(ha(7));
imagesc(norOb(midSlice, midSlice, z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
axes(ha(8));
imagesc(norReconOb(midSlice, midSlice, z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
subplot(3,3,9);

suptitle('Comparison of the true object and MB reconstructed image after 1000 iterations');

saveas(TrueVsGWF, "TunableTrueVsMBIter1000.jpg");

[ MSE, SSIM ] = MSESSIM(norReconOb, norOb)