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
expNames = ["202006252115_Sim3WOpt1e3GWF3Dp4S6StarNew256SNR15dB", ...
            "202007050541_Sim3WMBPCHot3Dp4S6StarNew256SNR15dBReg1e5Iter300", ...
            ];
% iterInd  = [0, 0, 0, 4, 4, 2];
iterInd  = [0, 3];
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

%% add the 2D-GWF restored image
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\3Dp4S6StarNew\Sim3W3Dp4S6StarNew256SNR15dB_FairSIM.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages+floor(NumberImages/2)*2,'uint16');
for i = 1:NumberImages
    temp = imread(FileTif,'Index',i);
    %temp = temp/max(temp(:));
    reconOb(:,:,2*(i-1)+1) = temp;
end
for i = 2:2:size(reconOb,3)
    if (i+1 <= size(reconOb,3))
        reconOb(:,:,i) = (reconOb(:,:,i-1) + reconOb(:,:,i+1))/2;
    else
        reconOb(:,:,i) = reconOb(:,:,i-1);
    end
end
reconOb    = double(reconOb);
reconOb(reconOb < 0) = 0;
recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));


%% add the 3D-GWF, 3D-MB, 3D-MBPC results
MSE  = zeros(length(expNames)+1, 1);
SSIM = zeros(length(expNames)+1, 1);
[MSE(1), SSIM(1)] =  MSESSIM(recVars{end}, norOb);
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb./sum(reconOb(:))*sum(HROb(:));
    else
        load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)}./sum(retVars{iterInd(k)}(:))*sum(HROb(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
    [ MSE(k+1), SSIM(k+1) ] = MSESSIM(recVars{end}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["2D-FairSIM", "3D-GWF", "3D-MBPC, Iter300"])

%% results at different number of iterations
load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
fomVars = {};
fomVars{end+1} = g(:,:,:,1,1) + g(:,:,:,1,2) + g(:,:,:,1,3) + g(:,:,:,1,4) + g(:,:,:,1,5)+ ...
                 g(:,:,:,2,1) + g(:,:,:,2,2) + g(:,:,:,2,3) + g(:,:,:,2,4) + g(:,:,:,2,5)+ ...
                 g(:,:,:,3,1) + g(:,:,:,3,2) + g(:,:,:,3,3) + g(:,:,:,3,4) + g(:,:,:,3,5);
temp    = fomVars{end};
temp    = fftshift(temp);
temp    = fftn(temp);
temp    = fftshift(temp);
temp    = padarray(temp,[128 128 128]);
temp    = ifftshift(temp);
temp    = ifftn(temp);
temp    = ifftshift(temp);
fomVars{end}   = real(temp);
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(HROb(:));
fomVars{end+1} = retVars{1};
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(HROb(:));
fomVars{end+1} = retVars{2};
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(HROb(:));
fomVars{end+1} = retVars{3};
fomVars{end}   = fomVars{end}./sum(fomVars{end}(:))*sum(HROb(:));
MSE  = zeros(length(fomVars), 1);
SSIM = zeros(length(fomVars), 1);
for k = 1:length(fomVars)
    [ MSE(k), SSIM(k) ] = MSESSIM(fomVars{k}, norOb);
end
texRet = MSESSIMtoTex(MSE, SSIM, ["initial guess", "3D-MBPC, Iter100", "3D-MBPC, Iter200", "3D-MBPC, Iter300"])

%%
colormapSet = 'gray';
fomVars{1}   = fomVars{1}*5;
MethodCompareFig = StarLike_plot_iter(...
                                fomVars, z2BF, y2BF, ...
                                ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                ["initial guess", "3D-MBPC, Iter100", "3D-MBPC, Iter200", "3D-MBPC, Iter300"],...
                                [],...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);

%%
colormapSet = 'gray';
MethodCompareFig = Subplot_Pub_xy_xz_Profile(...
                                recVars, z2BF, y2BF, ...
                                ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
                                ["True Object", "3D-GWF Deconvolved WF", "2D-FairSIM", "3D-GWF", "3D-MBPC 15SIM 15dB, Iter300"],...
                                [],...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);

% %% plot the difference
% diffVars = {};
% diffVars{end+1} = recVars{1};
% diffVars{end+1} = recVars{4};
% diffVars{end+1} = recVars{5};
% diffVars{end+1} = recVars{6};
% diffVars{end+1} = abs(recVars{4}-recVars{1});
% diffVars{end+1} = abs(recVars{5}-recVars{1});
% diffVars{end+1} = abs(recVars{6}-recVars{1});
% 
% %%
% colormapSet = 'gray';
% MethodCompareFig = DiffDRStarNewSubplot(...
%                                 diffVars, z2BF, y2BF, ...
%                                 ...["True Object", "Widefield", "3D-GWF Deconvolved WF", "FairSIM, OTF atten", "FairSIM, no OTF atten", "3D-GWF, 1e-3", "3D-GWF, 1e-2", "MBPCReg1e5, 200Iter"],...
%                                 ["True Object", "MBPC DRWF3 15dB, Iter400", "MBPC DR7 15dB, Iter400", "MBPC 15dB, Iter300", "|MBPC WF3 - Truth|", "|MBPC7 - Truth|", "|MBPC - Truth|"],...
%                                 [],...
%                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
% saveas(MethodCompareFig, "3W2P15dBBestMethodComparison.jpg");
% 
% 
% 


%% resolution pixel computation
%dx     = 0.224;
dx     = 0.229;
dXY    = 0.02;
dx_arc = dx*(6*4)/(2*pi*dXY);
%dx_SIM = 0.125;
%dx_SIM = 0.127;
dx_SIM = 0.150; % for display purpose, move off the limit
dx_SIM_arc = dx_SIM*(6*4)/(2*pi*dXY);

dz     = 0.525;
dZ     = 0.02;
dz_arc = dz*(6*4)/(2*pi*dZ);
%dz_SIM = 0.292;
%dz_SIM = 0.298;
dz_SIM = 0.310; % for display purpose, move off the limit
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

profInd = [1, 2, 3, 4, 5];
profTxt = {"Truth", "Deconv WF", "2D-FairSIM", "3D-GWF", "3D-MBPC"};
profColor = {'k', 'g', "b", 'm', 'r'};
lineStyle = {'-', ':', '--', '-.', '-'};

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
    sampleN = 400;
    theta = linspace(pi/2+pi/4, 3*pi/2-pi/4, sampleN);

    figure('Position', get(0, 'Screensize'));
    
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
    lblInd = [1, 61, 129, 196, 263, 331, 400];
    for ind = 1:length(profInd)
        %hold on; plot(radVal/(6*4)*(2*pi*0.02)*1000, resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
        hold on; plot(smooth(resVal{ind}, 9), lineStyle{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
        set(gca,'XTick', lblInd );
        set(gca,'XTickLabel', round((lblInd-1)*2*pi*amp/4/400*dXY*1000));
        xlim([0 length(resVal{ind})])
        %set(gca,'XTick',[]);
        ylabel('Intensity'); xlabel("Distance along the arc (nm)");
    end
    legend;
    %title("Profile along the " + dx_lbl{cnt} + " arc at resolution " + resolution*1000 + " nm");
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
    sampleN = 400;
    theta = linspace(pi/2+pi/4, 3*pi/2-pi/4, sampleN);

    figure('Position', get(0, 'Screensize'));
    
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
                vals  = [vals, recVars{profInd(ind)}(257, xr, yr)];
                if (ind == 1)
                    obVal = [obVal, ob(257, xr, yr)];
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
    lblInd = [1, 61, 129, 196, 263, 331, 400];
    for ind = 1:length(profInd)
        %hold on; plot(radVal/(6*4)*(2*pi*0.02)*1000, resVal{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
        hold on; plot(smooth(resVal{ind}), lineStyle{ind},'LineWidth',3,'DisplayName',profTxt{ind}, 'Color', profColor{ind});
        set(gca,'XTick', lblInd );
        set(gca,'XTickLabel', round((lblInd-1)*2*pi*amp/4/400*dXY*1000));
        xlim([0 length(smooth(resVal{ind}))])
        %set(gca,'XTick',[]);
        ylabel('Intensity'); xlabel("Distance along the arc (nm)");
    end
    legend;
    %title("Profile along the " + dx_lbl{cnt} + " arc at resolution " + resolution*1000 + " nm");
    cnt = cnt + 1;
end

%% spectrum comparison
dUV = 1/512/0.02;
dW  = 1/512/0.02;
uc  = 2*1.4/0.515;
wc  = 0.35*uc;
fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(1,5,[.01 .001],[.01 .03],[.01 .01]);
for i = 1:5
    axes(ha(i));
    tempFT = log(1+abs(FT(recVars{i})));
    min(tempFT(:))
    max(tempFT(:))
    temp   = tempFT(:,:,256);
    imagesc(temp); axis image off; caxis([0 14.8269]);
    if (i == 2)
        hold on; plot([257-round(uc/dUV), 257-round(uc/dUV)], [240 270], 'LineWidth',3, 'Color', 'r');
    elseif (i > 2)
        hold on; plot([257-round(1.8*uc/dUV), 257-round(1.8*uc/dUV)], [240 270], 'LineWidth',3, 'Color', 'k');
    elseif (i == 1)
        hold on; plot([257-round(uc/dUV), 257-round(uc/dUV)], [240 270], 'LineWidth',3, 'Color', 'r');
        hold on; plot([257-round(1.8*uc/dUV), 257-round(1.8*uc/dUV)], [240 270], 'LineWidth',3, 'Color', 'k');
    end
end

fig   = figure('Position', get(0, 'Screensize'));
[ha, pos] = TightSubplot(1,5,[.01 .001],[.01 .03],[.01 .01]);
for i = 1:5
    axes(ha(i));
    tempFT = log(1+abs(FT(recVars{i})));
    temp   = tempFT(:,256,:);

    imagesc(squeeze(temp)'); axis image off; caxis([0 14.8269]);
    if (i == 2)
        hold on; plot([240 270], [257-round(wc/dW), 257-round(wc/dW)], 'LineWidth',3, 'Color', 'm');
    elseif (i > 2)
        hold on; plot([240 270], [257-round(1.8*wc/dW), 257-round(1.8*wc/dW)], 'LineWidth',3, 'Color', 'w');
    elseif (i == 1)
        hold on; plot([240 270], [257-round(wc/dW), 257-round(wc/dW)], 'LineWidth',3, 'Color', 'm');
        hold on; plot([240 270], [257-round(1.8*wc/dW), 257-round(1.8*wc/dW)], 'LineWidth',3, 'Color', 'w');
    end
end