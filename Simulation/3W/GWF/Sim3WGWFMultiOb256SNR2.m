% This simulation is based on Hasti's simulation parameters
% use exact parameters and setup.
run("../MultiOb/Sim3WMultiOb256Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb256SNR2.mat";

%% run RunReconstruction
wD     = 0.01;
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
            'reconFunction',    @GWF3W3D, ...
            'reconArgs',        {"g", "h", "im", "uc", "u", "phi", "offs", "theta", "wD", "dXY", "dZ", cutoff, A, sigma, 1, Filter},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Sim3WGWFMultiOb256SNR2.tex")
        