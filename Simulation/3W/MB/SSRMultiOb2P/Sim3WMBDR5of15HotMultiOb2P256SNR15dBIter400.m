% use exact parameters and setup.
run("../../SSRMultiOb2P/Sim3WMultiOb2P256Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3WDR5of15MultiOb2P256SNR15dB.mat";
thePhi    = [  0 0;   0 72*2;   0 144*2; ...
                     60 72*2;  ...
                    120 72*2];

%% run RunReconstruction
numIt = 400;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
picIn = 100;    % picture every 20 interations
initInd = 3;
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
            'reconFunction',    @DRHotGradientDescent, ...
            'reconArgs',        {@HotForwardModel, ...
                                 @HotGradient, ...
                                 @HotStepSize, ...
                                 @UpSampling, ...
                                 @im3W,...
                                 @jm3W,...
                                 "g", "h", "dXY", "dZ", 3, "u", "w", thePhi, offs, phizDeg,...
                                 "numIt", 5e-20 ,-1, -1, picIn, initInd},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Sim3WMBDR5of15HotMultiOb2P256SNR15dBIter400.tex")
