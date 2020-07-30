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
expNames = ["202005291428_Sim3WOpt5e4GWF3Dp4S6Star256SNR20dB"];
iterInd  = [0];
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
texRet = MSESSIMtoTex(MSE, SSIM, ["GWF5e4 20dB", "GWF1e3 15dB", "GWF1e2 10dB", "MBPC 20dB, Iter200", "MBPC 15dB, Iter200", "MBPC 10dB, Iter100"])


%%
colormapSet = 'gray';
MethodCompareFig = TempSubplot(     recVars, z2BF, y2BF, ...
                                    ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                    ["True Object", "Widefield", "3D-GWF Deconvolved WF", "GWF"],...
                                    [],...
                                    colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);

%% profile comparison on XZ plane
profInd = [1, 2, 3];
profTxt = {"Truth", "WF", "Deconv WF"};
profColor = {'k', 'm', 'r'};
lineStyle = {'-', '-.', '-'};

dz     = 0.367;
dZ     = 0.02;
dz_arc = dz*(6*4)/(2*pi*dZ);
amp  = dz_arc;
offX = 256;
offY = 256;
sampleN = 500;
theta = linspace(-pi/2,pi/2, sampleN);
figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2,3,[.01 .001],[.01 .03],[.01 .01]);
for ind = 1:length(profInd)
    axes(ha(ind+(1-1)*length(profInd)));
    if (ind == 2)
        imagesc(squeeze(recVars{profInd(ind)}(129,:,:,1,1))') ; axis square off; colormap gray; xlabel('x'); ylabel('z');
    else
        imagesc(squeeze(recVars{profInd(ind)}(257,:,:,1,1))') ; axis image off; colormap gray; xlabel('x'); ylabel('z');
    end
    caxis(colorScale);
    
    %r     = amp*(1-sin(theta));
    r     = amp;
    if (ind == 2)
        hold on; plot(round((offX+(r.*cos(theta)))/2), round((offY+(r.*sin(theta)))/2),'LineWidth',3,'Color', 'y');
    else
        hold on; plot(offX+(r.*cos(theta)), offY+(r.*sin(theta)),'LineWidth',3,'Color', 'y');
    end
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
        %r   = amp*(1-sin(thetaVal));
        r   = amp;
        xr  = 257;
        yr  = offX+round((r.*cos(thetaVal)));
        zr  = offY+round((r.*sin(thetaVal)));
        
        if (ind == 2)
            xr = 129;
            yr = round(yr/2);
            zr = round(zr/2);
        end
        
        %if ( xr ~= curX || yr ~= curY)
            vals  = [vals, recVars{profInd(ind)}(xr, yr, zr,1,1)];
            if (ind == 1)
                obVal = [obVal, ob(xr, yr, zr)];
            end
            curX   = xr;
            curY   = yr;
            radVal = [radVal, r];
        %end
    end
    resVal{end+1} = vals;
end
%figure('Position', get(0, 'Screensize'));
subplot(2,length(profInd),length(profInd)+1:length(profInd)*2); 
lblInd = [1, 35, 70, 105, 150, 193, 230];
for ind = 1:length(profInd)
    %hold on; plot(radVal/(6*4)*(2*pi*0.02)*1000, resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
    hold on; plot((resVal{ind}), lineStyle{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
    set(gca,'XTick', lblInd );
    set(gca,'XTickLabel', round(radVal(lblInd)/(6*4)*(2*pi*0.02)*1000));
    ylabel('Intensity'); xlabel('Resolution (nm)');
end
legend; title('Profile along the yellow curve');
