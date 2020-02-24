run("../Experiment/3W/OMX_U2OS_Actin_525nm/Exp3WActinCorner200Setup.m");
[scale01, scaleOmega] = Pixel2Omega(uc, u(1), X, dXY);

%% 2D FT
hZ    = h(:,:,1+Z/2);
hFTZ  = abs(FT(hZ));
hFTYZ = hFTZ(1+Y/2,:);
%hFTYZ = hFTYZ./max(hFTYZ(:));
figure; plot(hFTYZ);

%% 3D FT
hFT   = abs(FT(h));
hFTZ  = hFT(:,:,1+Z/2);
hFTYZ = hFTZ(1+Y/2,:);
%hFTYZ = hFTYZ./max(hFTYZ(:));
figure; plot(hFTYZ);

%% 1D damping
A = 1;
sigma  = sqrt(0.03);
center = 1+X/2;
damp   = (1 - A*exp(-(((1:X) - center)/X/dXY).^2./sigma^2));
hFTYZDamp = hFTYZ.*damp;
%hold on; plot(damp);
hold on; plot(hFTYZDamp);
set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega)

%% 2D damping
A = 1;
sigma  = sqrt(0.06);
[yy, xx] = meshgrid(1 : 1 : Y, 1 : 1 : X);
radius = sqrt(((xx - (1+X/2))/X/dXY).^2 + ((yy - (1+Y/2))/X/dXY).^2);
damp   = 1 - A*exp(-radius./sigma^2);
hFTYZDamp = hFTYZ.*damp;
%hold on; plot(damp(1+Y/2,:));
hold on; plot(hFTYZDamp(1+Y/2,:));
set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega)

%% 3D damping
A = 1;
sigma  = sqrt(1);
hFTYZDamp = ZeroFreqDamp3D(hFT,X,Y,Z,dXY,dZ,A,sigma);
%hold on; plot(damp(1+Y/2,:));
hold on; plot(hFTYZDamp(1+Y/2,:,1+Z/2));
set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega)