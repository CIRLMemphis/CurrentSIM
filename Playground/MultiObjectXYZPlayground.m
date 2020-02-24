run("../CIRLSetup.m");
X     = 256;       % discrete lateral size in voxels
Y     = 256;       % discrete lateral size in voxels
Z     = 256;        % discrete axial size in voxels
dXY   = 0.025;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.025;     % axial voxel scaling in microns

obXYZ = MultiObjectXYZ(X, Z, dXY, dZ);
% obXY  = SSRMultiObject(X, Z, dXY, dZ);

figure; 
subplot(1,2,1);
imagesc(obXYZ(:,:,Z/2)); axis square; colormap gray;
subplot(1,2,2);
imagesc(squeeze(obXYZ(Y/2,:,:))'); axis square; colormap gray;

figure; plot(obXYZ(Y/2, :, Z/2))

% figure; 
% subplot(1,2,1);
% imagesc(obXY(:,:,Z/2)); axis square; colormap gray;
% subplot(1,2,2);
% imagesc(squeeze(obXY(Y/2,:,:))'); axis square; colormap gray;