run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];
xzRegionX   = 257-100:257+99;
xzRegionZ   = 257-100:257+99;
xyRegionX   = 257-50 :257+49;
xyRegionY   = 257-50 :257+49;
yBest       = 257;
zBest       = 257;

%% load the original high resolution object
matFile = CIRLDataPath + "\Simulation\3W\Sim3WMultiOb2P512.mat";
load(matFile, 'ob');
HROb  = ob;
norOb = HROb; % multi object is already on scale [0,1]

%%
CIRLDataPath = "E:\Cong\Data";

%% load the reconstruction results
expNames = ["201908211719_SimTunableGWFMultiOb256SNR2",...
            "201908232115_SimTunableMBMultiOb256SNR2Iter200",...
            "201908240025_SimTunableMBPCMultiOb256SNR2Iter200" ];
load(CIRLDataPath + "/Results/" + expNames(1) + "/" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ');
iterInd  = [0, 4, 4];

X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;

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

%% add the 3D-MB, 3D-MBPC results
MSE  = zeros(length(expNames), 1);
SSIM = zeros(length(expNames), 1);
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "/Results/" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load(CIRLDataPath + "/Results/" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)}./sum(retVars{iterInd(k)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["3D-GWF", "MB, 200Iter", "MBPC 200Iter"])


%%
MethodCompareFig = OSSRSubplotXY( recVars, z2BF, y2BF, ...
                                  ["True Object", "3D-GWF", "MB, 200Iter", "MBPC 200Iter"],...
                                  "Comparison of different methods for 15dB-noisy simulated data of Tunable system",...
                                  colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
                              
MethodCompareFig = OSSRSubplotXZ( recVars, z2BF, y2BF, ...
                                  ["True Object", "3D-GWF", "MB, 200Iter", "MBPC 200Iter"],...
                                  "Comparison of different methods for 15dB-noisy simulated data of Tunable system",...
                                  colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
print(gcf,"Tunable2P15dBBestMethodComparison.png",'-dpng','-r300');

%% plot raw images and widefield
load(CIRLDataPath + "/Results/" + expNames(1) + "/" + expNames(1) + ".mat", 'g');
rawImgs    = {};
rawImgs{1} = g(:,:,:,1,1);
rawImgs{2} = g(:,:,:,1,2);
rawImgs{3} = g(:,:,:,1,3);
rawImgs{4} = sum(g(:,:,:,1,:),5);

%%
MethodCompareFig = QBISubplotXYXZ(rawImgs, z2BF, y2BF, ...
                                  ["\phi = 0", "\phi = 120^o", "\phi = 240^o", "Widefield"],...
                                  "3 out of 3 raw images and widefield",...
                                  colormapSet, colorScale);

%% export separate pictures for publication
midOff   = 41;
midSlice = y2BF-midOff-1:y2BF+midOff-1;
MethodCompareFig = QBIXYXZSubplot(  recVars, z2BF, y2BF, ...
                                    [],...
                                    [],...
                                    colormapSet, midSlice, colorScale);

%% different number of iterations
% load(CIRLDataPath + "/Results/" + expNames(3) + "/" + expNames(3) + ".mat", 'retVars');
% 
% %%
% cnt    = 1;
% titTxt = ["50 Iter", "100 Iter", "150 Iter", "200 Iter"];
% yScale = [0 1.2];
% ProfileCompareFig = figure('Position', get(0, 'Screensize'));
% MSE  = zeros(length(titTxt), 1);
% SSIM = zeros(length(titTxt), 1);
% for ind = 1:4
%     norReconOb = retVars{ind};
%     norReconOb = norReconOb./sum(norReconOb(:))*sum(HROb(:));
%     norReconOb(norReconOb < 0) = 0;
%     [ MSE(ind), SSIM(ind) ] = MSESSIM(norReconOb, HROb);
%     subplot(4,2,cnt);
%              plot(squeeze(HROb      (y2BF, :, z2BF)), 'DisplayName', 'True');
%     hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', titTxt(ind));
%     xlabel('x'); ylabel('Intensity'); ylim(yScale); legend;
%     cnt = cnt + 1;
% 
%     subplot(4,2,cnt);
%              plot(squeeze(HROb      (y2BF, y2BF-14, :)), 'DisplayName', 'True');
%     hold on; plot(squeeze(norReconOb(y2BF, y2BF-14, :)), 'DisplayName', titTxt(ind));
%     xlabel('z'); ylabel('Intensity'); ylim(yScale); legend;
%     cnt = cnt + 1;
% end
% suptitle("x, z profiles of different iterations for MBPC method of noisy data.");
% texRet = MSESSIMtoTex(MSE, SSIM, titTxt)