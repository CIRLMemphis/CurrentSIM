run("SimTunable9SlitsMultiOb256Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunable9SlitsMultiOb256DataRed.mat";
thePhi = [0 0; 0 120; 60 120; 120 120];

%% run forward model and save the results into CIRLDataPath
ob = MultiObject(X, Z, dXY, dZ);
[im, jm, Nn] = PatternTunable3DDataRed9Slits(X, Y, Z, u, w, dXY, dZ, thePhi, phizDeg);
g  = ForwardModelDataRed(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');