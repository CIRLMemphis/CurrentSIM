run("ExpTunable070919Glio512x128SetupAber5.m");
load(CIRLDataPath + "/TunableData/071919_Glioblastoma/070919_Glioblastoma2_Grid512x256.mat", 'g');

%%
zBF = 92;
yBF = 256;
colorSetting = 'hot';

%%
fitRange = 280:320;
yLine = 280;
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
    gCur = g(yLine,fitRange,zBF,1,k);
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
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\GlioForward.png",...
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
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\GlioForwardFFT.png",...
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
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\AxialAlign.png",...
      '-dpng','-r300');

%% reconstruction result
%load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\071719Glio\201912091327_ExpTunableOptMB071719GlioNoDouble_SR100mw2500ms\201912091327_ExpTunableOptMB071719GlioNoDouble_SR100mw2500ms.mat', 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912151756_ExpTunableOptMB071719GlioNoDouble_SR100mw2500msAber5\201912151756_ExpTunableOptMB071719GlioNoDouble_SR100mw2500msAber5.mat", 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912161925_ExpTunableOptMB071719GlioNoDouble_3200ms_75mW_Aber5\201912161925_ExpTunableOptMB071719GlioNoDouble_3200ms_75mW_Aber5.mat", 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912152100_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5Reg1e4\201912152100_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5Reg1e4.mat", 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912152057_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5\201912152057_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5.mat", 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912181933_ExpTunableOptMB071719Glio512x128_3200ms_75mW_Aber5LowNASlits\201912181933_ExpTunableOptMB071719Glio512x128_3200ms_75mW_Aber5LowNASlits.mat", 'retVars')
matObj = matfile(CIRLDataPath + "\Results\071719Glio\201912180226_ExpTunableOptMB070919Glio512x128Aber5\201912180226_ExpTunableOptMB070919Glio512x128Aber5.mat");
retVars = matObj.retVars;

