run("../../CIRLSetup.m");
colormapSet = 'jet';
colorScale  = [0 1.1];

%% load the reconstruction results
expNames = ["201909181608_Exp3WGWFActin13Slices", ...
            "201909211427_Exp3WMBActin13SlicesIter100", ...
            "201909211454_Exp3WMBPCActin13SlicesIter100"];
iterInd  = [0];
load(CIRLDataPath + "\Results\FairSIM\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb');
 
%% load GWF result
reconObNor = reconOb./sum(reconOb(:));
reconObNor(reconObNor < 0) = 0;
reconObNor = reconObNor/max(reconObNor(:));
figure; imagesc(reconObNor(:,:,13)); axis square; caxis([0 1]); colorbar; colormap(colormapSet);
fig = figure; imshow(reconObNor(:,:,13)); axis square; caxis([0 1]);
saveas(fig, "GWFResult.jpg");

%% load MB result
load(CIRLDataPath + "\Results\FairSIM\" + expNames(2) + "\" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb    = retVars{5};
reconObNor = reconOb./sum(reconOb(:));
reconObNor(reconObNor < 0) = 0;
reconObNor = reconObNor/max(reconObNor(:));
figure; imagesc(reconObNor(:,:,13)); axis square; caxis([0, 0.5]); colorbar; colormap(colormapSet);
fig = figure; imshow(reconObNor(:,:,13)); axis square; caxis([0 0.5]);
saveas(fig, "MBResult.jpg");

%% load MBPC result
load(CIRLDataPath + "\Results\FairSIM\" + expNames(3) + "\" + expNames(3) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
reconOb    = retVars{10};
reconObNor = reconOb./sum(reconOb(:));
reconObNor(reconObNor < 0) = 0;
reconObNor = reconObNor/max(reconObNor(:));
figure; imagesc(reconObNor(:,:,13)); axis square; caxis([0, 0.5]); colorbar; colormap(colormapSet);
fig = figure; imshow(reconObNor(:,:,13)); axis square; caxis([0 0.5]);
saveas(fig, "MBPCResult.jpg");