function fig = FairSIMSubplot(vars, zBF, yBF, colTitles, supTitle, colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale)
nVars = length(vars);
fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2,4,[.01 .001],[.01 .03],[.01 .01]);

%% resolution pixel computation
dx     = 0.224;
dXY    = 0.02;
dx_arc = dx*(6*4)/(2*pi*dXY);
dx_SIM = 0.125;
dx_SIM_arc = dx_SIM*(6*4)/(2*pi*dXY);

dz     = 0.525;
dZ     = 0.02;
dz_arc = dz*(6*4)/(2*pi*dZ);
dz_SIM = 0.367;
dz_SIM_arc = dz_SIM*(6*4)/(2*pi*dZ);

for k = 1:nVars
    curVar  = vars{k};
    if (zBF > size(curVar,3))
        yBFCur = 1 + size(curVar,1)/2;
        zBFCur = 1 + size(curVar,3)/2;
    else
        yBFCur = yBF;
        zBFCur = zBF;
    end
    axes(ha(k+(1-1)*nVars));
    imagesc(curVar(:,:,zBFCur)); axis square off; colormap(colormapSet);
    if (zBF > size(curVar,3))
        viscircles([128, 128], dx_arc/2,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'red');
        viscircles([128, 128], dx_SIM_arc/2, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'blue');
    else
        viscircles([256, 256], dx_arc,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'red');
        viscircles([256, 256], dx_SIM_arc, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'blue');
    end
    %caxis(colorScale);
    if (~isempty(colTitles))
        title(colTitles(k));
    end
    zoom on
    zoom(3)
    zoom off
end
if (~isempty(supTitle))
    suptitle(supTitle);
end

fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2,4,[.01 .001],[.01 .03],[.01 .01]);
for k = 1:nVars
    curVar  = vars{k};
    if (zBF > size(curVar,3))
        yBFCur = 1 + size(curVar,1)/2;
        zBFCur = 1 + size(curVar,3)/2;
    else
        yBFCur = yBF;
        zBFCur = zBF;
    end
    
    axes(ha(k+(1-1)*nVars));
    imagesc(squeeze(curVar(yBFCur,:,:))'); axis square off; colormap(colormapSet);
    %caxis(colorScale);
    if (zBF > size(curVar,3))
        viscircles([128, 128], dz_arc/2,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'yellow');
        viscircles([128, 128], dz_SIM_arc/2, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'green');
    else
        viscircles([256, 256], dz_arc,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'yellow');
        viscircles([256, 256], dz_SIM_arc, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'green');
    end
    if (~isempty(colTitles))
        title(colTitles(k));
    end
end
if (~isempty(supTitle))
    suptitle(supTitle);
end
end