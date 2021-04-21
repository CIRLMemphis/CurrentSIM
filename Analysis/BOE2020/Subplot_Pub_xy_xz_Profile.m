function fig = Subplot_Pub_xy_xz_Profile(vars, zBF, yBF, colTitles, supTitle, colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale)
nVars = length(vars);
fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2,5,[.01 .001],[.15 .15],[.03 .01]);

%% resolution pixel computation
dx     = 0.224;
dXY    = 0.02;
dx_arc = dx*(6*4)/(2*pi*dXY);
dx_SIM = 0.150;
dx_SIM_arc = dx_SIM*(6*4)/(2*pi*dXY);

dz     = 0.525;
dZ     = 0.02;
dz_arc = dz*(6*4)/(2*pi*dZ);
dz_SIM = 0.310;
dz_SIM_arc = dz_SIM*(6*4)/(2*pi*dZ);

% plot the zoom in
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
        amp = dx_SIM_arc/2;
    else
        amp = dx_SIM_arc;
    end
    caxis(colorScale);
    zoom on
    zoom(3)
    zoom off
    offX = 256;
    offY = 256;
    sampleN = 500;
        theta = linspace(pi/2+pi/4, 3*pi/2-pi/4, sampleN);
        % r = amp*(1-2.5*sin(theta));
        r = amp;
        hold on; plot(offX+(r.*cos(theta)), offY+(r.*sin(theta)),'LineWidth',3,'Color', 'blue');
end

if (~isempty(supTitle))
    suptitle(supTitle);
end

% plot the zoom-in
for k = 1:nVars
    curVar  = vars{k};
    if (zBF > size(curVar,3))
        yBFCur = 1 + size(curVar,1)/2;
        zBFCur = 1 + size(curVar,3)/2;
    else
        yBFCur = yBF;
        zBFCur = zBF;
    end
    
    axes(ha(k+(2-1)*nVars));
    imagesc(squeeze(curVar(yBFCur,:,:))'); axis square off; colormap(colormapSet);
    caxis(colorScale);
    if (zBF > size(curVar,3))
        amp = dz_SIM_arc/2;
    else
        amp = dz_SIM_arc;
    end
    
    zoom on
    zoom(2)
    zoom off
        r = amp;
        hold on; plot(offX+(r.*cos(theta)), offY+(r.*sin(theta)),'LineWidth',3,'Color', 'green');
end

if (~isempty(supTitle))
    suptitle(supTitle);
end
end