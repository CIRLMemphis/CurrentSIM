run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];
yScale      = [0 1.2];

%% load the reconstruction results
expName = '201909121511_Sim3WGWFMultiOb256';
load(CIRLDataPath + "\Results\ISBI2020\" + expName + "\" + expName + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb');

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
matFile = CIRLDataPath + "\Simulation\3W\Sim3WMultiOb512.mat";
load(matFile, 'ob');
HROb  = ob;
norOb = ob; % multi object is already on scale [0,1]

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
% ct         = 0;
% ForwardFig = figure('Position', get(0, 'Screensize'));
% for k = 1:Nphi
%     ct = ct + 1;
%     subplot(2,Nphi,ct); 
%     imagesc(g(:,:,zBF,1,k)); axis square; colormap(colormapSet); colorbar;
%     xlabel('x'); ylabel('y'); title("Phase " + num2str(k));
% end
% for k = 1:Nphi
%     ct = ct + 1;
%     subplot(2,Nphi,ct);
%     imagesc(squeeze(g(yBF,:,:,1,k))'); axis square; colormap(colormapSet); colorbar;
%     xlabel('x'); ylabel('z');
% end
% suptitle('Forward image for orientation 0');
% saveas(ForwardFig, "3WForwardImage.jpg");

%% load GWF middle steps
% OTF    = retVars{1};
% DeComp = retVars{2};
% Denom  = retVars{3};
% DeConv = retVars{4};
% AD     = retVars{5};
% DeCoAD = retVars{6};
% WF     = retVars{7};

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
xlabel('x'); ylabel('y'); title('GWF'); caxis(colorScale);
subplot(3,3,3); 
         plot(squeeze(norOb     (y2BF, :, z2BF)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', 'GWF');
xlabel('x'); ylabel('Intensity'); ylim(yScale); legend;

axes(ha(4));
imagesc(squeeze(norOb(y2BF,:,:))'); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
axes(ha(5));
imagesc(squeeze(norReconOb(y2BF,:,:))'); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
subplot(3,3,6); 
         plot(squeeze(norOb     (y2BF, y2BF-14, :)), 'DisplayName', 'True');
hold on; plot(squeeze(norReconOb(y2BF, y2BF-14, :)), 'DisplayName', 'GWF');
xlabel('z'); ylabel('Intensity'); ylim(yScale); legend;

axes(ha(7));
imagesc(norOb(midSlice, midSlice, z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
axes(ha(8));
imagesc(norReconOb(midSlice, midSlice, z2BF)); axis square off; colormap(colormapSet);
xlabel('x'); ylabel('z'); caxis(colorScale);
subplot(3,3,9);

suptitle('Comparison of the true object and GWF reconstructed image');

saveas(TrueVsGWF, "3WTrueVsGWF.jpg");

[ MSE, SSIM ] = MSESSIM(norReconOb, norOb)