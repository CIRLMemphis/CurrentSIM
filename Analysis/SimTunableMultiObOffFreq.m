run("../CIRLSetup.m");
colormapSet = 'gray';

%% load the reconstruction results
expNames = ["201908211658_SimTunableGWFMultiOb",...
            "SimTunableMBMultiOb256Iter200",...
            "201908252306_SimTunableMBMultiOb256FreqOff"];
load(CIRLDataPath + "\Results\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'g');

%% remove the negative values of the reconOb
reconOb(reconOb < 0) = 0;

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

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;
recVars{end+1} = HROb;
for k = 1:length(expNames)
    load(CIRLDataPath + "\Results\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
    recVars{end+1} = reconOb;
end

MethodCompareFig = XYXZSubplot( recVars, z2BF, y2BF, ...
                                ["True Object", "GWF", "MB 200 Iter", "MB off frequency"],...
                                "Comparison of different reconstruction methods when frequency is off",...
                                colormapSet, midSlice);
saveas(MethodCompareFig, "TunableOffFreqComparison.jpg");
