%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Simulation\3W\Sim3W3Dp6BigStar512.mat', 'ob', 'g')

%%
dx     = 0.224;
dXY    = 0.03;
dx_arc = dx*(8*4)/(2*pi*dXY);
dx_SIM = 0.125;
dx_SIM_arc = dx_SIM*(8*4)/(2*pi*dXY);

dz     = 0.525;
dZ     = 0.03;
dz_arc = dz*(8*4)/(2*pi*dZ);
dz_SIM = 0.367;
dz_SIM_arc = dz_SIM*(8*4)/(2*pi*dZ);

figure;
subplot(1,2,1); imagesc(squeeze(ob(:,:,257,1,1))) ; axis image; colormap gray; xlabel('x'); ylabel('y');
viscircles([256, 256], dx_arc,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'red');
viscircles([256, 256], dx_SIM_arc, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'blue');
subplot(1,2,2); imagesc(squeeze(ob(257,:,:,1,1))'); axis image; colormap gray; xlabel('x'); ylabel('z');
viscircles([256, 256], dz_arc,     'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'yellow');
viscircles([256, 256], dz_SIM_arc, 'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'green');

%%
figure;
subplot(1,2,1); imagesc(squeeze(g(:,:,257,1,1))) ; axis image; colormap gray; xlabel('x'); ylabel('y');
subplot(1,2,2); imagesc(squeeze(g(257,:,:,1,1))'); axis image; colormap gray; xlabel('x'); ylabel('z');

%% curve profile
figure;
imagesc(squeeze(ob(:,:,257,1,1))) ; axis image; colormap gray; xlabel('x'); ylabel('y');
theta = linspace(pi, 3*pi/2, 200); r = 50*(1-sin(theta));
hold on; plot(256+abs(r.*cos(theta)), 225+abs(r.*sin(theta)),'LineWidth',3);

%% plot profile along the curve
val = [];
curX = 0;
curY = 0;
for thetaVal = theta
    r   = 50*(1-sin(thetaVal));
    if (256+round(abs(r.*cos(thetaVal))) ~= curX || 225+round(abs(r.*sin(thetaVal))) ~= curY)
        val  = [val, ob(256+round(abs(r.*cos(thetaVal))), 225+round(abs(r.*sin(thetaVal))), 257)];
        curX = 256+round(abs(r.*cos(thetaVal)));
        curY = 225+round(abs(r.*sin(thetaVal)));
    end
end
figure; plot(val,'LineWidth',3);