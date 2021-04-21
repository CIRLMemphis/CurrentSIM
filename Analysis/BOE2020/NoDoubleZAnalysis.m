clear; close all

%%
reconOb = ReadTIF(char("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\FairSimData\OriginalReconstruction\OMX_LSEC_Actin_525nm.tif"), 1, 1);
figure('name', 'LSEC OMX'); imagesc(reconOb(513:end,513:end,6)); colormap hot; axis image off;

%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\LSECActin\202008111304\202008111304.mat')
reconOb(reconOb < 0) = 0;
figure('name', 'LSEC GWF double Z'); imagesc(reconOb(513:end,513:end,6*2)); colormap hot; axis image off;

%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CurrentSIM\GeneratedReport\202012040638\202012040638.mat')
reconOb(reconOb < 0) = 0;
figure('name', 'LSEC GWF no double Z'); imagesc(reconOb(513:end,513:end,6)); colormap hot; axis image off;

%%
reconOb = ReadTIF(char("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\FairSimData\OriginalReconstruction\OMX_U2OS_Actin_525nm.tif"), 1, 1);
figure('name', 'U2OS OMX'); imagesc(reconOb(513:end,1:512,7)); colormap hot; axis image off;

%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CurrentSIM\GeneratedReport\202012040659\202012040659.mat')
reconOb(reconOb < 0) = 0;
figure('name', 'U2OS GWF no double Z'); imagesc(reconOb(513:end,1:512,7)); colormap hot; axis image off;


%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\U2OSActin\201912181803_Exp3WU2OSActinOptGWF\201912181803_Exp3WU2OSActinOptGWF.mat')
reconOb(reconOb < 0) = 0;
figure('name', 'U2OS GWF double Z'); imagesc(reconOb(513:end,1:512,7*2)); colormap hot; axis image off;
