%% load the experiment setup (in this case it is simulated setup)
run("../SimTunable11SlitsStarlike256SetupU08.m");

%% load the collected data (in this case simulated data)
matFile = CIRLDataPath + "/Simulation/Starlike/SimTunable11SlitsStarlike256U08.mat";

%% run RunReconstruction
wD     = 0.0001;
cutoff = -1;
A      = -1;
sigma  = -1;
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
            'reconVars',        {"wD"}, ...
            'reconVals',        {wD}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFAgard, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ"}, ...
            'patternFunction',  @PatternTunable3DNSlits, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg, Nslits},...
            'reconFunction',    @GWFTunable3D, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ", cutoff, A, sigma, 1},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "SimGWF11Slits122StarSNRMaxdBU08.tex")