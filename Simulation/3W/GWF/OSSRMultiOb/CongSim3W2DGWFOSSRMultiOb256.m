run("../../OSSRMultiOb/Sim3WOSSRMultiOb256Setup.m");
load(CIRLDataPath + "/Simulation/3W/Sim3WOSSRMultiOb256.mat", 'g');

%% Wiener parameter
wD = 0.001;

% lateral fractions
qn = [0, 1, -1, 2, -2]/2; % qn = (1:Nphi) - (Nphi+1)/2;

% decomposition matrix coefficients
cn = [1, 2/3, 2/3, 1/3, 1/3];

% input OTFs
load(CIRLDataPath + "/Simulation/SimOTFs/OTFs_256_256_256.mat", 'Hn');
    tempHn = zeros(Y, X, length(phi));
    for phiInd = 1:length(phi)
        tempHn(:,:,phiInd) = sum(Hn(:,:,:,phiInd),3);
        tempHn(:,:,phiInd) = ZeroFreqDamp2D(tempHn(:,:,phiInd),X,Y,0,dXY,0.99995, 0.2);
    end
    Hn = tempHn;

%% get 3D apodization
% AD = zeros(X*2, Y*2, Z*2, length(theta), length(phi));
% for l = 1:length(theta)
%     radius = round((uc+u(l)).*X*dXY);
%     for k = 1 : length(phi)
%         center  = [1+Y 1+X 1+Z] + round(u(l)*X*dXY*qn(k)*[sin(theta(l)) cos(theta(l)) 0]);
%         AD(:,:,:,l,k) = apodization( X*2, Z*2, radius, center);
%     end
% end


reconOb = zeros(Y*2, X*2, Z);
for zInd = 1:Z
    zInd
    reconOb(:,:,zInd) = CongOTF2DGWFCore(...
                             squeeze(g(:,:,zInd,:,:)),  ...
                             ...squeeze(Hn(:,:,zInd,:)), ...
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
                             ...-1, 0, 0, [], 1, [], 0, squeeze(AD(:,:,zInd*2,:,:)));
                             -1, 0, 0, [], 1, [], 0 );
end


save('CongSim3W2DGWFOSSRMultiOb256', 'reconOb');