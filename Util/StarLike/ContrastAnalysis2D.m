N  = 128;
ob = StarLikeSample(2,N,8,20,3,0.7);
X = N;
Y = N;
Z = N;
omegaXY  = 5;
theta    = 0;
phi      = 0;
dXY      = 0.025;

%% show the object
figure;
imagesc(ob); axis image;

%% 1D contrast analysis
y       = 0:1:Y-1;
jm1D_TN = 1 + cos(2*pi*omegaXY*y*dXY);
jm1D_TNFT = abs(fftshift(fft(jm1D_TN)));
jm1D_TNFT = jm1D_TNFT./max(jm1D_TNFT(:));
figure; 
subplot(1,2,1); plot(1:Y, jm1D_TN,'DisplayName','Tunable 1D Lateral pattern'); legend;
subplot(1,2,2); plot(1:Y, jm1D_TNFT,'DisplayName','Tunable 1D FT');

%%
[yy, xx] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1);
jm2D_TN    = 1 + cos(2*pi*omegaXY*(cos(theta)*yy + sin(theta)*xx)*dXY);
figure; imagesc(jm2D_TN);

%%
jm_TNFT = abs(fftshift(fft(jm2D_TN(64,:))));
jm_TNFT = jm_TNFT/max(jm_TNFT(:));
figure;
subplot(1,2,1); plot(1:Y, jm2D_TN(64,:),'DisplayName','Tunable Lateral pattern');
subplot(1,2,2); plot(1:Y, jm_TNFT,'DisplayName','Tunable FT 1D');
legend;

%%
jm2D_TNFT = abs(fftshift(fft2(jm2D_TN)));
jm2D_TNFT_mid = jm2D_TNFT(65,:);
jm2D_TNFT_mid = jm2D_TNFT_mid/max(jm2D_TNFT_mid(:));
figure;
subplot(1,2,1); plot(1:Y, jm2D_TNFT_mid,'DisplayName','Tunable FT 2D'); legend;
subplot(1,2,2); plot(1:Y, jm_TNFT,'DisplayName','Tunable FT 1D'); legend;