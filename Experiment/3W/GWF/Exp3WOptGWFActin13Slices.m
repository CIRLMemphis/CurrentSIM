% use exact parameters and setup.
run("../OMX_U2OS_Actin_525nm/Exp3WActin13SlicesSetup.m");
matFile = CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm_13Slices.mat";

%% run RunReconstruction
wD = 0.05;
A  = -1;
sigma = 0;
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
            'patternFunction',  @Pattern3W3D, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg},...
            'reconFunction',    @OptGWF3W3D, ...
            ...'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ",-1,A,sigma,1,ones(Y,X,Z), char(CIRLDataPath + "/FairSimData/ActinHn.mat")},...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ",-1,A,sigma,1,Filter},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Exp3WOptGWFActin13Slices.tex")