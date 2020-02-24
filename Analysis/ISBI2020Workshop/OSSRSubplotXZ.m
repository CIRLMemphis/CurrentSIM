function fig = OSSRSubplotXZ(vars, zBF, yBF, colTitles, supTitle, colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale)
nVars = length(vars);
fig   = figure();
fig.WindowState = 'maximized';
[ha, pos] = TightSubplot(1,nVars,[.01 .001],[.01 .03],[.01 .01]);
for k = 1:nVars
    curVar  = vars{k};
    if (zBF > size(curVar,3))
        yBFCur = 1 + size(curVar,1)/2;
    else
        yBFCur = yBF;
    end

    axes(ha(k+(1-1)*nVars));
    imagesc(squeeze(curVar(yBFCur,:,:))'); axis square off; colormap(colormapSet);
    caxis(colorScale);
    if (~isempty(colTitles))
        title(colTitles(k));
    end
end
fig   = figure();
fig.WindowState = 'maximized';
[ha, pos] = TightSubplot(1,nVars,[.01 .001],[.01 .03],[.01 .01]);
for k = 1:nVars
    curVar  = vars{k};
    if (zBF > size(curVar,3))
        yBFCur = 1 + size(curVar,1)/2;
        xzRegionXCur = round(xzRegionX/2);
        xzRegionZCur = round(xzRegionZ/2);
    else
        yBFCur = yBF;
        xzRegionXCur = xzRegionX;
        xzRegionZCur = xzRegionZ;
    end

    axes(ha(k+(1-1)*nVars));
    imagesc(squeeze(curVar(yBFCur,xzRegionXCur,xzRegionZCur))'); axis square off; colormap(colormapSet); 
    caxis(colorScale);
    if (~isempty(colTitles))
        title(colTitles(k));
    end
end
if (~isempty(supTitle))
    suptitle(supTitle);
end
end