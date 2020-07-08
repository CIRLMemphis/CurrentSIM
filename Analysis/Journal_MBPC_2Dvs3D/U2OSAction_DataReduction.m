clear; close all

% WF3 result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202007011726_Exp3WU2OSActinOTFMBDR3WF\202007011726_Exp3WU2OSActinOTFMBDR3WF.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
WF3Result = reconOb;

% MB result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\201912221021_Exp3WU2OSActinOTFMB\201912221021_Exp3WU2OSActinOTFMB.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBResult = reconOb;

% DR7 MB result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202001032033_Exp3WU2OSActinOTFMBDR7\202001032033_Exp3WU2OSActinOTFMBDR7.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
DR7MBResult = reconOb;

% DR9 MB result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202001041740_Exp3WU2OSActinOTFMBDR9\202001041740_Exp3WU2OSActinOTFMBDR9.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
DR9MBResult = reconOb;

% DR7 MBPC result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202002221320_Exp3WU2OSActinPSFVzMBPC\202002221320_Exp3WU2OSActinPSFVzMBPC.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBPCResult = reconOb;

%%
fig       = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2, 4,[.03 .001],[.1 .1],[.1 .1]);
axes(ha(1)); imagesc(MBResult   (:,:,13)); axis off square; colormap hot; title('MB')
axes(ha(2)); imagesc(WF3Result  (:,:,13)); axis off square; colormap hot; title('MB WF+3')
axes(ha(3)); imagesc(DR7MBResult(:,:,13)); axis off square; colormap hot; title('MB 7')
axes(ha(4)); imagesc(DR9MBResult(:,:,13)); axis off square; colormap hot; title('MB 9')
axes(ha(5)); imagesc(MBPCResult (:,:,13)); axis off square; colormap hot; title('MBPC')



%%
fig       = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2, 4,[.01 .001],[.1 .1],[.1 .1]);
axes(ha(1)); imagesc(MBResult   (1024-256:1024,1:256,13)); axis off square; colormap hot; title('MB')
axes(ha(2)); imagesc(WF3Result  (1024-256:1024,1:256,13)); axis off square; colormap hot; title('MB WF+3')
axes(ha(3)); imagesc(DR7MBResult(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MB 7')
axes(ha(4)); imagesc(DR9MBResult(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MB 9')
axes(ha(5)); imagesc(MBPCResult (1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC')