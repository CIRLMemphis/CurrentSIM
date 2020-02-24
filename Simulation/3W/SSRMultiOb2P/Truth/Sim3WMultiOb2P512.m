run("Sim3WMultiOb2P512Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb2P512.mat";

%% run forward model and save the results into CIRLDataPath
ob = SSRMultiObject(X, Z, dXY, dZ);
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb2P256.mat";
ob = ob(1:2:end, 1:2:end, 1:2:end);
g  = g (1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g', 'ob');