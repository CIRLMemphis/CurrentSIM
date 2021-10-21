run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1];
xzRegionX   = 257-100:257+99;
xzRegionZ   = 257-100:257+99;
xyRegionX   =   513+256+100:1024-60;
xyRegionY   =   513+128+60:1024-128-100;
yBest       = 257;
zBest       = 257;

%% load the reconstruction results
expNames = ["201912181803_Exp3WU2OSActinOptGWF",...
            "202002221320_Exp3WU2OSActinPSFVzMBPC"];
iterInd  = [0, 6];

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;

% add the widefield image
load(CIRLDataPath + "\Results\U2OSActin\" + expNames(1) + "\" + expNames(1) + ".mat", 'retVars');
recVars{end+1} = retVars{2};
%recVars{end+1} = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);
%recVars{end}   = PadZeroTransform(recVars{end});
%recVars{end}   = recVars{end}./sum(recVars{end}(:))*sum(HROb(:));

% add the 2D-GWF restored image
reconOb = ReadTIF(char(CIRLDataPath + "/Results/U2OSActin/U2OSActinRecon_FairSIM2D.tif"), 1, 1);
%reconOb(reconOb < 0) = 0;
upReconOb = zeros(size(reconOb,1), size(reconOb,2), floor(size(reconOb,3)/2)*2 + size(reconOb,3));
for i = 1:size(reconOb,3)
    upReconOb(:,:,2*(i-1)+1) = reconOb(:,:,i);
end
for i = 2:2:size(upReconOb,3)
    if (i+1 <= size(upReconOb,3))
        upReconOb(:,:,i) = (upReconOb(:,:,i-1) + upReconOb(:,:,i+1))/2;
    else
        upReconOb(:,:,i) = upReconOb(:,:,i-1);
    end
end

recVars{end+1} = upReconOb;
%recVars{end}   = recVars{end}./sum(recVars{end}(:))*sum(HROb(:));


