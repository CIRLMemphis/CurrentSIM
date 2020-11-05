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
expNames = ["202008111304",...
            "202008071619_Exp3WLSECActinPSFVzMBPC_jmDouble_Reg1e4"];
iterInd  = [0, 6];

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;

% add the widefield image
load(CIRLDataPath + "\Results\LSECActin\" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
recVars{end+1} = g(:,:,:,lThe,1) + g(:,:,:,lThe,2) + g(:,:,:,lThe,3) + g(:,:,:,lThe,4) + g(:,:,:,lThe,5);
%recVars{end}   = recVars{end}./sum(recVars{end}(:))*sum(HROb(:));

% add the 2D-GWF restored image
load(char(CIRLDataPath + "/Results/LSECActin/LSECActinRecon_FairSIM2D.mat"));
reconOb(reconOb < 0) = 0;
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
        load(CIRLDataPath + "\Results\LSECActin\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb;
    else
        load(CIRLDataPath + "\Results\LSECActin\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
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
z2BF = 11;
y2BF = 513;
colormapSet = 'hot';
xyRegionX   =   513:1024;
xyRegionY   =   513:1024;
MethodCompareFig = LSECActinPlot(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);

%% zoom of middle bottom art
z2BF = 11;
y2BF = 513;
colormapSet = 'hot';
xyRegionX   =   513+256+100:1024-60;
xyRegionY   =   513+128+60:1024-128-100;
MethodCompareFig = LSECActinPlot(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
                             
%% another xy field of view
z2BF = 11;
y2BF = 513;
colormapSet = 'hot';
xyRegionX   =   513:513+224;
xyRegionY   =   800:1024;
MethodCompareFig = LSECActinPlot(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
%% xy slices
z2BF = 10;
y2BF = 513;
colormapSet = 'hot';
xyRegionX   =   513:513+224;
xyRegionY   =   800:1024;
MethodCompareFig = LSECActinSlices(recVars, z2BF, y2BF, ...
                                 ["Widefield", "2D-FairSIM", "3D-GWF", "3D-MBPC, 150Iter"],...
                                 [],...
                                 colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);