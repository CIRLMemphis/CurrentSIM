% use exact parameters and setup.
run("../2019-04-08 New6umBead 63x1p4NA/ExpTunable0408BeadSetup.m");
matFile = CIRLDataPath + "/2019-04-08 New6umBead 63x1p4NA SIM/NormData_20190408_6umBead_63x1p4NA.mat";

%% calibrated parameters
[ psfpar, psfpari ] = PSFConfig();
p  = psfpar.initialize(psfpar, 'Vectorial', 200);
X    = 200;   % discrete lateral size in voxels
Y    = 200;   % discrete lateral size in voxels
Z    = 600;   % discrete axial size in voxels
M    = 63;    % Experimetal magnification
dXY  = 6.5/M; % lateral voxel scaling in microns ---- for 63X lens (6.5/63)....for 60X lens (6.4/63)
dZ   = 0.1;   % axial voxel scaling in microns

uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
phi   = [96   13  -89.2310];
offs  = 0;
theta = 0;
%u     = [0.1737, 0.1968, 0.1912]*uc; % 0.45*uc;0.9281;
%u     = [1.066, 1.066, 1.066];
u     = [0.19, 0.19, 0.19]*uc;
w     = 0.07625*u;
phizDeg = 33.5;
Nslits  = 3;

%%
load(matFile);

%%
Y_loc= 98; % 80 from best focus
for k = 1:length(phi)
    gk = g(Y_loc,:,1+Z/2,1,k);
    gk = gk/max(gk(:));
    figure; plot(gk,'linewidth',2);
    xx = 0:1:X-1;
    cosxx = cos(2*pi*u(k)*xx*dXY + phi(k))/10+0.9;
    hold on; plot(cosxx,'linewidth',2);
end