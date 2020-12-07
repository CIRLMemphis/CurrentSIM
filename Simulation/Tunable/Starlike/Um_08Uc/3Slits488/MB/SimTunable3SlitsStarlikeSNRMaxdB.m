%% load the experiment setup (in this case it is simulated setup)
run("../SimTunable3SlitsStarlike256SetupU08.m");

%% load the collected data (in this case simulated data)
matFile = CIRLDataPath + "/Simulation/Starlike/SimTunable3SlitsStarlike256U08.mat";
load(matFile, 'g');

%% double the grid size
X2       = 2*X;
Y2       = 2*Y;
Z2       = Z*2;
dXY2     = dXY/2;
dZ2      = dZ/2;

%% construct the HR point-spread function (PSF)
h = PSFAgard(X2, Z2, dXY2, dZ2);

%% run the MB reconstruction and get the restored image
numIt   = 800;
picIn   = 100;
[reconOb, ~, retVars] = HotGradientDescent(    @HotForwardModel, ...
                                 @HotGradient, ...
                                 @HotStepSize, ...
                                 @UpSampling, ...
                                 @imTunable3Slits,...
                                 @jmTunable,...
                                 g, h, dXY2, dZ2, 2, omegaXY, omegaZ, theta, phi, offs, phizDeg,...
                                 numIt, -1 ,-1, -1, picIn, -1);

%% save data
reconData = CIRLDataPath + "/GeneratedReport/Starlike/3Slits/SimTunableMB3Slits488StarlikeU08.mat";
save(reconData, '-v7.3');
