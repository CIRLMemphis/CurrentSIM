run("../Sim3W3Dp4S6StarNew256Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3Dp4S6StarNew256SNR10dB.mat";

%% reduce data input and set the theta phi and offset
load(matFile, 'g');
gIn = zeros(size(g,1), size(g,2), size(g,3), 4);
gIn(:,:,:,1) = g(:,:,:,1,2);
gIn(:,:,:,2) = g(:,:,:,2,2);
gIn(:,:,:,3) = g(:,:,:,3,2);
gIn(:,:,:,4) = g(:,:,:,1,1) + g(:,:,:,1,2) + g(:,:,:,1,3) + g(:,:,:,1,4) + g(:,:,:,1,5);
clear g;

thePhiOff = [ theta(1) phi(2) offs(1); ...
              theta(2) phi(2) offs(2); ...
              theta(3) phi(2) offs(3); ...
              0        0      0];

%% run RunReconstruction
numIt = 400;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
picIn = 100;    % picture every 20 interations
initInd = 5;
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
            'reconFunction',    @DRWFHotPCGradientDescent, ...
            'reconArgs',        {@HotForwardModel, ...
                                 @HotGradient, ...
                                 @DRHotPCStepSize, ...
                                 @UpSampling, ...
                                 @im3W,...
                                 @jm3W,...
                                 gIn, "h", "dXY", "dZ", 3, "u", "w", thePhiOff, phizDeg,...
                                 "numIt", 5e-20 ,-1, -1, picIn, initInd},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Sim3WMBPCDRWF3of15Hot3Dp4S6StarNew256SNR10dBIter400.tex")