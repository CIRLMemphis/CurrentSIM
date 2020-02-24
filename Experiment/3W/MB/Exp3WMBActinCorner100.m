% use exact parameters and setup.
run("../OMX_U2OS_Actin_525nm/Exp3WActinCorner100Setup.m");

%% run RunReconstruction
numIt = 50;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
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
            'reconVars',        {"numIt"}, ...
            'reconVals',        {numIt}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFLutz, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ", "psfParam"}, ...
            'patternFunction',  @Pattern3W3D, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg},...
            'reconFunction',    @GradientDescent, ...
            'reconArgs',        {@ForwardModel, ...
                                 @CostFunction, ...
                                 @Gradient, ...
                                 @StepSize, ...
                                 "g", "h", "im", "jm", "numIt" ,5e-20 ,-1, -1},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Exp3WMBActinCorner100.tex")