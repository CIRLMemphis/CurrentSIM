run("../../CIRLSetup.m");

%% Initialization
[ psfpar, psfpari ] = PSFFairSIM();
p     = psfpar.initialize(psfpar, 'Vectorial', 200);
X     = 200;       % discrete lateral size in voxels
Y     = 200;       % discrete lateral size in voxels
Z     = 200;        % discrete axial size in voxels
dXY   = 0.04;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.08*2;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
offs  = [0, 0, 0];          %[-106.675, -58.77, 123.872];
phi   = [0, 72, 144, -144, -72]; % phi   = [-144, -72, 0, 72, 144];
theta = [0, 60, 120];          %[-45.723, -105.589, 14.73];
%u     = 0.632*uc;   %[0.632, 0.636, 0.607]*uc;
u     = [0.6, 0.6, 0.6]*uc;   %[0.632, 0.636, 0.607]*uc;
w     = 0.1*u;      % how to get this?
wD    = 0.05; 
phizDeg   = -25.0;
contrast  = 1.0;
attenRate = 0;
[scale01, scaleOmega] = Pixel2Omega(uc, u(1), X, dXY);

zBF = 1+Z/2;
ob = StarLike3DExtend(X, Y, Z);
obFT = abs(FT(ob));
h  = PSFLutz(X, Z, dXY, dZ, p);

%% plot the original object and its FT at best focus
figure; imagesc(ob(:,:,zBF)); axis square; colorbar; colormap hot;
xlabel('x'); ylabel('y'); title("original ob at zBF = " + num2str(zBF));

figure; imagesc(log(obFT(:,:,zBF))); axis square; colorbar; colormap hot;
xlabel('u'); ylabel('v'); title("log(FT) of original ob at zBF = " + num2str(zBF));
set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega)
set(gca, 'YTick', scale01, 'YTickLabel', scaleOmega)

%% construct the best result GWF can achieve
radius   = round((uc+u(1)).*X*dXY);
center   = [1+Y/2 1+X/2 zBF];
cutOff   = ApodizationCutOff( X, Z, radius, center);
obFTCut  = obFT.*cutOff;
obCut    = abs(IFT(obFTCut));

figure; imagesc(obCut(:,:,zBF)); axis square; colorbar; colormap hot;
xlabel('x'); ylabel('y'); title("cut-off ob at zBF = " + num2str(zBF));

figure; imagesc(log(obFTCut(:,:,zBF))); axis square; colorbar; colormap hot;
xlabel('u'); ylabel('v'); title("log(FT) of cut-off ob at zBF = " + num2str(zBF));
set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega)
set(gca, 'YTick', scale01, 'YTickLabel', scaleOmega)

%% get the pattern and check
[im, jm, Nn] = ThreeW3DPattern(X, Y, Z, u, w, dXY, dZ, phi, offs, theta, phizDeg, contrast, attenRate);
vz = squeeze(im(1+Y/2,1+X/2,:,1,1,3));
vz = vz./max(vz(:));
hz = squeeze(h (1+Y/2,1+X/2,:));
hz = hz./max(hz(:));
figure;  plot(vz, 'DisplayName', 'v(z)'); 
hold on; plot(hz, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value'); suptitle("Visibility and PSF at zBF = " + num2str(zBF)); legend;

jm2 = squeeze(jm(1+Y/2,:,zBF,1,1,2));
jm3 = squeeze(jm(1+Y/2,:,zBF,1,1,3));
figure;  plot(jm2, 'DisplayName', 'jm(2)'); 
hold on; plot(jm3, 'DisplayName', 'jm(3)'); 
xlabel('x'); ylabel('value'); suptitle("jm at zBF = " + num2str(zBF)); legend;

%% run forward model
g = ForwardModel3W(ob, h, im, jm);

%% run reconstruction
recon = GWFThreeW3D(g, h, im, uc, u, phi, offs, theta, wD, dXY, dZ);