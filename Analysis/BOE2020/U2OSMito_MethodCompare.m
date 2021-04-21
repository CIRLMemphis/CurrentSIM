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
expNames = ["202007261108_Exp3WU2OSMitoOptGWF_jmDouble",...
            "202007240231_Exp3WU2OSMitoPSFVzMBPC_jmDouble"];
iterInd  = [0, 8];

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;

% add the widefield image
load(CIRLDataPath + "\Results\U2OSMito\" + expNames(1) + "\" + expNames(1) + ".mat", 'retVars');
recVars{end+1} = retVars{2};
%recVars{end+1} = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);
%recVars{end}   = PadZeroTransform(recVars{end});
%recVars{end}   = recVars{end}./sum(recVars{end}(:))*sum(HROb(:));

% add the 2D-GWF restored image
reconOb = ReadTIF(char(CIRLDataPath + "/Results/U2OSMito/FairSIM.tif"), 1, 1);
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
        load(CIRLDataPath + "\Results\U2OSMito\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb;
    else
        load(CIRLDataPath + "\Results\U2OSMito\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
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


%% full xy field of view
z2BF = [11, 11, 11, 11];
y2BF = 11;
colormapSet = 'hot';
xyRegionX   =   1:1024;
xyRegionY   =   1:1024;
MethodCompareFig = U2OSActinPlot(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale,...
                                 [0,0,0,0], 0);
                             
%% corner xy field of view
z2BF = [11, 11, 11, 11];
y2BF = 11;
colormapSet = 'hot';
xyRegionX   =   200:256+200;
xyRegionY   =   1  :256;
MethodCompareFig = U2OSActinPlot(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale,...
                                 [0,0,0,0], 0);

%% xy slices
z2BF = 11;
y2BF = 11;
colormapSet = 'hot';
xyRegionX   =   200:256+200;
xyRegionY   =   1  :256;
MethodCompareFig = U2OSActinSlices(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);