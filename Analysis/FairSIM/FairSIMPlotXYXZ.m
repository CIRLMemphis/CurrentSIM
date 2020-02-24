function FairSIMPlotXYXZ(widefieldNor, reconObNor, yBest, zBest, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, colormapSet)
%%
figure
subplot(6,4,1:4); imagesc(squeeze(widefieldNor(yBest, :, :))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
rectangle('Position',[xzRegionX(1),xzRegionZ(1),xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(6,4,5:8); imagesc(squeeze(reconObNor  (yBest, :, :))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
rectangle('Position',[xzRegionX(1),xzRegionZ(1),xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(6,4, [ 9,10,13,14,17,18,21,22]); imagesc(widefieldNor(:,:,zBest)); axis square; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
rectangle('Position',[xyRegionX(1),xyRegionY(1),xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(6,4, [11,12,15,16,19,20,23,24]); imagesc(reconObNor  (:,:,zBest)); axis square; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
rectangle('Position',[xyRegionX(1),xyRegionY(1),xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')

%%
figure
subplot(6,4,1:4); imagesc(squeeze(widefieldNor(yBest, xzRegionX, xzRegionZ))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
rectangle('Position',[1,1,xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(6,4,5:8); imagesc(squeeze(reconObNor  (yBest, xzRegionX, xzRegionZ))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
rectangle('Position',[1,1,xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(6,4, [ 9,10,13,14,17,18,21,22]); imagesc(widefieldNor(xyRegionY, xyRegionX,zBest)); axis image; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
rectangle('Position',[1,1,xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(6,4, [11,12,15,16,19,20,23,24]); imagesc(reconObNor  (xyRegionY, xyRegionX,zBest)); axis image; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
rectangle('Position',[1,1,xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
end