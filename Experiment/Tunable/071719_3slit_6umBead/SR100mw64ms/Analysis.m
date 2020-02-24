run("ExpTunable071719BeadSetup.m");
matFile = CIRLDataPath + "/TunableData/071719_3slit_6umBead/FSIM_071719_3S_6umBead_SR100mw64ms.mat";
load(matFile);
zBF = 171;
yBF = 1+Y/2;

%%
gFT11 = FT(g(:,:,:,1,1));
gFT12 = FT(g(:,:,:,1,2));
gFT13 = FT(g(:,:,:,1,3));
figure;
subplot(2,3,1); imagesc(g(:,:,zBF,1,1)); axis square; colormap jet; xlabel('x'); ylabel('y'); title('phase 0');
subplot(2,3,2); imagesc(g(:,:,zBF,1,2)); axis square; colormap jet; xlabel('x'); ylabel('y'); title('phase 1');
subplot(2,3,3); imagesc(g(:,:,zBF,1,3)); axis square; colormap jet; xlabel('x'); ylabel('y'); title('phase 2');
subplot(2,3,4); imagesc(squeeze(g(yBF,:,:,1,1))'); axis square; colormap jet; xlabel('x'); ylabel('z');
subplot(2,3,5); imagesc(squeeze(g(yBF,:,:,1,2))'); axis square; colormap jet; xlabel('x'); ylabel('z');
subplot(2,3,6); imagesc(squeeze(g(yBF,:,:,1,3))'); axis square; colormap jet; xlabel('x'); ylabel('z');

%%
figure;
subplot(2,3,1); imagesc(log(abs(gFT11(:,:,1+Z/2)))); axis square; colormap jet; xlabel('u'); ylabel('v'); title('phase 0');
subplot(2,3,2); imagesc(log(abs(gFT12(:,:,1+Z/2)))); axis square; colormap jet; xlabel('u'); ylabel('v'); title('phase 1');
subplot(2,3,3); imagesc(log(abs(gFT13(:,:,1+Z/2)))); axis square; colormap jet; xlabel('u'); ylabel('v'); title('phase 2');
subplot(2,3,4); imagesc(squeeze(log(abs(gFT11(1+Y/2,:,:))))'); axis square; colormap jet; xlabel('u'); ylabel('w'); title('phase 0');
subplot(2,3,5); imagesc(squeeze(log(abs(gFT12(1+Y/2,:,:))))'); axis square; colormap jet; xlabel('u'); ylabel('w'); title('phase 1');
subplot(2,3,6); imagesc(squeeze(log(abs(gFT13(1+Y/2,:,:))))'); axis square; colormap jet; xlabel('u'); ylabel('w'); title('phase 2');

%%
yLine = 105;
figure;
subplot(1,2,1); imagesc(g(:,:,zBF,1,1)); axis square; colormap jet; xlabel('x'); ylabel('y'); title('phase 0');
hold on;
line([1,256], [yLine,yLine], 'Color', 'r');
subplot(1,2,2); plot(g(yLine,(100:180),zBF,1,1));
xlabel('x'); title('profile at the line'); ylim([20000,45000]); axis square;

%% fit phases
x = 0:1:X-1;
figure;
for k = 1:size(g,5)
    gCur = g(yBF,:,1+Z/2,1,k);
    gCur = gCur/max(gCur(:));
    y = cos(2*pi*omegaXY(k)*x*dXY + phi(k)*pi/180);
    subplot(1,3,k); plot(gCur(100:180)); ylim([0.7,1]);
    hold on; plot((y(100:180)+1)/10+0.8); xlabel('x'); title(char("phase = " + phi(k))); ylim([0.7,1]); axis square;
end

%% axial alignment
h  = PSFLutz(X, Z, dXY, dZ, p);
[im, jm, Nn] = PatternTunable3DNSlits(X, Y, Z, omegaXY, omegaZ, dXY, dZ, phi, offs, theta, phizDeg, Nslits);
vz = squeeze(im(1,1,:,1,1,2));
vz = vz./max(vz(:));
hz = squeeze(h (1+Y/2,1+X/2,:));
hz = hz./max(hz(:));
figure;  plot(vz, 'DisplayName', 'v(z)'); 
hold on; plot(hz, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value'); suptitle("Visibility and PSF alignment"); legend;

%% PSFs
hm = zeros([size(h),2]);
for m = 1:size(im,6)
    hm(:,:,:,m) = h.*im(1,1,:,1,1,m);
end
figure;
subplot(1,3,1); imagesc(squeeze(hm(110:150,110:150,1+Z/2,1))); axis square; colormap jet; xlabel('x'); ylabel('y'); title('PSF (xy)');
subplot(1,3,2); imagesc(squeeze(hm(1+Y/2,110:150,110:250,1))'); axis square; colormap jet; xlabel('x'); ylabel('z'); title('PSF (xz)');
subplot(1,3,3); imagesc(squeeze(hm(1+Y/2,110:150,110:250,2))'); axis square; colormap jet; xlabel('x'); ylabel('z'); title('PSF*im (xz)');

%% reconstruction result
load('C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\src\GeneratedReport\201911211454_ExpTunableOptMB071719BeadNoDouble_SR100mw64ms\201911211454_ExpTunableOptMB071719BeadNoDouble_SR100mw64ms.mat', 'retVars');

%%
reconOb = retVars{8};
reconOb(reconOb < 0) = 0;
figure;
subplot(1,2,1); imagesc(squeeze(reconOb(:, :, zBF)) ); axis square; colormap jet; xlabel('x'); ylabel('y');
subplot(1,2,2); imagesc(squeeze(reconOb(yBF, :, :))'); axis square; colormap jet; xlabel('x'); ylabel('z');