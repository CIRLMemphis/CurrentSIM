run("Sim3W3DStar512Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DStar512.mat";

%% run forward model and save the results into CIRLDataPath
ob = OSSRMultiObject(X, Z, dXY, dZ);
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DStar256.mat";
g = g(1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g');