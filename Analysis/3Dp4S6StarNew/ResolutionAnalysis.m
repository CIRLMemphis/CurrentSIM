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

figure;
subplot(1,2,1); imagesc(squeeze(ob(:,:,257,1,1))) ; axis image; colormap gray; xlabel('x'); ylabel('y');
viscircles([256, 256], dx_arc,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'red');
viscircles([256, 256], dx_SIM_arc, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'blue');
subplot(1,2,2); imagesc(squeeze(ob(257,:,:,1,1))'); axis image; colormap gray; xlabel('x'); ylabel('z');
viscircles([256, 256], dz_arc,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'yellow');
viscircles([256, 256], dz_SIM_arc, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'green');