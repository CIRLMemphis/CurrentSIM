% use exact parameters and setup.
run("../OMX_U2OS_Actin_525nm/Exp3WActinCorner200Mid7Setup.m");

%% run RunReconstruction
wD     = 0.01;
cutoff = -1;
A      = -1;
sigma  = sqrt(1);
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
            'offsets',          offs, ...
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
            'patternFunction',  @Pattern3W3D, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg},...
            'reconFunction',    @GWF3W3D, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ", cutoff, A, sigma},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "")