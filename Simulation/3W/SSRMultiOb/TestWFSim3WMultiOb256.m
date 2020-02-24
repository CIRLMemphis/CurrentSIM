run("Sim3WMultiOb256Setup.m");

%% run forward model and save the results into CIRLDataPath
ob = SSRMultiObject(X, Z, dXY, dZ);
g  = ForwardModel(ob, h, im, jm);

g_partial = g(:,:,:,1,1) + g(:,:,:,1,2) + g(:,:,:,1,3);
g_WF= g(:,:,:,1,1) + g(:,:,:,1,2) + g(:,:,:,1,3) + g(:,:,:,1,4) + g(:,:,:,1,5);

figure;
subplot(1,2,1); imagesc(g_partial(:,:,1+Z/2)); axis square; title('partial');
subplot(1,2,2); imagesc(g_WF(:,:,1+Z/2)); axis square; title('WF');