%% add the 3D-GWF, 3D-MB, 3D-MBPC results
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\U2OSActin\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb;
    else
        load(CIRLDataPath + "\Results\U2OSActin\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)};
    end
    %recVars{end}(recVars{end} < 0) = 0;
end

%% normalization
for k = 1:length(recVars)-1
    recVars{k}   = recVars{k}./sum(recVars{k}(:))*sum(recVars{end}(:));
    recVars{k}(recVars{k} < 0) = 0;
    recVars{k}   = recVars{k}./max(recVars{k}(:));
end
recVars{end}(recVars{end} < 0) = 0;
recVars{end} = recVars{end}./max(recVars{end}(:));


%% corner xy field of view
z2BF = [14, 14, 14, 13];
y2BF = 1024-(200-130)-1;
colormapSet = 'hot';
xyRegionX   =   513:1024;
xyRegionY   =   1:512;
MethodCompareFig = U2OSActinPlot(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale,...
                                 [0,0,0,0], 0);

%% zoom of middle bottom art
z2BF = [14, 14, 14, 13];
y2BF = 1024-(200-130)-1;
colormapSet = 'hot';
xyRegionX   =   1024-200:1024;
xyRegionY   =   1:200;
MethodCompareFig = U2OSActinPlot(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale,...
                                 [0,0,0,0], 1);
                             
%% For FOM talk
z2BF = [14, 14, 14, 13];
fomVars = {};
fomVars{end+1} = recVars{1};
fomVars{end+1} = recVars{2};
fomVars{end+1} = recVars{3};
fomVars{end+1} = recVars{4};
y2BF = 361; %%%%%%%%%%%%%%%%%%%%% REMOVE
colormapSet = 'gray';
xyRegionX   =   1024-200:1024;
xyRegionY   =   1:200;
MethodCompareFig = U2OSActinPlotFOM(fomVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale,...
                                 [0,0,0,0], 1);
                             
%%
fomVars_NoFairSIM = {};
fomVars_NoFairSIM{end+1} = recVars{1};
fomVars_NoFairSIM{end+1} = recVars{3};
fomVars_NoFairSIM{end+1} = recVars{4};
MethodCompareFig = U2OSActinPlotFOM_NoFairSIM(fomVars_NoFairSIM, z2BF, y2BF, ...
                                 ["Widefield", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale,...
                                 [0,0,0,0], 1);
                             
                             
%% xy slices
z2BF = 14;
y2BF = 1024-(200-130)-1;
colormapSet = 'hot';
xyRegionX   =   1024-200:1024;
xyRegionY   =   1:200;
MethodCompareFig = U2OSActinSlices(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
                             
%% create video
fileName = "U2OSActin_MBPC";
varInd   = 4;
video = VideoWriter(char(fileName + ".avi")); %create the video object
video.FrameRate = 1;
open(video); %open the file for writing
for ii=1:size(recVars{varInd},1) %where N is the number of images
  img = squeeze(recVars{varInd}(ii,xyRegionY,:));
  img = img/max(img(:));
  writeVideo(video,img'); %write the image to file
end
close(video); %close the file

%% spectrum comparison
dUV = 1/1024/0.04;
dW  = 1/53/0.125;
uc  = 2*1.4/0.525;
wc  = 0.35*uc;
fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(1,4,[.01 .001],[.01 .03],[.01 .01]);
for i = 1:4
    axes(ha(i));
    tempFT = log(1+abs(FT(recVars{i})));
    max(tempFT(:))
    %tempFT = tempFT/(max(tempFT(:)));
    temp = tempFT(:,:,53);
    %temp   = log(1+tempFT(:,:,53));
    %temp   = temp/(max(temp(:)));
    imagesc(temp); axis image off; caxis([0 16.0242]);
    if (i == 1)
        hold on; plot([513-round(uc/dUV), 513-round(uc/dUV)], [482 542], 'LineWidth',3, 'Color', 'r');
    elseif (i > 1)
        hold on; plot([513-round(1.8*uc/dUV), 513-round(1.8*uc/dUV)], [482 542], 'LineWidth',3, 'Color', 'k');
    end
end

%%
fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(4,1,[.01 .3],[.01 .3],[.01 .01]);
%[ha, pos] = TightSubplot(1,4,[.01 .001],[.01 .03],[.01 .01]);
for i = 1:4
    axes(ha(i));
    tempFT = log(1+abs(FT(recVars{i})));
    temp   = tempFT(:,513,:);
    %temp   = temp/(max(temp(:)));
    imagesc(squeeze(temp)'); axis image off; caxis([0 16.0242]);
    if (i == 1)
        hold on; plot([513-round(uc/dUV), 513-round(uc/dUV)], [53-10 53+10], 'LineWidth',3, 'Color', 'r');
        hold on; plot([497 527], [53-round(wc/dW), 53-round(wc/dW)], 'LineWidth',3, 'Color', 'm');
    elseif (i > 1)
        hold on; plot([513-round(1.8*uc/dUV), 513-round(1.8*uc/dUV)], [53-10 53+10], 'LineWidth',3, 'Color', 'k');
        hold on; plot([497 527], [53-round(1.58*wc/dW), 53-round(1.58*wc/dW)], 'LineWidth',3, 'Color', 'w');
    end
end

%% profiles along u of the uw-plane
figure
wInd = 100;
for i = 1:4
    tempFT = log(1+abs(FT(recVars{i})));
    temp   = tempFT(:,513,:);
    if (i > 1)
        hold on; plot(temp(:,wInd),'LineWidth',3);
    end
end
hold on; line([513-round(1.8*uc/dUV) 513-round(1.8*uc/dUV)], [0 16], 'LineWidth',3, 'Color', 'k'); 
legend('FairSIM', 'GWF', 'MBPC', '1.8 of lateral cut-off');
title(['u profile at index w = ', string(wInd)]);

%% profiles along w of the uw-plane
figure
for i = 1:4
    tempFT = log(1+abs(FT(recVars{i})));
    temp   = tempFT(:,513,:);
    if (i > 1)
        hold on; plot(temp(513,:),'LineWidth',3);
    end
end
hold on; line([53-round(1.58*wc/dW) 53-round(1.58*wc/dW)], [0 16], 'LineWidth',3, 'Color', 'k'); 
legend('FairSIM', 'GWF', 'MBPC', '1.58 of axial cut-off');

%% results at different number of iterations
z2BF = [13, 13, 13, 13, 13];
fomVars = {};
fomVars{end+1} = retVars{1};
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(recVars{end}(:));
fomVars{end+1} = retVars{3};
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(recVars{end}(:));
fomVars{end+1} = retVars{5};
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(recVars{end}(:));
fomVars{end+1} = retVars{7};
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(recVars{end}(:));
fomVars{end+1} = retVars{10};
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(recVars{end}(:));
y2BF = 1024-(200-130)-1;
colormapSet = 'hot';
%%
xyRegionX   =   513:1024;
xyRegionY   =   1:512;
MethodCompareFig = U2OSActinPlot(fomVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale,...
                                 [0,0,0,0,0], 0);
                             
%%                             
xyRegionX   =   1024-200:1024;
xyRegionY   =   1:200;
MethodCompareFig = U2OSActinPlot(fomVars, z2BF, y2BF, ...
                                 ["3D-MBPC, 40Iter", "3D-MBPC, 60Iter", "3D-MBPC, 80Iter", "3D-MBPC, 100Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale,...
                                 [0,0,0,0,0], 1);