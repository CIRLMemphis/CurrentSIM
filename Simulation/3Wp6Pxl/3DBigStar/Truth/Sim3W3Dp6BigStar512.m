run("Sim3W3Dp6BigStar512Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3Dp6BigStar512.mat";

%% run forward model and save the results into CIRLDataPath
ob = StarLikeSample(3,512,8,20,3,0.7);
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3Dp6BigStar256.mat";
g = g(1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g');

%% add Poisson noise
b = 0.0168; % 1.5% of the signal is background
scaleCCA = 2980;
for l = 1:size(g,4)
    for k = 1:size(g,5)
        [g(:,:,:,l,k), SNR] = AddPoissnNoise(g(:,:,:,l,k),b,scaleCCA);
    end
end

%% save the noisy data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3Dp8BigStar256SNR15dB.mat";
save(matFile, '-v7.3', 'g');