run("Sim3WMultiOb2P256Setup.m");

%% load the high resolution data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb2P512.mat";
load(matFile, 'g');

%% set the data reduction phases and index
thePhi    = [  0 0;   0 72*2;   0 144*2;   0 216*2;   0 288*2;...
              60 0;  60 72*2;  60 144*2;  60 216*2;  60 288*2;...
             120 0; 120 72*2; 120 144*2; 120 216*2; 120 288*2];
thePhiInd = [1 1; 1 2; 1 3; 1 4; 1 5;...
             2 1; 2 2; 2 3; 2 4; 2 5;...
             3 1; 3 2; 3 3; 3 4; 3 5];
Npt       = length(thePhi);

%% down-sample with data reduction
matFile = CIRLDataPath + "/Simulation/3W/Sim3WDRMultiOb2P256.mat";
gDR = zeros(X,Y,Z,Npt);
for ind = 1:Npt
    gDR(:,:,:,ind) = g(1:2:end, 1:2:end, 1:2:end, thePhiInd(ind,1), thePhiInd(ind,2));
end
g = gDR;
save(matFile, '-v7.3', 'g');