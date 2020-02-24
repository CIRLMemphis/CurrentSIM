run("Sim3WMultiOb256Setup.m");

%% load the high resolution data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb512.mat";
load(matFile, 'g');

%% set the data reduction phases and index
thePhi    = [  0 0;   0 72;   0 144;   0 216;   0 288;...
              60 0;  60 72;  60 144;  60 216;  60 288;...
             120 0; 120 72; 120 144; 120 216; 120 288];
thePhiInd = [1 1; 1 2; 1 3; 1 4; 1 5;...
             2 1; 2 2; 2 3; 2 4; 2 5;...
             3 1; 3 2; 3 3; 3 4; 3 5];
Npt       = length(thePhi);

%% down-sample with data reduction
matFile = CIRLDataPath + "/Simulation/3W/Sim3WDRMultiOb256.mat";
gDR = zeros(X,Y,Z,Npt);
for ind = 1:Npt
    gDR(:,:,:,ind) = g(1:2:end, 1:2:end, 1:2:end, thePhiInd(ind,1), thePhiInd(ind,2));
end
g = gDR;
save(matFile, '-v7.3', 'g');