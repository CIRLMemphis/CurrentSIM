X = 100;
Y = 100;
Z = 100;
dXY = 6.5/39;
dZ  = dXY;

%%
Nslits = 1;
eta = 70.10; 
pat = FresnelPattern_afterLens_Eq10(eta, Nslits, X, Z, dXY*10^-3, dZ); 

figure;imagesc(pat);colormap(gray);colorbar; xlabel('z'); ylabel('x');
figure; plot(pat(:,1)); xlabel('x');
figure; plot(pat(51,:)); xlabel('z');

%%
Nslits = 3;
eta = 68.10; 
pat = FresnelPattern_afterLens_Eq10(eta, Nslits, X, Z, dXY*10^-3, dZ); 

figure;imagesc(pat);colormap(gray);colorbar; xlabel('z'); ylabel('x');
figure; plot(pat(:,1)); xlabel('x');
figure; plot(pat(51,:)); xlabel('z');

%% analytic pattern formula
NA     = 1.4;
lambda = 0.488;
uc     = 2*NA/lambda;
um     = [0.8, 0.8, 0.8]*uc;
x0     = 0.488;  % in mm
fL1    = 100;    % in mm
fL2    = 250;    % in mm
%fMO    = 160/63;
fMO    = 8;
wm     = ((x0*fL2)/(2*fL1*fMO))*um;
phi    = [0, 1, 2]*(2*180)/3;        % lateral phase
theta  = [0, 60, 120]; 
offs   = [0, 0, 0]; 
phizDeg = 154.0;  
[im, jm, Nn] = PatternTunable3DNSlits(X, Y, Z, um, wm, dXY, dZ, phi, offs, theta, phizDeg, Nslits);

vz = squeeze(im(1,1,:,1,1,2));
vz = vz./max(vz(:));
figure;  plot(vz, 'DisplayName', 'v(z)');  xlabel('z'); title('3-slit visibility function');