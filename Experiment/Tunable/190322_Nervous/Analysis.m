run("ExpTunable190322NervousSetup.m");
load(CIRLDataPath + "/TunableData/190322_Nervous/190322_Nervous.mat", 'g');

%% 
zBF = 105;
yBF = 322;

%%
fitRange = 390:420;
yLine = 85;
figure;
subplot(1,2,1); imagesc(g(:,:,zBF,1,1)); axis square; colormap jet; xlabel('x'); ylabel('y'); title('phase 0');
hold on;
line([1,X], [yLine,yLine], 'Color', 'r');
subplot(1,2,2); plot(g(yLine,fitRange,zBF,1,1));
xlabel('x'); title('profile at the line'); axis square;
%ylim([20000,45000]);

%% fit phases
x = 0:1:X-1;
figure;
for k = 1:size(g,5)
    gCur = g(yBF,fitRange,zBF,1,k);
    gCur = gCur/max(gCur(:));
    y = cos(2*pi*omegaXY(k)*x*dXY + phi(k)*pi/180);
    subplot(1,3,k); plot(gCur); ylim([0.7,1]);
    hold on; plot((y(fitRange)+1)/10+0.8); xlabel('x'); title(char("phase = " + phi(k))); ylim([0.7,1]); axis square;
end

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
