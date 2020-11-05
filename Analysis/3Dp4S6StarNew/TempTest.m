%% add the 2D-GWF restored image
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\3Dp4S6StarNew\Sim3W3Dp4S6StarNew256SNR15dB_FairSIM.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages,'uint16');
for i = 1:NumberImages
    reconOb(:,:,i) = imread(FileTif,'Index',i);
end
reconOb    = double(reconOb);
reconOb(reconOb < 0) = 0;
