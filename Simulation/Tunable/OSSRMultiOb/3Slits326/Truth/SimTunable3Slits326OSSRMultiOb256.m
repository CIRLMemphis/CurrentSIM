run("../SimTunable3Slits326OSSRMultiOb256Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunable3Slits326OSSRMultiOb256.mat";

%% run forward model and save the results into CIRLDataPath
ob = OSSRMultiObject(X, Z, dXY, dZ);
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');