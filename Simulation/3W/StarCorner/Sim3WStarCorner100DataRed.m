run("Sim3WStarCorner100Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3WStarCorner100DataRed.mat";
thePhi = [0 0; 0 72; 0 144; 60 72; 60 144; 120 72; 120 144];

%% run forward model and save the results into CIRLDataPath
sigma = 0.6;
ob           = StarCorner3DExtend(X, Y, Z, sigma);
h            = PSFLutz(X, Z, dXY, dZ, p);
[im, jm, Nn] = Pattern3W3DDataRed(X, Y, Z, u, w, dXY, dZ, thePhi, phizDeg);
g            = ForwardModelDataRed(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');