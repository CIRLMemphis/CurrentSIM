run("../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];

%% load the reconstruction results
expName = '201908191954_SimTunableMBPCMultiOb256Iter200';
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

%% Forward images
zBF        = 1 + Z/2;
yBF        = 1 + Y/2;
% forVars    = {};
% lThe       = 1;
% for k = 1:3
%     forVars{end+1} = g(:,:,:,lThe,k);
% end
% ForwardFig = XYXZSubplot(forVars, zBF, yBF, ...
%                          ["1", "2", "3", "4", "5"],...
%                          "Forward image for orientation 0", colormapSet);
% saveas(ForwardFig, "TunableForwardImage.jpg");

%% load MB middle steps
vars = [{norOb}, retVars];
for k = 1:length(vars)
    vars{k} = vars{k}./sum(vars{k}(:))*sum(HROb(:));
end
TruevsIterFig = XYXZSubplot(vars, z2BF, y2BF, ...
                            ["True Object", "50 Iter", "100 Iter", "150 Iter", "200 Iter"],...
                            "MBPC different iterations", colormapSet, midSlice);
saveas(TruevsIterFig, "TunableMBPCTruevsIterIter200.jpg");


%% compare original ob vs MB results
norReconOb = reconOb./sum(reconOb(:))*sum(HROb(:));
norReconOb(norReconOb < 0) = 0;

TrueVsGWF = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(3,3,[.01 0.0],[.01 .03],[.01 .01]);
axes(ha(1));
imagesc(norOb(:,:,z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('y'); title('True Object'); caxis(colorScale);
axes(ha(2));
imagesc(norReconOb(:,:,z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('y'); title('MBPC'); caxis(colorScale);
subplot(3,3,3); 
         plot(squeeze(norOb     (y2BF, :, z2BF)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', 'MBPC'); caxis([0 1]);
xlabel('x'); ylabel('Intensity'); legend;

axes(ha(4));
imagesc(squeeze(norOb(y2BF,:,:))'); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
axes(ha(5));
imagesc(squeeze(norReconOb(y2BF,:,:))'); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
subplot(3,3,6); 
         plot(squeeze(norOb     (y2BF, y2BF-12, :)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, y2BF-12, :)), 'DisplayName', 'MBPC');
xlabel('z'); ylabel('Intensity'); legend;

axes(ha(7));
imagesc(norOb(midSlice, midSlice, z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
axes(ha(8));
imagesc(norReconOb(midSlice, midSlice, z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
subplot(3,3,9);

suptitle('Comparison of the true object and MBPC reconstructed image');

saveas(TrueVsGWF, "TunableTrueVsMBPCIter200.jpg");

[ MSE, SSIM ] = MSESSIM(norReconOb, norOb)