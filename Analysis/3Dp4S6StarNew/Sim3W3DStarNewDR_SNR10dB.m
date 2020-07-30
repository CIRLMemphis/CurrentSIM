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
% expNames = ["202005291428_Sim3WOpt5e4GWF3Dp4S6Star256SNR20dB",...
%             "202005152310_Sim3WOpt1e3GWF3Dp4S6Star256SNR15dB", ...
%             "202005271418_Sim3WOpt1e2GWF3Dp4S6Star256SNR10dB", ...
%             "20200529204406_SNR20", ...
%             "20200529204348_SNR15", ...
%             "20200529204346_SNR10"];
expNames = ["202006252112_Sim3WOpt1e2GWF3Dp4S6StarNew256SNR10dB", ...
            "202007092052_Sim3WMBPCDRWF3of15Hot3Dp4S6StarNew256SNR10dBIter400", ...
            "20200708090421_DR7_SNR10dB", ...
            "202007051818_Sim3WMBPCHot3Dp4S6StarNew256SNR10dBReg1e5Iter300", ...
            ];
% iterInd  = [0, 0, 0, 4, 4, 2];
iterInd  = [0, 2, 2, 2];
load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(1) + "\" + expNames(1) + ".mat",...
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

% add the deconvolved widefield image
reconOb        = retVars{end-1};
reconOb(reconOb < 0) = 0;
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

%% add the 3D-GWF, 3D-MB, 3D-MBPC results
MSE  = zeros(length(expNames), 1);
SSIM = zeros(length(expNames), 1);
for k = 1:length(expNames)-1
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(k+1) + "\" + expNames(k+1) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(k+1) + "\" + expNames(k+1) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k+1)}./sum(retVars{iterInd(k+1)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["MBPC WF3 15dB, Iter300", "MBPC DR7 15dB, Iter300", "MBPC 15dB, Iter300", ""])

%%
colormapSet = 'gray';
MethodCompareFig = DRStarNewSubplot(...
                                recVars, z2BF, y2BF, ...
                                ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                ["True Object", "3D-GWF Deconvolved WF", "MBPC 3SIM+WF 10dB, Iter200", "MBPC 7SIM 10dB, Iter200", "MBPC 15SIM 10dB, Iter200"],...
                                [],...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);

% %% plot the difference
% diffVars = {};
% diffVars{end+1} = recVars{1};
% diffVars{end+1} = recVars{4};
% diffVars{end+1} = recVars{5};
% diffVars{end+1} = recVars{6};
% diffVars{end+1} = abs(recVars{4}-recVars{1});
% diffVars{end+1} = abs(recVars{5}-recVars{1});
% diffVars{end+1} = abs(recVars{6}-recVars{1});
% 
% %%
% colormapSet = 'gray';
% MethodCompareFig = DiffDRStarNewSubplot(...
%                                 diffVars, z2BF, y2BF, ...
%                                 ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
%                                 ["True Object", "MBPC DRWF3 15dB, Iter400", "MBPC DR7 15dB, Iter400", "MBPC 15dB, Iter300", "|MBPC WF3 - Truth|", "|MBPC7 - Truth|", "|MBPC - Truth|"],...
%                                 [],...
%                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
% saveas(MethodCompareFig, "3W2P15dBBestMethodComparison.jpg");
% 
% 
% 
% %% resolution pixel computation
% dx     = 0.224;
% dXY    = 0.02;
% dx_arc = dx*(6*4)/(2*pi*dXY);
% dx_SIM = 0.125;
% dx_SIM_arc = dx_SIM*(6*4)/(2*pi*dXY);
% 
% dz     = 0.525;
% dZ     = 0.02;
% dz_arc = dz*(6*4)/(2*pi*dZ);
% dz_SIM = 0.292;
% dz_SIM_arc = dz_SIM*(6*4)/(2*pi*dZ);
