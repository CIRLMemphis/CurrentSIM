run("ExpTunable071719GlioSetup.m");
load(CIRLDataPath + "/TunableData/071919_Glioblastoma/FSIM_071719_3S_GB_SR100mw2500ms_Grid512.mat", 'g');

%%
zBF = 129;
yBF = 257;
colorSetting = 'gray';

%%
fitRange = 300:340;
yLine = yBF;
figure;
subplot(1,2,1); imagesc(g(:,:,zBF,1,1)); axis square; colormap(colorSetting); xlabel('x'); ylabel('y'); title('phase 0');
hold on;
line([1,X], [yLine,yLine], 'Color', 'r');
subplot(1,2,2); plot(g(yLine,:,zBF,1,1));
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
subplot(2,2,1); imagesc(g(:,:,zBF,1,1)); axis image; colormap(colorSetting); xlabel('x'); ylabel('y'); title('phase 0');
subplot(2,2,2); imagesc(g(:,:,zBF,1,2)); axis image; colormap(colorSetting); xlabel('x'); ylabel('y'); title('phase 1');
%subplot(2,3,3); imagesc(g(:,:,zBF,1,3)); axis square; colormap(colorSetting); xlabel('x'); ylabel('y'); title('phase 2');
subplot(2,2,3); imagesc(squeeze(g(yBF,:,:,1,1))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
subplot(2,2,4); imagesc(squeeze(g(yBF,:,:,1,2))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
%subplot(2,3,6); imagesc(squeeze(g(yBF,:,:,1,3))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\GlioForward.png",...
      '-dpng','-r300');

%%
figure;
subplot(2,2,1); imagesc(log(abs(gFT11(:,:,1+Z/2)))); axis image; colormap(colorSetting); xlabel('u'); ylabel('v'); title('phase 0');
subplot(2,2,2); imagesc(log(abs(gFT12(:,:,1+Z/2)))); axis image; colormap(colorSetting); xlabel('u'); ylabel('v'); title('phase 1');
%subplot(2,3,3); imagesc(log(abs(gFT13(:,:,1+Z/2)))); axis image; colormap(colorSetting); xlabel('u'); ylabel('v'); title('phase 2');
subplot(2,2,3); imagesc(squeeze(log(abs(gFT11(1+Y/2,:,:))))'); axis image; colormap(colorSetting); xlabel('u'); ylabel('w'); title('phase 0');
subplot(2,2,4); imagesc(squeeze(log(abs(gFT12(1+Y/2,:,:))))'); axis image; colormap(colorSetting); xlabel('u'); ylabel('w'); title('phase 1');
%subplot(2,3,6); imagesc(squeeze(log(abs(gFT13(1+Y/2,:,:))))'); axis image; colormap(colorSetting); xlabel('u'); ylabel('w'); title('phase 2');
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\GlioForwardFFT.png",...
      '-dpng','-r300');

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

%% reconstruction result
%load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\071719Glio\201912091327_ExpTunableOptMB071719GlioNoDouble_SR100mw2500ms\201912091327_ExpTunableOptMB071719GlioNoDouble_SR100mw2500ms.mat', 'retVars');
load(CIRLDataPath + "\Results\071719Glio\201912151756_ExpTunableOptMB071719GlioNoDouble_SR100mw2500msAber5\201912151756_ExpTunableOptMB071719GlioNoDouble_SR100mw2500msAber5.mat", 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912152100_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5Reg1e4\201912152100_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5Reg1e4.mat", 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912152057_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5\201912152057_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5.mat", 'retVars');

%% get the widefield
wf = zeros(X,Y,Z);
for l = 1:size(g,4)
    for k = 1:size(g,5)
        wf = wf + g(:,:,:,l,k);
    end
end

%%
figure;
subplot(2,1,1); imagesc(squeeze(wf(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(2,1,2); imagesc(squeeze(wf(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\Widefield.png",...
      '-dpng','-r300');

%%
reconOb = retVars{5};
reconOb(reconOb < 0) = 0;
figure;
subplot(1,2,1); imagesc(squeeze(reconOb(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(1,2,2); imagesc(squeeze(reconOb(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\MBRecon.png",...
      '-dpng','-r300');

%% post-process the data
figure;
reconFT = FT(reconOb);
subplot(2,1,1); imagesc(log(abs(squeeze(reconFT(257, :, :))'))); axis image;  colormap(colorSetting); xlabel('u'); ylabel('w'); title('Before post-processing');
reconFT(:, 350:385, :) = 0;
%reconFT(:, 362:372, :) = 0;
reconFT(:, 130:160, :) = 0;
%reconFT(:, 142:152, :) = 0;
reconFT(:, 472:482, :) = 0;
reconFT(:,  32:42 , :) = 0;
subplot(2,1,2); imagesc(log(abs(squeeze(reconFT(257, :, :))'))); axis image;  colormap(colorSetting); xlabel('u'); ylabel('w'); title('After post-processing');
cleanRecon = abs(IFT(reconFT));
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\FFTPostProcessing.png",...
      '-dpng','-r300');
  
%%
figure;
subplot(1,2,1); imagesc(squeeze(cleanRecon(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(1,2,2); imagesc(squeeze(cleanRecon(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\PostProcessed.png",...
      '-dpng','-r300');

%%
figure;
subplot(2,2,1); imagesc(squeeze(reconOb(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[]); title('MB restoration');
subplot(2,2,2); imagesc(squeeze(cleanRecon(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[]); title('post-processed');
subplot(2,2,3); imagesc(squeeze(reconOb(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[])
subplot(2,2,4); imagesc(squeeze(cleanRecon(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\PrevsPost.png",...
      '-dpng','-r300');

%% show the results w.r.t iterations
iterRange = 40:10:60;
figure;
cnt = 1;
for iter = iterRange
    iterInd = iter/10;
    reconOb = retVars{iterInd};
    reconOb(reconOb < 0) = 0;
    reconFT = FT(reconOb);
   
    reconFT(:, 350:385, :) = 0;
    %reconFT(:, 362:372, :) = 0;
    reconFT(:, 130:160, :) = 0;
    %reconFT(:, 142:152, :) = 0;
    reconFT(:, 472:482, :) = 0;
    reconFT(:,  32:42 , :) = 0;
    cleanRecon = abs(IFT(reconFT));
    
    subplot(1,length(iterRange),cnt); imagesc(squeeze(cleanRecon(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
    title("iter = " + iter); set(gca,'xtick',[],'ytick',[])
%     subplot(2,length(iterRange),length(iterRange)+cnt); imagesc(squeeze(reconOb(yBF, :, :))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
%     set(gca,'xtick',[],'ytick',[])
    cnt = cnt + 1;
end
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\XYIter.png",...
      '-dpng','-r300');

figure;
cnt = 1;
for iter = iterRange
    iterInd = iter/10;
    reconOb = retVars{iterInd};
    reconOb(reconOb < 0) = 0;
    reconFT = FT(reconOb);
   
    reconFT(:, 350:385, :) = 0;
    %reconFT(:, 362:372, :) = 0;
    reconFT(:, 130:160, :) = 0;
    %reconFT(:, 142:152, :) = 0;
    reconFT(:, 472:482, :) = 0;
    reconFT(:,  32:42 , :) = 0;
    cleanRecon = abs(IFT(reconFT));
    
    subplot(1,length(iterRange),cnt); imagesc(squeeze(cleanRecon(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
    title("iter = " + iter); set(gca,'xtick',[],'ytick',[])
    cnt = cnt + 1;
end
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\GlioAber5PostProcessing\XZIter.png",...
      '-dpng','-r300');