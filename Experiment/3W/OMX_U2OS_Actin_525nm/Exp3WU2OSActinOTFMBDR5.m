run("Exp3WActinFullSetup.m");
matFile   = CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm.mat";

%% reduce data input and set the theta phi and offset
load(matFile, 'g');
gIn = zeros(size(g,1), size(g,2), size(g,3), 5);
gIn(:,:,:,1) = g(:,:,:,1,1);
gIn(:,:,:,2) = g(:,:,:,1,2);
gIn(:,:,:,3) = g(:,:,:,1,3);
gIn(:,:,:,4) = g(:,:,:,1,4);
gIn(:,:,:,5) = g(:,:,:,1,5);
clear g;

thePhiOff = [ theta(1) phi(1) offs(1); ...
              theta(1) phi(2) offs(1); ...
              theta(1) phi(3) offs(1); ...
              theta(1) phi(4) offs(1); ...
              theta(1) phi(5) offs(1) ];

%% run RunReconstruction
numIt   = 100;
picIn   = 10;    % picture every 50 interations
initInd = 5;

%%
load(CIRLDataPath + "/FairSimOTFs/splineOTF_512_512_53_5.mat");
OTFs = zeros(2*X, 2*Y, Z + floor(Z/2)*2, 3);
OTFs(:,:,:,1) = padarray(Hn(:,:,:,1), [Y/2 X/2 floor(Z/2)]);
OTFs(:,:,:,2) = OTFs(:,:,:,1);
OTFs(:,:,:,3) = padarray(Hn(:,:,:,2), [Y/2 X/2 floor(Z/2)]);
clear Hn;

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
            'reconFunction',    @DRHotOTFGradientDescent, ...
            'reconArgs',        {@HotOTFForwardModel, ...
                                 @HotOTFGradient, ...
                                 @HotOTFStepSize, ...
                                 @UpSampling, ...
                                 OTFs,...
                                 @jm3WTest,...
                                 gIn, h, "dXY", "dZ", 3, "u", "w", thePhiOff, phizDeg,...
                                 "numIt", 5e-20 ,-1, -1, picIn, initInd},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Exp3WU2OSActinOTFMBDR5.tex")