run("C:/Users/cvan/OneDrive - The University of Memphis/CurrentSIM/CIRLSetup.m");

datasets = {"Sim3W3DDataNN_Pawpa",...
            "Sim3W3DDataNN_Spath"};
%datasets = {"OMX_LSEC_Actin_525nm"};
bgVals   = [0, 0];
slides   = {62:66; ...
            62:66};
regionX  = {1:1024;...
            1:1024}; % region of interest in X dimension, -1 for everything
regionY  = {1:1024;...
            1:1024}; % region of interest in Y dimension, -1 for everything

%%
fileCnt = 1;
for ind = 1:length(datasets)
    FileTif      = char(CIRLDataPath + "/Simulation/3W/" + datasets(ind) + ".mat");
    load(FileTif, 'ob')
    obCut    = ob(regionX{ind}, regionY{ind}, slides{ind});
    endObCnt = NNCrop(obCut, 128*2, 128*2, 1, 32*2, 32*2, 1*2, 'out/outSim', fileCnt);
    
    % generate input data
    load(char(CIRLDataPath + "/Simulation/3W/" + datasets(ind) + "256.mat"), 'g');
    g = g - bgVals(ind);
    g = g(:,:,round(slides{ind}(1:2:end)/2),:,:);
    [Y, X, Z, Nthe, Nphi] = size(g);
    gCut = zeros(length(round(regionX{ind}(1:2:end)/2)),...
                 length(round(regionY{ind}(1:2:end)/2)),...
                 length(round(slides {ind}(1:2:end)/2)));
    for zInd = 1:Z
        for l = 1:Nthe
            for k = 1:Nphi
                temp = fadeBorderCos(g(:,:,zInd,l,k), 15);
                gCut(:,:,zInd,l,k) = temp(round(regionX{ind}(1:2:end)/2), round(regionY{ind}(1:2:end)/2));
            end
        end
    end
    endRawCnt = NNCrop(gCut, 128, 128, 1, 32, 32, 1, 'in/inSim', fileCnt);
    
    assert(endObCnt == endRawCnt);
    fileCnt = endObCnt;
end