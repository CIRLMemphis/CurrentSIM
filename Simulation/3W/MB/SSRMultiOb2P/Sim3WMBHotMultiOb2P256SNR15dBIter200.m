% use exact parameters and setup.
run("../../SSRMultiOb2P/Sim3WMultiOb2P256Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb2P256SNR15dB.mat";

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
            'reconFunction',    @HotGradientDescent, ...
            'reconArgs',        {@HotForwardModel, ...
                                 @HotGradient, ...
                                 @HotStepSize, ...
                                 @UpSampling, ...
                                 @im3W,...
                                 @jm3W,...
                                 "g", "h", "dXY", "dZ", 3, "u", "w", "theta", "phi", offs, phizDeg,...
                                 "numIt", 5e-20 ,-1, -1, picIn},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Sim3WMBHotMultiOb2P256SNR15dBIter200.tex")