% use exact parameters and setup.
run("Exp3WLSECActinFullSetup.m");
matFile = CIRLDataPath + "/FairSimData/OMX_LSEC_Actin_525nm.mat";

%% run RunReconstruction
wD = 0.01;
A  = -1; % -1 is no attenuation of the FT of the raw data, using the notation from the paper (about different artifacts of GWF0
sigma = 0.3;
%radius = round(uc*X*dXY);
%Filter = bead(dXY, dZ, X, Z, radius*dXY, radius*dXY);
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
            'reconFunction',    @FairSIMOptGWF3W3D, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ",-1,0,0,1,ones(Y,X,Z), char(CIRLDataPath + "/FairSimOTFs/FairSIMGreenLRHn_512_512_7.mat")},...
            ...'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ",-1,A,sigma,1,ones(Y,X,Z)},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Exp3WLSECActinOptGWF.tex")