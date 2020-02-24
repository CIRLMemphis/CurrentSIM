run("../../CIRLSetup.m");
colormapSet = 'jet';
colorScale  = 'auto';
xzRegionX   = 257-100:257+99;
xzRegionZ   = 257-100:257+99;
xyRegionX   = 257-50 :257+49;
xyRegionY   = 257-50 :257+49;
yBest       = 257;
zBest       = 257;

%% load the reconstruction results
expNames = ["SimTunable9SlitsA5MB_OSSRMultiOb",...
            "SimTunable9SlitsA7MB_OSSRMultiOb",...
            "SimTunable9SlitsA9MB_OSSRMultiOb",...
            "SimTunable9SlitsA11MB_OSSRMultiOb"];
load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'uc', 'omegaXY');

%% load the original high resolution object
X2 = 2*X;
Y2 = 2*Y;
Z2 = 2*Z;
matFile = CIRLDataPath + "\Simulation\3W\Sim3WOSSRMultiOb512.mat";
load(matFile, 'ob');
HROb  = ob;
norOb = ob; % multi object is already on scale [0,1]

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;
z2BF    = 1 + Z2/2;
y2BF    = 1 + Y2/2;


% the original object first
recVars{end+1} = HROb;

%% add the forward images of different aberration
for k = 1:length(expNames)
    load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(k) + ".mat", 'reconOb');
    recVars{end+1} =  reconOb;
end


%%
MethodCompareFig = OSSRSubplot( recVars, z2BF, y2BF, ...
                                ["True Object", "5 Aber Recon", "7 Aber Recon", "9 Aber Recon", "11 Aber Recon"],...
                                "Comparison of the reconstruction of different level of aberrations for Tunable 9-slit",...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
saveas(MethodCompareFig, "Tunable9SlitsAberRecon.jpg");

