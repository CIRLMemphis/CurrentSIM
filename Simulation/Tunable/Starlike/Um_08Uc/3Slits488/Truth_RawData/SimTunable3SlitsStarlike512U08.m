run("SimTunable3SlitsStarlike512SetupU08.m");
matFile = CIRLDataPath + "/Simulation/Starlike/SimTunable3SlitsStarlike512U08.mat";

%% run forward model and save the results into CIRLDataPath
ob  = StarLikeSample(3,512,6,20,3,0.6);
gIn = ForwardModel(ob, h, im, jm);
g   = gIn;
save(matFile, '-v7.3', 'g', 'ob');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/Starlike/SimTunable3SlitsStarlike256U08.mat";
gIn = gIn(1:2:end, 1:2:end, 1:2:end, :,:);
g   = gIn;
save(matFile, '-v7.3', 'g');

%% add 20dB Poisson noise
b = 0.0168; % 1.5% of the signal is background
scaleCCA = 29800;
for l = 1:size(g,4)
    for k = 1:size(g,5)
        [g(:,:,:,l,k), SNR] = AddPoissnNoise(gIn(:,:,:,l,k),b,scaleCCA);
    end
end
%% save the noisy data
matFile = CIRLDataPath + "/Simulation/Starlike/SNR20dBSimTun3Slits488StarlikeU08.mat";
save(matFile, '-v7.3', 'g');

%% add 15dB Poisson noise
b = 0.0168; % 1.5% of the signal is background
scaleCCA = 2980;
for l = 1:size(g,4)
    for k = 1:size(g,5)
        [g(:,:,:,l,k), SNR] = AddPoissnNoise(gIn(:,:,:,l,k),b,scaleCCA);
    end
end
%% save the noisy data
matFile = CIRLDataPath + "/Simulation/Starlike/SNR15dBSimTun3Slits488StarlikeU08.mat";
save(matFile, '-v7.3', 'g');

%% add 10dB Poisson noise
b = 0.0168; % 1.5% of the signal is background
scaleCCA = 298;
for l = 1:size(g,4)
    for k = 1:size(g,5)
        [g(:,:,:,l,k), SNR] = AddPoissnNoise(gIn(:,:,:,l,k),b,scaleCCA);
    end
end
%% save the noisy data
matFile = CIRLDataPath + "/Simulation/Starlike/SNR10dBSimTun3Slits488StarlikeU08.mat";
save(matFile, '-v7.3', 'g');