run("SimTunableMultiOb256Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableDRMultiOb256.mat";
thePhi = [0 0; 0 120; 60 120; 120 120];
Nslits = 3;

%% run forward model and save the results into CIRLDataPath
ob           = MultiObject(X, Z, dXY, dZ);
h            = PSFAgard( X, Z, dXY, dZ);
[im, jm, Nn] = DRPatternTunable3DNSlits(X, Y, Z, u, w, dXY, dZ, thePhi, phizDeg, Nslits);
g            = DRForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');