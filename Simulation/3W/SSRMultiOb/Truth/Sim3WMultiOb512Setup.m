%%
run("../../../../CIRLSetup.m");

%% Simulated 3W star corner settings
[ psfpar, psfpari ] = PSFConfigNoAber();
factr = 2;
X     = 256*factr;       % discrete lateral size in voxels
Y     = 256*factr;       % discrete lateral size in voxels
Z     = 256*factr;       % discrete axial size in voxels
dXY   = 0.025/factr;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.025/factr;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
offs  = [0, 0, 0];
phi   = [0, 72, 144, 216, 288];
theta = [0, 60, 120];
u     = [0.8, 0.8, 0.8]*uc;
w     = (psfpar.NA/4/psfpar.n(1))*u;   % assuming the same fraction as uc/wc
phizDeg   = 282.0;

%% get the pattern and check
zBF = 1 + Z/2;
h   = PSFAgard( X, Z, dXY, dZ);
[im, jm, Nn] = Pattern3W3D(X, Y, Z, u, w, dXY, dZ, phi, offs, theta, phizDeg);
vz = squeeze(im(1,1,:,1,1,3));
vz = vz./max(vz(:));
hz = squeeze(h (1+Y/2,1+X/2,:));
hz = hz./max(hz(:));
figure;  plot(vz, 'DisplayName', 'v(z)'); 
hold on; plot(hz, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value'); suptitle("Visibility and PSF at zBF = " + num2str(zBF)); legend;

jm2 = squeeze(jm(1+Y/2,:,1,1,1,2));
jm3 = squeeze(jm(1+Y/2,:,1,1,1,3));
figure;  plot(jm2, 'DisplayName', 'jm(2)'); 
hold on; plot(jm3, 'DisplayName', 'jm(3)'); 
xlabel('x'); ylabel('value'); suptitle("jm at zBF = " + num2str(zBF)); legend;