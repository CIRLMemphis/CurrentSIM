% use exact parameters and setup.
run("../MultiOb/SimTunable9SlitsMultiOb256Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunable9SlitsMultiOb256DataRedSNR2.mat";
thePhi = [0 0; 0 120; 60 120; 120 120];

%% run RunReconstruction
numIt = 200;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
picIn = 20;    % picture every 20 interations
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
            'patternFunction',  @PatternTunable3DDataRed9Slits, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", thePhi, phizDeg},...
            'reconFunction',    @GradientDescentDataRed, ...
            'reconArgs',        {@ForwardModelDataRed, ...
                                 @CostFunction, ...
                                 @GradientDataRed, ...
                                 @StepSizeDataRed, ...
                                 "g", "h", "im", "jm", "numIt" ,...
                                 5e-20 ,-1, -1, picIn},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "SimTunable9SlitsMBMultiOb256DRSNR2Iter200.tex")
