run("../Simulation/3W/StarCorner/Sim3WStarCorner100x100x100Setup.m");

%%
sigma = 0.6;
ob = StarCorner3DExtend(Y, X, Z, sigma);

%%
obXY = ob(:,:,1+Z/2);
figure; 
subplot(1,2,1); imagesc(obXY); axis square; colormap hot; xlabel('x'); ylabel('y');
subplot(1,2,2); plot(obXY(1+Y/2,:)); xlabel('x');

obXZ = squeeze(ob(1+Y/2,:,:));
figure;
subplot(1,3,1); imagesc(obXZ); axis square; colormap hot; xlabel('z'); ylabel('x');
subplot(1,3,2); plot(obXZ(1+X/2,:)); xlabel('z');
subplot(1,3,3); plot(obXZ(:,1+Z/2)); xlabel('x');

%% fourier domain
obFT = abs(FT(ob));
obFTXY = obFT(:,:,1+Z/2);
obFTXY = obFTXY./max(obFTXY(:));
figure; 
subplot(1,2,1); imagesc(obFTXY); axis square; colormap hot; xlabel('u'); ylabel('v');
subplot(1,2,2); plot(obFTXY(1+Y/2,:)); xlabel('u');

obFTXZ = squeeze(obFT(1+Y/2,:,:));
obFTXZ = obFTXZ./max(obFTXZ(:));
figure;
subplot(1,3,1); imagesc(obFTXZ); axis square; colormap hot; xlabel('u'); ylabel('w');
subplot(1,3,2); plot(obFTXZ(1+Y/2,:)); xlabel('w');
subplot(1,3,3); plot(obFTXZ(:,1+Z/2)); xlabel('u');