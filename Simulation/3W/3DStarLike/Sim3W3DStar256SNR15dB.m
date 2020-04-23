run("Sim3W3DStar256Setup.m");


%% load the noiseless data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DStar256.mat";
load(matFile, 'g');

% add Poisson noise
b = 0.0168; % 1.5% of the signal is background
scaleCCA = 2980;
for l = 1:size(g,4)
    for k = 1:size(g,5)
        [g(:,:,:,l,k), SNR] = AddPoissnNoise(g(:,:,:,l,k),b,scaleCCA);
    end
end

%% save the noisy data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DStar256SNR15dB.mat";
save(matFile, '-v7.3', 'g');
