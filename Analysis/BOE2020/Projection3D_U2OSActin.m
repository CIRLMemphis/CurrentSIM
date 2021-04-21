% smaller field of view
xyRegionX   =   1024-200:1024;

% add the 2D-GWF restored image
reconOb = ReadTIF(char(CIRLDataPath + "/Results/U2OSActin/U2OSActinRecon_FairSIM2D.tif"), 1, 1);
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

reconOb = upReconOb;

reconOb(reconOb < 0) = 0;
reconOb = reconOb./max(reconOb(:));
FileTif = char("FairSIMRestoration_U2OSActin_Cut.tif");
[Y, X, Z, ] = size(reconOb);
    for k = 1:Z
            imwrite(reconOb(xyRegionX,:,k)', FileTif, 'WriteMode', 'append');
    end

%% load the reconstruction results
expNames = ["201912181803_Exp3WU2OSActinOptGWF",...
            "202002221320_Exp3WU2OSActinPSFVzMBPC"];
iterInd  = [0, 6];
load(CIRLDataPath + "\Results\U2OSActin\" + expNames(1) + "\" + expNames(1) + ".mat", 'reconOb');
reconOb(reconOb < 0) = 0;
reconOb = reconOb./max(reconOb(:));
FileTif = char("GWFRestoration_U2OSActin_Cut.tif");
[Y, X, Z, ] = size(reconOb);
    for k = 1:Z
            imwrite(reconOb(xyRegionX,:,k)', FileTif, 'WriteMode', 'append');
    end
    
load(CIRLDataPath + "\Results\U2OSActin\" + expNames(2) + "\" + expNames(2) + ".mat", 'retVars');
reconOb = retVars{6};
reconOb(reconOb < 0) = 0;
reconOb = reconOb./max(reconOb(:));
FileTif = char("MBPCRestoration_U2OSActin_Cut.tif");
[Y, X, Z, ] = size(reconOb);
    for k = 1:Z
            imwrite(reconOb(xyRegionX,:,k)', FileTif, 'WriteMode', 'append');
    end