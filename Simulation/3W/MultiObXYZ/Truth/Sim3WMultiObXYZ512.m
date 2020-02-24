run("Sim3WMultiObXYZ512Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiObXYZ512.mat";

%% run forward model and save the results into CIRLDataPath
ob = MultiObjectXYZ(X, Z, dXY, dZ);
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiObXYZ256.mat";
g = g(1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g');