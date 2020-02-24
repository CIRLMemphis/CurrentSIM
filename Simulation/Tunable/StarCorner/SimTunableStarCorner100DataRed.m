run("SimTunableStarCorner100Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableStarCorner100DataRed.mat";
thePhi = [0 0; 0 120; 0 240; 60 120; 120 120];

%% run forward model and save the results into CIRLDataPath
sigma = 0.01;
ob = StarCorner3DExtend(X, Y, Z, sigma);
[im, jm, Nn] = PatternTunable3DDataRed3Slits(X, Y, Z, u, w, dXY, dZ, thePhi, phizDeg);
g  = ForwardModelDataRed(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');