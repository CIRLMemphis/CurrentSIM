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
            "202005152247_Sim3WOpt1e2GWF3Dp4S6Star256SNR15dB"];
iterInd  = [0, 0];
load(CIRLDataPath + "\Results\3Dp4S6Star\" + expNames(1) + "\" + expNames(1) + ".mat",...
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
load(CIRLDataPath + "\Results\3Dp4S6Star\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
reconOb        = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

% add the deconvolved widefield image
reconOb        = retVars{end-1};
reconOb(reconOb < 0) = 0;
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

%% plot the raw data
figure;
subplot(1,2,1); imagesc(squeeze(g(:,:,129,1,1))) ; axis image; colormap gray; xlabel('x'); ylabel('y');
subplot(1,2,2); imagesc(squeeze(g(129,:,:,1,1))'); axis image; colormap gray; xlabel('x'); ylabel('z');


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
                                ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                ["True Object", "Widefield", "3D-GWF Deconvolved WF", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                [],...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
saveas(MethodCompareFig, "3W2P15dBBestMethodComparison.jpg");

%% profile comparison on XY plane
profInd = [4, 5];
profTxt = {"3D-GWF, 1e-3", "3D-GWF, 1e-2"};
profColor = {'r', 'g'};

amp  = 30;
offX = 256;
offY = 256;
sampleN = 500;

figure('Position', get(0, 'Screensize'));
for ind = 1:length(profInd)
    subplot(1,length(profInd) + 1,ind);
    imagesc(squeeze(recVars{profInd(ind)}(:,:,257,1,1))) ; axis image off; colormap gray; xlabel('x'); ylabel('y');
    theta = linspace(pi, 3*pi/2, sampleN); r = amp*(1-sin(theta));
    hold on; plot(offX+abs(r.*cos(theta)), offY+abs(r.*sin(theta)),'LineWidth',3);
    title(profTxt{ind});
end

resVal = {};
obVal  = [];
curX   = 0;
curY   = 0;
for ind = 1:length(profInd)
    vals = [];
    for thetaVal = theta
        r   = amp*(1-sin(thetaVal));
        if (offX+round(abs(r.*cos(thetaVal))) ~= curX || offY+round(abs(r.*sin(thetaVal))) ~= curY)
            vals  = [vals, recVars{profInd(ind)}(offX+round(abs(r.*cos(thetaVal))), offY+round(abs(r.*sin(thetaVal))), 257)];
            if (ind == 1)
                obVal = [obVal, ob(offX+round(abs(r.*cos(thetaVal))), offY+round(abs(r.*sin(thetaVal))), 257)];
            end
            curX  = offX+round(abs(r.*cos(thetaVal)));
            curY  = offY+round(abs(r.*sin(thetaVal)));
        end
    end
    resVal{end+1} = vals;
end
subplot(1,length(profInd) + 1,length(profInd) + 1); plot(obVal,'LineWidth',3,'DisplayName','Truth','Color', 'k'); axis square;
for ind = 1:length(profInd)
    hold on; plot(resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
end
legend; title('Profile comparison');

%% profile comparison on XZ plane
figure('Position', get(0, 'Screensize'));
for ind = 1:length(profInd)
    subplot(1,length(profInd) + 1,ind);
    imagesc(squeeze(recVars{profInd(ind)}(257,:,:,1,1))') ; axis image off; colormap gray; xlabel('x'); ylabel('z');
    theta = linspace(pi, 3*pi/2, sampleN); r = amp*(1-sin(theta));
    hold on; plot(offX+abs(r.*cos(theta)), offY+abs(r.*sin(theta)),'LineWidth',3);
    title(profTxt{ind});
end

resVal = {};
obVal  = [];
curX   = 0;
curY   = 0;
for ind = 1:length(profInd)
    vals = [];
    for thetaVal = theta
        r   = amp*(1-sin(thetaVal));
        if (offX+round(abs(r.*cos(thetaVal))) ~= curX || offY+round(abs(r.*sin(thetaVal))) ~= curY)
            vals  = [vals, recVars{profInd(ind)}(257,offX+round(abs(r.*cos(thetaVal))), offY+round(abs(r.*sin(thetaVal))))];
            if (ind == 1)
                obVal = [obVal, ob(257,offX+round(abs(r.*cos(thetaVal))), offY+round(abs(r.*sin(thetaVal))))];
            end
            curX  = offX+round(abs(r.*cos(thetaVal)));
            curY  = offY+round(abs(r.*sin(thetaVal)));
        end
    end
    resVal{end+1} = vals;
end
subplot(1,length(profInd) + 1,length(profInd) + 1); plot(obVal,'LineWidth',3,'DisplayName','Truth','Color', 'k'); axis square;
for ind = 1:length(profInd)
    hold on; plot(resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
end
legend; title('Profile comparison');
