run("Sim3WMultiOb256Setup.m");

%% load the high resolution data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb512.mat";
load(matFile, 'g');

%% set the data reduction phases and index
thePhi    = [  0 0;   0 72;   0 144; ...
                     60 72; ...
                    120 72];
thePhiInd = [1 1; 1 2; 1 3; ...
                  2 2; ...
                  3 2];
Npt       = length(thePhi);

%% down-sample with data reduction
matFile = CIRLDataPath + "/Simulation/3W/Sim3WDR5of15MultiOb256.mat";
gDR = zeros(X,Y,Z,Npt);
for ind = 1:Npt
    gDR(:,:,:,ind) = g(1:2:end, 1:2:end, 1:2:end, thePhiInd(ind,1), thePhiInd(ind,2));
end
g = gDR;
save(matFile, '-v7.3', 'g');