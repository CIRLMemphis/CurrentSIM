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
expNames = ["202007240231_Exp3WU2OSMitoPSFVzMBPC_jmDouble", ...
            "202007251038_Exp3WU2OSMitoPSFVzMBPCDR6_jmDouble",...
            "202007241735_Exp3WU2OSMitoPSFVzMBPCDR7_jmDouble",...
            "202007251305_Exp3WU2OSMitoPSFVzMBPCDR9_jmDouble"];
iterInd  = [6, 6, 6, 6];

%% Reconstruction images of different methods
recVars = {};
lThe    = 1;
kPhi    = 1;

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
                                ["3D MBPC 5+5+5", "3D MBPC 2+2+2", "3D MBPC 5+1+1", "3D MBPC 3+3+3"],...
                                "Comparison of different DR methods for U2OSMito",...
                                colormapSet, xyRegionX, xyRegionY, xzRegionX, xzRegionZ, colorScale);
