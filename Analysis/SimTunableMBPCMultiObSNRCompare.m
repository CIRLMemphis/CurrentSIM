run("../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];

%% load the reconstruction results
expNames = ["201908191954_SimTunableMBPCMultiOb256Iter200",...
            "201908231220_SimTunableMBPCMultiOb256SNR1Iter200",...
            "201908240025_SimTunableMBPCMultiOb256SNR2Iter200",...
            "201908240045_SimTunableMBPCMultiOb256SNR3Iter200"];
load(CIRLDataPath + "\Results\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb');

%% load the original high resolution object
X2 = X;
Y2 = Y;
Z2 = Z;
X = X/2;
Y = Y/2;
Z = Z/2;
dXY = dXY*2;
dZ  = dZ *2;
zBF  = 1 + Z/2;
yBF  = 1 + Y/2;
z2BF = 1 + Z2/2;
y2BF = 1 + Y2/2;
midOff   = 41;
midSlice = y2BF-midOff-1:y2BF+midOff-1;
HROb = MultiObject(X*2, Z*2, dXY/2, dZ/2);

%% Forward images of different noises
%forVars = {};
recVars = {};
lThe    = 1;
kPhi    = 1;
recVars{end+1} = HROb;
for k = 1:length(expNames)
    load(CIRLDataPath + "\Results\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
%     if (size(g,4) > size(g,1))
%         forVars{end+1} = squeeze(g(lThe,kPhi,:,:,:));
%     else
%         forVars{end+1} = g(:,:,:,lThe,kPhi);
%     end
    recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
end
% ForwardNoiseFig = XYXZSubplot(forVars, zBF, yBF, ...
%                               ["Noiseless", "SNR1", "SNR2", "SNR3", "SNR4"],...
%                               "Noisy data for the zero orientation, phi = 0", colormapSet);
% saveas(ForwardNoiseFig, "TunableForwardNoiseComparison.jpg");

ReconSNRFig = XYXZSubplot(recVars, z2BF, y2BF, ...
                          ["True Object", "Noiseless", "SNR1", "SNR2", "SNR3", "SNR4"],...
                          "Comparison of different reconstruction for different noise level for the MBPC method",...
                          colormapSet, midSlice, colorScale);
saveas(ReconSNRFig, "TunableMBPCNoisyComparison.jpg");
