run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];

%% load the reconstruction results
expNames = ["201909131733_Sim3WMBHotMultiOb256SNR15dBIter200",...
            "201909142058_Sim3WMBDR7of15HotMultiOb256SNR15dBIter400", ...
            "201909142117_Sim3WMBDR5of15HotMultiOb256SNR15dBIter400"];
load(CIRLDataPath + "\Results\ISBI2020\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb');

%% load the original high resolution object
X2 = X;
Y2 = Y;
Z2 = Z;
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

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;
recVars{end+1} = HROb;
for k = 1:length(expNames)
    load(CIRLDataPath + "\Results\ISBI2020\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
    recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
end

MethodCompareFig = XYXZSubplot( recVars, z2BF, y2BF, ...
                                ["True Object", "15 of 15, 200 Iter", "7 of 15, 400 Iter", "5 of 15, 400 Iter"],...
                                "Model-based method with data reduction when SNR = 15dB",...
                                colormapSet, midSlice, colorScale);
saveas(MethodCompareFig, "3WMBDR15dBComparison.jpg");

%%
cnt    = 1;
titTxt = ["15of15", "7of15", "5of15"];
yScale = [0 1.2];
ProfileCompareFig = figure('Position', get(0, 'Screensize'));
MSE  = zeros(length(titTxt), 1);
SSIM = zeros(length(titTxt), 1);
for ind = 2:4
    norReconOb = recVars{ind};
    [ MSE(ind-1), SSIM(ind-1) ] = MSESSIM(norReconOb, norOb);
    subplot(3,2,cnt);
             plot(squeeze(norOb     (y2BF, :, z2BF)), 'DisplayName', 'True');
    hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', titTxt(ind-1));
    xlabel('x'); ylabel('Intensity'); ylim(yScale); legend;
    cnt = cnt + 1;

    subplot(3,2,cnt);
             plot(squeeze(norOb     (y2BF, y2BF-14, :)), 'DisplayName', 'True');
    hold on; plot(squeeze(norReconOb(y2BF, y2BF-14, :)), 'DisplayName', titTxt(ind-1));
    xlabel('z'); ylabel('Intensity'); ylim(yScale); legend;
    cnt = cnt + 1;
end
suptitle("x, z profiles of MB with data reduction when SNR = 15dB");
saveas(ProfileCompareFig, "3WMBDR15dBProfileComparison.jpg");
texRet = MSESSIMtoTex(MSE, SSIM, titTxt)