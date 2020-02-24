% use exact parameters and setup.
run("ExpTunable190322RhizopusSetup.m");
matFile = CIRLDataPath + "/TunableData/190322_Rhizopus/190322_Rhizopus.mat";

%% run RunReconstruction
wD     = 0.01;
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
            'offsets',          offs, ...
            'theta',            theta, ...
            'w',                omegaZ, ...
            'dXY',              dXY, ...
            'dZ',               dZ, ...
            'psfParam',         psfpar, ...
            'reconVars',        {"wD"}, ...
            'reconVals',        {wD}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFLutz, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ", "psfParam"}, ...
            'patternFunction',  @PatternTunable3DNSlits, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg, Nslits},...
            'reconFunction',    @OptGWFTunable3DNoDouble, ...
            ...'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ", cutoff, A, sigma, 1, Filter},...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ"},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "ExpTunable190322RhizopusGWFNoDouble.tex")