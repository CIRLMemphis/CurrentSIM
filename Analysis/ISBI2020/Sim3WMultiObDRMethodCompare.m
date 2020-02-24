run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];

%% load the reconstruction results
expNames = ["201909121906_Sim3WMBHotMultiOb256Iter200", ...
            "201909131311_Sim3WMBDR7of15HotMultiOb256Iter400", ...
            "201909131643_Sim3WMBDR5of15HotMultiOb256Iter400", ...
            "201909122325_Sim3WMBPCHotMultiOb256Iter200", ...
            "201909140832_Sim3WMBPCDR7of15HotMultiOb256Iter400", ...
            "201909140837_Sim3WMBPCDR5of15HotMultiOb256Iter400"];
iterInd  = [3, 2, 2, 3, 2, 2];
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
texRet = MSESSIMtoTex(MSE, SSIM, ["MB 15of15", "MB 7of15", "MB 5of15", "MBPC 15of15", "MBPC 7of15", "MBPC 5of15"])

MethodCompareFig = XYXZSubplot( recVars, z2BF, y2BF, ...
                                ["True Object", "MB 15of15", "MB 7of15", "MB 5of15", "MBPC 15of15", "MBPC 7of15", "MBPC 5of15"],...
                                "Comparison of MB and MBPC methods with data reduction for noisy data",...
                                colormapSet, midSlice, colorScale);
saveas(MethodCompareFig, "3WDRMethodComparison.jpg");