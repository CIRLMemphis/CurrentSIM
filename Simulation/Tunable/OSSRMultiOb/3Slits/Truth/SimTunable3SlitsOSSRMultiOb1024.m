run("SimTunable3SlitsOSSRMultiOb1024Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunable3SlitsOSSRMultiOb1024.mat";

%% run forward model and save the results into CIRLDataPath
ob = OSSRMultiObject(X, Z, dXY, dZ);
g  = ForwardModel11(ob, h, im, jm);
save(matFile, '-v7.3', 'g');