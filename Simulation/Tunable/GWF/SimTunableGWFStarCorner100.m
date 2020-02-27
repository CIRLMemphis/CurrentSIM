% use exact parameters and setup.
run("../StarCorner/SimTunableStarCorner100Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableStarCorner100.mat";

%% run RunReconstruction
wD = 1e-8;
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
            'reconVars',        {"wD"}, ...
            'reconVals',        {wD}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFLutz, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ", "psfParam"}, ...
            'patternFunction',  @PatternTunable3D3Slits, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg},...
            'reconFunction',    @GWFTunable3D, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ"},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "EnlargedStarCorner.tex")