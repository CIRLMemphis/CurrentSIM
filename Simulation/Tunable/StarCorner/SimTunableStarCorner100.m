run("SimTunableStarCorner100Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableStarCorner100.mat";

%% run forward model and save the results into CIRLDataPath
sigma = 0.01;
ob    = StarCorner3DExtend(X, Y, Z, sigma);
g     = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');