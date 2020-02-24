run("Exp3WActinCorner128Setup.m");
matFile   = CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm_Corner128.mat";
xyRegionX =   1:128;
xyRegionY =   512-128:512;

%% run RunReconstruction
numIt = 100;
picIn = 10;    % picture every 50 interations

%%
load(CIRLDataPath + "/FairSimOTFs/splineOTF_512_512_53_5.mat");
[HnX, HnY, HnZ, ~] = size(Hn);
%Hn   = Hn(257-64:257+63, 257-64:257+63, :, :);
OTFs = zeros(2*HnX, 2*HnY, HnZ + floor(HnZ/2)*2, 3);
OTFs(:,:,:,1) = padarray(Hn(:,:,:,1), [HnY/2 HnX/2 floor(HnZ/2)]);
OTFs(:,:,:,2) = OTFs(:,:,:,1);
OTFs(:,:,:,3) = padarray(Hn(:,:,:,2), [HnY/2 HnX/2 floor(HnZ/2)]);
OTFs = OTFs(513-128:513+127, 513-128:513+127, :, :);
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
            'reconFunction',    @HotOTFGradientDescent, ...
            'reconArgs',        {@HotOTFForwardModel, ...
                                 @HotOTFGradient, ...
                                 @HotOTFStepSize, ...
                                 @UpSampling, ...
                                 OTFs,...
                                 @jm3WTest,...
                                 "g", h, "dXY", "dZ", 3, "u", "w", "theta", "phi", offs, phizDeg,...
                                 "numIt", 5e-20 ,-1, -1, picIn, -1},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "Exp3WU2OSActinCorner128OTFMB.tex")
