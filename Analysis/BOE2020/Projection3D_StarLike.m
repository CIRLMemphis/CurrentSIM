ob = StarLikeSample(3,512,6,20,3,0.6);
FileTif = char("Truth_StarLike.tif");
[Y, X, Z, ] = size(ob);
    for k = 1:Z
            imwrite(ob(:,:,k)', FileTif, 'WriteMode', 'append');
    end
    
    
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
reconOb = reconOb./max(reconOb(:));
FileTif = char("FairSIMRestoration_StarLike.tif");
[Y, X, Z, ] = size(reconOb);
    for k = 1:Z
            imwrite(reconOb(:,:,k)', FileTif, 'WriteMode', 'append');
    end

%%
expNames = ["202006252115_Sim3WOpt1e3GWF3Dp4S6StarNew256SNR15dB", ...
            "202007050541_Sim3WMBPCHot3Dp4S6StarNew256SNR15dBReg1e5Iter300", ...
            ];
% iterInd  = [0, 0, 0, 4, 4, 2];
iterInd  = [0, 3];
load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(1) + "\" + expNames(1) + ".mat", 'reconOb');
reconOb(reconOb < 0) = 0;
reconOb = reconOb./max(reconOb(:));
FileTif = char("GWFRestoration_StarLike.tif");
[Y, X, Z, ] = size(reconOb);
    for k = 1:Z
            imwrite(reconOb(:,:,k)', FileTif, 'WriteMode', 'append');
    end
    
load(CIRLDataPath + "\Results\3Dp4S6StarNew\" + expNames(2) + "\" + expNames(2) + ".mat", 'retVars');
reconOb = retVars{3};
reconOb(reconOb < 0) = 0;
reconOb = reconOb./max(reconOb(:));
FileTif = char("MBPCRestoration_StarLike.tif");
[Y, X, Z, ] = size(reconOb);
    for k = 1:Z
            imwrite(reconOb(:,:,k)', FileTif, 'WriteMode', 'append');
    end