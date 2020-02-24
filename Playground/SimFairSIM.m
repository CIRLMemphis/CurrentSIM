run("../../CIRLSetup.m");

%% Initialization
[ psfpar, psfpari ] = PSFFairSIM();
p     = psfpar.initialize(psfpar, 'Vectorial', 200);
X     = 512;       % discrete lateral size in voxels
Y     = 512;       % discrete lateral size in voxels
Z     = 53;        % discrete axial size in voxels
dXY   = 0.08;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.08;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
offs  = 0;          %[-106.675, -58.77, 123.872];
phi   = [0, 72, 144, -144, -72]; % phi   = [-144, -72, 0, 72, 144];
theta = 0;          %[-45.723, -105.589, 14.73];
%u     = 0.632*uc;   %[0.632, 0.636, 0.607]*uc;
u     = 0.6*uc;   %[0.632, 0.636, 0.607]*uc;
w     = 1.0*u;      % how to get this?
wD    = 0.05; 
phizDeg   = 0.0;
contrast  = 1.0;
attenRate = 0;

Radius    = 20/2;      % radius of bead in microns
Thickness = 18/2;      % shell thickness of bead in microns

ob = SphericalShell(X, Y, Z, dXY, Radius, Thickness);
h  = PSFLutz(X, Z, dXY, dZ, p);

%% estimating phi
[im, jm, Nn] = ThreeW3DPattern(X, Y, Z, u, w, dXY, dZ, phi, offs, theta, phizDeg, contrast, attenRate);
g    = ForwardModel3W(ob, h, im, jm);

%%
[ AxialP, LateralP1, LateralP2, Phase ] = ThreeW_3DPattern( u, w, h, dXY, dZ, phi, theta );
g = ForwardImage_3WSIM(ob, h, AxialP, LateralP1, LateralP2);

%%
zBF   = round(Z/2);
gXY   = squeeze(g(:,:,zBF,1,1));
gXYFT = abs(FT(gXY));
figure; plot(squeeze(gXY(1+Y/2,:)));
figure; imagesc(g(:,:,1+round(Z/2),1,1)); axis square;
figure; imagesc(gXYFT.^0.1);

gYFT = gXYFT(256,:);
gYFT = gYFT./max(gYFT(:));
figure; plot(gYFT); xlabel('u'); ylabel('value');



%% estimating omegaZ
gz = squeeze(g(1+Y/2,1+X/2,:,1,1));
Gz = abs(squeeze(fftshift(fft(gz))));
figure; plot(gz);
figure; plot(Gz);

%%
imz = squeeze(im(1+Y/2,1+X/2,:,1,1,2));
IMz = abs(fftshift(fft(imz)));
figure; plot(imz);
figure; plot(IMz);

%%
LFT2p1 = abs(fftshift(fft2(1+LateralP1(:,:, 27,1,1))));
LFT2p1 = LFT2p1./max(LFT2p1(:));
figure; plot(LFT2p1(1+Y/2,:));
LFT1p1 = abs(fftshift(fft(1+LateralP1(1+Y/2,:, 27,1,1))));
LFT1p1 = LFT1p1./max(LFT1p1(:));
figure; plot(LFT1p1);

%%
hFT = abs(fftshift(fftn(h)));
figure; plot(hFT(1+Y/2,:,27), 'DisplayName', 'fftn(h)');

%%
hFT2D = abs(fftshift(fft2(h(:,:,27))));
hFT2D = hFT2D./max(hFT2D(:));
hold on; plot(hFT2D(1+Y/2,:), 'DisplayName', 'fft2(h)');
xlabel('u'); ylabel('value');
legend;
title('dXY = 0.08');