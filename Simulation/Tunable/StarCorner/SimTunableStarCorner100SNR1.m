run("SimTunableStarCorner100Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableStarCorner100SNR1.mat";

%% run forward model and save the results into CIRLDataPath
sigma = 0.5;
ob = StarCorner3DExtend(X, Y, Z, sigma);
g  = ForwardModel(ob, h, im, jm);

% add Poisson noise
b = 0.0168; % 1.5% of the signal is background
scaleCCA = 29800;
for l = 1:length(theta)
    for k = 1:length(phi)
        [temp, SNR] = AddPoissnNoise(g(:,:,:,l,k),b,scaleCCA);
        g(:,:,:,l,k) = temp;
    end
end

save(matFile, '-v7.3', 'g', 'ob');