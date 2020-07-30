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
% expNames = ["202005291428_Sim3WOpt5e4GWF3Dp4S6Star256SNR20dB",...
%             "202005152310_Sim3WOpt1e3GWF3Dp4S6Star256SNR15dB", ...
%             "202005271418_Sim3WOpt1e2GWF3Dp4S6Star256SNR10dB", ...
%             "20200529204406_SNR20", ...
%             "20200529204348_SNR15", ...
%             "20200529204346_SNR10"];
expNames = ["202006252116_Sim3WOpt5e4GWF3Dp4S6StarNew256SNR20dB",...
            "202006252115_Sim3WOpt1e3GWF3Dp4S6StarNew256SNR15dB", ...
            "202006252112_Sim3WOpt1e2GWF3Dp4S6StarNew256SNR10dB"];
% iterInd  = [0, 0, 0, 4, 4, 2];
iterInd  = [0, 0, 0];
load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(1) + "\" + expNames(1) + ".mat",...
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

% add the deconvolved widefield image
reconOb        = retVars{end-1};
reconOb(reconOb < 0) = 0;
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));

%% plot the raw data
figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(2,3,[.01 .001],[.01 .03],[.01 .01]);
for ind = 1:3
    load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(ind) + "\" + expNames(ind) + ".mat", 'g');
    axes(ha(ind+(1-1)*3));
    imagesc(squeeze(g(:,:,129,1,1))) ; axis image off; colormap gray;
    axes(ha(ind+(2-1)*3));
    imagesc(squeeze(g(129,:,:,1,1))'); axis image off; colormap gray;
end

%% add the 3D-GWF, 3D-MB, 3D-MBPC results
MSE  = zeros(length(expNames), 1);
SSIM = zeros(length(expNames), 1);
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)}./sum(retVars{iterInd(k)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k), SSIM(k) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["GWF5e4 20dB", "GWF1e3 15dB", "GWF1e2 10dB", "MBPC 20dB, Iter200", "MBPC 15dB, Iter200", "MBPC 10dB, Iter100"])

%% swap deconvolved WF for displaying purpose
temp       = recVars{2};
recVars{2} = recVars{3};
recVars{3} = recVars{4};
recVars{4} = recVars{5};
recVars{5} = temp;

