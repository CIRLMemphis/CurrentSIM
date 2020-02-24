run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];
xzRegionX   = 257-100:257+99;
xzRegionZ   = 257-100:257+99;
xyRegionX   = 257-50 :257+49;
xyRegionY   = 257-50 :257+49;
yBest       = 257;
zBest       = 257;

%% load the reconstruction results
expNames = ["201912121420_Sim3WOptGWFOSSRMultiOb256SNR15dB",...
            "201911241138_Sim3WMBPCHotOSSRMultiOb256SNR15dBReg1e4",...
            "201912131513_SimTunable3SlitsMBPCHotOSSRMultiOb256Iter400Reg1e4"];
iterInd  = [0, 3, 5];
load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'uc', 'u', 'reconOb');

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
matFile = CIRLDataPath + "\Simulation\3W\Sim3WOSSRMultiOb512.mat";
load(matFile, 'ob');
HROb  = ob;
norOb = ob; % multi object is already on scale [0,1]

%% True Object
z2BF      = 1 + Z2/2;
y2BF      = 1 + Y2/2;
midOff    = 41;
midSlice  = y2BF-midOff-1:y2BF+midOff-1;
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

% the original object first
recVars{end+1} = HROb;

% add the widefield image
% load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
% recVars{end+1} = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);
% %recVars{end}   = recVars{end}./sum(recVars{end}(:))*sum(HROb(:));

%% add the 3D-MBPC, 3D-MBPCReg results
MSE  = zeros(length(expNames), 1);
SSIM = zeros(length(expNames), 1);
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)}./sum(retVars{iterInd(k)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["3W 3D-GWF", "3W MBPCReg1e4, 150Iter", "Tunable MBPCReg1e4, 250Iter"])


%%
MethodCompareFig = OSSRSubplotXY( recVars, z2BF, y2BF, ...
                                  ["True Object", "3W 3D-GWF", "3W MBPCReg1e4, 150Iter", "Tunable MBPCReg1e4, 250Iter"],...
                                  "Comparison of different methods for 15dB-noisy data",...
                                  colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
                              
MethodCompareFig = OSSRSubplotXZ( recVars, z2BF, y2BF, ...
                                  ["True Object", "3W 3D-GWF", "3W MBPCReg1e4, 150Iter", "Tunable MBPCReg1e4, 250Iter"],...
                                  "Comparison of different methods for 15dB-noisy data",...
                                  colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
%saveas(MethodCompareFig, "3W2P15dBBestMethodComparison.jpg");
