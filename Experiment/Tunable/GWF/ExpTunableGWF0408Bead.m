% use exact parameters and setup.
run("../2019-04-08 New6umBead 63x1p4NA/ExpTunable0408BeadSetup.m");

%% run RunReconstruction
wD     = 0.05;
cutoff = -1;
A      = 1;
sigma  = 4;
radius = round(uc*X*dXY);
Filter = bead(dXY, dXY, X, Z, radius*dXY, radius*dXY);
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
            'patternFunction',  @PatternTunable3DNSlits, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg, Nslits},...
            'reconFunction',    @GWFTunable3D, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ", cutoff, A, sigma, 1, Filter},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "ExpTunableGWF0408Bead.tex")