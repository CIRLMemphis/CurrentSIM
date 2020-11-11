function fig = LSECActinPlot(vars, zBF, yBF, colTitles, supTitle, colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale)
nVars = length(vars);
fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(1,nVars,[.01 .001],[.01 .03],[.01 .01]);
for k = 1:nVars
    curVar  = vars{k};
    if (zBF > size(curVar,3))
        yBFCur = 1 + round(size(curVar,1)/2);
        zBFCur = 1 + round(size(curVar,3)/2);
        xyRegionXCur = round(xyRegionX/2);
        xyRegionYCur = round(xyRegionY/2);
        xzRegionXCur = round(xzRegionX/2);
        xzRegionZCur = round(xzRegionZ/2);
    else
        yBFCur = yBF;
        zBFCur = zBF;
        xyRegionXCur = xyRegionX;
        xyRegionYCur = xyRegionY;
        xzRegionXCur = xzRegionX;
        xzRegionZCur = xzRegionZ;
    end
%     axes(ha(k+(1-1)*nVars));
%     imagesc(curVar(:,:,zBFCur)); axis square off; colormap(colormapSet);
%     %caxis(colorScale);
%     if (~isempty(colTitles))
%         title(colTitles(k));
%     end
    
        axes(ha(k+(1-1)*nVars));
        if (k == nVars)
            imagesc(curVar(xyRegionXCur,xyRegionYCur,zBFCur-1)); axis square off; colormap(colormapSet); 
        else
            imagesc(curVar(xyRegionXCur,xyRegionYCur,zBFCur)); axis square off; colormap(colormapSet);
        end
        caxis(colorScale);

    if 0
    axes(ha(k+(3-1)*nVars));
    imagesc(squeeze(curVar(yBFCur,:,:))'); axis square off; colormap(colormapSet);
    caxis(colorScale);

        axes(ha(k+(4-1)*nVars));
        imagesc(squeeze(curVar(yBFCur,xzRegionXCur,xzRegionZCur))'); axis square off; colormap(colormapSet); 
        caxis(colorScale);
    end
end
if (~isempty(supTitle))
    suptitle(supTitle);
end
end