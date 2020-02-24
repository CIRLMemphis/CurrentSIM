run("../../CIRLSetup.m");
colormapSet = 'jet';
colorScale  = [0 1.0];
shouldScale = 0;
xzRegionX   = 450:650;
xzRegionZ   =   1:50;
xyRegionX   = 300:800;
xyRegionY   = 300:600;
yBest       = 512;
zBest       = 13;

%% load the reconstruction results
expNames = ["201910151247_Exp3WOptGWFActinFull"];
iterInd  = [0];
load(CIRLDataPath + "\Results\FairSIM\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb', 'retVars');
 
%% load GWF result
reconObNor = reconOb./sum(reconOb(:));
reconObNor(reconObNor < 0) = 0;
reconObNor = reconObNor/max(reconObNor(:));

%% load the GWF widefield
widefield = retVars{2};
widefieldNor = widefield./sum(widefield(:));
widefieldNor(widefieldNor < 0) = 0;
widefieldNor = widefieldNor/max(widefieldNor(:));

%%
FairSIMPlotXYXZ(widefieldNor, reconObNor, yBest, zBest, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale, colormapSet)

%%
figure;
imshow3D(permute(reconObNor, [2, 3, 1])); caxis(colorScale); axis image; colorbar; colormap(colormapSet);


% %% load MB result
% load(CIRLDataPath + "\Results\FairSIM\" + expNames(2) + "\" + expNames(2) + ".mat",...
%      'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
%  
% %%
% reconOb    = retVars{5};
% reconObNor = reconOb./sum(reconOb(:));
% reconObNor(reconObNor < 0) = 0;
% reconObNor = reconObNor/max(reconObNor(:));
% figure; imagesc(reconObNor(:,:,13)); axis square; caxis([0, 0.5]); colorbar; colormap(colormapSet);
% fig = figure; imshow(reconObNor(:,:,13)); axis square; caxis([0 0.5]);
% saveas(fig, "MBResult.jpg");
% 
% %% load MBPC result
% load(CIRLDataPath + "\Results\FairSIM\" + expNames(3) + "\" + expNames(3) + ".mat",...
%      'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
%  
% %%
% reconOb    = retVars{10};
% reconObNor = reconOb./sum(reconOb(:));
% reconObNor(reconObNor < 0) = 0;
% reconObNor = reconObNor/max(reconObNor(:));
% figure; imagesc(reconObNor(:,:,13)); axis square; caxis([0, 0.5]); colorbar; colormap(colormapSet);
% fig = figure; imshow(reconObNor(:,:,13)); axis square; caxis([0 0.5]);
% saveas(fig, "MBPCResult.jpg");