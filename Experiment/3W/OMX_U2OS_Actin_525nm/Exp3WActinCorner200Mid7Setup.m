run("../../../CIRLSetup.m");
matFile = CIRLDataPath + "/FairSimData/Corner200Mid7_OMX_U2OS_Actin_525nm.mat";

%% calibrated parameters
[ psfpar, psfpari ] = PSFFairSIM();
p     = psfpar.initialize(psfpar, 'Vectorial', 200);
X     = 200;       % discrete lateral size in voxels
Y     = 200;       % discrete lateral size in voxels
Z     = 12;        % discrete axial size in voxels
dXY   = 0.08;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.08;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
offs  = [-106.675, -58.77, 123.872]*2;
phi   = [0, 72, 144, -144, -72]*2; % phi   = [-144, -72, 0, 72, 144];
theta = -[-45.723, -105.589, 14.73];
u     = [0.632, 0.636, 0.607]*uc;
w     = OmegaZ(u, psfpari.v(1));
wD    = 0.05; 
phizDeg   = 215.0;

%% get the pattern and check
zBF = 7;
h  = PSFLutz(X, Z, dXY, dZ, p);
[im, jm, Nn] = Pattern3W3D(X, Y, Z, u, w, dXY, dZ, phi, offs, theta, phizDeg);
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