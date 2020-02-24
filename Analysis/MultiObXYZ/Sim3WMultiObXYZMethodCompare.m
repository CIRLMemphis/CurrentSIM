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
expNames = ["201910071747_Sim3WOptGWFMultiObXYZ256",...
            "201910180011_Sim3WMBHotMultiObXYZ256Iter200",...
            "201910172132_Sim3WMBPCHotMultiObXYZ256Iter200"];
iterInd  = [0, 3, 2];
load(CIRLDataPath + "\Results\MultiObXYZ\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'uc', 'u', 'reconOb');

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
matFile = CIRLDataPath + "\Simulation\3W\Sim3WMultiObXYZ512.mat";
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

% the original object first
recVars{end+1} = HROb;

% add the widefield image
load(CIRLDataPath + "\Results\MultiObXYZ\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
recVars{end+1} = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);
recVars{end}   = recVars{end}./sum(recVars{end}(:))*sum(HROb(:));

% add the 2D-GWF restored image
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\MultiObXYZ\AutoReconstructionResult.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages+floor(NumberImages/2)*2,'uint16');
for i = 1:NumberImages
    reconOb(:,:,2*(i-1)+1) = imread(FileTif,'Index',i);
end
for i = 2:2:size(reconOb,3)
    if (i+1 <= size(reconOb,3))
        reconOb(:,:,i) = (reconOb(:,:,i-1) + reconOb(:,:,i+1))/2;
    else
        reconOb(:,:,i) = reconOb(:,:,i-1);
    end
end
reconOb    = double(reconOb);
reconObNor = reconOb./sum(reconOb(:));
reconObNor = reconObNor/max(reconObNor(:));
reconObNor = permute(reconObNor, [2, 1, 3]);
recVars{end+1} = reconObNor;
recVars{end}   = recVars{end}./sum(recVars{end}(:))*sum(HROb(:));


MSE  = zeros(length(expNames), 1);
SSIM = zeros(length(expNames), 1);
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\MultiObXYZ\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load(CIRLDataPath + "\Results\MultiObXYZ\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)}./sum(retVars{iterInd(k)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["GWF 15dB", "MB 15dB", "MBPC 15dB"])

MethodCompareFig = OSSRSubplot( recVars, z2BF, y2BF, ...
                                ["True Object", "Widefield", "2D-GWF", "GWF", "MB, 150 Iter", "MBPC, 100Iter"],...
                                "Comparison of different methods for noiseless data",...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
saveas(MethodCompareFig, "3W2P15dBBestMethodComparison.jpg");

%% noisy
cnt    = 1;
titTxt = ["GWF", "MB", "MBPC"];
colTxt = ["green", "blue", "red"];
yScale = [0 1.2];

ProfileCompareFig = figure('Position', get(0, 'Screensize'));
[scale01, scaleMicron] = Pixel2Micron(X2, dXY/2);
subplot(2,1,1);
plot(squeeze(norOb(y2BF, :, z2BF)), 'DisplayName', 'Truth', 'LineWidth', 2, 'color','black');
for ind = 4:6
    norReconOb = recVars{ind};
    hold on; plot(squeeze(norReconOb(y2BF, :, z2BF)), 'DisplayName', titTxt(ind-3), 'LineWidth', 2, 'color', colTxt(ind-3));
end
xlabel('x (\mum)'); ylabel('Intensity (a.u.)'); ylim(yScale);xlim([X2/2-4/dXY, X2/2+4/dXY]);
set(gca,'XTick',scale01);
set(gca,'XTickLabel',scaleMicron);
set(gca,'DataAspectRatio',[133 1 1])
set(gca,'FontSize',18)

%ProfileCompareFig = figure('Position', get(0, 'Screensize'));
subplot(2,1,2);
plot(squeeze(norOb(y2BF, y2BF-14, :)), 'DisplayName', 'Truth', 'LineWidth', 2, 'color','black');
for ind = 4:6
    norReconOb = recVars{ind};
    hold on; plot(squeeze(norReconOb(y2BF, y2BF-14, :)), 'DisplayName', titTxt(ind-3), 'LineWidth', 2, 'color', colTxt(ind-3));
end
%suptitle("x, z profiles of different methods for noisy data");
xlabel('z (\mum)'); ylabel('Intensity (a.u.)'); ylim(yScale); xlim([X2/2-4/dXY, X2/2+4/dXY]);
set(gca,'XTick',scale01);
set(gca,'XTickLabel',scaleMicron);
set(gca,'DataAspectRatio',[133 1 1])
set(gca,'FontSize',18)

legend('location','northoutside','orientation','horizontal')
saveas(ProfileCompareFig, "3W2P15dBBestMethodProfileComparison.jpg");

% %% add the forward image
% load(CIRLDataPath + "\Results\MultiObXYZ\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
% recVars{end+1} = g(:,:,:,lThe,kPhi);
% recVars{end}   = recVars{end}./sum(recVars{end}(:))*sum(HROb(:));
% 
% %% export separate pictures for publication
% midOff   = 41;
% midSlice = y2BF-midOff-1:y2BF+midOff-1;
% MethodCompareFig = QBIXYXZSubplot(  recVars, z2BF, y2BF, ...
%                                     [],...
%                                     [],...
%                                     colormapSet, midSlice, colorScale);