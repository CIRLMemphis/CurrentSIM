run("../../../CIRLSetup.m");

%% calibrated parameters
[ psfpar, psfpari ] = TunablePSFConfigAber(-5);
p  = psfpar.initialize(psfpar, 'Vectorial', 200);
X    = 512;   % discrete lateral size in voxels
Y    = 512;   % discrete lateral size in voxels
Z    = 128;   % discrete axial size in voxels
M    = 63;    % Experimetal magnification
dXY  = 6.5/M; % lateral voxel scaling in microns ---- for 63X lens (6.5/63)....for 60X lens (6.4/63)
dZ   = 0.1;   % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
phi   = [220, 160, 280];
offs  = 0;
theta = 0;
omegaXY = [0.3830, 0.3830, 0.3830]*uc; % 0.45*uc;0.9281;
x0      = 0.488;  % in mm
fL1     = 100;  % in mm
fL2     = 250;  % in mm
fMO     = 160/63;
omegaZ  = ((x0*fL2)/(2*fL1*fMO))*omegaXY;
phizDeg = 85;
Nslits  = 3;

%% get the pattern and check
zBF = 1+Z/2;
h  = PSFLutz(X, Z, dXY, dZ, p);
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