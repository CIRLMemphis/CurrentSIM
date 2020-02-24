run("../../CIRLSetup.m");

%%
load(CIRLDataPath + "/Simulation/3W/Sim3WOSSRMultiOb256.mat", 'g');
[X,Y,Z,Nthe,Nphi] = size(g);
g3W = g;

%%
figure;
subplot(2,1,1); imagesc(g3W(:,:,1+Z/2,1,1));           axis square; xlabel('x'); ylabel('y'); colormap('jet'); colorbar;
subplot(2,1,2); imagesc(squeeze(g3W(1+Y/2,:,:,1,1))'); axis square; xlabel('u'); ylabel('v'); colormap('jet'); colorbar;

%%
load(CIRLDataPath + "/Simulation/Tunable/SimTunable3SlitsOSSRMultiOb256.mat", 'g');
[X,Y,Z,Nthe,Nphi] = size(g);
gTN3Slits = g;

%%
figure;
subplot(2,1,1); imagesc(gTN3Slits(:,:,1+Z/2,1,1));           axis square; xlabel('x'); ylabel('y'); colormap('jet'); colorbar;
subplot(2,1,2); imagesc(squeeze(gTN3Slits(1+Y/2,:,:,1,1))'); axis square; xlabel('u'); ylabel('v'); colormap('jet'); colorbar;