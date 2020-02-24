run("Sim3WStarCorner150Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3WStarCorner150.mat";

%% run forward model and save the results into CIRLDataPath
sigma = 0.6;
ob = StarCorner3DExtend(X, Y, Z, sigma);
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g');