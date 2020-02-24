% use exact parameters and setup.
run("../2019-04-08 New6umBead 63x1p4NA/ExpTunable0408BeadSetup.m");
matFile = CIRLDataPath + "/2019-04-08 New6umBead 63x1p4NA SIM/NormData_20190408_6umBead_63x1p4NA.mat";

%% run RunReconstruction
wD     = 0.05;
cutoff = -1;
A      = -1;
sigma  = -1;
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
            'reconFunction',    @OptGWFTunable3D, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ", cutoff, A, sigma, 1, Filter},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "ExpTunableOptGWF0408NormBead.tex")