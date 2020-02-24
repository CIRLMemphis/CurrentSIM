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
expNames = ["SimTunable9SlitsOSSRMultiOb256",...
            "SimTunable9SlitsA5OSSRMultiOb256",...
            "SimTunable3SlitsA5OSSRMultiOb256"];
load(CIRLDataPath + "\Simulation\Tunable\" + expNames(1) + ".mat", 'g');
[X,Y,Z,~,~] = size(g);

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
    load(CIRLDataPath + "\Simulation\Tunable\" + expNames(k) + ".mat", 'g');
    recVars{end+1} =  g(:,:,:,1,1);
end


%%
MethodCompareFig = OSSRSubplot( recVars, z2BF, y2BF, ...
                                ["True Object", "0 Aber Forward, 9-slit", "5 Aber Forward, 9-slit", "5 Aber Forward, 3-slit"],...
                                "Comparison of the forward images of different level of aberrations for different number of slits",...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
saveas(MethodCompareFig, "TunableAberForward.jpg");

