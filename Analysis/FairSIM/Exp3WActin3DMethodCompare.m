run("../../CIRLSetup.m");
colormapSet = 'jet';
colorScale  = [0 1.0];
shouldScale = 0;
xzRegionX   = 450:650;
xzRegionZ   =   1:50;
xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;
yBest       = 512;
zBest       = 13;

%% load the reconstruction results
expNames = ["201910151247_Exp3WOptGWFActinFull",   ...
            "201910170618_Exp3WMBActinFullIter100",...
            "201910171618_Exp3WMBPCActinFullIter100"];
iterInd  = [0, 10, 8];
load(CIRLDataPath + "\Results\FairSIM\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'retVars');
 
%% load GWF result
GWFObNor = reconOb./sum(reconOb(:));
GWFObNor(GWFObNor < 0) = 0;
GWFObNor = GWFObNor/max(GWFObNor(:));

%% load the GWF widefield
widefield = retVars{2};
widefieldNor = widefield./sum(widefield(:));
widefieldNor(widefieldNor < 0) = 0;
widefieldNor = widefieldNor/max(widefieldNor(:));

%% load the MB results
load(CIRLDataPath + "\Results\FairSIM\" + expNames(2) + "\" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb = retVars{iterInd(2)};
MBObNor = reconOb./sum(reconOb(:));
MBObNor(MBObNor < 0) = 0;
MBObNor = MBObNor/max(MBObNor(:));

%% load the MBPC results
load(CIRLDataPath + "\Results\FairSIM\" + expNames(3) + "\" + expNames(3) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb   = retVars{iterInd(3)};
MBPCObNor = reconOb./sum(reconOb(:));
MBPCObNor(MBPCObNor < 0) = 0;
MBPCObNor = MBPCObNor/max(MBPCObNor(:));
MBPCObNor = MBPCObNor/max(MBPCObNor(:))/0.5;

%% XY plan
%colormapSet = 'gray';

figure
subplot(1,4,1); imagesc(widefieldNor(:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('GWF-WF Full');
subplot(1,4,2); imagesc(GWFObNor    (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(1,4,3); imagesc(MBObNor     (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
subplot(1,4,4); imagesc(MBPCObNor   (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MBPC Full');

xyRegionX   =   50:350;
xyRegionY   =   50:350;
figure;
subplot(1,4,1); imagesc(widefieldNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed GWF-WF');
subplot(1,4,2); imagesc(GWFObNor    (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(1,4,3); imagesc(MBObNor     (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
subplot(1,4,4); imagesc(MBPCObNor   (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MBPC');

xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;
figure;
subplot(1,4,1); imagesc(widefieldNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed GWF-WF');
subplot(1,4,2); imagesc(GWFObNor    (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(1,4,3); imagesc(MBObNor     (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
subplot(1,4,4); imagesc(MBPCObNor   (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MBPC');

%% XZ plan
%colormapSet = 'gray';

figure
subplot(4,1,1); imagesc(squeeze(widefieldNor(yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('GWF-WF Full');
subplot(4,1,2); imagesc(squeeze(GWFObNor    (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(4,1,3); imagesc(squeeze(MBObNor     (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MB Full');
subplot(4,1,4); imagesc(squeeze(MBPCObNor   (yBest, :,:))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MBPC Full');

figure;
subplot(4,1,1); imagesc(squeeze(widefieldNor(yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed GWF-WF');
subplot(4,1,2); imagesc(squeeze(GWFObNor    (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(4,1,3); imagesc(squeeze(MBObNor     (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MB');
subplot(4,1,4); imagesc(squeeze(MBPCObNor   (yBest, xzRegionX, xzRegionZ))'); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MBPC');

% %%
% figure
% subplot(6,4,[1,2]); imagesc(squeeze(widefieldNor(yBest, xzRegionX, xzRegionZ))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
% rectangle('Position',[1,1,xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
%   'EdgeColor', 'r',...
%   'LineWidth', 3,...
%   'LineStyle','-')
% subplot(6,4,[3,4]); imagesc(squeeze(GWFObNor(yBest, xzRegionX, xzRegionZ))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
% rectangle('Position',[1,1,xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
%   'EdgeColor', 'r',...
%   'LineWidth', 3,...
%   'LineStyle','-')
% subplot(6,4,[5,6]); imagesc(squeeze(MBObNor(yBest, xzRegionX, xzRegionZ))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
% rectangle('Position',[1,1,xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
%   'EdgeColor', 'r',...
%   'LineWidth', 3,...
%   'LineStyle','-')
% subplot(6,4,[7,8]); imagesc(squeeze(MBPCObNor(yBest, xzRegionX, xzRegionZ))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
% rectangle('Position',[1,1,xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
%   'EdgeColor', 'r',...
%   'LineWidth', 3,...
%   'LineStyle','-')
% subplot(6,4, [ 9,10,13,14]); imagesc(widefieldNor(xyRegionY, xyRegionX,zBest)); axis image; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
% rectangle('Position',[1,1,xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
%   'EdgeColor', 'r',...
%   'LineWidth', 3,...
%   'LineStyle','-')
% subplot(6,4, [11,12,15,16]); imagesc(GWFObNor(xyRegionY, xyRegionX,zBest)); axis image; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
% rectangle('Position',[1,1,xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
%   'EdgeColor', 'r',...
%   'LineWidth', 3,...
%   'LineStyle','-')
% subplot(6,4, [17,18,21,22]); imagesc(MBObNor(xyRegionY, xyRegionX,zBest)); axis image; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
% rectangle('Position',[1,1,xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
%   'EdgeColor', 'r',...
%   'LineWidth', 3,...
%   'LineStyle','-')
% subplot(6,4, [19,20,23,24]); imagesc(MBPCObNor(xyRegionY, xyRegionX,zBest)); axis image; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
% rectangle('Position',[1,1,xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
%   'EdgeColor', 'r',...
%   'LineWidth', 3,...
%   'LineStyle','-')