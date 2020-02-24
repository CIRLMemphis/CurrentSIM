run("../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];

%% load the reconstruction results
expNames = ["201908211658_SimTunableGWFMultiOb",...
            "201908211718_SimTunableGWFMultiOb256SNR1",...
            "201908211719_SimTunableGWFMultiOb256SNR2",...
            "201908211725_SimTunableGWFMultiOb256SNR3",...
            "201908211726_SimTunableGWFMultiOb256SNR4"];
load(CIRLDataPath + "\Results\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb');

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
HROb = MultiObject(X*2, Z*2, dXY/2, dZ/2);

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

%% Forward images of noiseless data
zBF        = 1 + Z/2;
yBF        = 1 + Y/2;
% forVars    = {};
% lThe       = 1;
% for k = 1:3
%     forVars{end+1} = g(:,:,:,lThe,k);
% end
% ForwardFig = XYXZSubplot(forVars, zBF, yBF, ...
%                          ["1", "2", "3", "4", "5"],...
%                          "Noiseless data for the zero orientation", colormapSet);
% saveas(ForwardFig, "TunableForwardImage.jpg");

%% Forward images of different noises
%forVars = {};
recVars = {};
lThe    = 1;
kPhi    = 1;
recVars{end+1} = HROb;
for k = 1:length(expNames)
    load(CIRLDataPath + "\Results\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
    %forVars{end+1} = g(:,:,:,lThe,kPhi);
    recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
end
% ForwardNoiseFig = XYXZSubplot(forVars, zBF, yBF, ...
%                               ["Noiseless", "SNR1", "SNR2", "SNR3", "SNR4"],...
%                               "Noisy data for the zero orientation, phi = 0", colormapSet);
% saveas(ForwardNoiseFig, "TunableForwardNoiseComparison.jpg");

ReconSNRFig = XYXZSubplot(recVars, z2BF, y2BF, ...
                          ["True Object", "Noiseless", "SNR1", "SNR2", "SNR3", "SNR4"],...
                          "Comparison of different reconstruction for different noise level",...
                          colormapSet, midSlice, colorScale);
saveas(ReconSNRFig, "TunableGWFNoisyComparison.jpg");
