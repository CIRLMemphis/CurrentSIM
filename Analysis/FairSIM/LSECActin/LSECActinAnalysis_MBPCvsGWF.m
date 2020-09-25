run("../../../CIRLSetup.m");
colormapSet = 'hot';
colorScale  = [0 1.0];
shouldScale = 0;
xzRegionX   = 450:650;
xzRegionZ   =   1:50;
xyRegionX   =   1:200;
xyRegionY   =   1024-200:1024;
yBest       = 512;
zBest       = 11;

%%
load(CIRLDataPath + "/FairSimData/OMX_LSEC_Actin_525nm.mat", 'g');
fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(g(256:end,256:end,6,1,1)); axis square off; xlabel('x'); ylabel('y'); title('g1'); colormap(colormapSet);
subplot(1,3,2); imagesc(g(256:end,256:end,6,2,1)); axis square off; xlabel('x'); ylabel('y'); title('g2'); colormap(colormapSet);
subplot(1,3,3); imagesc(g(256:end,256:end,6,3,1)); axis square off; xlabel('x'); ylabel('y'); title('g3'); colormap(colormapSet);

%% load the reconstruction results
expNames = ["202008071619_Exp3WLSECActinPSFVzMBPC_jmDouble_Reg1e4", ...
            "202008071806_Exp3WLSECActinPSFVzMBPCDR_jmDouble" , ...
            "202008091013_Exp3WLSECActinPSFVzMBPCDR9_jmDouble_Reg1e4"];
iterInd  = [10, 10, 10];

%% load the 2D-GWF reconstruction results
load(char(CIRLDataPath + "/Results/LSECActin/LSECActinRecon_FairSIM2D.mat"));
FairSIMRes  = reconOb;
FairSIMRes(FairSIMRes < 0) = 0;
FairSIMRes  = FairSIMRes/max(FairSIMRes(:));

%% load the MBPC results
load(CIRLDataPath + "/Results/LSECActin/" + expNames(1) + "/" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'retVars');
 
%%
MBPCObNor = retVars{4};
MBPCObNor(MBPCObNor < 0) = 0;
MBPCObNor = MBPCObNor/max(MBPCObNor(:));

%% load the MBPC7 (7 out of 15) results
load(CIRLDataPath + "/Results/LSECActin/" + expNames(2) + "/" + expNames(2) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb');
 
%%
MBPC7ObNor = reconOb;
MBPC7ObNor(MBPC7ObNor < 0) = 0;
MBPC7ObNor = MBPC7ObNor/max(MBPC7ObNor(:));

%% load the MBPC9 (9 out of 15) results
load(CIRLDataPath + "/Results/LSECActin/" + expNames(3) + "/" + expNames(3) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'reconOb');
 
%%
MBPC9ObNor = reconOb;
MBPC9ObNor(MBPC9ObNor < 0) = 0;
MBPC9ObNor = MBPC9ObNor/max(MBPC9ObNor(:));

%% load 3D-GWF results
load(CIRLDataPath + "/Results/LSECActin/202008111304/202008111304.mat")
%load(CIRLDataPath + "/Results/LSECActin/202008111158_Exp3WLSECActinOptGWF/202008111158_Exp3WLSECActinOptGWF.mat")
%load(CIRLDataPath + "/Results/LSECActin/202008111225_Exp3WLSECActinOptGWF_HROTF/202008111225_Exp3WLSECActinOptGWF_HROTF.mat")
GWFRes = reconOb;
GWFRes(GWFRes < 0) = 0;
GWFRes = GWFRes/max(GWFRes(:));


%% XY plan
%colormapSet = 'gray';

fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(FairSIMRes(:, :,round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('2D-FairSIM Full');
subplot(1,3,2); imagesc(GWFRes    (:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Full');
subplot(1,3,3); imagesc(MBPCObNor (:, :,zBest-1)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MBPC Full');
% subplot(1,4,3); imagesc(MBPC7ObNor(:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
% title('3D-MBPC7 Full');
% subplot(1,4,4); imagesc(MBPC9ObNor(:, :,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
% title('3D-MBPC9 Full');
% print(gcf,"XYCompareFull.png",'-dpng','-r300');

fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(FairSIMRes(512:end, 512:end, round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('2D-FairSIM Corner');
subplot(1,3,2); imagesc(GWFRes    (512:end, 512:end, zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-GWF Corner');
subplot(1,3,3); imagesc(MBPCObNor (512:end, 512:end, zBest-1)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('3D-MBPC7 Corner');
% subplot(1,4,4); imagesc(MBPC9ObNor(512:end, 512:end, zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
% title('3D-MBPC9 Corner');

xyRegionY   =   513+256+100:1024-60;
xyRegionX   =   513+128+60:1024-128-100;
fh = figure();
fh.WindowState = 'maximized';
subplot(1,3,1); imagesc(FairSIMRes(xyRegionY, xyRegionX,round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 2D-FairSIM');
subplot(1,3,2); imagesc(GWFRes    (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(1,3,3); imagesc(MBPCObNor (xyRegionY, xyRegionX,zBest-1)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MBPC');
% subplot(1,4,3); imagesc(MBPC7ObNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
% title('Zoomed 3D-MBPC7');
% subplot(1,4,4); imagesc(MBPC9ObNor(xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
% title('Zoomed 3D-MBPC9');
% print(gcf,"XYCompareTopLeft.png",'-dpng','-r300');

%% at different slices
fh = figure();
fh.WindowState = 'maximized';
subplot(3,3,1); imagesc(FairSIMRes(xyRegionY, xyRegionX,round(zBest/2)-1)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 2D-FairSIM');
subplot(3,3,2); imagesc(GWFRes    (xyRegionY, xyRegionX,zBest-2)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-GWF');
subplot(3,3,3); imagesc(MBPCObNor (xyRegionY, xyRegionX,zBest-3)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
title('Zoomed 3D-MBPC');
subplot(3,3,4); imagesc(FairSIMRes(xyRegionY, xyRegionX,round(zBest/2))); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
subplot(3,3,5); imagesc(GWFRes    (xyRegionY, xyRegionX,zBest)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
subplot(3,3,6); imagesc(MBPCObNor (xyRegionY, xyRegionX,zBest-1)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
subplot(3,3,7); imagesc(FairSIMRes(xyRegionY, xyRegionX,round(zBest/2)+1)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
subplot(3,3,8); imagesc(GWFRes    (xyRegionY, xyRegionX,zBest+2)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');
subplot(3,3,9); imagesc(MBPCObNor (xyRegionY, xyRegionX,zBest+1)); axis image; axis off; caxis(colorScale); colormap(colormapSet); xlabel('x'); ylabel('y');