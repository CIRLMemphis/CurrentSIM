clear; close all

% Widefield result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\201912181803_Exp3WU2OSActinOptGWF\201912181803_Exp3WU2OSActinOptGWF.mat', 'retVars')
WFNor = retVars{2}./sum(retVars{2}(:));
WFNor(WFNor < 0) = 0;
WFNor = WFNor/max(WFNor(:));

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

% MBPC result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202002221320_Exp3WU2OSActinPSFVzMBPC\202002221320_Exp3WU2OSActinPSFVzMBPC.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBPCResult = reconOb;

% MBPC WF3 result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202007091628_Exp3WU2OSActinPSFVzMBPCWF3\202007091628_Exp3WU2OSActinPSFVzMBPCWF3.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBPCWF3Result = reconOb;

% MBPC DR7 result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202007091925_Exp3WU2OSActinPSFVzMBPCDR\202007091925_Exp3WU2OSActinPSFVzMBPCDR.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBPCDR7Result = reconOb;

% MBPC DR9 result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202007100530_Exp3WU2OSActinPSFVzMBPCDR9\202007100530_Exp3WU2OSActinPSFVzMBPCDR9.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBPCDR9Result = reconOb;


%%
fig       = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2, 5,[.01 .001],[.2 .2],[.1 .1]);
axes(ha(1)) ; imagesc(WFNor      (:,:,13)); axis off square; colormap hot; title('WF')
axes(ha(2)) ; imagesc(WF3Result  (:,:,13)); axis off square; colormap hot; title('MB 3SIM+WF')
axes(ha(3)) ; imagesc(DR7MBResult(:,:,13)); axis off square; colormap hot; title('MB 7SIM')
axes(ha(4)) ; imagesc(DR9MBResult(:,:,13)); axis off square; colormap hot; title('MB 9SIM')
axes(ha(5)) ; imagesc(MBResult   (:,:,13)); axis off square; colormap hot; title('MB 15SIM')
axes(ha(6)) ; imagesc(WFNor      (1024-256:1024,1:256,13)); axis off square; colormap hot; title('WF')
axes(ha(7)) ; imagesc(WF3Result  (1024-256:1024,1:256,13)); axis off square; colormap hot; title('MB 3SIM+WF')
axes(ha(8)) ; imagesc(DR7MBResult(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MB 7SIM')
axes(ha(9)) ; imagesc(DR9MBResult(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MB 9SIM')
axes(ha(10)); imagesc(MBResult   (1024-256:1024,1:256,13)); axis off square; colormap hot; title('MB 15SIM')



%%
fig       = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2, 5,[.01 .001],[.2 .2],[.1 .1]);
axes(ha(1)) ; imagesc(WFNor        (:,:,13)); axis off square; colormap hot; title('WF')
axes(ha(2)) ; imagesc(MBPCWF3Result(:,:,13)); axis off square; colormap hot; title('MBPC 3SIM+WF'); caxis([0 6e4]);
axes(ha(3)) ; imagesc(MBPCDR7Result(:,:,13)); axis off square; colormap hot; title('MBPC 7SIM')   ; caxis([0 6e4]);
axes(ha(4)) ; imagesc(MBPCDR9Result(:,:,13)); axis off square; colormap hot; title('MBPC 9SIM')   ; caxis([0 6e4]);
axes(ha(5)) ; imagesc(MBPCResult   (:,:,13)); axis off square; colormap hot; title('MBPC 15SIM')  ; caxis([0 6e4]);
axes(ha(6)) ; imagesc(WFNor        (1024-256:1024,1:256,13)); axis off square; colormap hot; title('WF')
axes(ha(7)) ; imagesc(MBPCWF3Result(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC 3SIM+WF'); caxis([0 6e4]);
axes(ha(8)) ; imagesc(MBPCDR7Result(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC 7SIM')   ; caxis([0 6e4]);
axes(ha(9)) ; imagesc(MBPCDR9Result(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC 9SIM')   ; caxis([0 6e4]);
axes(ha(10)); imagesc(MBPCResult   (1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC 15SIM')  ; caxis([0 6e4]);

%% Plot FT of the chosen slice
WFNor_FT   = log(abs(FT(WFNor        (:,:,13))));
MBPCWF3_FT = log(abs(FT(MBPCWF3Result(:,:,13))));
MBPCDR7_FT = log(abs(FT(MBPCDR7Result(:,:,13))));
MBPCDR9_FT = log(abs(FT(MBPCDR9Result(:,:,13))));
MBPC_FT    = log(abs(FT(MBPCResult   (:,:,13))));
fig       = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2, 5,[.01 .001],[.2 .2],[.1 .1]);
axes(ha(1)) ; imagesc(WFNor        (1024-256:1024,1:256,13)); axis off square; colormap hot; title('WF')
axes(ha(2)) ; imagesc(MBPCWF3Result(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC 3SIM+WF'); caxis([0 6e4]);
axes(ha(3)) ; imagesc(MBPCDR7Result(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC 7SIM')   ; caxis([0 6e4]);
axes(ha(4)) ; imagesc(MBPCDR9Result(1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC 9SIM')   ; caxis([0 6e4]);
axes(ha(5)) ; imagesc(MBPCResult   (1024-256:1024,1:256,13)); axis off square; colormap hot; title('MBPC 15SIM')  ; caxis([0 6e4]);
axes(ha(6)) ; imagesc(WFNor_FT  ); axis off square; colormap jet; title('FT WF')
axes(ha(7)) ; imagesc(MBPCWF3_FT); axis off square; colormap jet; title('FT 3SIM+WF');
axes(ha(8)) ; imagesc(MBPCDR7_FT); axis off square; colormap jet; title('FT 7SIM')   ;
axes(ha(9)) ; imagesc(MBPCDR9_FT); axis off square; colormap jet; title('FT 9SIM')   ;
axes(ha(10)); imagesc(MBPC_FT   ); axis off square; colormap jet; title('FT 15SIM')  ;

%% plot FT of the raw data
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\FairSimData\OMX_U2OS_Actin_525nm.mat', 'g');

%%
fig       = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2, 3,[.01 .001],[.04 .05],[.13 .13]);
axes(ha(1)) ; imagesc(g(512-128:512,1:128,7,1,1)); axis off square; colormap hot; title('g11')
axes(ha(2)) ; imagesc(g(512-128:512,1:128,7,2,1)); axis off square; colormap hot; title('g21');
axes(ha(3)) ; imagesc(g(512-128:512,1:128,7,3,1)); axis off square; colormap hot; title('g31')   ;
g11_FT = log(abs(FT(g(:,:,7,1,1))));
g21_FT = log(abs(FT(g(:,:,7,2,1))));
g31_FT = log(abs(FT(g(:,:,7,3,1))));
axes(ha(4)) ; imagesc(g11_FT); axis off square; colormap jet; title('FT g11')
axes(ha(5)) ; imagesc(g21_FT); axis off square; colormap jet; title('FT g21');
axes(ha(6)) ; imagesc(g31_FT); axis off square; colormap jet; title('FT g31')   ;


%% XZ plan
yBest = 1024-(200-130)-1;
xyRegionX   =   1:256;
fig       = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(1, 5, [.01 .001],[.1 .1],[.1 .1]);
axes(ha(1)); imagesc(squeeze(WFNor        (yBest,xyRegionX,:))'); axis off image; colormap hot; title('WF')
axes(ha(2)); imagesc(squeeze(MBPCWF3Result(yBest,xyRegionX,:))'); axis off image; colormap hot; title('MBPC 3SIM+WF'); caxis([0 6e4]);
axes(ha(3)); imagesc(squeeze(MBPCDR7Result(yBest,xyRegionX,:))'); axis off image; colormap hot; title('MBPC 7SIM')   ; caxis([0 6e4]);
axes(ha(4)); imagesc(squeeze(MBPCDR9Result(yBest,xyRegionX,:))'); axis off image; colormap hot; title('MBPC 9SIM')   ; caxis([0 6e4]);
axes(ha(5)); imagesc(squeeze(MBPCResult   (yBest,xyRegionX,:))'); axis off image; colormap hot; title('MBPC 15SIM')  ; caxis([0 6e4]);

fig       = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(1, 5, [.01 .001],[.1 .1],[.1 .1]);
axes(ha(1)); imagesc(squeeze(WFNor      (yBest,xyRegionX,:))'); axis off image; colormap hot; title('WF')
axes(ha(2)); imagesc(squeeze(WF3Result  (yBest,xyRegionX,:))'); axis off image; colormap hot; title('MB 3SIM+WF')
axes(ha(3)); imagesc(squeeze(DR7MBResult(yBest,xyRegionX,:))'); axis off image; colormap hot; title('MB 7SIM')
axes(ha(4)); imagesc(squeeze(DR9MBResult(yBest,xyRegionX,:))'); axis off image; colormap hot; title('MB 9SIM')
axes(ha(5)); imagesc(squeeze(MBResult   (yBest,xyRegionX,:))'); axis off image; colormap hot; title('MB 15SIM')