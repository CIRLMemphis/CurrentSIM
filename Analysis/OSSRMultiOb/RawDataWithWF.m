run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1.2];
xzRegionX   = 257-100:257+99;
xzRegionZ   = 257-100:257+99;
xyRegionX   = 257-50 :257+49;
xyRegionY   = 257-50 :257+49;
yBest       = 257;
zBest       = 257;

%% load the reconstruction results
expNames = ["201911111020_Sim3WOptGWFOSSRMultiOb256",...
            "201911130251_Sim3WMBHotOSSRMultiOb256Iter200",...
            "201911140720_Sim3WMBPCHotOSSRMultiOb256Iter200"];

load(CIRLDataPath + "\Results\OSSRMultiOb\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
lThe = 1;
wf   = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);

%%
fig  = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2,4,[.01 .001],[.01 .03],[.01 .01]);
zBFCur = 129;
for lThe = 1:3
    axes(ha(lThe+(1-1)*4));
    imagesc(g(:,:,zBFCur,lThe,1)); axis square off; colormap(colormapSet);
end
axes(ha(4+(1-1)*4));
imagesc(wf(:,:,zBFCur)); axis square off; colormap(colormapSet);

yBFCur = 129;
for lThe = 1:3
    axes(ha(lThe+(2-1)*4));
    imagesc(squeeze(g(yBFCur,:,:,lThe,1))'); axis square off; colormap(colormapSet);
end
axes(ha(4+(2-1)*4));
imagesc(squeeze(wf(yBFCur,:,:))'); axis square off; colormap(colormapSet);