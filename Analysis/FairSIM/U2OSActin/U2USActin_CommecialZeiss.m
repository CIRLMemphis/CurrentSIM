    FileTif      = char("C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\FairSimData\OriginalReconstruction\OMX_U2OS_Actin_525nm.tif");
    InfoImage    = imfinfo(FileTif);
    mImage       = InfoImage(1).Width;
    nImage       = InfoImage(1).Height;
    NumberImages = length(InfoImage);
    truth        = zeros(mImage, nImage, NumberImages,'uint16');
    for i = 1:NumberImages
        truth(:,:,i) = imread(FileTif,'Index',i);
    end
    truth    = double(truth);