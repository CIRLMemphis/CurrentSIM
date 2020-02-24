run('../../CIRLSetup.m');

%% load the forward images
FileTif      = 'C:\Users\cvan\Downloads\Data_Underpinning_Visualization_of_Podocyte_Substructure_with_Structured_Illumination_Microscopy\Figure 3\Normal_3DSIM_Reconstructed.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
chNo         = 1;
nd2Imgs      = zeros(nImage,mImage,NumberImages/chNo,chNo,'uint16');
for i = 1:NumberImages/chNo
    for chInd = 1:chNo
        nd2Imgs(:,:,i,chInd) = imread(FileTif,'Index',chNo*(i-1)+chInd);
    end
end

%% make forward images
X     = nImage;
Y     = mImage;
Z     = NumberImages/chNo;
recon = zeros(X,Y,Z, chNo);
for chInd = 1:chNo
    for ind = 1:Z
        recon(:,:,ind) = nd2Imgs(:,:,ind,chInd);
    end
end

%% XZ video view
figure; imshow3D(permute(recon, [2, 3, 1])); axis image; colormap jet;

%% XY video view
figure; imshow3D(recon); axis image; colormap jet;