%%
colormapSet = 'gray';
MethodCompareFig = OSSRSubplot( recVars, z2BF, y2BF, ...
                                ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                ["True Object", "GWF5e4 20dB", "GWF1e3 15dB", "GWF1e2 10dB", "3D-GWF Deconvolved WF", "MBPC 20dB, Iter200", "MBPC 15dB, Iter200", "MBPC 10dB, Iter150"],...
                                [],...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
saveas(MethodCompareFig, "3W2P15dBBestMethodComparison.jpg");

%% resolution pixel computation
dx     = 0.224;
dXY    = 0.02;
dx_arc = dx*(6*4)/(2*pi*dXY);
dx_SIM = 0.125;
dx_SIM_arc = dx_SIM*(6*4)/(2*pi*dXY);

dz     = 0.525;
dZ     = 0.02;
dz_arc = dz*(6*4)/(2*pi*dZ);
dz_SIM = 0.292;
dz_SIM_arc = dz_SIM*(6*4)/(2*pi*dZ);

%% profile comparison on XY plane

% profInd = [1, 2, 6];
% profTxt = {"Truth", "GWF 20dB", "MBPC 20dB"};
% profColor = {'k', 'm', 'r'};
% lineStyle = {'-', '-.', '-'};

% profInd = [1, 3, 7];
% profTxt = {"Truth", "GWF 15dB", "MBPC 15dB"};
% profColor = {'k', 'm', 'r'};
% lineStyle = {'-', '-.', '-'};

% profInd = [1, 4, 8];
% profTxt = {"Truth", "GWF 10dB", "MBPC 10dB"};
% profColor = {'k', 'm', 'r'};
% lineStyle = {'-', '-.', '-'};

profInd = [1, 5, 2];
profTxt = {"Truth", "Deconvolved WF", "GWF 20dB"};
profColor = {'k', 'm', 'r'};
lineStyle = {'-', '-.', '-'};

%profTxt = {"Truth", "GWF 20dB", "GWF 15dB", "GWF 10dB"};
%profColor = {'k', 'r', 'm', 'g'};
%lineStyle = {'-', '-', '-.', '--'};
%profTxt = {"Truth", "MBPC 20dB", "MBPC 15dB", "MBPC 10dB"};
%profColor = {'k', 'r', 'm', 'g'};
%lineStyle = {'-', '-', '-.', '--'};

dx_lbl = {"red", "blue"};
x_color = {'r', 'b'};
cnt = 1;
for resolution = [dx, dx_SIM]
    amp = resolution*(6*4)/(2*pi*dZ);
    offX = 256;
    offY = 256;
    sampleN = 500;

    figure('Position', get(0, 'Screensize'));
    [ha, pos] = TightSubplot(2,length(profInd),[.01 .001],[.01 .03],[.01 .01]);
    for ind = 1:length(profInd)
        axes(ha(ind+(1-1)*length(profInd)));
        imagesc(squeeze(recVars{profInd(ind)}(:,:,257,1,1))) ; axis image off; colormap gray; xlabel('x'); ylabel('y');
        caxis(colorScale);
        theta = linspace(pi/2, 3*pi/2, sampleN);
        % r = amp*(1-2.5*sin(theta));
        r = amp;
        hold on; plot(offX+(r.*cos(theta)), offY+(r.*sin(theta)),'LineWidth',3,'Color', x_color{cnt});
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
            %r   = amp*(1-2.5*sin(thetaVal));
            r = amp;
            xr  = offX+round((r.*cos(thetaVal)));
            yr  = offY+round((r.*sin(thetaVal)));
            %if ( xr ~= curX || yr ~= curY)
                vals  = [vals, recVars{profInd(ind)}(xr, yr, 257)];
                if (ind == 1)
                    obVal = [obVal, ob(xr, yr, 257)];
                end
                curX   = xr;
                curY   = yr;
                radVal = [radVal, r];
            %end
        end
        resVal{end+1} = vals;
    end
    %axes(ha(4:6));
    %figure('Position', get(0, 'Screensize'));
    subplot(2,length(profInd),length(profInd)+1:length(profInd)*2); 
    lblInd = [1, 25, 48, 72, 101, 131];
    for ind = 1:length(profInd)
        %hold on; plot(radVal/(6*4)*(2*pi*0.02)*1000, resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
        hold on; plot(smooth(resVal{ind}), lineStyle{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
        %set(gca,'XTick', lblInd );
        %set(gca,'XTickLabel', round(radVal(lblInd)/(6*4)*(2*pi*0.02)*1000));
        xlim([0 length(smooth(resVal{ind}))])
        set(gca,'XTick',[]);
        %ylabel('Intensity'); xlabel("At resolution " + amp + " (nm)");
    end
    legend; title("Profile along the " + dx_lbl{cnt} + " arc at resolution " + resolution*1000 + " nm");
    cnt = cnt + 1;
end

%% profile comparison on XZ plane
dx_lbl = {"yellow", "green"};
x_color = {'y', 'g'};
cnt = 1;
for resolution = [dz, dz_SIM]
    amp = resolution*(6*4)/(2*pi*dZ);
    offX = 256;
    offY = 256;
    sampleN = 500;

    figure('Position', get(0, 'Screensize'));
    [ha, pos] = TightSubplot(2,length(profInd),[.01 .001],[.01 .03],[.01 .01]);
    for ind = 1:length(profInd)
        axes(ha(ind+(1-1)*length(profInd)));
        imagesc(squeeze(recVars{profInd(ind)}(257,:,:,1,1))') ; axis image off; colormap gray; xlabel('x'); ylabel('y');
        caxis(colorScale);
        theta = linspace(pi/2, 3*pi/2, sampleN);
        % r = amp*(1-2.5*sin(theta));
        r = amp;
        hold on; plot(offX+(r.*cos(theta)), offY+(r.*sin(theta)),'LineWidth',3,'Color', x_color{cnt});
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
            %r   = amp*(1-2.5*sin(thetaVal));
            r = amp;
            xr  = offX+round((r.*cos(thetaVal)));
            yr  = offY+round((r.*sin(thetaVal)));
            if ( xr ~= curX || yr ~= curY)
                vals  = [vals, recVars{profInd(ind)}(257, xr, yr)];
                if (ind == 1)
                    obVal = [obVal, ob(257, xr, yr)];
                end
                curX   = xr;
                curY   = yr;
                radVal = [radVal, r];
            end
        end
        resVal{end+1} = vals;
    end
    %axes(ha(4:6));
    %figure('Position', get(0, 'Screensize'));
    subplot(2,length(profInd),length(profInd)+1:length(profInd)*2); 
    lblInd = [1, 25, 48, 72, 101, 131];
    for ind = 1:length(profInd)
        %hold on; plot(radVal/(6*4)*(2*pi*0.02)*1000, resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
        hold on; plot(smooth(resVal{ind}), lineStyle{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
        %set(gca,'XTick', lblInd );
        %set(gca,'XTickLabel', round(radVal(lblInd)/(6*4)*(2*pi*0.02)*1000));
        xlim([0 length(smooth(resVal{ind}))])
        set(gca,'XTick',[]);
        %ylabel('Intensity'); xlabel("At resolution " + amp + " (nm)");
    end
    legend; title("Profile along the " + dx_lbl{cnt} + " arc at resolution " + resolution*1000 + " nm");
    cnt = cnt + 1;
end
