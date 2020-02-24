run("../../CIRLSetup.m");
g = ReadTIF(char(CIRLDataPath + "\..\FairSimData\OMX_U2OS_Actin_525nm.tif"), 3, 5);
slides = 1:size(g,3);
%slides = 1:20;
zBF    = 7;

g      = g(51:150,51:150,slides,:,:);
save(CIRLDataPath + "/../FairSimData/CornerMidZOMX_U2OS_Actin_525nm.mat", 'g');

%g      = g(:,:,slides,:,:);
%save(CIRLDataPath + "/../FairSimData/MidZOMX_U2OS_Actin_525nm.mat", 'g');

[X,Y,Z,Nalp,Nphi] = size(g);
curSlice = g(:,:,zBF,:,:);
figure;imagesc(curSlice(:,:,1,1,1)); axis square; colorbar;

%% find omegaXY
[ psfpar, psfpari ] = PSFFairSIM();
p     = psfpar.initialize(psfpar, 'Vectorial', 200);
dXY   = 0.08;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.08;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
dXY   = 0.08;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.08;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
offs  = [-106.675, -58.77, 123.872];
phi   = [0, 72, 144, -144, -72]; % phi   = [-144, -72, 0, 72, 144];
theta = [-45.723, -105.589, 14.73];
u     = [0.632, 0.636, 0.607]*uc;
[yy, xx] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1);

% find omegaXY
gXY   = squeeze(g(:,:,zBF,1,1));
gXYFT = abs(FT(gXY));
gXYFT = imrotate(gXYFT, -theta(1));
yBF   = 362;
gFTY  = gXYFT(yBF,:);
gFTY  = gFTY./max(gFTY(:));
figure; plot(squeeze(gFTY));