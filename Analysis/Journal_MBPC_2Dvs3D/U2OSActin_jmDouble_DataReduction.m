run("../../CIRLSetup.m");

% Widefield result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\201912181803_Exp3WU2OSActinOptGWF\201912181803_Exp3WU2OSActinOptGWF.mat', 'retVars')
WFNor = retVars{2}./sum(retVars{2}(:));
WFNor(WFNor < 0) = 0;
WFNor = WFNor/max(WFNor(:));

% MBPC result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\20200730141158.mat', 'retVars')
reconOb = retVars{end};
reconOb(reconOb < 0) = 0;
MBPCResult = reconOb;

% MBPC WF3 result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202007302033_Exp3WU2OSActinPSFVzMBPCDRWF3_jmDouble\202007302033_Exp3WU2OSActinPSFVzMBPCDRWF3_jmDouble.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBPCWF3Result = reconOb;

% MBPC DR7 result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202007310539_Exp3WU2OSActinPSFVzMBPCDR_jmDouble\202007310539_Exp3WU2OSActinPSFVzMBPCDR_jmDouble.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBPCDR7Result = reconOb;

% MBPC DR9 result
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\202007310706_Exp3WU2OSActinPSFVzMBPCDR9_jmDouble\202007310706_Exp3WU2OSActinPSFVzMBPCDR9_jmDouble.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
MBPCDR9Result = reconOb;


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
