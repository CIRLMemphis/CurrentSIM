run("../Sim3W3Dp4S6Star256Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3Dp4S6Star256SNR15dB.mat";

%% run RunReconstruction
wD     = 0.001;
cutoff = -1;
A      = -1;
sigma  = -1;
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
            'reconVars',        {"wD"}, ...
            'reconVals',        {wD}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFAgard, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ"}, ...
            'patternFunction',  @Pattern3W3D, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg},...
            'reconFunction',    @OptGWF3W3D, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ", cutoff, A, sigma, 1},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Sim3WOpt1e3GWF3Dp4S6Star256SNR15dB.tex")
        