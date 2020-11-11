function fig = U2OSActinPlot(vars, zBF, yBF, colTitles, supTitle, colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, shouldHalf, plotXZ)
nVars = length(vars);
fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(1,nVars,[.01 .001],[.01 .03],[.01 .01]);

for k = 1:nVars
    curVar  = vars{k};
    if (shouldHalf(k) == 1)
        yBFCur = round(yBF/2);
        zBFCur = round(zBF/2);
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
        imagesc(curVar(xyRegionXCur,xyRegionYCur,zBFCur(k))); axis square off; colormap(colormapSet); 
        caxis(colorScale);
end
if (~isempty(supTitle))
    suptitle(supTitle);
end

if plotXZ
    fig   = figure('Position', get(0, 'Screensize'));
    [ha, pos] = TightSubplot(1,nVars,[.01 .001],[.01 .03],[.01 .01]);
    for k = 1:nVars
        curVar  = vars{k};
        if (shouldHalf(k) == 1)
            yBFCur = round(yBF/2);
            zBFCur = round(zBF/2);
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
            axes(ha(k+(1-1)*nVars));
            imagesc(squeeze(curVar(yBFCur,xyRegionYCur,:))'); axis image off; colormap(colormapSet);
            caxis(colorScale);
        
    end
end
end