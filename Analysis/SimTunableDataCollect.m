run("../Simulation/Tunable/MultiOb/SimTunableMultiOb256Setup.m");
colormapSet = 'gray';

%% load the reconstruction results
expName = '201908211658_SimTunableGWFMultiOb';
load(CIRLDataPath + "/Results/" + expName + "/" + expName + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'g');

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
HROb = MultiObject(X*2, Z*2, dXY/2, dZ/2);
[im, jm, Nn] = PatternTunable3D3Slits(X2, Y2, Z2, u, w, dXY/2, dZ/2, phi, offs, theta, phizDeg);

h  = PSFAgard( X2, Z2, dXY/2, dZ/2);
HRg  = ForwardModel(HROb, h, im, jm);

%% True Object
z2BF      = 1 + Z2/2;
y2BF      = 1 + Y2/2;
midOff   = 41;
midSlice = y2BF-midOff-1:y2BF+midOff-1;
TrueObFig = figure('Position', get(0, 'Screensize'));
subplot(3,1,1); 
imagesc(HROb(:,:,z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title('True Object');
subplot(3,1,2);
imagesc(squeeze(HROb(y2BF,:,:))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z');
subplot(3,1,3);
imagesc(HROb(midSlice, midSlice, z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); title('Zoomed-in middle');
saveas(TrueObFig, "TrueObject.jpg");


%% HR forward images
Nphi = length(phi);
HRForwardFig = figure('Position', get(0, 'Screensize'));
ct = 0;
for k = 1:Nphi
    ct = ct + 1;
    subplot(2,Nphi,ct); 
    imagesc(HRg(:,:,z2BF,1,k)); axis square; colormap(colormapSet); colorbar;
    xlabel('x'); ylabel('y'); title("Phase " + num2str(k));
end
for k = 1:Nphi
    ct = ct + 1;
    subplot(2,Nphi,ct);
    imagesc(squeeze(HRg(y2BF,:,:,1,k))'); axis square; colormap(colormapSet); colorbar;
    xlabel('x'); ylabel('z');
end
suptitle('HR forward image for orientation 0');
saveas(HRForwardFig, "TunableHRForwardImage.jpg");


%% Forward images
zBF        = 1 + Z/2;
yBF        = 1 + Y/2;
ct         = 0;
ForwardFig = figure('Position', get(0, 'Screensize'));
for k = 1:Nphi
    ct = ct + 1;
    subplot(2,Nphi,ct); 
    imagesc(g(:,:,zBF,1,k)); axis square; colormap(colormapSet); colorbar;
    xlabel('x'); ylabel('y'); title("Phase " + num2str(k));
end
for k = 1:Nphi
    ct = ct + 1;
    subplot(2,Nphi,ct);
    imagesc(squeeze(g(yBF,:,:,1,k))'); axis square; colormap(colormapSet); colorbar;
    xlabel('x'); ylabel('z');
end
suptitle('Forward image for orientation 0');
saveas(ForwardFig, "TunableForwardImage.jpg");

%%
SimDownsamplingFig = figure('Position', get(0, 'Screensize'));
subplot(2,3,1); 
imagesc(HROb(:,:,z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title("True Object");
subplot(2,3,4);
imagesc(squeeze(HROb(y2BF,:,:))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z');

subplot(2,3,2); 
imagesc(HRg(:,:,z2BF,1,1)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title("HR Image " + num2str(1));
subplot(2,3,5);
imagesc(squeeze(HRg(y2BF,:,:,1,1))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z');

subplot_tight(2,3,3, [0.15 0.15])
imagesc(g(:,:,zBF,1,1)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title("LR Image" + num2str(1));
subplot_tight(2,3,6, [0.15 0.15])
imagesc(squeeze(g(yBF,:,:,1,1))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z');

suptitle('Simulated data process');
saveas(SimDownsamplingFig, "SimDownsampling.jpg");
