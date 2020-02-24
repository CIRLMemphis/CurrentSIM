run("C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\src\Simulation\3W\OSSRMultiOb\Sim3WOSSRMultiOb256Setup.m");
load(CIRLDataPath + "/Simulation/3W/Sim3WOSSRMultiOb256SNR15dB.mat", 'g');

%%
zBF = 129;
yBF = 129;
colorSetting = 'gray';

%%
gFT11 = FT(g(:,:,:,1,1));
gFT12 = FT(g(:,:,:,1,2));
gFT14 = FT(g(:,:,:,1,4));
figure;
subplot(2,3,1); imagesc(g(:,:,zBF,1,1)); axis square; colormap(colorSetting); xlabel('x'); ylabel('y'); title('phase 0');
subplot(2,3,2); imagesc(g(:,:,zBF,1,2)); axis square; colormap(colorSetting); xlabel('x'); ylabel('y'); title('phase 1');
subplot(2,3,3); imagesc(g(:,:,zBF,1,4)); axis square; colormap(colorSetting); xlabel('x'); ylabel('y'); title('phase 3');
subplot(2,3,4); imagesc(squeeze(g(yBF,:,:,1,1))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
subplot(2,3,5); imagesc(squeeze(g(yBF,:,:,1,2))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
subplot(2,3,6); imagesc(squeeze(g(yBF,:,:,1,4))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');

%%
figure;
subplot(2,3,1); imagesc(log(abs(gFT11(:,:,1+Z/2)))); axis square; colormap(colorSetting); xlabel('u'); ylabel('v'); title('phase 0');
subplot(2,3,2); imagesc(log(abs(gFT12(:,:,1+Z/2)))); axis square; colormap(colorSetting); xlabel('u'); ylabel('v'); title('phase 1');
subplot(2,3,3); imagesc(log(abs(gFT14(:,:,1+Z/2)))); axis square; colormap(colorSetting); xlabel('u'); ylabel('v'); title('phase 3');
subplot(2,3,4); imagesc(squeeze(log(abs(gFT11(1+Y/2,:,:))))'); axis square; colormap(colorSetting); xlabel('u'); ylabel('w'); title('phase 0');
subplot(2,3,5); imagesc(squeeze(log(abs(gFT12(1+Y/2,:,:))))'); axis square; colormap(colorSetting); xlabel('u'); ylabel('w'); title('phase 1');
subplot(2,3,6); imagesc(squeeze(log(abs(gFT14(1+Y/2,:,:))))'); axis square; colormap(colorSetting); xlabel('u'); ylabel('w'); title('phase 3');

%% axial alignment
zBF = 1 + Z/2;
h  = PSFAgard( X, Z, dXY, dZ);
[im, jm, Nn] = Pattern3W3D(X, Y, Z, u, w, dXY, dZ, phi, offs, theta, phizDeg);
vz = squeeze(im(1,1,:,1,1,3));
vz = vz./max(vz(:));
hz = squeeze(h (1+Y/2,1+X/2,:));
hz = hz./max(hz(:));
figure;  plot(vz, 'DisplayName', 'v(z)'); 
hold on; plot(hz, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value'); suptitle("Visibility and PSF at zBF = " + num2str(zBF)); legend;

%% reconstruction result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\071719Glio\201912091327_ExpTunableOptMB071719GlioNoDouble_SR100mw2500ms\201912091327_ExpTunableOptMB071719GlioNoDouble_SR100mw2500ms.mat', 'retVars');

%% get the widefield
wf = zeros(X,Y,Z);
for l = 1:size(g,4)
    for k = 1:size(g,5)
        wf = wf + g(:,:,:,l,k);
    end
end

%%
figure;
subplot(1,2,1); imagesc(squeeze(wf(:, :, zBF)) ); axis square; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(1,2,2); imagesc(squeeze(wf(yBF, :, :))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])

%%
reconOb = retVars{5};
reconOb(reconOb < 0) = 0;
figure;
subplot(1,2,1); imagesc(squeeze(reconOb(:, :, zBF)) ); axis square; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(1,2,2); imagesc(squeeze(reconOb(yBF, :, :))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])

%%
figure;
subplot(2,2,1); imagesc(squeeze(wf(:, :, zBF)) ); axis square; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[]); title('widefield');
subplot(2,2,2); imagesc(squeeze(reconOb(:, :, zBF)) ); axis square; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[]); title('restored');
subplot(2,2,3); imagesc(squeeze(wf(yBF, :, :))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[])
subplot(2,2,4); imagesc(squeeze(reconOb(yBF, :, :))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[])

%% show the results w.r.t iterations
iterRange = 40:10:60;
figure;
cnt = 1;
for iter = iterRange
    iterInd = iter/10;
    reconOb = retVars{iterInd};
    reconOb(reconOb < 0) = 0;
    subplot(1,length(iterRange),cnt); imagesc(squeeze(reconOb(:, :, zBF)) ); axis square; colormap(colorSetting); xlabel('x'); ylabel('y');
    title("iter = " + iter); set(gca,'xtick',[],'ytick',[])
%     subplot(2,length(iterRange),length(iterRange)+cnt); imagesc(squeeze(reconOb(yBF, :, :))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
%     set(gca,'xtick',[],'ytick',[])
    cnt = cnt + 1;
end
figure;
cnt = 1;
for iter = iterRange
    iterInd = iter/10;
    reconOb = retVars{iterInd};
    reconOb(reconOb < 0) = 0;
    subplot(1,length(iterRange),cnt); imagesc(squeeze(reconOb(yBF, :, :))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
    title("iter = " + iter); set(gca,'xtick',[],'ytick',[])
    cnt = cnt + 1;
end