run("Exp3WActinFullSetup.m");
matFile = CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm.mat";

%% run RunReconstruction
numIt = 100;
picIn = 10;    % picture every 50 interations

%%
load(CIRLDataPath + "/FairSimOTFs/vz.mat");
load(CIRLDataPath + "/FairSimOTFs/splinePSF_1024_1024_105.mat");

X     = 2*X;
Y     = 2*Y;
Z     = Z + floor(Z/2)*2;
dXY   = dXY/2;
dZ    = dZ/2;

%%
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
            'reconVars',        {"numIt"}, ...
            'reconVals',        {numIt}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFLutz, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ", "psfParam"}, ...
            'reconFunction',    @HotGradientDescent, ...
            'reconArgs',        {@HotPSFVzForwardMismatchModel, ...
                                 @HotPSFVzGradientMismatch, ...
                                 @HotPSFVzStepSizeMismatch, ...
                                 @UpSampling, ...
                                 vz,...
                                 @jm3WTestMismatch,...
                                 "g", h, "dXY", "dZ", 3, "u", "w", "theta", "phi", offs, phizDeg,...
                                 "numIt", 5e-20 ,-1, -1, picIn, -1},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Exp3WU2OSActinPSFVzMBMismatch.tex")
