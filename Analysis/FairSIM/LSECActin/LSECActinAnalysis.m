scale = [0 1];

load('LSECActinRecon_FairSIM2D.mat');
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{1} = reconOb;

load('LSECActinRecon_FairSIM3D.mat');
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{2} = reconOb;

load('LSECActinRecon_3DGWF_LROTF.mat');
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{3} = reconOb;

load('LSECActinRecon_3DGWF_HROTF.mat');
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{4} = reconOb;

%%
load('C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\src\GeneratedReport\201911121633_Exp3WMB_LSECActinNoZ_LROTFs\201911121633.mat', 'retVars')
reconOb = retVars{10};
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{5} = reconOb;

%% [TODO]
load('C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\src\GeneratedReport\201911141147_Exp3WMB_LSECActinNoZ_HROTFs\201911141147.mat', 'retVars')
reconOb = retVars{10};
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{6} = reconOb;

%%
load('LSECActinRecon_2DGWF_LROTF.mat');
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{7} = reconOb;

%% [TODO]
load('LSECActinRecon_2DGWF_HROTF.mat');
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));
recOb{8} = reconOb;

%%
load('C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\FairSimData\OMX_LSEC_Actin_525nm.mat')
WF = zeros(512,512,7);
for i = 1:3
for j = 1:5
WF = WF + g(:,:,:,i,j);
end
end
WF = WF/sum(WF(:));
WF = WF/max(WF(:));
recOb{end+1} = WF;

titles = {"FairSIM2D", "FairSIM3D", "3DGWF_LR", "3DGWF_HR", "3DMBReg_LR", "3DMBReg_HR", "2DGWF_LR", "2DGWF_HR", "Widefield"};
% for obInd = 1:5
%     for i = 1:7
%         figure;
%         if (obInd < length(titles))
%             imagesc(recOb{obInd}(end-249+30:end-160, 150+31:250-10, i));
%         else
%             imagesc(recOb{obInd}((round((512-249+30)/2)):(round(512-160)/2), round((150+31)/2):round((250-10)/2), i));
%             imagesc(recOb{obInd}(512 + round((-249+30)/2):512-80, round((150+31)/2):round((250-10)/2), i));
%         end
%         %imagesc(recOb{obInd}(:, :, i+1));
%         axis square; colormap hot; axis off; caxis(scale);
%         print(gcf,titles{obInd} + i + ".png",'-dpng','-r600');
%     end
% end

%%

for obInd = 1:length(titles)
    reconOb = recOb{obInd};

    colorScale = [0 1];
    c      = hot;
    temp   = c(:, 1);
    c(:,1) = c(:,2);
    c(:,2) = temp;
    s = get(0, 'ScreenSize');
    figure('Position', [0 0 s(4) s(4)/1.3333]);
    imagesc(reconOb(513:end,513:end,6)); colormap(c); axis equal; axis off; caxis(colorScale);
    ah=gca;
    source_pos=[722, 894,  766,  938] - 512;
    target_pos=[850, 850, 1020, 1020] - 512;
    zoomPlot(ah,source_pos,target_pos,colorScale);
    axis(ah);
    print(gcf,titles{obInd} + ".png",'-dpng','-r600');
    CleanJPG(char(titles{obInd} + ".png"), 1, 308, 1190, 3750,4640);
end

%%
c      = hot;
temp   = c(:, 1);
c(:,1) = c(:,2);
c(:,2) = temp;
fh = figure();
fh.WindowState = 'maximized';
titles = {"1st orientation", "2nd orientation"};
for l = 1:2
    subplot(1,2,l); imagesc(g(287:end,1:226,4,l,1)); colormap(c); axis square;
    xlabel('x'); ylabel('y'); title(char(titles{l}));
end
print(gcf,"C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\112619Bonny_3DSIM_NN\pics\LSECActin_DiffOrientation.png",...
      '-dpng','-r600');
  
fh = figure();
fh.WindowState = 'maximized';
titles = {"1st phase", "2nd phase"};
for k = 1:2
    subplot(1,2,k); imagesc(g(287:end,1:226,4,1,k)); colormap(c); axis square;
    xlabel('x'); ylabel('y'); title(char(titles{k}));
end
print(gcf,"C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\112619Bonny_3DSIM_NN\pics\LSECActin_DiffPhase.png",...
      '-dpng','-r600');

%%
load('C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\src\GeneratedReport\201911141147_Exp3WMB_LSECActinNoZ_HROTFs\201911141147.mat', 'retVars')
reconOb = retVars{10};
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));

%%
fh = figure();
fh.WindowState = 'maximized';
subplot(1,2,1);
imagesc(g(287:end,1:226,4,1,1)); colormap(c); axis square;
    xlabel('x'); ylabel('y'); title('One collected image');
subplot(1,2,2);
imagesc(reconOb(287*2:end,1:226*2,6)); colormap(c); axis square;
xlabel('x'); ylabel('y'); title('Original (estimated)');
print(gcf,"C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\doc\Discussion\112619Bonny_3DSIM_NN\pics\LSECActin_Output.png",...
      '-dpng','-r600');