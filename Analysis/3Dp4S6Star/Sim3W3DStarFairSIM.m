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
expNames = ["202005152310_Sim3WOpt1e3GWF3Dp4S6Star256SNR15dB"];
iterInd  = [0];
load(CIRLDataPath + "\Results\3Dp4S6Star\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'uc', 'u', 'retVars');

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
ob = StarLikeSample(3,512,6,20,3,0.6);
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
load(CIRLDataPath + "\Results\3Dp4S6Star\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
reconOb        = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

% add the deconvolved widefield image
reconOb        = retVars{end-1};
reconOb(reconOb < 0) = 0;
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

%% add the 2D-GWF restored image using FairSIM with attenuation
for i = [30:-10:10]
    if (i >= 10)
        FileTif      = char("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\3Dp4S6Star\FairSIM_SNRresult_p" + i + "_ap99.tif");
    else
        FileTif      = char("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\3Dp4S6Star\FairSIM_SNRresult_p0" + i + "_ap99.tif");
    end
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
    reconObNor = reconOb./sum(reconOb(:))*sum(HROb(:));
    reconObNor = permute(reconObNor, [2, 1, 3]);
    recVars{end+1} = reconObNor;
end

%% add the 2D-GWF restored image using FairSIM with attenuation
for i = [97, 95]
    FileTif      = char("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\3Dp4S6Star\FairSIM_SNRresult_p10_ap"+i+".tif");
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
    reconObNor = reconOb./sum(reconOb(:))*sum(HROb(:));
    reconObNor = permute(reconObNor, [2, 1, 3]);
    recVars{end+1} = reconObNor;
end


%% add the 3D-GWF, 3D-MB, 3D-MBPC results
MSE  = zeros(length(recVars)-3, 1);
SSIM = zeros(length(recVars)-3, 1);
for k = 1:length(recVars)-3
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{3+k}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["FairSIM 3e-1, a 0.99", "FairSIM 2e-1, a 0.99", "FairSIM 1e-1, a 0.99", "FairSIM 1e-1, a 0.97", "FairSIM 1e-1, a 0.95", "FairSIM 4e-2"])

%%
colormapSet = 'gray';
MethodCompareFig = FairSIMSubplot(  recVars, z2BF, y2BF, ...
                                    ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                    ["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM 3e-1, a 0.99", "FairSIM 2e-1, a 0.99", "FairSIM 1e-1, a 0.99", "FairSIM 1e-1, a 0.97", "FairSIM 1e-1, a 0.95"],...
                                    [],...
                                    colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
saveas(MethodCompareFig, "3W2P15dBBestMethodComparison.jpg");
