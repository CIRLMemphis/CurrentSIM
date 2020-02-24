run("SimTunableSRMultiOb160Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableSRMultiOb160.mat";

%% run forward model and save the results into CIRLDataPath
HROb = SRMultiObject(-X*dXY/2, X*dXY/2, X*2+1, 1);
[im, jm, Nn] = PatternTunable3DNSlits(X*2+1, Y*2+1, Z*2+1, u, w, dXY/2, dZ/2, phi, offs, theta, phizDeg, 3);
h    = PSFAgard( X*2+1, Z*2+1, dXY/2, dZ/2);
HRg  = ForwardModel(HROb, h, im, jm);
g    = HRg(2:2:end, 2:2:end, 2:2:end, :, :);
save(matFile, '-v7.3', 'g', 'HROb');