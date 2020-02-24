%% load the settings for this reconstruction
run("../OMX_LSEC_Actin_525nm/Exp3WLSECActinFullSetup.m");

%% load the data file
matFile = CIRLDataPath + "/FairSimData/OMX_LSEC_Actin_525nm.mat";
load(matFile);

%% Wiener parameter
wD = 0.001;

% lateral fractions
qn = [0, 1, -1, 2, -2]/2; % qn = (1:Nphi) - (Nphi+1)/2;

% decomposition matrix coefficients
cn = [1, 0.4, 0.4, 0.4, 0.4]; % cn = [1, 2/3, 2/3, 1/3, 1/3];

% input OTFs
load('FairSIMGreenHn_512_512_7.mat', 'Hn');
    tempHn = zeros(Y, X, length(phi));
    for zInd = 1:length(phi)
        tempHn(:,:,zInd) = sum(Hn(:,:,:,zInd),3);
    end
    Hn = tempHn;

reconOb = zeros(Y*2, X*2, Z);
for zInd = 1:Z
    reconOb(:,:,zInd) = OTF2DGWFCore(...
                             squeeze(g(:,:,zInd,:,:)),  ...
                             Hn, ...
                             qn, ...
                             cn, ...
                             uc, ...
                             u, ...
                             phi, ...
                             offs, ...
                             theta, ...
                             wD, ...
                             dXY, dZ, ...
                             -1, 0, 0, [], 1, [], 0);
end

%% 
c      = hot;
temp   = c(:, 1);
c(:,1) = c(:,2);
c(:,2) = temp;
reconOb(reconOb < 0) = 0;
reconOb = reconOb/sum(reconOb(:));
reconOb = reconOb/max(reconOb(:));

%%
figure; imagesc(reconOb(:,:,6)); axis square; colormap(c);
hold on; imagesc(reconOb(513:end,513:end,6)); axis square; colormap(c); caxis([0, 1]);
figure; imagesc(reconOb(894:938,722:766,6)); axis square; colormap(c); caxis([0, 1]);

%%
s = get(0, 'ScreenSize');
figure('Position', [0 0 s(4) s(4)/1.3333]);
imagesc(reconOb(:,:,5)); colormap(c); axis equal; axis off;
ah=gca;
source_pos=[722, 894, 766, 938];
target_pos=[600 600 1000 1000];
zoomPlot(ah,source_pos,target_pos);
axis(ah);