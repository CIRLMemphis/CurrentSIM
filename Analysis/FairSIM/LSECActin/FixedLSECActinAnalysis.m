scale = [0 1];

load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\LSECActin\LSECActinRecon_FairSIM2D.mat');
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{1} = reconOb;

%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\LSECActin\202008071619_Exp3WLSECActinPSFVzMBPC_jmDouble_Reg1e4\202008071619_Exp3WLSECActinPSFVzMBPC_jmDouble_Reg1e4.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
reconOb = reconOb/max(reconOb(:));
recOb{2} = reconOb;

%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\LSECActin\202008071806_Exp3WLSECActinPSFVzMBPCDR_jmDouble\202008071806_Exp3WLSECActinPSFVzMBPCDR_jmDouble.mat', 'reconOb')
reconOb(reconOb < 0) = 0;
reconOb = reconOb/max(reconOb(:));
recOb{3} = reconOb;

%%
figure; 
subplot(131); imagesc(recOb{1}(513+256+100:end-60, 513+128+60:end-128-100, 6)); axis square; colormap hot;
subplot(132); imagesc(recOb{2}(513+256+100:end-60, 513+128+60:end-128-100, 11)); axis square; colormap hot;
subplot(133); imagesc(recOb{3}(513+256+100:end-60, 513+128+60:end-128-100, 11)); axis square; colormap hot;