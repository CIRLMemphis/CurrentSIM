run("SimTunableMultiOb200Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableMultiOb200.mat";

%% run forward model and save the results into CIRLDataPath
ob = MultiObject(X, Z, dXY, dZ);
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');