function fig = U2OSActinPlotIter(vars, zBF, yBF, colTitles, supTitle, colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, shouldHalf, plotXZ)
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
            tmpImg = squeeze(curVar(yBFCur,xyRegionYCur,:))';
            tmpImg = tmpImg/max(tmpImg(:));
            imagesc(tmpImg); axis image off; colormap(colormapSet);
            caxis(colorScale);
        
    end
    
    % plot the profile along z axis
    profColor = {"red", "magenta", "blue", "black"};
    figure;
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
        tmpImg = squeeze(curVar(yBFCur,xyRegionYCur,:));
        tmpImg = tmpImg/max(tmpImg(:));
        img = squeeze(tmpImg(85,:));
        hold on; plot(img,'LineWidth',4, 'Color', profColor{k});
    end
    lblInd = 0:8:size(tmpImg, 2);
    set(gca,'XTick', lblInd );
    set(gca,'XTickLabel', lblInd*0.0625);
    ylim([0 1])
    ylabel('Intensity'); xlabel("Distance along z direction (um)");
    legend('widefield', 'FairSIM', 'GWF', 'MBPC');
    
    % plot the profile along z axis
    figure;
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
        tmpImg = squeeze(curVar(yBFCur,xyRegionYCur,:));
        tmpImg = tmpImg/max(tmpImg(:));
        img = squeeze(tmpImg(:,12));
        hold on; plot(img,'LineWidth',4, 'Color', profColor{k});
    end
    lblInd = 0:20:size(tmpImg, 1);
    set(gca,'XTick', lblInd );
    set(gca,'XTickLabel', lblInd*0.08/2);
    ylim([0 1])
    ylabel('Intensity'); xlabel("Distance along x direction (um)");
    legend('widefield', 'FairSIM', 'GWF', 'MBPC');
end
end