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
expNames = ["SimTunable11Slits400Nless",...
            "SimTunable11Slits400Nless"];
iterInd  = [2, 3];
load("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Jules\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'uc', 'u', 'retVars');

%% load the original high resolution object
X2 = X*2;
Y2 = Y*2;
Z2 = Z*2;
ob = StarLikeSample(3,512,6,20,3,0.6);
HROb  = ob;
norOb = ob; % multi object is already on scale [0,1]

%% True Object
z2BF      = 1 + Z2/2;
y2BF      = 1 + Y2/2;
midOff   = 41;
midSlice = y2BF-midOff-1:y2BF+midOff-1;
TrueObFig = figure('Position', get(0, 'Screensize'));
subplot(3,1,1); 
imagesc(HROb(:,:,z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('y'); title('True Object');
subplot(3,1,2);
imagesc(squeeze(HROb(y2BF,:,:))'); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z');
subplot(3,1,3);
imagesc(HROb(midSlice, midSlice, z2BF)); axis square; colormap(colormapSet); colorbar;
xlabel('x'); ylabel('z'); title('Zoomed-in middle');
saveas(TrueObFig, "TrueObject.jpg");

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;

% the original object first
recVars{end+1} = HROb;

% add the widefield image
load("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Jules\" + expNames(1) + ".mat", 'g');
reconOb        = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3);
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

%% plot the raw data
figure;
subplot(1,2,1); imagesc(squeeze(g(:,:,129,1,1))) ; axis image; colormap gray; xlabel('x'); ylabel('y');
subplot(1,2,2); imagesc(squeeze(g(129,:,:,1,1))'); axis image; colormap gray; xlabel('x'); ylabel('z');


%% add the results in expNames
MSE  = zeros(length(expNames), 1);
SSIM = zeros(length(expNames), 1);
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Jules\" + expNames(1) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Jules\" + expNames(1) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)}./sum(retVars{iterInd(k)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["MB 200Iter", "MB 300Iter"])

%%
colormapSet = 'gray';
MethodCompareFig = OSSRSubplot( recVars, z2BF, y2BF, ...
                                ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                ["True Object", "Widefield", "MB 200Iter", "MB 300Iter"],...
                                [],...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);

%% profile comparison on XY plane
profInd = [1, 3, 4];
profTxt = {"Truth", "MB 200Iter", "MB 300Iter"};
profColor = {'k', 'y', 'g'};

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
