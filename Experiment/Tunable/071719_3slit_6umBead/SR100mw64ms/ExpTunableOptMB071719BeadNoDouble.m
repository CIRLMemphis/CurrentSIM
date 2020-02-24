run("ExpTunable071719BeadSetup.m");
matFile = CIRLDataPath + "/TunableData/071719_3slit_6umBead/FSIM_071719_3S_6umBead_SR100mw64ms.mat";

%% run RunReconstruction
numIt = 50;
picIn = 5;    % picture every 5 interations
RunReconstruction(...
            'savemat',          1, ...
            'u',                omegaXY, ...
            'uc',               uc, ...
            'X' ,               X , ...
            'Y' ,               Y , ...
            'Z' ,               Z , ...
            'Nphi',             length(phi), ...
            'Nthe',             length(theta), ...
            'phi',              phi, ...
            'offsets',          offs, ...
            'theta',            theta, ...
            'w',                omegaZ, ...
            'dXY',              dXY, ...
            'dZ',               dZ, ...
            'psfParam',         psfpar, ...
            'reconVars',        {"numIt"}, ...
            'reconVals',        {numIt}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFLutz, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ", "psfParam"}, ...
            'reconFunction',    @HotGradientDescentNoDouble, ...
            'reconArgs',        {@HotForwardModel, ...
                                 @HotGradient, ...
                                 @HotStepSize, ...
                                 @UpSampling, ...
                                 @imTunable,...
                                 @jmTunable,...
                                 "g", "h", "dXY", "dZ", 2, "u", "w", "theta", "phi", offs, phizDeg,...
                                 "numIt", 5e-20 ,-1, -1, picIn},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "ExpTunableOptMB071719BeadNoDouble_SR100mw64ms.tex")