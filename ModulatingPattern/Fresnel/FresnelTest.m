%%
run("../../CIRLSetup.m");

%% Simulated bead settings
[ psfpar, psfpari ] = PSFConfigNoAber();
X     = 100;                        % discrete lateral size in voxels
Y     = 100;                        % discrete lateral size in voxels
Z     = 100;                        % discrete axial size in voxels
dXY   = 0.05;                      % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.05;                      % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);   % cycle/um
offs  = [0, 0, 0];                  % offset from the standard values of phi
phi   = [0, 1, 2]*(2*180)/3;        % lateral phase
theta = [0, 60, 120];               % orientation
x0    = 0.488;  % in mm
fL1   = 100;    % in mm
fL2   = 250;    % in mm
fMO   = 160/63;
omegaXY = [0.8, 0.8, 0.8]*uc;         % lateral modulating frequency
omegaZ  = ((x0*fL2)/(2*fL1*fMO))*omegaXY;  % axial modulating frequency
phizDeg = 154.0;                   % axial phase
Nslits  = 3;

%% get the pattern and check
zBF = 1 + Z/2;
p  = psfpar.initialize(psfpar, 'Vectorial', 200);
h  = PSFLutz(X, Z, dXY, dZ, p);
%h  = PSFAgard( X, Z, dXY, dZ);
[im, jm, Nn] = PatternTunable3DNSlits(X, Y, Z, omegaXY, omegaZ, dXY, dZ, phi, offs, theta, phizDeg, Nslits);
vz = squeeze(im(1,1,:,1,1,2));
vz = vz./max(vz(:));
hz = squeeze(h (1+Y/2,1+X/2,:));
hz = hz./max(hz(:));
figure;  plot(vz, 'DisplayName', 'v(z)'); 
hold on; plot(hz, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value'); suptitle("Visibility and PSF at zBF = " + num2str(zBF)); legend;

jm2 = squeeze(jm(1+Y/2,:,1,1,1,2));
figure;  plot(jm2, 'DisplayName', 'jm(2)'); 
xlabel('x'); ylabel('value'); suptitle("jm at zBF = " + num2str(zBF)); legend;

%% get the Fresnel pattern
eta = 68.80; 
biLambda = 488 * 10^-6;
biNi     = 1.515;         % Refractive Index of biprism
biDelta  = 2.5*pi/180;
pat = FresnelPattern(eta, Nslits, X, Z, dXY*10^-3, dZ*10^-3, biLambda, biNi, biDelta, x0, fL1, fL2, fMO); 

%% Tune eta to match real vs ideal patterns
figure;subplot(221);imagesc(pat);colormap(gray);colorbar;
zslice = 50;
subplot(222);imagesc(pat(:,zslice)');title(sprintf('Pattern %g',zslice));colormap(gray);colorbar;
subplot(2,2,3:4);plot(pat(:,zslice)');title(sprintf('Pattern %g',zslice));axis tight;

Mask_2D = Grating_2D( phi, theta, omegaXY(1), 1, 1, X, dXY, 0);
I_ideal = squeeze(Mask_2D(1+X/2,:,1,1))'; I_ideal = I_ideal./max(I_ideal);
I_slit = squeeze(pat(:,zslice))'; I_slit = I_slit./max(I_slit);
NFFT = X; f = [-X/2:X/2-1]/(X*dXY);
I_ideal_F = abs(fftshift(fft(fftshift(I_ideal,NFFT)))); I_ideal_F = I_ideal_F./max(I_ideal_F(:));
I_slit_F = abs(fftshift(fft(fftshift(I_slit,NFFT)))); I_slit_F = I_slit_F./max(I_slit_F(:));
fig = figure; plot(f,I_slit_F,'b',f,I_ideal_F,':m','linewidth',2); xlim([-2*uc 2*uc]);
legend('Real Pattern','Ideal Pattern');
grid on; lb.x = 'Lateral Frequency (\mum^{-1})'; lb.y = 'Amplitude';
%pubPlot(lb);

%% shift the pattern laterally to have the phse = 0, 120, 240
X_ext = 2*X; Z_ext = 2*Z; 
pat = FresnelPattern(eta, Nslits, X_ext, Z_ext, dXY*10^-3, dZ, biLambda, biNi, biDelta, x0, fL1, fL2, fMO); 

%%
figure;subplot(221);imagesc(pat);colormap(gray);colorbar;
zslice = 58;
subplot(222);imagesc(pat(:,zslice)');title(sprintf('Pattern %g',zslice));colormap(gray);colorbar;
subplot(2,2,3:4);plot(pat(:,zslice)');title(sprintf('Pattern %g',zslice));axis tight;

pat1 = circshift(pat,[1 0]); pat11 = pat1(X_ext/2-X/2+1:X_ext/2+X/2,:); pat11 = pat11./max(pat11(:));
pat2 = circshift(pat,[0 0]); pat22 = pat2(X_ext/2-X/2+1:X_ext/2+X/2,:); pat22 = pat22./max(pat22(:));
pat3 = circshift(pat,[-2 0]); pat33 = pat3(X_ext/2-X/2+1:X_ext/2+X/2,:); pat33 = pat33./max(pat33(:));
%figure;
subplot(311);
plot(squeeze(Mask_2D(1+X/2,:,1,1)),'linewidth',2); axis tight; hold on;
plot(squeeze(pat11(:,zslice)),'linewidth',2); axis tight; hold off;
subplot(312);
plot(squeeze(Mask_2D(1+X/2,:,1,2)),'linewidth',2); axis tight; hold on;
plot(squeeze(pat22(:,zslice)),'linewidth',2); axis tight; hold off;
subplot(313);
plot(squeeze(Mask_2D(1+X/2,:,1,3)),'linewidth',2); axis tight; hold on;
plot(squeeze(pat33(:,zslice)),'linewidth',2); axis tight; hold off;

%% tune zslice to have the best resonant plane in the best focus for more than one slit
figure;imagesc(pat);colormap(gray);colorbar;
zslice = 58;
pat1 = circshift(pat,[1 0]); pat11 = pat1(X_ext/2-X/2+1:X_ext/2+X/2,zslice-Z/2+1:zslice+Z/2); pat11 = pat11./max(pat11(:));
pat2 = circshift(pat,[0 0]); pat22 = pat2(X_ext/2-X/2+1:X_ext/2+X/2,zslice-Z/2+1:zslice+Z/2); pat22 = pat22./max(pat22(:));
pat3 = circshift(pat,[-2 0]); pat33 = pat3(X_ext/2-X/2+1:X_ext/2+X/2,zslice-Z/2+1:zslice+Z/2); pat33 = pat33./max(pat33(:));
z = [1:Z]; figure,plot(z, squeeze(pat11(1,:)), z, squeeze(h(1+Y/2,1+X/2,:))./max(squeeze(h(1+Y/2,1+X/2,:))))
figure;
subplot(311);
plot(squeeze(Mask_2D(1+X/2,:,1,1)),'linewidth',2); axis tight; hold on;
plot(squeeze(pat11(:,1+Z/2)),'linewidth',2); axis tight; hold off;
subplot(312);
plot(squeeze(Mask_2D(1+X/2,:,1,2)),'linewidth',2); axis tight; hold on;
plot(squeeze(pat22(:,1+Z/2)),'linewidth',2); axis tight; hold off;
subplot(313);
plot(squeeze(Mask_2D(1+X/2,:,1,3)),'linewidth',2); axis tight; hold on;
plot(squeeze(pat33(:,1+Z/2)),'linewidth',2); axis tight; hold off;

%% make 3D voulme of the pattern
for z = 1:Z
    Pattern_3D(:,:,z,1,1) = repmat(pat11(:,z),1,X)';
    Pattern_3D(:,:,z,1,2) = repmat(pat22(:,z),1,X)';
    Pattern_3D(:,:,z,1,3) = repmat(pat33(:,z),1,X)';
end
figure; ct = 0; Angle_No = length(theta); Ph_No = length(phi);
Angle_No = 1;
for k = 1 : Ph_No
    for j = 1 : Angle_No
        ct = ct + 1;
        subplot(Ph_No,2*Angle_No,ct); colormap gray; imagesc(squeeze(Pattern_3D(1+Y/2,:,:,j,k))'); xlabel('X'); ylabel('Z'); axis image; colorbar
        ct = ct + 1;
        subplot(Ph_No,2*Angle_No,ct); colormap gray; imagesc(squeeze(Pattern_3D(:,:,1+Z/2,j,k))); xlabel('X'); ylabel('Y'); axis image;
    end
end