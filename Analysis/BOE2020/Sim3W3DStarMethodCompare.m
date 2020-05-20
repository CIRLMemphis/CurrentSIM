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
expNames = ["202005152310_Sim3WOpt1e3GWF3Dp4S6Star256SNR15dB", ...
            "20200516052932"];
iterInd  = [0, 4];
load(CIRLDataPath + "\Results\3Dp4S6Star\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'uc', 'u', 'retVars');

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
z2BF      = 1 + Z2/2;
y2BF      = 1 + Y2/2;
midOff    = 41;
midSlice  = y2BF-midOff-1:y2BF+midOff-1;

ob = StarLikeSample(3,512,6,20,3,0.6);
HROb  = ob;
norOb = ob; % multi object is already on scale [0,1]

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;

% the original object first
recVars{end+1} = HROb;

% add the widefield image
load(CIRLDataPath + "\Results\3Dp4S6Star\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
reconOb        = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

% add the deconvolved widefield image
reconOb        = retVars{end-1};
reconOb(reconOb < 0) = 0;
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

%% add the 2D-GWF restored image using FairSIM with attenuation
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\3Dp4S6Star\FairSIM_SNRresult_p10_ap99.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages+floor(NumberImages/2)*2,'uint16');
for i = 1:NumberImages
    reconOb(:,:,2*(i-1)+1) = imread(FileTif,'Index',i);
end
for i = 2:2:size(reconOb,3)
    if (i+1 <= size(reconOb,3))
        reconOb(:,:,i) = (reconOb(:,:,i-1) + reconOb(:,:,i+1))/2;
    else
        reconOb(:,:,i) = reconOb(:,:,i-1);
    end
end
reconOb    = double(reconOb);
reconObNor = reconOb./sum(reconOb(:))*sum(HROb(:));
reconObNor = permute(reconObNor, [2, 1, 3]);
recVars{end+1} = reconObNor;

%% plot the truth vs raw data
figure('Position', get(0, 'Screensize'));
[ha, ~]   = TightSubplot(1,2,[.01 .001],[.01 .03],[.01 .01]);
axes(ha(1)); 
imagesc(HROb(:,:,z2BF)); axis square off; colormap(colormapSet);
axes(ha(2)); 
imagesc(squeeze(HROb(y2BF,:,:))'); axis square off; colormap(colormapSet);
figure('Position', get(0, 'Screensize'));
[ha, ~]   = TightSubplot(1,2,[.01 .001],[.01 .03],[.01 .01]);
axes(ha(1)); 
imagesc(squeeze(g(:,:,129,1,1))) ; axis image off; colormap(colormapSet);
axes(ha(2)); 
imagesc(squeeze(g(129,:,:,1,1))'); axis image off; colormap(colormapSet);


%% add the 3D-GWF, 3D-MB, 3D-MBPC results
MSE  = zeros(length(expNames), 1);
SSIM = zeros(length(expNames), 1);
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\3Dp4S6Star\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load(CIRLDataPath + "\Results\3Dp4S6Star\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)}./sum(retVars{iterInd(k)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["GWF1e3 15dB", "GWF1e2 15dB", "MBPCReg1e5, 200Iter"])

%%
colormapSet = 'gray';
MethodCompareFig = OSSRSubplot( recVars, z2BF, y2BF, ...
                                ["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM", "3D-GWF", "3D-MBPC"],...
                                ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, 1e-1, a 0.99", "3D-GWF, 1e-3", "MBPCReg1e5, 150Iter"],...
                                [],...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
saveas(MethodCompareFig, "3W2P15dBBestMethodComparison.jpg");

%% profile comparison on XY plane
profInd = [1, 4, 5, 6];
profTxt = {"Truth", "FairSIM", "3D-GWF", "3D-MBPC"};
profColor = {'k', 'y', 'g', 'r'};

amp  = 40;
offX = 256;
offY = 256;
sampleN = 500;

figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2,4,[.01 .001],[.01 .03],[.01 .01]);
for ind = 1:length(profInd)
    axes(ha(ind+(1-1)*length(profInd)));
    imagesc(squeeze(recVars{profInd(ind)}(:,:,257,1,1))) ; axis image off; colormap gray; xlabel('x'); ylabel('y');
    caxis(colorScale);
    theta = linspace(pi, 3*pi/2, sampleN); r = amp*(1-sin(theta));
    hold on; plot(offX+abs(r.*cos(theta)), offY+abs(r.*sin(theta)),'LineWidth',3);
    title(profTxt{ind});
end

resVal = {};
obVal  = [];
curX   = 0;
curY   = 0;
for ind = 1:length(profInd)
    vals   = [];
    radVal = [];
    for thetaVal = theta
        r   = amp*(1-sin(thetaVal));
        if (offX+round(abs(r.*cos(thetaVal))) ~= curX || offY+round(abs(r.*sin(thetaVal))) ~= curY)
            vals  = [vals, recVars{profInd(ind)}(offX+round(abs(r.*cos(thetaVal))), offY+round(abs(r.*sin(thetaVal))), 257)];
            if (ind == 1)
                obVal = [obVal, ob(offX+round(abs(r.*cos(thetaVal))), offY+round(abs(r.*sin(thetaVal))), 257)];
            end
            curX   = offX+round(abs(r.*cos(thetaVal)));
            curY   = offY+round(abs(r.*sin(thetaVal)));
            radVal = [radVal, r];
        end
    end
    resVal{end+1} = vals;
end
subplot(2,length(profInd),length(profInd)+1:length(profInd)*2); 
lblInd = [1, 20, 40, 60, 85, 110, 130];
for ind = 1:length(profInd)
    %hold on; plot(radVal/(6*4)*(2*pi*0.02)*1000, resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
    hold on; plot(resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
    set(gca,'XTick', lblInd );
    set(gca,'XTickLabel', round(radVal(lblInd)/(6*4)*(2*pi*0.02)*1000));
    ylabel('Intensity'); xlabel('Resolution (nm)');
end
legend; title('Profile along the blue arc');

%% profile comparison on XZ plane
amp  = 70;
figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2,4,[.01 .001],[.01 .03],[.01 .01]);
for ind = 1:length(profInd)
    axes(ha(ind+(1-1)*length(profInd)));
    imagesc(squeeze(recVars{profInd(ind)}(257,:,:,1,1))') ; axis image off; colormap gray; xlabel('x'); ylabel('z');
    caxis(colorScale);
    theta = linspace(pi, 3*pi/2, sampleN); r = amp*(1-sin(theta));
    hold on; plot(offX+abs(r.*cos(theta)), offY+abs(r.*sin(theta)),'LineWidth',3);
    title(profTxt{ind});
end

resVal = {};
obVal  = [];
curX   = 0;
curY   = 0;
for ind = 1:length(profInd)
    vals   = [];
    radVal = [];
    for thetaVal = theta
        r   = amp*(1-sin(thetaVal));
        if (offX+round(abs(r.*cos(thetaVal))) ~= curX || offY+round(abs(r.*sin(thetaVal))) ~= curY)
            vals  = [vals, recVars{profInd(ind)}(257,offX+round(abs(r.*cos(thetaVal))), offY+round(abs(r.*sin(thetaVal))))];
            if (ind == 1)
                obVal = [obVal, ob(257,offX+round(abs(r.*cos(thetaVal))), offY+round(abs(r.*sin(thetaVal))))];
            end
            curX   = offX+round(abs(r.*cos(thetaVal)));
            curY   = offY+round(abs(r.*sin(thetaVal)));
            radVal = [radVal, r];
        end
    end
    resVal{end+1} = vals;
end
subplot(2,length(profInd),length(profInd)+1:length(profInd)*2); 
lblInd = [1, 35, 70, 105, 150, 193, 230];
for ind = 1:length(profInd)
    %hold on; plot(radVal/(6*4)*(2*pi*0.02)*1000, resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
    hold on; plot(resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
    set(gca,'XTick', lblInd );
    set(gca,'XTickLabel', round(radVal(lblInd)/(6*4)*(2*pi*0.02)*1000));
    ylabel('Intensity'); xlabel('Resolution (nm)');
end
legend; title('Profile along the blue arc');
