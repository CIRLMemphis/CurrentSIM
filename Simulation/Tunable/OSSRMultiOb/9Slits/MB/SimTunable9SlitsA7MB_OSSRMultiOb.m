%% load the CIRL settings
run("../../../../../CIRLSetup.m")

%% load the experiment setup (in this case it is simulated setup)
run("../SimTunable9SlitsA7OSSRMultiOb256Setup.m");

%% load the collected data (in this case simulated data)
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunable9SlitsA5OSSRMultiOb256.mat";
load(matFile, 'g');

%% double the grid size
X2       = 2*X;
Y2       = 2*Y;
Z2       = Z*2;
dXY2     = dXY/2;
dZ2      = dZ/2;

%% construct the HR point-spread function (PSF)
h = PSFLutz(X2, Z2, dXY2, dZ2, p);

%% run the MB reconstruction and get the restored image
numIt   = 200;
picIn   = 50;
reconOb = HotGradientDescent(    @HotForwardModel, ...
                                 @HotGradient, ...
                                 @HotStepSize, ...
                                 @UpSampling, ...
                                 @imTunable9Slits,...
                                 @jmTunable,...
                                 g, h, dXY2, dZ2, 2, omegaXY, omegaZ, theta, phi, offs, phizDeg,...
                                 numIt, -1 ,-1, -1, picIn, -1);

%% save
save('SimTunable9SlitsA7MB_OSSRMultiOb')