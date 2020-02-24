run("../../OSSRMultiOb/Sim3WOSSRMultiOb256Setup.m");
load(CIRLDataPath + "/Simulation/3W/Sim3WOSSRMultiOb256.mat", 'g');

[Y,X,Z,Nthe,Nphi] = size(g);
G = zeros(Y,X,Z,Nthe,Nphi);
for l = 1:Nthe
    for k = 1:Nphi
        G(:,:,:,l,k) = FT(g(:,:,:,l,k));
    end
end

%% Wiener parameter
wD = 0.001;

% lateral fractions
qn = [0, 1, -1, 2, -2]/2; % qn = (1:Nphi) - (Nphi+1)/2;

% decomposition matrix coefficients
cn = [1, 2/3, 2/3, 1/3, 1/3];

% input OTFs
load(CIRLDataPath + "/Simulation/SimOTFs/OTFs_256_256_256.mat", 'Hn');
    tempHn = zeros(Y, X, length(phi));
    for zInd = 1:length(phi)
        tempHn(:,:,zInd) = sum(Hn(:,:,:,zInd),3);
    end
    Hn = tempHn;

reconOb = zeros(Y*2, X*2, Z);
for zInd = 1:Z
    zInd
    reconOb(:,:,zInd) = OTF2DGWFCore(...
                             squeeze(G(:,:,zInd,:,:)),  ...
                             Hn, ...
                             qn, ...
                             cn, ...
                             uc, ...
                             u, ...
                             phi, ...
                             offs, ...
                             theta, ...
                             wD, ...
                             dXY, dZ, ...
                             -1, 0, 0, [], 1, [], 0);
end


save('Sim3W2DGWFOSSRMultiOb256');