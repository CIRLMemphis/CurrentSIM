% use exact parameters and setup.
run("Exp3WU2OSMitoFullSetup.m");
matFile = CIRLDataPath + "/FairSimData/OMX_U2OS_Mitotracker_600nm.mat";

%% run RunReconstruction
wD = 0.05;
A  = -1;
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
            'reconFunction',    @FairSIMOptGWF3W3D_jmDouble, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ",-1,0,0,1,ones(Y,X,Z), char(CIRLDataPath + "/FairSimOTFs/splineOTF_512_512_21_5.mat")},...
            ...'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ",-1,A,sigma,1,ones(Y,X,Z)},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Exp3WU2OSMitoOptGWF_jmDouble.tex")