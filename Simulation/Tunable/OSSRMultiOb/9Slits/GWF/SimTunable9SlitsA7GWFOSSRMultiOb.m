%% load the CIRL settings
run("../../../../../CIRLSetup.m")

%% load the experiment setup (in this case it is simulated setup)
run("../SimTunable9SlitsA7OSSRMultiOb256Setup.m");

%% load the collected data (in this case simulated data)
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunable9SlitsA5OSSRMultiOb256.mat";
load(matFile, 'g');

%% construct the point-spread function (PSF)
h = PSFLutz(X, Z, dXY, dZ, p);

%% load the modulating patterns
[im, jm, ~] = PatternTunable3DNSlits(X, Y, Z, omegaXY, omegaZ, dXY, dZ, phi, offs, theta, phizDeg, Nslits);

%% run the GWF reconstruction and get the restored image
wD      = 1e-6;
reconOb = OptGWFTunable3D(g, h, im, uc, omegaXY, phi, offs, theta, wD, dXY, dZ);

%% save
save('SimTunable9SlitsA7GWFOSSRMultiOb')