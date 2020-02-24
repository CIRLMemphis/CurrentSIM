run("../../../CIRLSetup.m");

%% Simulated 3W star corner settings
[ psfpar, psfpari ] = PSFConfigNoAber();
p     = psfpar.initialize(psfpar, 'Vectorial', 200);
X     = 100;       % discrete lateral size in voxels
Y     = 100;       % discrete lateral size in voxels
Z     = 100;        % discrete axial size in voxels
dXY   = 0.1;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.1;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
offs  = [0, 0, 0];          %[-106.675, -58.77, 123.872];
phi   = [0, 72, 144, -144, -72]; % phi   = [-144, -72, 0, 72, 144];
theta = [0, 60, 120];          %[-45.723, -105.589, 14.73];
u     = [0.8, 0.8, 0.8]*uc;   %[0.632, 0.636, 0.607]*uc;
w     = 0.1605*u;
phizDeg   = 185.0;

% %% get the pattern and check
% zBF = 1 + Z/2;
% h  = PSFLutz(X, Z, dXY, dZ, p);
% [im, jm, Nn] = Pattern3W3D(X, Y, Z, u, w, dXY, dZ, phi, offs, theta, phizDeg);
% vz = squeeze(im(1+Y/2,1+X/2,:,1,1,3));
% vz = vz./max(vz(:));
% hz = squeeze(h (1+Y/2,1+X/2,:));
% hz = hz./max(hz(:));
% figure;  plot(vz, 'DisplayName', 'v(z)'); 
% hold on; plot(hz, 'DisplayName', 'h(z)'); 
% xlabel('z'); ylabel('value'); suptitle("Visibility and PSF at zBF = " + num2str(zBF)); legend;
% 
% jm2 = squeeze(jm(1+Y/2,:,zBF,1,1,2));
% jm3 = squeeze(jm(1+Y/2,:,zBF,1,1,3));
% jm2 = squeeze(jm(1+Y/2,:,zBF,1,1,2));
% jm3 = squeeze(jm(1+Y/2,:,zBF,1,1,3));
% figure;  plot(jm2, 'DisplayName', 'jm(2)'); 
% hold on; plot(jm3, 'DisplayName', 'jm(3)'); 
% xlabel('x'); ylabel('value'); suptitle("jm at zBF = " + num2str(zBF)); legend;