run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];

%% load the reconstruction results
expNames = ["201909121511_Sim3WGWFMultiOb256",...
            "201909121906_Sim3WMBHotMultiOb256Iter200", ...
            "201909122325_Sim3WMBPCHotMultiOb256Iter200", ...
            "201908280842_Sim3WGWFMultiOb256SNR15dB",...
            "201909131733_Sim3WMBHotMultiOb256SNR15dBIter200", ...
            "201909141259_Sim3WMBPCHotMultiOb256SNR15dBIter200"];
iterInd  = [0, 4, 3, 0, 2, 2];
load(CIRLDataPath + "\Results\ISBI2020\" + expNames(1) + "\" + expNames(1) + ".mat",...
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

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;
recVars{end+1} = HROb;
MSE  = zeros(length(expNames), 1);
SSIM = zeros(length(expNames), 1);
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\ISBI2020\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load(CIRLDataPath + "\Results\ISBI2020\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)}./sum(retVars{iterInd(k)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["GWF Noiseless", "MB Noiseless", "MBPC Noiseless", "GWF 15dB", "MB 15dB", "MBPC 15dB"])

MethodCompareFig = XYXZSubplot( recVars, z2BF, y2BF, ...
                                ["True Object", "GWF", "MB 200Iter", "MBPC 150Iter", "GWF 15dB", "MB 15dB, 100Iter", "MBPC 15dB, 100Iter"],...
                                "Comparison of different methods for noiseless and noisy data",...
                                colormapSet, midSlice, colorScale);
saveas(MethodCompareFig, "3WBestMethodComparison.jpg");

%% noiseless
cnt    = 1;
titTxt = ["GWF", "MB", "MBPC"];
yScale = [0 1.2];
ProfileCompareFig = figure('Position', get(0, 'Screensize'));
for ind = 2:4
    norReconOb = recVars{ind};
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
suptitle("x, z profiles of different methods for noiseless data");
saveas(ProfileCompareFig, "3WNoiselessBestMethodProfileComparison.jpg");

%% noisy
cnt    = 1;
titTxt = ["GWF", "MB", "MBPC"];
yScale = [0 1.2];
ProfileCompareFig = figure('Position', get(0, 'Screensize'));
for ind = 5:7
    norReconOb = recVars{ind};
    subplot(3,2,cnt);
             plot(squeeze(norOb     (y2BF, :, z2BF)), 'DisplayName', 'True');
    hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', titTxt(ind-4));
    xlabel('x'); ylabel('Intensity'); ylim(yScale); legend;
    cnt = cnt + 1;

    subplot(3,2,cnt);
             plot(squeeze(norOb     (y2BF, y2BF-14, :)), 'DisplayName', 'True');
    hold on; plot(squeeze(norReconOb(y2BF, y2BF-14, :)), 'DisplayName', titTxt(ind-4));
    xlabel('z'); ylabel('Intensity'); ylim(yScale); legend;
    cnt = cnt + 1;
end
suptitle("x, z profiles of different methods for noisy data");
saveas(ProfileCompareFig, "3W15dBBestMethodProfileComparison.jpg");