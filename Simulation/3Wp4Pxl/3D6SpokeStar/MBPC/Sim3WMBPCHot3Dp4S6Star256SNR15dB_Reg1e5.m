run("../Sim3W3Dp4S6Star256Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3Dp4S6Star256SNR15dB.mat";

%% run RunReconstruction
numIt = 200;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
picIn = 50;    % picture every 20 interations
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
            'psfFunction',      @PSFAgard, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ"}, ...
            'reconFunction',    @HotPCGradientDescent, ...
            'reconArgs',        {@HotForwardModel, ...
                                 @HotGradient, ...
                                 @HotPCStepSize, ...
                                 @UpSampling, ...
                                 @im3W,...
                                 @jm3W,...
                                 "g", "h", "dXY", "dZ", 3, "u", "w", "theta", "phi", offs, phizDeg,...
                                 "numIt", 1e-5 ,-1, -1, picIn},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Sim3WMBPCHot3Dp4S6Star256SNR15dBReg1e5Iter200.tex")