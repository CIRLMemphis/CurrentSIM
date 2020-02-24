%%
run("../../../CIRLSetup.m");

%% Simulated bead settings
factor = 1;
[ psfpar, psfpari ] = PSFConfigNoAber();
X     = 80*factor;                        % discrete lateral size in voxels
Y     = 80*factor;                        % discrete lateral size in voxels
Z     = 300;                        % discrete axial size in voxels
dXY   = 0.1/factor;                      % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.1/factor;                      % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);   % cycle/um
offs  = 0;                  % offset from the standard values of phi
phi   = [0, 1, 2]*(2*180)/3;        % lateral phase
theta = 0;               % orientation
x0    = 0.488;  % in mm
fL1   = 100;    % in mm
fL2   = 250;    % in mm
fMO   = 640/63;
omegaXY = [0.2, 0.2, 0.2]*uc;         % lateral modulating frequency
omegaZ  = ((x0*fL2)/(2*fL1*fMO))*omegaXY;  % axial modulating frequency
%phizDeg   = 104.0;                   % axial phase
phizDeg = [10.0, 14.0, 33.0, 40.0];                   % axial phase
Nslits  = 3;

%% get PSF and original object
p  = psfpar.initialize(psfpar, 'Vectorial', 200);
h  = PSFLutz(X, Z, dXY, dZ, p);
Radius    = 6/2;
Thickness = 2/2;
ob = SphericalShell(X, Y, Z, dXY, Radius, Thickness);

%%
fig = figure;
for k = 1:4
    omegaXY = k*[0.2, 0.2, 0.2]*uc;         % lateral modulating frequency
    omegaZ  = ((x0*fL2)/(2*fL1*fMO))*omegaXY;  % axial modulating frequency
    [im, jm, Nn] = PatternTunable3DNSlits(X, Y, Z, omegaXY, omegaZ, dXY, dZ, phi, offs, theta, phizDeg(k), Nslits);
    g     = ForwardModel(ob, h, im, jm);
    %gCont = g(65,100:220,151,1,1);
    %gCont = g(15,25:55,151,1,1);
    gCont = g(15,:,151,1,1);
    Contrast(gCont)
    figure(fig);
    subplot(1,4,k); imagesc(g(:,:,151,1,1)); axis square off; colormap gray;
    xlabel('x'); ylabel('y');
    title(char("um = " + omegaXY(1)/uc(1) + " uc"))
    
    vz = squeeze(im(1,1,:,1,1,2));
    vz = vz./max(vz(:));
    hz = squeeze(h (1+Y/2,1+X/2,:));
    hz = hz./max(hz(:));
    figure; 
    subplot(121); plot(vz, 'DisplayName', 'v(z)'); 
    hold on; plot(hz, 'DisplayName', 'h(z)'); 
    xlabel('z'); ylabel('value'); title("Aligning Visibility function and PSF"); legend;
    subplot(122); plot(gCont);
    xlabel('y'); ylabel('value'); title("contrast region"); legend;
end