% use exact parameters and setup.
run("../MultiOb/SimTunableMultiOb256Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableMultiOb256.mat";

%% run RunReconstruction
numIt = 10;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
picIn = 2;    % picture every 20 interations

load(matFile, 'g');
h            = PSFAgard( X, Z, dXY, dZ);
[im, jm, Nn] = PatternTunable3D3Slits(X, Y, Z, u, w, dXY, dZ, phi, offs, theta, phizDeg);
recon = GradientDescent(@ForwardModel, ...
                        @CostFunction, ...
                        @Gradient, ...
                        @StepSize, ...
                        g, h, im, jm, numIt ,...
                        5e-20 ,-1, -1, picIn);
