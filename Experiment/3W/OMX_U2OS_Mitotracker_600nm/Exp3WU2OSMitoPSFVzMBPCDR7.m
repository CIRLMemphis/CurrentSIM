run("Exp3WActinFullSetup.m");
matFile = CIRLDataPath + "/FairSimData/OMX_U2OS_Mitotracker_600nm.mat";

%% reduce data input and set the theta phi and offset
load(matFile, 'g');
gIn = zeros(size(g,1), size(g,2), size(g,3), 7);
gIn(:,:,:,1) = g(:,:,:,1,1);
gIn(:,:,:,2) = g(:,:,:,1,2);
gIn(:,:,:,3) = g(:,:,:,1,3);
gIn(:,:,:,4) = g(:,:,:,1,4);
gIn(:,:,:,5) = g(:,:,:,1,5);
gIn(:,:,:,6) = g(:,:,:,2,2);
gIn(:,:,:,7) = g(:,:,:,3,2);
clear g;

thePhiOff = [ theta(1) phi(1) offs(1); ...
              theta(1) phi(2) offs(1); ...
              theta(1) phi(3) offs(1); ...
              theta(1) phi(4) offs(1); ...
              theta(1) phi(5) offs(1); ...
              theta(2) phi(2) offs(2); ...
              theta(3) phi(2) offs(3) ];

%% run RunReconstruction
numIt = 100;
picIn = 10;    % picture every 50 interations
initInd = 5;

%%
load(CIRLDataPath + "/FairSimOTFs/U2OSMito_vz.mat");
load(CIRLDataPath + "/FairSimOTFs/splinePSF_1024_1024_41.mat");

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
            'reconFunction',    @DRHotPCGradientDescent, ...
            'reconArgs',        {@HotPSFVzForwardModel, ...
                                 @HotPSFVzGradient, ...
                                 @DRHotPSFVzPCStepSize, ...
                                 @UpSampling, ...
                                 vz,...
                                 @jm3WTest,...
                                 gIn, h, "dXY", "dZ", 3, "u", "w", thePhiOff, phizDeg,...
                                 "numIt", 5e-20 ,-1, -1, picIn, initInd},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Exp3WU2OSMitoPSFVzMBPCDR7.tex")
