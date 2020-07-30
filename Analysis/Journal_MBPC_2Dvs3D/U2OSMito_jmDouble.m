run("../../CIRLSetup.m");
colormapSet = 'gray';
colorScale  = [0 1];
xzRegionX   = 257-100:257+99;
xzRegionZ   = 1:41;
xyRegionX   = 257-50 :257+49;
xyRegionY   = 257-50 :257+49;
yBest       = 257;
zBest       = 257;

%% load the reconstruction results
expNames = ["202005192034_Exp3WU2OSMitoOptGWF",...
            "202007261108_Exp3WU2OSMitoOptGWF_jmDouble",...
            "202004231618_Exp3WU2OSMitoPSFVzMBPC", ...
            "202007240231_Exp3WU2OSMitoPSFVzMBPC_jmDouble"];
iterInd  = [0, 0, 8, 8];
load(CIRLDataPath + "\Results\U2OSMito\" + expNames(1) + "\" + expNames(1) + ".mat",...
     'X', 'Y', 'Z', 'dXY', 'dZ', 'uc', 'u', 'reconOb');

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;

% add the deconvolved widefield image
load(CIRLDataPath + "/Results/U2OSMito/" + expNames(1) + "\" + expNames(1) + ".mat", 'retVars');
recVars{end+1} = retVars{2};
recVars{end} = recVars{end}/max(recVars{end}(:));

% % add the widefield image
% load(CIRLDataPath + "/Results/U2OSMito/" + expNames(1) + "\" + expNames(1) + ".mat", 'g');
% recVars{end+1} = g(:,:,:,1,1) + g(:,:,:,1,2) + g(:,:,:,1,3) + g(:,:,:,1,4) + g(:,:,:,1,5);
% recVars{end} = recVars{end}/max(recVars{end}(:));


%% add the 3D-GWF, 3D-MB, 3D-MBPC results
for k = 1:length(expNames)
    if (iterInd(k) == 0)
        load(CIRLDataPath + "\Results\U2OSMito\" + expNames(k) + "\" + expNames(k) + ".mat", 'reconOb');
        recVars{end+1} = reconOb/max(reconOb(:));
    else
        load(CIRLDataPath + "\Results\U2OSMito\" + expNames(k) + "\" + expNames(k) + ".mat", 'retVars');
        recVars{end+1} = retVars{iterInd(k)};
        recVars{end} = recVars{end}/max(recVars{end}(:));
    end
    recVars{end}(recVars{end} < 0) = 0;
end


%%
xyRegionX   = 200:256+200;
xyRegionY   = 1  :256;
colormapSet = 'hot';
MethodCompareFig = U2OSMito_Plot( recVars, 11, 11, ...
                                ["Deconvolved WF", "3D-GWF, .4 mod", "3D-GWF, .8 mod", "3D-MBPC, .4 mod", "3D-MBPC, .8 mod", "3D-MBPC, 150Iter"],...
                                "Comparison of different methods for U2OSMito",...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
