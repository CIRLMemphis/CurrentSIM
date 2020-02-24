run("../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];

%% load the reconstruction results
expNames = ["SimTunableMBMultiOb256Iter200",...
            "201908231025_SimTunableMBMultiOb256SNR1Iter200",...
            "201908232115_SimTunableMBMultiOb256SNR2Iter200",...
            "201908232120_SimTunableMBMultiOb256SNR3Iter200",...
            "201908232319_SimTunableMBMultiOb256SNR4Iter200"];
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
%   forVars{end+1} = g(:,:,:,lThe,kPhi);
    recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
end
% ForwardNoiseFig = XYXZSubplot(forVars, zBF, yBF, ...
%                               ["Noiseless", "SNR1", "SNR2", "SNR3", "SNR4"],...
%                               "Noisy data for the zero orientation, phi = 0", colormapSet);
% saveas(ForwardNoiseFig, "TunableForwardNoiseComparison.jpg");

ReconSNRFig = XYXZSubplot(recVars, z2BF, y2BF, ...
                          ["True Object", "Noiseless", "SNR1", "SNR2", "SNR3", "SNR4"],...
                          "Comparison of different reconstruction for different noise level for the MB method",...
                          colormapSet, midSlice, colorScale);
saveas(ReconSNRFig, "TunableMBNoisyComparison.jpg");
