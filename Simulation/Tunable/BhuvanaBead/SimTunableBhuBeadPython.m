%%
run("../../../CIRLSetup.m");

%% Simulated bead settings
[ psfpar, psfpari ] = PSFConfigAber5();
X     = 200;                        % discrete lateral size in voxels
Y     = 200;                        % discrete lateral size in voxels
Z     = 300;                        % discrete axial size in voxels
dXY   = 0.1;                      % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.1;                      % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);   % cycle/um
offs  = 0;                  % offset from the standard values of phi
phi   = [0, 1, 2]*(2*180)/3;        % lateral phase
theta = 0;               % orientation
x0    = 0.488;  % in mm
fL1   = 100;    % in mm
fL2   = 250;    % in mm
fMO   = 160/63;
omegaXY = [0.2, 0.2, 0.2]*uc;         % lateral modulating frequency
omegaZ  = ((x0*fL2)/(2*fL1*fMO))*omegaXY;  % axial modulating frequency
%phizDeg   = 104.0;                   % axial phase
phizDeg = 20.0;                   % axial phase
Nslits  = 3;

%% get the pattern and check
zBF = 1 + Z/2;
p  = psfpar.initialize(psfpar, 'Vectorial', 200);
h  = PSFLutz(X, Z, dXY, dZ, p);
%h  = PSFAgard( X, Z, dXY, dZ);
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

%% run forward model and save the results into CIRLDataPath
Radius    = 6/2;
Thickness = 2/2;
ob = SphericalShell(X, Y, Z, dXY, Radius, Thickness);
g  = ForwardModel(ob, h, im, jm);

save(CIRLDataPath + "/Simulation/PyLBFGSB/SimTunableA5BhuBead.mat", 'g');
save(CIRLDataPath + "/Simulation/PyLBFGSB/hBhuBeadA5.mat" , 'h');
save(CIRLDataPath + "/Simulation/PyLBFGSB/imBhuBeadA5.mat", 'im');
save(CIRLDataPath + "/Simulation/PyLBFGSB/jmBhuBeadA5.mat", 'jm');

%% without aberration
[ psfpar, psfpari ] = PSFConfigNoAber();
phizDeg = 40.0;                   % axial phase

%%
p  = psfpar.initialize(psfpar, 'Vectorial', 200);
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

%%
g  = ForwardModel(ob, h, im, jm);

save(CIRLDataPath + "/Simulation/PyLBFGSB/SimTunableBhuBead.mat", 'g');
save(CIRLDataPath + "/Simulation/PyLBFGSB/hBhuBead.mat" , 'h');
save(CIRLDataPath + "/Simulation/PyLBFGSB/imBhuBead.mat", 'im');
save(CIRLDataPath + "/Simulation/PyLBFGSB/jmBhuBead.mat", 'jm');