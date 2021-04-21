NSpokes = 6;

ob = StarLikeSample(3,512,NSpokes,20,3,0.6);
%%
dx     = 0.224;
dXY    = 0.02;
dx_arc = dx*(NSpokes*4)/(2*pi*dXY);
dx_SIM = 0.125;
dx_SIM_arc = dx_SIM*(NSpokes*4)/(2*pi*dXY);

dz     = 0.525;
dZ     = 0.02;
dz_arc = dz*(NSpokes*4)/(2*pi*dZ);
dz_SIM = 0.292;
dz_SIM_arc = dz_SIM*(NSpokes*4)/(2*pi*dZ);

figure; imagesc(squeeze(ob(:,:,257,1,1))) ; axis off image; colormap gray;
viscircles([256, 256], dx_arc,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'red','LineWidth',3);
viscircles([256, 256], dx_SIM_arc, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'blue','LineWidth',3);

%%
figure; imagesc(squeeze(ob(257,:,:,1,1))'); axis off image; colormap gray;
%viscircles([256, 256], dz_arc,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'yellow');
%viscircles([256, 256], dz_SIM_arc, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'green');
    offX = 256;
    offY = 256;
    sampleN = 500;
        theta = linspace(pi/2+pi/4, 3*pi/2-pi/4, sampleN);
        % r = amp*(1-2.5*sin(theta));
        r = dz_SIM_arc;
        hold on; plot(offX+(r.*cos(theta)), offY+(r.*sin(theta)),'LineWidth',3,'Color', 'green');
        r = dz_arc;
        hold on; plot(offX+(r.*cos(theta)), offY+(r.*sin(theta)),'LineWidth',3,'Color', 'yellow');