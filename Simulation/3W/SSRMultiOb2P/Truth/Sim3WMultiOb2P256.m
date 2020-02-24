run("../Sim3WMultiOb2P256Setup.m");

%% run forward model and save the results into CIRLDataPath
ob = SSRMultiObject(X, Z, dXY, dZ);
g  = ForwardModel(ob, h, im, jm);

%%
gWF = g(:,:,:,1,1) + g(:,:,:,1,2) + g(:,:,:,1,3) + g(:,:,:,1,4) + g(:,:,:,1,5);

%%
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);
G = zeros(Y,X,Z);
for phiTemp = 0:72:288
    G = G + HotForwardModel(ob, h, @im3W, @jm3W, 3, xx, yy, zz, dXY, dZ, u(1), w(1), 0, 2*phiTemp, 0, phizDeg, 1);
end
figure; imagesc(G(:,:,1+Z/2)); axis square;
