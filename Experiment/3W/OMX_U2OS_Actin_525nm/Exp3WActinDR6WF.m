run("../../../CIRLSetup.m");
load(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm.mat", 'g');

thePhiInd = [     1 1; ...
                  1 2; ...
                  2 1; ...
                  2 2; ...
                  3 1; ...
                  3 2; ...
             1 1; 1 2; 1 3; 1 4; 1 5];
Npt       = length(thePhiInd);

%% down-sample with data reduction
gDR = zeros(size(g,1), size(g,2), size(g,3), 7);
for ind = 1:6
    gDR(:,:,:,ind) = g(:, :, :, thePhiInd(ind,1), thePhiInd(ind,2));
end
for ind = 7:Npt
    gDR(:,:,:,end) = gDR(:,:,:,end) + g(:, :, :, thePhiInd(ind,1), thePhiInd(ind,2));
end

%% add the noise
g = gDR;
save(CIRLDataPath + "/FairSimData/OMX_U2OS_Actin_525nm_DR6WF.mat", '-v7.3', 'g');