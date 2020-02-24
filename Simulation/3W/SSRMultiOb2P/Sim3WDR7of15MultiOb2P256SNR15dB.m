run("Sim3WMultiOb2P256Setup.m");

%% load the noiseless data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb2P256SNR15dB.mat";
load(matFile, 'g');

%% set the data reduction phases and index
thePhi    = [  0 0;   0 72*2; 0 144*2; 0 216*2; 0 288*2; ...
                     60 72*2; ...
                    120 72*2];
thePhiInd = [1 1; 1 2; 1 3; 1 4; 1 5; ...
                  2 2; ...
                  3 2];
Npt       = length(thePhi);

%% down-sample with data reduction
for ind = 1:Npt
    gDR(:,:,:,ind) = g(:, :, :, thePhiInd(ind,1), thePhiInd(ind,2));
end

%% add the noise
matFile = CIRLDataPath + "/Simulation/3W/Sim3WDR7of15MultiOb2P256SNR15dB.mat";
g = gDR;
save(matFile, '-v7.3', 'g');
