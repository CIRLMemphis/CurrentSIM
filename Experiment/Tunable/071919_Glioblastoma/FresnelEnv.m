run("ExpTunable071719GlioSetup.m");

%%
Nslits = 3;
eta = 49.10; 
[pat, env, VC, VS] = FresnelPattern_afterLens_Eq10(eta, Nslits, X, Z, dXY*10^-3, dZ*10^-3); 

%%
zslice = 129;
figure;imagesc(pat);colormap(gray);colorbar; xlabel('z'); ylabel('x');
figure; plot(pat(:,zslice)); xlabel('x');
saveas(gcf,'xProfile.png')
figure; plot(pat(257,:)); xlabel('z');
saveas(gcf,'zProfile.png')

Mask_2D = Grating_2D( phi, theta, omegaXY(1), 1, 1, X, dXY, 0);
I_ideal = squeeze(Mask_2D(1+X/2,:,1,1))'; I_ideal = I_ideal./max(I_ideal);
I_slit = squeeze(pat(:,zslice))'; I_slit = I_slit./max(I_slit);
NFFT = X; f = [-X/2:X/2-1]/(X*dXY);
I_ideal_F = abs(fftshift(fft(fftshift(I_ideal,NFFT)))); I_ideal_F = I_ideal_F./max(I_ideal_F(:));
I_slit_F = abs(fftshift(fft(fftshift(I_slit,NFFT)))); I_slit_F = I_slit_F./max(I_slit_F(:));
fig = figure; plot(f,I_slit_F,'b',f,I_ideal_F,':m','linewidth',2); xlim([-2*uc 2*uc]);
legend('Real Pattern','Ideal Pattern');
grid on; lb.x = 'Lateral Frequency (\mum^{-1})'; lb.y = 'Amplitude';
saveas(fig,'Freq.png')

save('FresnelEnv.mat')
