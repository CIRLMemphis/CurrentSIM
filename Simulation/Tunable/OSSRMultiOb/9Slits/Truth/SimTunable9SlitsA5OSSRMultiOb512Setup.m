%%
run("../../../../../CIRLSetup.m");

%% Simulated Tunable settings
[ psfpar, psfpari ] = PSFConfigAber5();
factr   = 2;
X       = 256*factr;       % discrete lateral size in voxels
Y       = 256*factr;       % discrete lateral size in voxels
Z       = 256*factr;       % discrete axial size in voxels
dXY     = 0.025/factr;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ      = 0.025/factr;     % axial voxel scaling in microns
uc      = 2*psfpar.NA/psfpari.v(1);  % cycle/um
offs    = [0, 0, 0];
phi     = [0, 1, 2]*(2*180)/3;
theta   = [0, 60, 120];
omegaXY = [0.8, 0.8, 0.8]*uc;
x0      = 0.122;  % in mm
fL1     = 100;  % in mm
fL2     = 250;  % in mm
fMO     = 160/63;
omegaZ  = ((x0*fL2)/(2*fL1*fMO))*omegaXY;
phizDeg = 219.0;
Nslits  = 9;

%% get the pattern and check
zBF = 1 + Z/2;
p   = psfpar.initialize(psfpar, 'Vectorial', 200);
h   = PSFLutz(X, Z, dXY, dZ, p);
[im, jm, Nn] = PatternTunable3DNSlits(X, Y, Z, omegaXY, omegaZ, dXY, dZ, phi, offs, theta, phizDeg, Nslits);
vz = squeeze(im(1,1,:,1,1,2));
vz = vz./max(vz(:));
hz = squeeze(h (1+Y/2,1+X/2,:));
hz = hz./max(hz(:));
figure;  plot(vz, 'DisplayName', 'v(z)'); 
hold on; plot(hz, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value'); suptitle("Visibility and PSF at zBF = " + num2str(zBF)); legend;

jm2 = squeeze(jm(1+Y/2,:,1,1,1,2));
figure;  plot(jm2, 'DisplayName', 'jm(2)'); 
xlabel('x'); ylabel('value'); suptitle("jm at zBF = " + num2str(zBF)); legend;