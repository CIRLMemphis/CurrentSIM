% use exact parameters and setup.
run("../MultiOb/SimTunableMultiOb256Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableMultiOb256SNR2.mat";

%% run RunReconstruction
numIt = 200;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
picIn = 50;    % picture every 20 interations
RunReconstruction(...
            'savemat',          1, ...
            'u',                u, ...
            'uc',               uc, ...
            'X' ,               X , ...
            'Y' ,               Y , ...
            'Z' ,               Z , ...
            'Nphi',             length(phi), ...
            'Nthe',             length(theta), ...
            'phi',              phi, ...
            'theta',            theta, ...
            'w',                w, ...
            'dXY',              dXY, ...
            'dZ',               dZ, ...
            'psfParam',         psfpar, ...
            'reconVars',        {"numIt"}, ...
            'reconVals',        {numIt}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFAgard, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ"}, ...
            'patternFunction',  @PatternTunable3D3Slits, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg},...
            'reconFunction',    @PCGradientDescent, ...
            'reconArgs',        {@ForwardModel, ...
                                 @PCCostFunction, ...
                                 @PCGradient, ...
                                 @PCStepSize, ...
                                 "g", "h", "im", "jm", "numIt" ,...
                                 5e-20 ,-1, -1, picIn},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "SimTunableMBPCMultiOb256SNR2Iter200.tex")