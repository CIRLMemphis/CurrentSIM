function OSSRPlotXYXZ(widefieldNor, reconObNor, yBest, zBest, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, colormapSet)
%%
figure
subplot(4,4,[1,2,5,6]); imagesc(squeeze(widefieldNor(yBest, :, :))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
rectangle('Position',[xzRegionX(1),xzRegionZ(1),xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(4,4,[3,4,7,8]); imagesc(squeeze(reconObNor  (yBest, :, :))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
rectangle('Position',[xzRegionX(1),xzRegionZ(1),xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(4,4,[9,10,13,14]); imagesc(widefieldNor(:,:,zBest)); axis square; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
rectangle('Position',[xyRegionX(1),xyRegionY(1),xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(4,4,[11,12,15,16]); imagesc(reconObNor  (:,:,zBest)); axis square; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
rectangle('Position',[xyRegionX(1),xyRegionY(1),xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')

%%
figure
subplot(4,4,[1,2,5,6]); imagesc(squeeze(widefieldNor(yBest, xzRegionX, xzRegionZ))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
rectangle('Position',[1,1,xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(4,4,[3,4,7,8]); imagesc(squeeze(reconObNor  (yBest, xzRegionX, xzRegionZ))'); caxis(colorScale); axis image; colorbar; colormap(colormapSet); xlabel('x'); ylabel('z');
rectangle('Position',[1,1,xzRegionX(end)-xzRegionX(1),xzRegionZ(end)-xzRegionZ(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(4,4,[9,10,13,14]); imagesc(widefieldNor(xyRegionY, xyRegionX,zBest)); axis image; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
rectangle('Position',[1,1,xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
subplot(4,4,[11,12,15,16]); imagesc(reconObNor  (xyRegionY, xyRegionX,zBest)); axis image; caxis(colorScale); colorbar; colormap(colormapSet); xlabel('x'); ylabel('y');
rectangle('Position',[1,1,xyRegionX(end)-xyRegionX(1),xyRegionY(end)-xyRegionY(1)],...
  'EdgeColor', 'r',...
  'LineWidth', 3,...
  'LineStyle','-')
end