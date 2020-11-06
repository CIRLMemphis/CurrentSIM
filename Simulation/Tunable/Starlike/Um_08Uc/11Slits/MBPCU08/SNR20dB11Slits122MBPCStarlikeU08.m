%% load the experiment setup (in this case it is simulated setup)
run("../SimTunable11SlitsStarlike256SetupU08.m");

%% load the collected data (in this case simulated data)
matFile = CIRLDataPath + "/Simulation/Starlike/SNR20dBSimTun11Slits122StarlikeU08.mat";

%% run RunReconstruction
numIt = 500;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
picIn = 100;    % picture every 20 interations
RunReconstruction(...
            'savemat',          1, ...
            'u',                omegaXY, ...
            'uc',               uc, ...
            'X' ,               X , ...
            'Y' ,               Y , ...
            'Z' ,               Z , ...
            'Nphi',             length(phi), ...
            'Nthe',             length(theta), ...
            'phi',              phi, ...
            'theta',            theta, ...
            'w',                omegaZ, ...
            'dXY',              dXY, ...
            'dZ',               dZ, ...
            'psfParam',         psfpar, ...
            'reconVars',        {"numIt"}, ...
            'reconVals',        {numIt}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFAgard, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ"}, ...
            'reconFunction',    @HotPCGradientDescent, ...
            'reconArgs',        {@HotForwardModel, ...
                                 @HotGradient, ...
                                 @HotPCStepSize, ...
                                 @UpSampling, ...
                                 @imTunable11Slits,...
                                 @jmTunable,...
                                 "g", "h", "dXY", "dZ", 2, "u", "w", "theta", "phi", offs, phizDeg,...
                                 "numIt", 1e-2,-1, -1, picIn},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "SNR20dB11Slits122MBPCStarlikeU08.tex")