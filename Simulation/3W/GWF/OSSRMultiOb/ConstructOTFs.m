run("../../OSSRMultiOb/Sim3WOSSRMultiOb256Setup.m");

%% LR OTFs
h          = PSFAgard( X, Z, dXY, dZ);
[im, ~, ~] = Pattern3W3D(X, Y, Z, u, w, dXY, dZ, phi, offs, theta, phizDeg);
Nphi = length(phi);
vn = ones(1, 1, Z, Nphi);
vn(1,1,:,2) = im(1,1,:,1,1,3);
vn(1,1,:,3) = im(1,1,:,1,1,3);
Hn = zeros(Y,X,Z,Nphi);

for k = 1:Nphi
    Hn(:,:,:,k) = FT(h.*vn(1,1,:,k));
end

save(CIRLDataPath + "/Simulation/SimOTFs/OTFs_256_256_256.mat", 'Hn');

%% HR OTFs
X2   = X*2;
Y2   = Y*2;
Z2   = Z + floor(Z/2)*2;
dXY2 = dXY/2;
dZ2  = dZ/2;
Nphi = length(phi);

[im, jm, Nn] = Pattern3W3D(X2, Y2, Z2, u, w, dXY2, dZ2, phi, offs, theta, phizDeg);
vn   = ones(1, 1, Z2, Nphi);
vn(1,1,:,2) = im(1,1,:,1,1,3);
vn(1,1,:,3) = im(1,1,:,1,1,3);

Hn = zeros(Y2,X2,Z2,Nphi);
h  = PSFAgard( X2, Z2, dXY2, dZ2);
for k = 1:Nphi
    Hn(:,:,:,k) = FT(h.*vn(1,1,:,k));
end
save(CIRLDataPath + "/Simulation/SimOTFs/OTFs_512_512_512.mat", 'Hn', '-v7.3');