%%
MBReconOb = retVars{8}; clear retVars;
MBReconOb(MBReconOb < 0) = 0;
figure;
subplot(1,2,1); imagesc(squeeze(MBReconOb(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(1,2,2); imagesc(squeeze(MBReconOb(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\MBRecon.png",...
      '-dpng','-r300');

%% post-process the data
omegaXYPxl = 110;
deltaPxl   = 15;
x = 0:30;
y = 1-gaussmf(x,[4 15])*0.97;
figure; plot(x,y);
y = repmat(y, [size(MBReconOb,1), 1, size(MBReconOb,3)]);

figure;
reconFT = FT(MBReconOb);
subplot(2,1,1); imagesc(log(abs(squeeze(reconFT(513, :, :))'))); axis image;  colormap(colorSetting); xlabel('u'); ylabel('w'); title('Before post-processing');
reconFT(:, 513-omegaXYPxl-deltaPxl:513-omegaXYPxl+deltaPxl, :)     = y.*reconFT(:, 513-omegaXYPxl-deltaPxl:513-omegaXYPxl+deltaPxl, :);
reconFT(:, 513+omegaXYPxl-deltaPxl:513+omegaXYPxl+deltaPxl, :)     = y.*reconFT(:, 513+omegaXYPxl-deltaPxl:513+omegaXYPxl+deltaPxl, :);

reconFT(:, 513-omegaXYPxl*2-deltaPxl:513-omegaXYPxl*2+deltaPxl, :) = y.*reconFT(:, 513-omegaXYPxl*2-deltaPxl:513-omegaXYPxl*2+deltaPxl, :);
reconFT(:, 513+omegaXYPxl*2-deltaPxl:513+omegaXYPxl*2+deltaPxl, :) = y.*reconFT(:, 513+omegaXYPxl*2-deltaPxl:513+omegaXYPxl*2+deltaPxl, :);

reconFT(:, 513-omegaXYPxl*3-deltaPxl:513-omegaXYPxl*3+deltaPxl, :) = y.*reconFT(:, 513-omegaXYPxl*3-deltaPxl:513-omegaXYPxl*3+deltaPxl, :);
reconFT(:, 513+omegaXYPxl*3-deltaPxl:513+omegaXYPxl*3+deltaPxl, :) = y.*reconFT(:, 513+omegaXYPxl*3-deltaPxl:513+omegaXYPxl*3+deltaPxl, :);

reconFT(:, 513-omegaXYPxl*4-deltaPxl:513-omegaXYPxl*4+deltaPxl, :) = y.*reconFT(:, 513-omegaXYPxl*4-deltaPxl:513-omegaXYPxl*4+deltaPxl, :);
reconFT(:, 513+omegaXYPxl*4-deltaPxl:513+omegaXYPxl*4+deltaPxl, :) = y.*reconFT(:, 513+omegaXYPxl*4-deltaPxl:513+omegaXYPxl*4+deltaPxl, :);

subplot(2,1,2); imagesc(log(abs(squeeze(reconFT(513, :, :))'))); axis image;  colormap(colorSetting); xlabel('u'); ylabel('w'); title('After post-processing');
cleanRecon = abs(IFT(reconFT));
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\FFTPostProcessing.png",...
      '-dpng','-r300');
  
%%
figure;
subplot(1,2,1); imagesc(squeeze(cleanRecon(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(1,2,2); imagesc(squeeze(cleanRecon(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\PostProcessed.png",...
      '-dpng','-r300');

%%
figure;
subplot(2,2,1); imagesc(squeeze(MBReconOb(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[]); title('MB restoration');
subplot(2,2,2); imagesc(squeeze(cleanRecon(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[]); title('post-processed');
subplot(2,2,3); imagesc(squeeze(MBReconOb(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[])
subplot(2,2,4); imagesc(squeeze(cleanRecon(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\PrevsPost.png",...
      '-dpng','-r300');

% %% show the results w.r.t iterations
% iterRange = 40:10:60;
% figure;
% cnt = 1;
% for iter = iterRange
%     iterInd = iter/10;
%     reconOb = retVars{iterInd};
%     reconOb(reconOb < 0) = 0;
%     reconFT = FT(reconOb);
%    
%     reconFT(:, 513-omegaXYPxl-deltaPxl:513-omegaXYPxl+deltaPxl, :) = 0;
%     reconFT(:, 513+omegaXYPxl-deltaPxl:513+omegaXYPxl+deltaPxl, :) = 0;
% 
%     reconFT(:, 513-omegaXYPxl*2-deltaPxl:513-omegaXYPxl*2+deltaPxl, :) = 0;
%     reconFT(:, 513+omegaXYPxl*2-deltaPxl:513+omegaXYPxl*2+deltaPxl, :) = 0;
% 
%     reconFT(:, 513-omegaXYPxl*3-deltaPxl:513-omegaXYPxl*3+deltaPxl, :) = 0;
%     reconFT(:, 513+omegaXYPxl*3-deltaPxl:513+omegaXYPxl*3+deltaPxl, :) = 0;
% 
%     reconFT(:, 513-omegaXYPxl*4-deltaPxl:513-omegaXYPxl*4+deltaPxl, :) = 0;
%     reconFT(:, 513+omegaXYPxl*4-deltaPxl:513+omegaXYPxl*4+deltaPxl, :) = 0;
%     cleanRecon = abs(IFT(reconFT));
%     
%     subplot(1,length(iterRange),cnt); imagesc(squeeze(cleanRecon(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
%     title("iter = " + iter); set(gca,'xtick',[],'ytick',[])
% %     subplot(2,length(iterRange),length(iterRange)+cnt); imagesc(squeeze(reconOb(yBF, :, :))'); axis square; colormap(colorSetting); xlabel('x'); ylabel('z');
% %     set(gca,'xtick',[],'ytick',[])
%     cnt = cnt + 1;
% end
% print(gcf,...
%       "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0719Aber5LowNASlits\XYIter.png",...
%       '-dpng','-r300');
% 
% figure;
% cnt = 1;
% for iter = iterRange
%     iterInd = iter/10;
%     reconOb = retVars{iterInd};
%     reconOb(reconOb < 0) = 0;
%     reconFT = FT(reconOb);
%    
%     reconFT(:, 513-omegaXYPxl-deltaPxl:513-omegaXYPxl+deltaPxl, :) = 0;
%     reconFT(:, 513+omegaXYPxl-deltaPxl:513+omegaXYPxl+deltaPxl, :) = 0;
% 
%     reconFT(:, 513-omegaXYPxl*2-deltaPxl:513-omegaXYPxl*2+deltaPxl, :) = 0;
%     reconFT(:, 513+omegaXYPxl*2-deltaPxl:513+omegaXYPxl*2+deltaPxl, :) = 0;
% 
%     reconFT(:, 513-omegaXYPxl*3-deltaPxl:513-omegaXYPxl*3+deltaPxl, :) = 0;
%     reconFT(:, 513+omegaXYPxl*3-deltaPxl:513+omegaXYPxl*3+deltaPxl, :) = 0;
% 
%     reconFT(:, 513-omegaXYPxl*4-deltaPxl:513-omegaXYPxl*4+deltaPxl, :) = 0;
%     reconFT(:, 513+omegaXYPxl*4-deltaPxl:513+omegaXYPxl*4+deltaPxl, :) = 0;
%     
%     subplot(1,length(iterRange),cnt); imagesc(squeeze(cleanRecon(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
%     title("iter = " + iter); set(gca,'xtick',[],'ytick',[])
%     cnt = cnt + 1;
% end
% print(gcf,...
%       "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0719Aber5LowNASlits\XZIter.png",...
%       '-dpng','-r300');
  
% %% GWF results
% load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\071719Glio\201912171852_ExpTunable070919Glio512x128GWF\201912171852_ExpTunable070919Glio512x128GWF.mat', 'reconOb');
% GWFreconOb = reconOb;
% GWFreconOb(GWFreconOb < 0) = 0;
% figure;
% subplot(1,2,1); imagesc(squeeze(GWFreconOb(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
% set(gca,'xtick',[],'ytick',[],'title',[])
% subplot(1,2,2); imagesc(squeeze(GWFreconOb(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
% set(gca,'xtick',[],'ytick',[],'title',[])
% print(gcf,...
%       "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\GWFRecon.png",...
%       '-dpng','-r300');
% 
% %%
% figure;
% subplot(2,2,1); imagesc(squeeze(GWFreconOb(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
% set(gca,'xtick',[],'ytick',[]); title('GWF restoration');
% subplot(2,2,2); imagesc(squeeze(MBReconOb(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
% set(gca,'xtick',[],'ytick',[]); title('MB restoration');
% subplot(2,2,3); imagesc(squeeze(GWFreconOb(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
% set(gca,'xtick',[],'ytick',[])
% subplot(2,2,4); imagesc(squeeze(MBReconOb(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
% set(gca,'xtick',[],'ytick',[])
% print(gcf,...
%       "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\GWFvsMB.png",...
%       '-dpng','-r300');
%   
%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\071719Glio\201912171852_ExpTunable070919Glio512x128GWF\201912171852_ExpTunable070919Glio512x128GWF.mat', 'retVars');
GWFWF = retVars{2};
GWFWF(GWFWF < 0) = 0;

figure;
widefieldFT = FT(GWFWF);
subplot(2,1,1); imagesc(log(abs(squeeze(widefieldFT(513, :, :))'))); axis image;  colormap(colorSetting); xlabel('u'); ylabel('w'); title('Before post-processing');
widefieldFT(:, 513-omegaXYPxl-deltaPxl:513-omegaXYPxl+deltaPxl, :) = 0;
widefieldFT(:, 513+omegaXYPxl-deltaPxl:513+omegaXYPxl+deltaPxl, :) = 0;

widefieldFT(:, 513-omegaXYPxl*2-deltaPxl:513-omegaXYPxl*2+deltaPxl, :) = 0;
widefieldFT(:, 513+omegaXYPxl*2-deltaPxl:513+omegaXYPxl*2+deltaPxl, :) = 0;

widefieldFT(:, 513-omegaXYPxl*3-deltaPxl:513-omegaXYPxl*3+deltaPxl, :) = 0;
widefieldFT(:, 513+omegaXYPxl*3-deltaPxl:513+omegaXYPxl*3+deltaPxl, :) = 0;

widefieldFT(:, 513-omegaXYPxl*4-deltaPxl:513-omegaXYPxl*4+deltaPxl, :) = 0;
widefieldFT(:, 513+omegaXYPxl*4-deltaPxl:513+omegaXYPxl*4+deltaPxl, :) = 0;

subplot(2,1,2); imagesc(log(abs(squeeze(widefieldFT(513, :, :))'))); axis image;  colormap(colorSetting); xlabel('u'); ylabel('w'); title('After post-processing');
cleanWF = abs(IFT(widefieldFT));

%% plot the widefield
figure;
subplot(2,1,1); imagesc(squeeze(GWFWF(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(2,1,2); imagesc(squeeze(GWFWF(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\Widefield.png",...
      '-dpng','-r300');
  
%% plot the post-processed widefield
figure;
subplot(2,1,1); imagesc(squeeze(cleanWF(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
set(gca,'xtick',[],'ytick',[],'title',[])
subplot(2,1,2); imagesc(squeeze(cleanWF(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
set(gca,'xtick',[],'ytick',[],'title',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\CleanWidefield.png",...
      '-dpng','-r300');

%%
figure;
subplot(2,2,1); imagesc(squeeze(cleanWF(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
%set(gca,'xtick',[],'ytick',[]); title('post-processed WF');
subplot(2,2,2); imagesc(squeeze(cleanRecon(:, :, zBF)) ); axis image; colormap(colorSetting); xlabel('x'); ylabel('y');
%set(gca,'xtick',[],'ytick',[]); title('post-processed MB');
subplot(2,2,3); imagesc(squeeze(cleanWF(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
%set(gca,'xtick',[],'ytick',[])
subplot(2,2,4); imagesc(squeeze(cleanRecon(yBF, :, :))'); axis image; colormap(colorSetting); xlabel('x'); ylabel('z');
%set(gca,'xtick',[],'ytick',[])
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\CleanWFvsMB.png",...
      '-dpng','-r300');
  
%% XY Full
fh = figure();
fh.WindowState = 'maximized';
subplot(1,2,1); imagesc(squeeze(cleanWF(:, :, zBF)) ); axis image; colormap(colorSetting);
set(gca,'xtick',[],'ytick',[]); title('post-processed WF');
subplot(1,2,2); imagesc(squeeze(cleanRecon(:, :, zBF)) ); axis image; colormap(colorSetting);
set(gca,'xtick',[],'ytick',[]); title('post-processed MB');
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\XYFullCleanWFvsMB.png",...
      '-dpng','-r300');
  
%% XY Zoomed
xyRegionX = 400:800;
xyRegionY = 600:1000;
fh = figure();
fh.WindowState = 'maximized';
subplot(1,2,1); imagesc(squeeze(cleanWF(xyRegionY, xyRegionX, zBF)) ); axis image; colormap(colorSetting);
set(gca,'xtick',[],'ytick',[]); title('zoomed post-processed WF');
subplot(1,2,2); imagesc(squeeze(cleanRecon(xyRegionY, xyRegionX, zBF)) ); axis image; colormap(colorSetting);
set(gca,'xtick',[],'ytick',[]); title('zoomed post-processed MB');
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\XYZoomedCleanWFvsMB.png",...
      '-dpng','-r300');
  
%% XZ Full
fh = figure();
fh.WindowState = 'maximized';
subplot(1,2,1); imagesc(squeeze(cleanWF(yBF, :, :))' ); axis image; colormap(colorSetting);
set(gca,'xtick',[],'ytick',[]); title('post-processed WF');
subplot(1,2,2); imagesc(squeeze(cleanRecon(yBF, :, :))' ); axis image; colormap(colorSetting);
set(gca,'xtick',[],'ytick',[]); title('post-processed MB');
print(gcf,...
      "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\120819_NSFReport\pics\Glio0709Aber5\XZFullCleanWFvsMB.png",...
      '-dpng','-r300');